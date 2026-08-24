"""RED/GREEN tests for the deterministic Night transform (tasks 2.3/2.4).

Contract under test (design §2, ADR-003):

- ``night_palette(base, profile_parameters, guardrails) -> dict[str, str]``
  never mutates its input, preserves every palette token key (excluding canonical
  mode metadata), and returns lowercase hex.
- The derived display name is "Dreamcoder Dark Night" while
  ``details`` stays "darker".
- HSL lightness/saturation are multiplied by the canonical factors with
  deterministic integer-rounded RGB; ``rgba()`` tokens preserve alpha exactly.
- Input aliases (e.g. ``selection == selection_bg``) stay exact in the output.
- A bounded corrective pass moves only declared foreground tokens toward the
  contrast-safe endpoint, never brightens background/surface roles, and never
  exceeds ``maximum_corrective_delta`` of lightness movement.
- New pure ``#000000``/``#ffffff`` values are rejected for functional roles;
  explicitly authored policy-approved black canvas/on-color roles are preserved.
- The transform never silently falls back to the standard dark palette.

The HSL helpers below are test-side color plumbing (a generic conversion, not
the SAPC/APCA formula); the canonical contrast math is imported from the
package.
"""

import json
from pathlib import Path

import pytest

from dreamcoder_theme._math import apca_lc
from dreamcoder_theme.palette import night_palette

ROOT = Path(__file__).resolve().parents[1]
THEME_ROOT = ROOT / "DreamcoderThemes" / "dreamcoder"

CANONICAL_PARAMS = {
    "brightness_factor": 0.86,
    "saturation_factor": 0.72,
    "maximum_corrective_delta": 0.12,
    "corrective_step": 0.02,
}


def _tokens() -> dict:
    return json.loads((THEME_ROOT / "tokens.json").read_text())


def _guardrails() -> dict[str, float]:
    tokens = _tokens()
    return {k: v for k, v in tokens["guardrails"].items() if isinstance(v, (int, float))}


def _dark_base(**overrides: str) -> dict[str, str]:
    pal = dict(_tokens()["modes"]["dark"])
    pal.update(overrides)
    return pal


# ---------------------------------------------------------------------------
# Test-side HSL plumbing (generic color conversion; deterministic round-half).
# ---------------------------------------------------------------------------


def _rgb(v: str) -> tuple[int, int, int]:
    v = v.lstrip("#")
    return int(v[0:2], 16), int(v[2:4], 16), int(v[4:6], 16)


def _hsl(v: str) -> tuple[float, float, float]:
    r, g, b = (c / 255 for c in _rgb(v))
    mx, mn = max(r, g, b), min(r, g, b)
    lightness = (mx + mn) / 2
    delta = mx - mn
    if delta == 0:
        return 0.0, 0.0, lightness
    saturation = delta / (1 - abs(2 * lightness - 1))
    if mx == r:
        hue = 60 * (((g - b) / delta) % 6)
    elif mx == g:
        hue = 60 * ((b - r) / delta + 2)
    else:
        hue = 60 * ((r - g) / delta + 4)
    return hue, saturation, lightness


def _pure_transform(v: str, params: dict[str, float]) -> str:
    """The deterministic HSL-reduction applied by night_palette to one hex."""
    hue, sat, light = _hsl(v)
    return _hex_from_hsl(
        hue, sat * params["saturation_factor"], light * params["brightness_factor"]
    )


def _hex_from_hsl(hue: float, sat: float, light: float) -> str:
    c = (1 - abs(2 * light - 1)) * sat
    x = c * (1 - abs((hue / 60) % 2 - 1))
    m = light - c / 2
    if hue < 60:
        r1, g1, b1 = c, x, 0.0
    elif hue < 120:
        r1, g1, b1 = x, c, 0.0
    elif hue < 180:
        r1, g1, b1 = 0.0, c, x
    elif hue < 240:
        r1, g1, b1 = 0.0, x, c
    elif hue < 300:
        r1, g1, b1 = x, 0.0, c
    else:
        r1, g1, b1 = c, 0.0, x
    r = round((r1 + m) * 255)
    g = round((g1 + m) * 255)
    b = round((b1 + m) * 255)
    return "#" + "".join(f"{max(0, min(255, ch)):02x}" for ch in (r, g, b))


# ---------------------------------------------------------------------------
# Contract tests
# ---------------------------------------------------------------------------


def test_night_preserves_token_keys():
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert set(night) == {key for key, value in base.items() if isinstance(value, str)}


def test_night_never_mutates_input():
    base = _dark_base()
    snapshot = dict(base)
    night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert base == snapshot


def test_night_metadata_and_details():
    night = night_palette(_dark_base(), CANONICAL_PARAMS, _guardrails())
    assert night["name"] == "Dreamcoder Dark Night"
    assert night["details"] == "darker"


def test_night_outputs_lowercase_hex():
    night = night_palette(_dark_base(), CANONICAL_PARAMS, _guardrails())
    for key, value in night.items():
        if value.startswith("#"):
            assert value == value.lower(), f"{key} not lowercase: {value}"


def test_night_preserves_exact_aliases():
    """selection == selection_bg (and every input alias) stays exact."""
    night = night_palette(_dark_base(), CANONICAL_PARAMS, _guardrails())
    assert night["selection"] == night["selection_bg"]
    assert night["subtle"] == night["disabled"]  # aliased in canonical dark
    assert night["bg"] == night["prompt_bg"]
    assert night["text"] == night["on_surface"]


def test_night_preserves_rgba_alpha_exactly():
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    for key in ("panel_rgba", "module_rgba", "active_rgba", "inactive_border", "overlay", "scrim"):
        value = base[key]
        assert value.startswith("rgba("), key
        alpha = value.rsplit(",", 1)[1].rstrip(")")
        assert night[key].rsplit(",", 1)[1].rstrip(")") == alpha
        assert night[key].endswith(")")


def test_night_reduces_lightness_and_saturation():
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert night["bg"] == base["bg"]
    assert _hsl(night["surface1"])[2] < _hsl(base["surface1"])[2]
    assert _hsl(night["accent"])[2] < _hsl(base["accent"])[2]
    assert _hsl(night["accent"])[1] < _hsl(base["accent"])[1]


def test_night_is_byte_identical_across_runs():
    base = _dark_base()
    first = night_palette(base, CANONICAL_PARAMS, _guardrails())
    second = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert first == second


def test_night_only_preserves_pure_black_for_explicit_oled_roles():
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    pure_black_keys = {key for key, value in night.items() if value == base["bg"]}
    hex_tokens = {value for value in night.values() if value.startswith("#")}

    assert pure_black_keys == {"bg", "prompt_bg", "on_accent", "on_error", "on_focus"}
    assert "#ffffff" not in hex_tokens


def test_night_preserves_explicit_oled_black_roles():
    base = _dark_base()
    for key in ("bg", "prompt_bg", "on_accent", "on_error", "on_focus"):
        base[key] = "#000000"

    night = night_palette(base, CANONICAL_PARAMS, _guardrails())

    for key in ("bg", "prompt_bg", "on_accent", "on_error", "on_focus"):
        assert night[key] == "#000000"


@pytest.mark.parametrize("token", ["#000000"])
def test_night_rejects_pure_black_on_functional_roles(token):
    base = _dark_base()
    base["hover"] = token
    with pytest.raises(ValueError):
        night_palette(base, CANONICAL_PARAMS, _guardrails())


def test_night_transforms_white_away_from_pure_white():
    """A pure-white input is dimmed (L*brightness < 1), never emitted white."""
    base = _dark_base()
    base["hover"] = "#ffffff"
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert night["hover"] != "#ffffff"
    assert _hsl(night["hover"])[2] < 1.0


def test_night_parameter_bounds_are_enforced():
    base = _dark_base()
    g = _guardrails()
    bad_params = [
        {
            "brightness_factor": 0,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 1.01,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 0,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 1.01,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": -0.01,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": 0.21,
            "corrective_step": 0.02,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0,
        },
        {
            "brightness_factor": 0.86,
            "saturation_factor": 0.72,
            "maximum_corrective_delta": 0.12,
            "corrective_step": 0.02,
            "extra": 1,
        },
    ]
    for params in bad_params:
        with pytest.raises(ValueError):
            night_palette(base, params, g)


def test_night_corrective_movement_is_capped_at_maximum_delta():
    """A token below its floor may be corrected only up to the bound."""
    base = _dark_base(subtle="#2f3a44")
    g = _guardrails()
    night = night_palette(base, CANONICAL_PARAMS, g)
    pure_lightness = _hsl(_pure_transform("#2f3a44", CANONICAL_PARAMS))[2]
    moved = _hsl(night["subtle"])[2] - pure_lightness
    assert 0 <= moved <= CANONICAL_PARAMS["maximum_corrective_delta"] + 1e-9
    # The deficit is large enough that the bound cannot reach the quiet floor:
    assert abs(apca_lc(night["subtle"], night["bg"])) < g["minimum_apca_quiet"]


def test_night_bounded_correction_restores_a_floor():
    """A small deficit is fixed within the bound (R4 scenario)."""
    base = _dark_base(subtle="#7e8c9e")
    g = _guardrails()
    night = night_palette(base, CANONICAL_PARAMS, g)
    assert abs(apca_lc(night["subtle"], night["bg"])) >= g["minimum_apca_quiet"]
    # And the correction respected the bound: lightness moved at most max_delta.
    moved = _hsl(night["subtle"])[2] - _hsl(_pure_transform("#7e8c9e", CANONICAL_PARAMS))[2]
    assert 0 <= moved <= CANONICAL_PARAMS["maximum_corrective_delta"] + 1e-9


def test_night_never_brightens_backgrounds():
    """Correction touches only declared pairs, never background/surface roles."""
    base = _dark_base(subtle="#2f3a44")
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    for key in (
        "bg",
        "bg_soft",
        "surface0",
        "surface1",
        "surface2",
        "surface3",
        "selection_bg",
        "hover",
        "pressed",
    ):
        assert night[key] == _pure_transform(base[key], CANONICAL_PARAMS), (
            f"background {key} was corrected"
        )


def test_night_has_no_silent_standard_dark_fallback():
    """The transform never returns the base palette as its output."""
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert night != base
    # An unfixable deficit still yields the bounded transform, never `base`.
    broken = _dark_base(subtle="#1a1a1a")
    night_broken = night_palette(broken, CANONICAL_PARAMS, _guardrails())
    assert night_broken != broken


def test_night_derivation_differs_from_standard_dark():
    """The Night palette must not silently substitute standard dark bytes."""
    base = _dark_base()
    night = night_palette(base, CANONICAL_PARAMS, _guardrails())
    assert night["surface1"] != base["surface1"]
    assert night["text"] != base["text"]
