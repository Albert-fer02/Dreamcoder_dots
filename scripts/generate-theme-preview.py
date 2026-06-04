#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOKENS = ROOT / "themes/dreamcoder/tokens.json"
OUT = ROOT / "docs/dreamcoder-theme-preview.md"
TEXT_KEYS = [
    "text",
    "muted",
    "comment",
    "accent",
    "accent_2",
    "diagnostic",
    "sage",
    "error",
    "warning",
]
ROLES = [
    "bg",
    "bg_soft",
    "surface0",
    "surface1",
    "surface2",
    "text",
    "muted",
    "subtle",
    "comment",
    "accent",
    "accent_2",
    "diagnostic",
    "sage",
    "lavender",
    "mauve",
    "error",
    "warning",
    "border",
    "border_ui",
    "border_hi",
    "focus",
]


def rgb(value):
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def srgb_lin(channel):
    """APCA uses simple 2.4 exponent, not WCAG piecewise linearization."""
    return (channel / 255) ** 2.4


# APCA color coefficients (sRGB D65)
_APCA_R = 0.2126729
_APCA_G = 0.7151522
_APCA_B = 0.0721750

# APCA exponents
_NORM_TXT = 0.57  # normal polarity: text exponent
_NORM_BG = 0.56  # normal polarity: background exponent
_REV_TXT = 0.62  # reverse polarity: text exponent
_REV_BG = 0.65  # reverse polarity: background exponent

# APCA clamps and scalers
_BLK_THRS = 0.022
_BLK_CLMP = 1.414
_SCALE = 1.14
_LO_THRESH = 0.035991
_LO_FACTOR = 27.7847239587675
_OFFSET = 0.027


def apca_y(value: str) -> float:
    """Calculate APCA luminance Y for a color (no polarity exponent - applied later)."""
    r, g, b = (srgb_lin(part) for part in rgb(value))
    return _APCA_R * r + _APCA_G * g + _APCA_B * b


def apca_lc(foreground: str, background: str) -> float:
    """Calculate APCA contrast (Lc) for text on background.

    Uses correct polarity-aware exponents and black soft-clamp per APCA 0.0.98G-4g spec.
    """
    y_fg = apca_y(foreground)
    y_bg = apca_y(background)

    # Determine polarity: higher Y = lighter
    if y_bg >= y_fg:  # normal polarity (dark text on light bg)
        exp_bg = _NORM_BG
        exp_txt = _NORM_TXT
        is_reverse = False
    else:  # reverse polarity (light text on dark bg)
        exp_bg = _REV_BG
        exp_txt = _REV_TXT
        is_reverse = True

    # Apply black soft-clamp if needed (only to colors below threshold)
    def soft_clamp(y, exponent):
        if y < _BLK_THRS:
            return (y + (0.022 - y) ** _BLK_CLMP) ** exponent
        return y**exponent

    # Calculate SAPC
    y_bg_pow = soft_clamp(y_bg, exp_bg)
    y_fg_pow = soft_clamp(y_fg, exp_txt)

    if is_reverse:
        sapc = (y_bg_pow - y_fg_pow) * _SCALE
    else:
        sapc = (y_bg_pow - y_fg_pow) * _SCALE

    # Apply low-contrast offset (hysteresis)
    if abs(sapc) >= _LO_THRESH:
        if is_reverse:
            out = (sapc + _OFFSET) * 100
        else:
            out = (sapc - _OFFSET) * 100
    else:
        out = sapc * _LO_FACTOR * 100

    return abs(out)


def lum(value):
    def channel(part):
        part /= 255
        return part / 12.92 if part <= 0.03928 else ((part + 0.055) / 1.055) ** 2.4

    r, g, b = (channel(part) for part in rgb(value))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast(left, right):
    high, low = sorted((lum(left), lum(right)), reverse=True)
    return (high + 0.05) / (low + 0.05)


def badge(value):
    return f"<span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:{value}'></span> `{value}`"


def palette_table(name, palette):
    rows = [f"### {name}\n", "| Role | Color |", "| --- | --- |"]
    for role in ROLES:
        if role in palette:
            rows.append(f"| `{role}` | {badge(palette[role])} |")
    return "\n".join(rows)


def contrast_table(name, palette):
    rows = [
        f"### {name} contrast (WCAG 2)\n",
        "| Token | Ratio vs bg | Target |",
        "| --- | ---: | --- |",
    ]
    bg = palette["bg"]
    for key in TEXT_KEYS:
        ratio = contrast(bg, palette[key])
        target = (
            "AAA" if key == "text" and ratio >= 7 else "AA" if ratio >= 4.5 else "FAIL"
        )
        rows.append(f"| `{key}` | {ratio:.2f}:1 | {target} |")
    return "\n".join(rows)


def apca_table(name, palette, body_min, ui_min):
    rows = [
        f"### {name} APCA\n",
        "| Token | Lc vs bg | Target |",
        "| --- | ---: | --- |",
    ]
    bg = palette["bg"]
    for key in TEXT_KEYS:
        lc = apca_lc(palette[key], bg)
        target = "body" if lc >= body_min else "FAIL"
        rows.append(f"| `{key}` | {lc:.1f} | ≥{body_min} ({target}) |")
    for key in ["border_ui", "focus"]:
        lc = apca_lc(palette[key], bg)
        target = "UI" if lc >= ui_min else "FAIL"
        rows.append(f"| `{key}` | {lc:.1f} | ≥{ui_min} ({target}) |")
    return "\n".join(rows)


def ui_contrast_table(name, palette):
    rows = [
        f"### {name} UI affordance contrast\n",
        "| Token | Ratio vs bg | Target |",
        "| --- | ---: | --- |",
    ]
    bg = palette["bg"]
    for key in ["border_ui", "border_hi", "focus"]:
        ratio = contrast(bg, palette[key])
        target = "PASS" if ratio >= 3 else "FAIL"
        rows.append(f"| `{key}` | {ratio:.2f}:1 | {target} |")
    return "\n".join(rows)


def main():
    tokens = json.loads(TOKENS.read_text())
    guardrails = tokens["guardrails"]
    body_min = guardrails.get("minimum_apca_body", 75)
    ui_min = guardrails.get("minimum_apca_ui", 60)
    parts = [
        "# Dreamcoder Theme Preview",
        "",
        "Generated from `themes/dreamcoder/tokens.json`.",
        "",
    ]
    parts += [
        "## Design rationale",
        "",
        "Dreamcoder light themes follow a **cocoa/lúcuma** identity: warm parchment backgrounds, graphite-brown text, and restrained accents. Unlike generic light themes that jump from white to mid-gray surfaces, Dreamcoder uses a **flat surface ladder** (~10 luminance points between steps) so panels feel layered without looking muddy.",
        "",
        "Dreamcoder dark uses an **Ember Noir** identity: espresso/cacao glass surfaces, warm silver text, refined orange and maple red protagonists, and gold as the support accent. The opencode theme keeps the main background as `none` so the terminal's semi-transparent background remains visible while panels and selections carry the autumn glass color.",
        "",
        "Semantic tokens are intentionally distinct:",
        "",
        "- `comment` is softer and lower-chroma than `subtle` (syntax vs UI chrome).",
        "- Dark `accent` (refined ember orange), `accent_2` (maple red), `error` (soft coral red), and `warning` (lúcuma gold) form the orange/red/gold signature.",
        "- `focus` follows the orange protagonist instead of a separate cyan ring; `diagnostic` stays warm amber so the palette remains autumnal.",
        "- **Dusk** bridges daytime light and night dark for late-afternoon sessions on Arch.",
        "",
    ]
    parts += ["## Palette", ""]
    for mode, palette in tokens["modes"].items():
        parts.append(palette_table(palette.get("name", mode), palette))
        parts.append("")
    parts += ["## Contrast audit", ""]
    for mode, palette in tokens["modes"].items():
        label = palette.get("name", mode)
        parts.append(contrast_table(label, palette))
        parts.append("")
        parts.append(apca_table(label, palette, body_min, ui_min))
        parts.append("")
        parts.append(ui_contrast_table(label, palette))
        parts.append("")
    parts += [
        "## Usage",
        "",
        "```bash",
        "./scripts/dreamcoder auto",
        "./scripts/dreamcoder light",
        "./scripts/dreamcoder dusk",
        "./scripts/dreamcoder dark",
        "./scripts/dreamcoder verify",
        "./scripts/dreamcoder preview",
        "```",
        "",
    ]
    parts += [
        "## Design notes",
        "",
        "- Main backgrounds avoid pure black and pure white.",
        "- Main text targets AAA (WCAG 2) and APCA Lc ≥ 75 for long coding sessions.",
        "- Cocoa/Lúcuma accents are identity colors in light/dusk; Ember Noir uses refined orange, maple red, soft coral, and gold for dark-mode personality.",
        "- UI affordance tokens (`border_ui`, `border_hi`, `focus`) target at least 3:1 against the main background.",
        "- opencode uses one canonical theme: `dreamcoder`; its main `background` is generated as `none` for terminal transparency.",
        "",
    ]
    OUT.write_text("\n".join(parts))
    print(f"Generated {OUT}")


if __name__ == "__main__":
    main()
