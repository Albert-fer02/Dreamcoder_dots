"""Palette tokens and contrast helpers."""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path

from .palette_tokens import ANSI_KEYS


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
    # Reconcile: warn on silent divergence between defaults and tokens.json
    for mode_key in ("dark", "light", "dusk"):
        if mode_key in modes and mode_key in defaults:
            for token_key in set(defaults[mode_key]) & set(modes[mode_key]):
                d = defaults[mode_key][token_key]
                t = modes[mode_key][token_key]
                if d != t:
                    import warnings

                    warnings.warn(
                        f"palette divergence: {mode_key}.{token_key} = {t!r} (tokens.json) "
                        f"overrides {d!r} (palette_tokens.py). "
                        f"palette_tokens.py should be regenerated from tokens.json.",
                        stacklevel=2,
                    )
    return merged


def matugen_mode_name(mode_name: str) -> str:
    return "light" if mode_name in {"light", "dusk"} else "dark"


def resolve_color(palette: dict[str, str], value: str) -> str:
    return palette.get(value, value)


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    parts = tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))
    return parts  # type: ignore[return-value]


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    return "#" + "".join(f"{max(0, min(255, part)):02x}" for part in rgb)


def mix(left: str, right: str, amount: float) -> str:
    a = hex_to_rgb(left)
    b = hex_to_rgb(right)
    return rgb_to_hex(tuple(round(x + (y - x) * amount) for x, y in zip(a, b)))  # type: ignore[arg-type]


def rel_luminance(value: str) -> float:
    def channel(part: int) -> float:
        scaled = part / 255
        return scaled / 12.92 if scaled <= 0.03928 else ((scaled + 0.055) / 1.055) ** 2.4

    r, g, b = (channel(part) for part in hex_to_rgb(value))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


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
    c["selection"] = mix(c["selection"], scheme.get("primary_container", c["selection"]), 0.18)
    c["prompt_accent"] = c["accent"]
    c["prompt_accent_2"] = c["accent_2"]
    return c


def ansi(palette: dict[str, str]) -> list[str]:
    mode_name = "dark" if palette["details"] == "darker" else "light"
    safe = []
    for key in ANSI_KEYS:
        color = resolve_color(palette, key)
        safe.append(guard(color, palette["bg"], mode_name))
    return safe


def detect_mode(palette: dict[str, str]) -> str:
    """Return "dark" or "light" based on the palette's details key."""
    return "dark" if palette.get("details") == "darker" else "light"
