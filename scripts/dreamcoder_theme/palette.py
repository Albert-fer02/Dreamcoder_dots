"""Palette tokens and contrast helpers."""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path

VARIANTS = {
    "dark": {
        "name": "Dreamcoder Ember Noir",
        "bg": "#15100d",
        "bg_soft": "#1d1613",
        "surface0": "#241b16",
        "surface1": "#30231c",
        "surface2": "#3e2c22",
        "text": "#f0e7dc",
        "muted": "#c7b9aa",
        "subtle": "#aa927c",
        "comment": "#9c826d",
        "border": "#49362c",
        "border_ui": "#806754",
        "border_hi": "#d8c1a5",
        "focus": "#e6a15c",
        "accent": "#e6a15c",
        "accent_2": "#d66f50",
        "diagnostic": "#d2a268",
        "sage": "#b8bf84",
        "lavender": "#c9a8dc",
        "mauve": "#d98aa9",
        "error": "#e98272",
        "warning": "#e8b866",
        "selection": "#43291d",
        "panel_rgba": "rgba(21, 16, 13, 0.76)",
        "module_rgba": "rgba(240, 231, 220, 0.08)",
        "active_rgba": "rgba(230, 161, 92, 0.24)",
        "inactive_border": "rgba(49362cc8)",
        "details": "darker",
        "prompt_bg": "#19110c",
        "prompt_surface0": "#2c1c14",
        "prompt_surface1": "#52301c",
        "prompt_surface2": "#744524",
        "prompt_text": "#fff0df",
        "prompt_muted": "#dcc3aa",
        "prompt_accent": "#e6a15c",
        "prompt_accent_2": "#d66f50",
    },
    "light": {
        "name": "Dreamcoder Light",
        "bg": "#f3eadc",
        "bg_soft": "#e6d7c4",
        "surface0": "#fff7ea",
        "surface1": "#decbb1",
        "surface2": "#c8ad89",
        "text": "#17120d",
        "muted": "#3d3228",
        "subtle": "#554635",
        "comment": "#66523f",
        "border": "#8a7358",
        "border_ui": "#66513b",
        "border_hi": "#3e2f20",
        "focus": "#0f6570",
        "accent": "#824f16",
        "accent_2": "#a7471c",
        "diagnostic": "#15516e",
        "sage": "#3f6b35",
        "lavender": "#57478b",
        "mauve": "#7d3e64",
        "error": "#842f24",
        "warning": "#654300",
        "selection": "#17120d",
        "panel_rgba": "rgba(243, 234, 220, 0.96)",
        "module_rgba": "rgba(222, 203, 177, 0.80)",
        "active_rgba": "rgba(130, 79, 22, 0.34)",
        "inactive_border": "rgba(8a7358ee)",
        "details": "lighter",
        "prompt_bg": "#f3eadc",
        "prompt_surface0": "#fff0d8",
        "prompt_surface1": "#d6ac72",
        "prompt_surface2": "#a96d31",
        "prompt_text": "#20150c",
        "prompt_muted": "#53402e",
        "prompt_accent": "#8a5520",
        "prompt_accent_2": "#a7471c",
    },
    "dusk": {
        "name": "Dreamcoder Dusk",
        "bg": "#ebe4d6",
        "bg_soft": "#dfd5c4",
        "surface0": "#f1eadf",
        "surface1": "#d8cbb8",
        "surface2": "#c6b6a0",
        "text": "#1a1713",
        "muted": "#4c443a",
        "subtle": "#5a4f43",
        "comment": "#615548",
        "border": "#a7947a",
        "border_ui": "#665845",
        "border_hi": "#4a3f32",
        "focus": "#216a73",
        "accent": "#8a5520",
        "accent_2": "#96411e",
        "diagnostic": "#104b67",
        "sage": "#466b41",
        "lavender": "#5b4e86",
        "mauve": "#784762",
        "error": "#773126",
        "warning": "#604000",
        "selection": "#1a1713",
        "panel_rgba": "rgba(235, 228, 214, 0.88)",
        "module_rgba": "rgba(26, 23, 19, 0.08)",
        "active_rgba": "rgba(138, 85, 32, 0.22)",
        "inactive_border": "rgba(a7947adf)",
        "details": "lighter",
        "prompt_bg": "#ebe4d6",
        "prompt_surface0": "#f2e6d4",
        "prompt_surface1": "#d3bc98",
        "prompt_surface2": "#b88958",
        "prompt_text": "#261c14",
        "prompt_muted": "#574939",
        "prompt_accent": "#965f25",
        "prompt_accent_2": "#96411e",
    },
}

ANSI_KEYS = [
    "surface0",
    "error",
    "sage",
    "accent",
    "diagnostic",
    "mauve",
    "lavender",
    "muted",
    "subtle",
    "#e9a092",
    "#75a579",
    "warning",
    "#579ba4",
    "#846fc5",
    "#72b6bd",
    "text",
]


def load_variants(defaults: dict[str, dict[str, str]], tokens_file: Path) -> dict[str, dict[str, str]]:
    if not tokens_file.exists():
        return defaults
    tokens = json.loads(tokens_file.read_text())
    modes = tokens.get("modes", {})
    merged = {key: value.copy() for key, value in defaults.items()}
    for key in ("dark", "light", "dusk"):
        if key in modes:
            merged[key].update(modes[key])
    return merged


def matugen_mode_name(mode_name: str) -> str:
    return "light" if mode_name in {"light", "dusk"} else "dark"


def resolve_color(palette: dict[str, str], value: str) -> str:
    return palette.get(value, value)


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    return "#" + "".join(f"{max(0, min(255, part)):02x}" for part in rgb)


def mix(left: str, right: str, amount: float) -> str:
    a = hex_to_rgb(left)
    b = hex_to_rgb(right)
    return rgb_to_hex(tuple(round(x + (y - x) * amount) for x, y in zip(a, b)))


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


def surface_guard(color: str, background: str, mode_name: str, minimum: float = 1.05, maximum: float = 2.4) -> str:
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
        ["matugen", "image", str(path), "--json", "hex", "-m", matugen_mode_name(mode_name)],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        check=False,
    )
    match = re.search(r"\{.*\}", result.stdout, flags=re.S)
    if not match:
        return {}
    return json.loads(match.group(0)).get("colors", {}).get(matugen_mode_name(mode_name), {})


def adaptive_palette(base: dict[str, str], mode_name: str, wallpaper: Path, adaptive: bool) -> dict[str, str]:
    scheme = matugen_scheme(wallpaper, mode_name, adaptive)
    if not scheme:
        return base

    c = dict(base)
    bg = mix(c["bg"], scheme.get("background", c["bg"]), 0.18)
    if contrast(bg, c["text"]) >= 7:
        c["bg"] = bg
    c["surface0"] = surface_guard(mix(c["surface0"], scheme.get("surface_container", c["surface0"]), 0.16), c["bg"], mode_name)
    c["surface1"] = surface_guard(mix(c["surface1"], scheme.get("surface_container_high", c["surface1"]), 0.18), c["bg"], mode_name)
    c["surface2"] = surface_guard(mix(c["surface2"], scheme.get("surface_variant", c["surface2"]), 0.18), c["bg"], mode_name)
    c["bg_soft"] = surface_guard(c["bg_soft"], c["bg"], mode_name)
    c["accent"] = guard(mix(c["prompt_accent"], scheme.get("primary", c["accent"]), 0.25), c["bg"], mode_name)
    c["accent_2"] = guard(mix(c["prompt_accent_2"], scheme.get("secondary", c["accent_2"]), 0.22), c["bg"], mode_name)
    c["diagnostic"] = guard(mix(c["diagnostic"], scheme.get("tertiary", c["diagnostic"]), 0.45), c["bg"], mode_name)
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
