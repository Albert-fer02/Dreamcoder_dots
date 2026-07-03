"""Palette tokens and contrast helpers."""

from __future__ import annotations

import json
import re
import subprocess
import warnings
from pathlib import Path

from .palette_tokens import ANSI_KEY_NAMES


def load_variants(
    defaults: dict[str, dict[str, str]], tokens_file: Path
) -> dict[str, dict[str, str]]:
    if not tokens_file.exists():
        return defaults
    tokens = json.loads(tokens_file.read_text())
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
            return mix(palette[base], palette["text"], 0.18)
    return palette.get(value, value)


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16)


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    return "#" + "".join(f"{max(0, min(255, part)):02x}" for part in rgb)


def mix(left: str, right: str, amount: float) -> str:
    a = hex_to_rgb(left)
    b = hex_to_rgb(right)
    return rgb_to_hex(tuple(round(x + (y - x) * amount) for x, y in zip(a, b)))  # type: ignore[arg-type]


def rel_luminance(value: str) -> float:
    r: int
    g: int
    b: int
    r, g, b = hex_to_rgb(value)
    sr = r / 255
    sg = g / 255
    sb = b / 255
    lr = sr / 12.92 if sr <= 0.03928 else ((sr + 0.055) / 1.055) ** 2.4
    lg = sg / 12.92 if sg <= 0.03928 else ((sg + 0.055) / 1.055) ** 2.4
    lb = sb / 12.92 if sb <= 0.03928 else ((sb + 0.055) / 1.055) ** 2.4
    return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb  # type: ignore[no-any-return, unused-ignore]


def contrast(left: str, right: str) -> float:
    a, b = sorted((rel_luminance(left), rel_luminance(right)), reverse=True)
    return (a + 0.05) / (b + 0.05)


def guard(color: str, background: str, mode_name: str, minimum: float = 4.5) -> str:
    target = "#ffffff" if mode_name == "dark" else "#000000"
    safe = color
    for _ in range(12):
        if contrast(safe, background) >= minimum:
            return safe
        safe = mix(safe, target, 0.18)
    return safe


def compute_on_color(
    background: str,
    mode_name: str,
    *,
    light_candidate: str | None = None,
    dark_candidate: str | None = None,
    minimum: float = 4.5,
) -> str:
    """Pick readable foreground on a filled surface."""
    if mode_name == "dark":
        candidates = [c for c in (dark_candidate, "#100f0d", "#000000") if c]
    else:
        candidates = [c for c in (light_candidate, "#fff7ea", "#ffffff") if c]
    for candidate in candidates:
        if contrast(candidate, background) >= minimum:
            return candidate
    target = candidates[-1]
    return guard(target, background, mode_name, minimum=minimum)


def surface_guard(
    color: str,
    background: str,
    mode_name: str,
    minimum: float = 1.05,
    maximum: float = 2.4,
) -> str:
    if contrast(color, background) < minimum:
        target = "#ffffff" if mode_name == "dark" else "#000000"
        safe = color
        for _ in range(12):
            safe = mix(safe, target, 0.08)
            if contrast(safe, background) >= minimum:
                return safe
        return safe
    if contrast(color, background) > maximum:
        safe = color
        for _ in range(12):
            safe = mix(safe, background, 0.12)
            if contrast(safe, background) <= maximum:
                return safe
        return safe
    return color


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
    return json.loads(match.group(0)).get("colors", {}).get(matugen_mode_name(mode_name), {})  # type: ignore[no-any-return]


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


def validate_palette(
    palette: dict[str, str], guardrails: dict[str, float] | None = None
) -> list[str]:
    """Return human-readable validation errors for a mode palette."""
    g = guardrails or {}
    errors: list[str] = []
    bg = palette["bg"]
    mode = detect_mode(palette)
    text_min = g.get("minimum_text_contrast", 4.5)
    main_min = g.get("preferred_main_text_contrast", 7.0)
    sel_min = g.get("minimum_terminal_selection_contrast", 7.0)

    for key in ("text", "muted", "comment", "accent", "error", "warning", "diagnostic"):
        if key not in palette:
            errors.append(f"missing token: {key}")
            continue
        if contrast(bg, palette[key]) < text_min:
            errors.append(f"{key} contrast {contrast(bg, palette[key]):.2f} < {text_min}")

    if contrast(bg, palette["text"]) < main_min:
        errors.append(f"main text contrast {contrast(bg, palette['text']):.2f} < {main_min}")

    for fg_key, bg_key in (
        ("selection_fg", "selection_bg"),
        ("on_accent", "accent"),
        ("on_error", "error"),
    ):
        if fg_key in palette and bg_key in palette:
            ratio = contrast(palette[fg_key], palette[bg_key])
            if fg_key == "selection_fg" and ratio < sel_min:
                errors.append(f"selection pair {ratio:.2f} < {sel_min}")
            if fg_key.startswith("on_") and ratio < 4.5:
                errors.append(f"{fg_key}/{bg_key} contrast {ratio:.2f} < 4.5")

    if "on_accent" in palette and "accent" in palette:
        if contrast(palette["on_accent"], palette["accent"]) < 4.5:
            errors.append("on_accent/accent WCAG contrast below 4.5")

    for index, color in enumerate(ansi(palette)):
        if contrast(color, bg) < g.get("minimum_terminal_ansi_contrast", 4.5):
            errors.append(f"ANSI color{index} contrast too low")

    for step in ("bg_soft", "surface0", "surface1", "surface2", "surface3"):
        if step in palette and contrast(palette[step], bg) < 1.02:
            errors.append(f"{step} too close to bg")

    if palette.get("comment") == palette.get("subtle"):
        errors.append("comment and subtle must differ")
    if palette.get("accent") == palette.get("accent_2"):
        errors.append("accent and accent_2 must differ")
    if mode == "light" and "surface3" not in palette:
        errors.append("light mode missing surface3")
    return errors
