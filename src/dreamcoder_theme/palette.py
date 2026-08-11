"""Palette tokens and contrast helpers."""

from __future__ import annotations

import json
import math
import re
import subprocess
import warnings
from collections.abc import Callable
from pathlib import Path

# Re-export pure color math
from ._math import (
    apca_lc,
    compute_on_color,
    contrast,
    guard,
    hex_to_rgb,
    mix,
    rel_luminance,
    rgb_to_hex,
    surface_guard,
)
from .palette_tokens import ANSI_KEY_NAMES

# Re-export domain functions for backward compatibility
__all__ = [
    "apca_lc",
    "compute_on_color",
    "contrast",
    "guard",
    "hex_to_rgb",
    "load_guardrails",
    "load_render_profile",
    "mix",
    "night_palette",
    "rel_luminance",
    "rgb_to_hex",
    "surface_guard",
]


def load_variants(
    defaults: dict[str, dict[str, str]], tokens_file: Path
) -> dict[str, dict[str, str]]:
    if not tokens_file.exists():
        return defaults
    try:
        tokens = json.loads(tokens_file.read_text())
    except (json.JSONDecodeError, OSError):
        warnings.warn(f"invalid tokens file: {tokens_file}", stacklevel=2)
        return defaults
    modes = tokens.get("modes", {})
    merged = {key: value.copy() for key, value in defaults.items()}
    for key in ("dark", "light", "dusk"):
        if key in modes:
            merged[key].update(modes[key])
    for mode_key in ("dark", "light", "dusk"):
        if mode_key in modes and mode_key in defaults:
            for token_key in set(defaults[mode_key]) & set(modes[mode_key]):
                d = defaults[mode_key][token_key]
                t = modes[mode_key][token_key]
                if d != t:
                    warnings.warn(
                        f"palette divergence: {mode_key}.{token_key} = {t!r} (tokens.json) "
                        f"overrides {d!r} (palette_tokens.py). "
                        f"Run ./scripts/generate-palette-tokens.py.",
                        stacklevel=2,
                    )
    return merged


def matugen_mode_name(mode_name: str) -> str:
    return "light" if mode_name in {"light", "dusk"} else "dark"


def resolve_color(palette: dict[str, str], value: str) -> str:
    if value.endswith("_bright"):
        base = value.removesuffix("_bright")
        if base in palette:
            # Bright variants must always be LIGHTER than base.
            # Dark mode: text is light → mix with text to lighten.
            # Light mode: bg is light → mix with bg to lighten.
            if detect_mode(palette) == "light":
                mix_target = palette.get("bg", palette["text"])
            else:
                mix_target = palette["text"]
            return mix(palette[base], mix_target, 0.18)
    return palette.get(value, value)


def matugen_scheme(path: Path, mode_name: str, adaptive: bool) -> dict[str, str]:
    if not adaptive or not path.is_file():
        return {}
    result = subprocess.run(
        [
            "matugen",
            "image",
            str(path),
            "--json",
            "hex",
            "-m",
            matugen_mode_name(mode_name),
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        check=False,
        timeout=30,
    )
    match = re.search(r"\{.*\}", result.stdout, flags=re.S)
    if not match:
        return {}
    try:
        return json.loads(match.group(0)).get("colors", {}).get(matugen_mode_name(mode_name), {})  # type: ignore[no-any-return]
    except json.JSONDecodeError:
        return {}


def adaptive_palette(
    base: dict[str, str], mode_name: str, wallpaper: Path, adaptive: bool
) -> dict[str, str]:
    scheme = matugen_scheme(wallpaper, mode_name, adaptive)
    if not scheme:
        return base

    c = dict(base)
    bg = mix(c["bg"], scheme.get("background", c["bg"]), 0.18)
    if contrast(bg, c["text"]) >= 7:
        c["bg"] = bg
    c["surface0"] = surface_guard(
        mix(c["surface0"], scheme.get("surface_container", c["surface0"]), 0.16),
        c["bg"],
        mode_name,
    )
    c["surface1"] = surface_guard(
        mix(c["surface1"], scheme.get("surface_container_high", c["surface1"]), 0.18),
        c["bg"],
        mode_name,
    )
    c["surface2"] = surface_guard(
        mix(c["surface2"], scheme.get("surface_variant", c["surface2"]), 0.18),
        c["bg"],
        mode_name,
    )
    c["bg_soft"] = surface_guard(c["bg_soft"], c["bg"], mode_name)
    c["accent"] = guard(
        mix(c["prompt_accent"], scheme.get("primary", c["accent"]), 0.25),
        c["bg"],
        mode_name,
    )
    c["accent_2"] = guard(
        mix(c["prompt_accent_2"], scheme.get("secondary", c["accent_2"]), 0.22),
        c["bg"],
        mode_name,
    )
    c["diagnostic"] = guard(
        mix(c["diagnostic"], scheme.get("tertiary", c["diagnostic"]), 0.45),
        c["bg"],
        mode_name,
    )
    c["border"] = mix(c["border"], scheme.get("outline", c["border"]), 0.25)
    c["selection_bg"] = mix(
        c.get("selection_bg", c["surface1"]),
        scheme.get("primary_container", c.get("selection_bg", c["surface1"])),
        0.18,
    )
    c["selection"] = c["selection_bg"]
    c["prompt_accent"] = c["accent"]
    c["prompt_accent_2"] = c["accent_2"]
    return c


def ansi(palette: dict[str, str]) -> list[str]:
    mode_name = detect_mode(palette)
    safe = []
    for key in ANSI_KEY_NAMES:
        color = resolve_color(palette, key)
        if not color.startswith("#"):
            raise ValueError(f"ANSI key {key!r} resolved to non-hex {color!r}")
        safe.append(guard(color, palette["bg"], mode_name))
    return safe


def detect_mode(palette: dict[str, str]) -> str:
    """Return "dark" or "light" based on the palette's details key."""
    return "dark" if palette.get("details") == "darker" else "light"


def make_guard(palette: dict[str, str], minimum: float = 3.0) -> Callable[[str], str]:
    """Return a guard() bound to the palette's bg and mode.

    Usage:
        g = make_guard(c)          # min contrast 3.0
        g = make_guard(c, 2.8)     # custom minimum
        accent = g(c["accent"])    # guarded accent color
    """
    mode = detect_mode(palette)
    bg = palette["bg"]
    return lambda color: guard(color, bg, mode, minimum=minimum)


# ------------------------------------------------------------------
# Declarative APCA pair classes (ADR-002).
#
# Each class names its token pairs and the guardrail keys that own the
# threshold — light/dusk floor and dark/night floor. No numeric policy
# literals are allowed here; a missing guardrail key fails validation.
# ------------------------------------------------------------------
_APCA_PAIR_CLASSES: tuple[tuple[str, tuple[tuple[str, str], ...], str, str], ...] = (
    (
        "body",
        (
            ("text", "bg"),
            ("error", "bg"),
            ("warning", "bg"),
            ("success", "bg"),
            ("info", "bg"),
            ("diagnostic", "bg"),
        ),
        "minimum_apca_body",
        "minimum_apca_body_dark",
    ),
    (
        "heading",
        (("text_heading", "bg"),),
        "minimum_apca_heading_light",
        "minimum_apca_heading_dark",
    ),
    (
        "quiet",
        (
            ("muted", "bg"),
            ("comment", "bg"),
            ("subtle", "bg"),
            ("disabled", "bg"),
        ),
        "minimum_apca_quiet",
        "minimum_apca_quiet",
    ),
    (
        "ui",
        (
            ("border_ui", "bg"),
            ("border_hi", "bg"),
            ("focus", "bg"),
        ),
        "minimum_apca_ui",
        "minimum_apca_ui_dark",
    ),
    (
        "on-accent",
        (("on_accent", "accent"),),
        "minimum_apca_on_accent",
        "minimum_apca_on_accent",
    ),
)


def validate_palette(
    palette: dict[str, str],
    guardrails: dict[str, float] | None = None,
    *,
    profile: str = "standard",
    mode: str | None = None,
) -> list[str]:
    """Return stable validation errors for a mode palette.

    Dual gate (ADR-002): WCAG 2.2 and APCA are independently blocking and
    both metrics are fully evaluated — a pass on one metric never waives a
    failure on the other. Thresholds are resolved from ``guardrails`` by
    key; APCA thresholds must be present or validation fails closed.

    ``profile`` is the rendering profile (``standard`` today; ``night``
    arrives with the transform). ``mode`` defaults to the palette-derived
    base mode (``dark`` for ``details=darker``, otherwise ``light``).

    Metric diagnostics use the stable shape::

        {metric} fail: mode={mode} profile={profile} pair={fg}/{bg} \
            measured={value} guardrail={key}={threshold}
    """
    g = guardrails or {}
    errors: list[str] = []
    bg = palette["bg"]
    effective_mode = mode if mode is not None else detect_mode(palette)
    text_min = g.get("minimum_text_contrast", 4.5)
    main_min = g.get("preferred_main_text_contrast", 7.0)
    sel_min = g.get("minimum_terminal_selection_contrast", 7.0)

    def wcag_diag(fg_key: str, bg_key: str, measured: float, key: str, threshold: float) -> str:
        return (
            f"WCAG fail: mode={effective_mode} profile={profile} "
            f"pair={fg_key}/{bg_key} measured={measured:.2f} "
            f"guardrail={key}={threshold}"
        )

    def apca_diag(cls: str, fg_key: str, bg_key: str, lc: float, key: str, threshold: float) -> str:
        return (
            f"APCA fail: mode={effective_mode} profile={profile} "
            f"pair={fg_key}/{bg_key} class={cls} measured={abs(lc):.1f} "
            f"guardrail={key}={threshold}"
        )

    # -- WCAG 2.2 gate --------------------------------------------------
    for key in ("text", "muted", "comment", "accent", "error", "warning", "diagnostic"):
        if key not in palette:
            errors.append(f"missing token: {key}")
            continue
        ratio = contrast(bg, palette[key])
        if ratio < text_min:
            errors.append(wcag_diag(key, "bg", ratio, "minimum_text_contrast", text_min))

    if "text" in palette:
        ratio = contrast(bg, palette["text"])
        if ratio < main_min:
            errors.append(wcag_diag("text", "bg", ratio, "preferred_main_text_contrast", main_min))

    for fg_key, bg_key in (
        ("selection_fg", "selection_bg"),
        ("on_accent", "accent"),
        ("on_error", "error"),
    ):
        if fg_key in palette and bg_key in palette:
            ratio = contrast(palette[fg_key], palette[bg_key])
            if fg_key == "selection_fg" and ratio < sel_min:
                errors.append(
                    wcag_diag(fg_key, bg_key, ratio, "minimum_terminal_selection_contrast", sel_min)
                )
            elif fg_key.startswith("on_") and ratio < text_min:
                errors.append(wcag_diag(fg_key, bg_key, ratio, "minimum_text_contrast", text_min))

    ansi_min = g.get("minimum_terminal_ansi_contrast", 4.5)
    for index, color in enumerate(ansi(palette)):
        ratio = contrast(color, bg)
        if ratio < ansi_min:
            errors.append(
                wcag_diag(f"ansi{index}", "bg", ratio, "minimum_terminal_ansi_contrast", ansi_min)
            )

    # -- APCA gate (independent; never short-circuits WCAG) -------------
    if mode is not None and mode not in ("light", "dark", "dusk"):
        errors.append(f"invalid mode: {mode}")
    for cls, pairs, light_key, dark_key in _APCA_PAIR_CLASSES:
        key = light_key if effective_mode in ("light", "dusk") else dark_key
        threshold = g.get(key)
        if threshold is None:
            errors.append(f"missing guardrail key: {key}")
            continue
        for fg_key, bg_key in pairs:
            if fg_key not in palette or bg_key not in palette:
                errors.append(f"missing token: {fg_key} (declared {cls} pair)")
                continue
            lc = apca_lc(palette[fg_key], palette[bg_key])
            if abs(lc) < threshold:
                errors.append(apca_diag(cls, fg_key, bg_key, lc, key, threshold))
            # Independent WCAG floor on the SAME declared pair (ADR-002 dual
            # gate): both metrics are required for every declared class, so
            # an APCA-boosted near-invisible pair cannot pass unremarked.
            ratio = contrast(palette[fg_key], palette[bg_key])
            if ratio < text_min:
                errors.append(wcag_diag(fg_key, bg_key, ratio, "minimum_text_contrast", text_min))

    # -- Structural checks ----------------------------------------------
    for step in ("bg_soft", "surface0", "surface1", "surface2", "surface3"):
        if step in palette and contrast(palette[step], bg) < 1.02:
            errors.append(f"{step} too close to bg")

    if palette.get("comment") == palette.get("subtle"):
        errors.append("comment and subtle must differ")
    if palette.get("accent") == palette.get("accent_2"):
        errors.append("accent and accent_2 must differ")
    if effective_mode == "light" and "surface3" not in palette:
        errors.append("light mode missing surface3")
    return errors


# ---------------------------------------------------------------------------
# Canonical Night/Dim rendering profile (Phase 2; ADR-003).
#
# The transform is a deterministic brightness/saturation reduction of the dark
# Anthracite Steel palette. All parameters come from the canonical token
# contract (render_profiles.night) — never policy literals — and the bounded
# corrective pass restores a floor without weakening any threshold or
# brightening background/surface roles. Failure after the bound is reported by
# the caller's validate_palette() gate (fail closed, no standard-dark fallback).
# ---------------------------------------------------------------------------

_NIGHT_PROFILE_KEYS = (
    "brightness_factor",
    "saturation_factor",
    "maximum_corrective_delta",
    "corrective_step",
)

_HEX_RE = re.compile(r"^#[0-9a-fA-F]{6}$")
_RGBA_RE = re.compile(r"^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*([^)]+)\)$")

# Guardrail keys validate_palette() / night_palette() resolve; a missing key
# fails closed so thresholds always originate in the canonical token file.
_REQUIRED_GUARDRAIL_KEYS = (
    "minimum_text_contrast",
    "preferred_main_text_contrast",
    "minimum_terminal_ansi_contrast",
    "minimum_terminal_selection_contrast",
    "minimum_apca_body",
    "minimum_apca_body_dark",
    "minimum_apca_quiet",
    "minimum_apca_ui",
    "minimum_apca_ui_dark",
    "minimum_apca_on_accent",
    "minimum_apca_heading_light",
    "minimum_apca_heading_dark",
)


def _require_guardrails(guardrails: dict[str, float]) -> None:
    missing = [key for key in _REQUIRED_GUARDRAIL_KEYS if key not in guardrails]
    if missing:
        raise ValueError(f"missing required guardrails: {', '.join(missing)}")


def _validate_profile_parameters(params: dict[str, float]) -> None:
    """Fail closed when render-profile parameters violate the canonical bounds."""
    if set(params) != set(_NIGHT_PROFILE_KEYS):
        raise ValueError(
            "night profile parameters must contain exactly "
            f"{sorted(_NIGHT_PROFILE_KEYS)}, got {sorted(params)}"
        )
    brightness = params["brightness_factor"]
    saturation = params["saturation_factor"]
    max_delta = params["maximum_corrective_delta"]
    step = params["corrective_step"]
    if not (0 < brightness <= 1):
        raise ValueError("brightness_factor must be in (0, 1]")
    if not (0 < saturation <= 1):
        raise ValueError("saturation_factor must be in (0, 1]")
    if not (0 <= max_delta <= 0.20):
        raise ValueError("maximum_corrective_delta must be in [0, 0.20]")
    if not (0 < step <= max_delta):
        raise ValueError("corrective_step must be in (0, maximum_corrective_delta]")


def load_guardrails(tokens_file: Path) -> dict[str, float]:
    """Load numeric guardrails from the canonical token file, failing closed.

    Every threshold consumed by validation must originate here (ADR-002); a
    missing required key (or an unreadable file) raises instead of falling
    back to a code literal.
    """
    if not tokens_file.is_file():
        raise ValueError(f"tokens file not found: {tokens_file}")
    try:
        tokens = json.loads(tokens_file.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError) as exc:
        raise ValueError(f"invalid tokens file: {tokens_file}") from exc
    guardrails = tokens.get("guardrails", {})
    numeric = {k: float(v) for k, v in guardrails.items() if isinstance(v, (int, float))}
    _require_guardrails(numeric)
    return numeric


def load_render_profile(tokens_file: Path, name: str = "night") -> dict[str, float]:
    """Load canonical render-profile parameters, failing closed on absence."""
    if not tokens_file.is_file():
        raise ValueError(f"tokens file not found: {tokens_file}")
    try:
        tokens = json.loads(tokens_file.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError) as exc:
        raise ValueError(f"invalid tokens file: {tokens_file}") from exc
    profile = tokens.get("render_profiles", {}).get(name)
    if not isinstance(profile, dict):
        raise ValueError(f"render profile {name!r} missing from tokens")
    params = {k: float(v) for k, v in profile.items() if isinstance(v, (int, float))}
    _validate_profile_parameters(params)
    return params


def _hsl_from_rgb(r: int, g: int, b: int) -> tuple[float, float, float]:
    rn, gn, bn = r / 255, g / 255, b / 255
    mx, mn = max(rn, gn, bn), min(rn, gn, bn)
    lightness = (mx + mn) / 2
    delta = mx - mn
    if delta == 0:
        return 0.0, 0.0, lightness
    saturation = delta / (1 - abs(2 * lightness - 1))
    if mx == rn:
        hue = 60 * (((gn - bn) / delta) % 6)
    elif mx == gn:
        hue = 60 * ((bn - rn) / delta + 2)
    else:
        hue = 60 * ((rn - gn) / delta + 4)
    return hue, saturation, lightness


def _rgb_from_hsl(hue: float, saturation: float, lightness: float) -> tuple[int, int, int]:
    chroma = (1 - abs(2 * lightness - 1)) * saturation
    x = chroma * (1 - abs((hue / 60) % 2 - 1))
    m = lightness - chroma / 2
    if hue < 60:
        r1, g1, b1 = chroma, x, 0.0
    elif hue < 120:
        r1, g1, b1 = x, chroma, 0.0
    elif hue < 180:
        r1, g1, b1 = 0.0, chroma, x
    elif hue < 240:
        r1, g1, b1 = 0.0, x, chroma
    elif hue < 300:
        r1, g1, b1 = x, 0.0, chroma
    else:
        r1, g1, b1 = chroma, 0.0, x
    # Deterministic nearest-integer rounding for byte-identical output.
    r = round((r1 + m) * 255)
    g = round((g1 + m) * 255)
    b = round((b1 + m) * 255)
    return max(0, min(255, r)), max(0, min(255, g)), max(0, min(255, b))


def _transform_hex(value: str, params: dict[str, float]) -> str:
    hue, saturation, lightness = _hsl_from_rgb(*hex_to_rgb(value))
    rgb = _rgb_from_hsl(
        hue,
        saturation * params["saturation_factor"],
        lightness * params["brightness_factor"],
    )
    return rgb_to_hex(rgb).lower()


def _transform_rgba(value: str, params: dict[str, float]) -> str:
    match = _RGBA_RE.match(value)
    if match is None:  # defensive: non-color metadata handled by caller
        return value
    r, g, b, alpha = int(match.group(1)), int(match.group(2)), int(match.group(3)), match.group(4)
    hue, saturation, lightness = _hsl_from_rgb(r, g, b)
    nr, ng, nb = _rgb_from_hsl(
        hue,
        saturation * params["saturation_factor"],
        lightness * params["brightness_factor"],
    )
    return f"rgba({nr}, {ng}, {nb}, {alpha})"


def _alias_groups(base: dict[str, str]) -> dict[str, list[str]]:
    """Map every shared color value to its sorted key list (metadata excluded).

    Members of one group share a color identity (e.g. ``selection ==
    selection_bg``) and must stay byte-identical after the transform,
    preventing independent rounding or correction drift. Incidental equalities
    that mix roles (e.g. ``bg == on_accent``) are grouped here but the
    corrective pass never propagates onto background/surface roles.
    """
    groups: dict[str, list[str]] = {}
    for key, value in base.items():
        if key in ("name", "details"):
            continue
        if not (_HEX_RE.match(value) or _RGBA_RE.match(value)):
            continue
        groups.setdefault(value.lower(), []).append(key)
    return {value: sorted(keys) for value, keys in groups.items() if len(keys) > 1}


# Background/surface roles that correction must never touch or brighten: the
# on-accent pair's background is the semantic ``accent`` color, NOT one of
# these roles, so the bounded pass may adjust it to restore the on-accent floor.
_SURFACE_ROLES = frozenset(
    {
        "bg",
        "bg_soft",
        "surface0",
        "surface1",
        "surface2",
        "surface3",
        "selection",
        "selection_bg",
        "hover",
        "pressed",
        "prompt_bg",
        "prompt_surface0",
        "prompt_surface1",
        "prompt_surface2",
    }
)


def _move_toward_endpoint(out: dict[str, str], token: str, pair_other: str, step: float) -> str:
    """Move ``token`` lightness one bounded step toward its pair's contrast
    endpoint (dark-on-light darkens, light-on-dark lightens), preserving hue
    and the already-reduced saturation."""
    hue, saturation, lightness = _hsl_from_rgb(*hex_to_rgb(out[token]))
    if rel_luminance(out[token]) < rel_luminance(out[pair_other]):
        lightness = max(0.0, lightness - step)
    else:
        lightness = min(1.0, lightness + step)
    return rgb_to_hex(_rgb_from_hsl(hue, saturation, lightness)).lower()


def _apply_with_aliases(
    out: dict[str, str], token: str, value: str, members_of: dict[str, list[str]]
) -> None:
    """Write a corrected value to the token and its alias-group members, never
    onto background/surface roles (which keep their pure-transform value)."""
    for member in members_of.get(token, [token]):
        if member in _SURFACE_ROLES:
            continue
        out[member] = value


def _corrective_pass(
    out: dict[str, str],
    guardrails: dict[str, float],
    params: dict[str, float],
    effective_mode: str,
    groups: dict[str, list[str]],
) -> None:
    """Bounded lightness correction for failing declared pairs (in place).

    Each step moves a failing foreground's lightness toward its pair's
    contrast-safe endpoint (polarity-aware) while preserving hue and the
    already-reduced saturation. Total movement per token is structurally
    capped at ``maximum_corrective_delta``. Background/surface roles are never
    brightened; thresholds are never weakened. The on-accent pair is the one
    case whose foreground is pinned at a near-extreme (even pure black on the
    accent cannot reach its floor), so its semantic ``accent`` pair-background
    -- not a surface role -- receives the bounded adjustment instead; the
    corrected value propagates through alias groups so semantic relationships
    stay exact (``selection == selection_bg`` etc.).
    """
    max_delta = params["maximum_corrective_delta"]
    step = params["corrective_step"]
    if max_delta <= 0 or step <= 0:
        return
    text_min = guardrails["minimum_text_contrast"]
    # Alias-group membership per token: aliases share one value, so they
    # share one corrective budget and step at most once per sweep (otherwise
    # e.g. subtle/disabled would double-step the shared value and break the
    # maximum_corrective_delta cap).
    members_of: dict[str, list[str]] = {}
    group_of: dict[str, str] = {}
    for keys in groups.values():
        for member in keys:
            members_of[member] = keys
            group_of[member] = keys[0]

    def rep(token: str) -> str:
        return group_of.get(token, token)

    moved: dict[str, float] = {}
    max_sweeps = math.ceil(max_delta / step)
    for _ in range(max_sweeps):
        touched = False
        stepped: set[str] = set()
        for cls, pairs, light_key, dark_key in _APCA_PAIR_CLASSES:
            floor_key = light_key if effective_mode in ("light", "dusk") else dark_key
            floor = guardrails[floor_key]
            for fg_key, bg_key in pairs:
                if fg_key not in out or bg_key not in out:
                    continue
                fg, bg = out[fg_key], out[bg_key]
                if abs(apca_lc(fg, bg)) >= floor and contrast(fg, bg) >= text_min:
                    continue
                if bg_key not in _SURFACE_ROLES:
                    # On-accent: the pair background is the semantic accent
                    # color (pinned foreground cannot reach the floor); adjust
                    # the background, bounded, to restore the floor.
                    target, other = bg_key, fg_key
                else:
                    target, other = fg_key, bg_key
                target_rep = rep(target)
                if target_rep in stepped:
                    continue
                remaining = max_delta - moved.get(target_rep, 0.0)
                if remaining <= 0:
                    continue
                old_lightness = _hsl_from_rgb(*hex_to_rgb(out[target]))[2]
                corrected = _move_toward_endpoint(out, target, other, min(step, remaining))
                stepped.add(target_rep)
                if corrected == out[target]:
                    continue  # clamped at the endpoint; stop stepping it
                new_lightness = _hsl_from_rgb(*hex_to_rgb(corrected))[2]
                moved[target_rep] = moved.get(target_rep, 0.0) + abs(new_lightness - old_lightness)
                _apply_with_aliases(out, target, corrected, members_of)
                touched = True
        if not touched:
            return


def night_palette(
    base: dict[str, str],
    profile_parameters: dict[str, float],
    guardrails: dict[str, float],
) -> dict[str, str]:
    """Derive the deterministic Night palette from the dark base (ADR-003).

    Steps (design §2): copy the input (never mutate), set the derived display
    name while ``details`` stays ``darker``, reduce HSL lightness/saturation
    with deterministic integer-rounded RGB (lowercase hex), preserve ``rgba()``
    alpha exactly, re-establish input aliases, apply the bounded corrective
    pass to declared foreground tokens, and reject pure black/white when
    ``avoid_pure_black_white`` is set.

    Parameters and guardrails are canonical (``load_render_profile`` /
    ``load_guardrails``); invalid values fail closed with ``ValueError`` and
    never fall back to the standard dark palette.
    """
    _validate_profile_parameters(profile_parameters)
    _require_guardrails(guardrails)
    groups = _alias_groups(base)

    out = dict(base)
    out["name"] = "Dreamcoder Anthracite Steel Night"
    # details intentionally untouched: the transform keeps dark semantics.

    for key, value in base.items():
        if _HEX_RE.match(value):
            out[key] = _transform_hex(value, profile_parameters)
        elif _RGBA_RE.match(value):
            out[key] = _transform_rgba(value, profile_parameters)

    # Re-establish exact aliases (pure transform keeps equal inputs equal, but
    # the corrective pass below must propagate to every member of an alias
    # group, so the groups are shared between both stages).
    for _value, keys in groups.items():
        first = keys[0]
        for member in keys[1:]:
            out[member] = out[first]

    effective_mode = detect_mode(out)
    _corrective_pass(out, guardrails, profile_parameters, effective_mode, groups)

    if guardrails.get("avoid_pure_black_white"):
        for key, value in out.items():
            if _HEX_RE.match(value) and value.lower() in ("#000000", "#ffffff"):
                raise ValueError(
                    f"night transform produced pure {value} for {key} with "
                    "avoid_pure_black_white enabled"
                )
    return out
