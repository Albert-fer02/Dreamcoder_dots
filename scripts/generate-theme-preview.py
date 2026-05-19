#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOKENS = ROOT / "themes/dreamcoder/tokens.json"
OUT = ROOT / "docs/dreamcoder-theme-preview.md"
TEXT_KEYS = ["text", "muted", "comment", "accent", "accent_2", "diagnostic", "sage", "error", "warning"]
ROLES = ["bg", "bg_soft", "surface0", "surface1", "text", "muted", "accent", "accent_2", "diagnostic", "sage", "lavender", "mauve", "error", "warning"]

def rgb(value):
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))

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
    rows = [f"### {name} contrast\n", "| Token | Ratio vs bg | Target |", "| --- | ---: | --- |"]
    bg = palette["bg"]
    for key in TEXT_KEYS:
        ratio = contrast(bg, palette[key])
        target = "AAA" if key == "text" and ratio >= 7 else "AA" if ratio >= 4.5 else "FAIL"
        rows.append(f"| `{key}` | {ratio:.2f}:1 | {target} |")
    return "\n".join(rows)

def main():
    tokens = json.loads(TOKENS.read_text())
    parts = ["# Dreamcoder Theme Preview", "", "Generated from `themes/dreamcoder/tokens.json`.", ""]
    parts += ["## Palette", ""]
    for mode, palette in tokens["modes"].items():
        parts.append(palette_table(palette.get("name", mode), palette))
        parts.append("")
    parts += ["## Contrast audit", ""]
    for mode, palette in tokens["modes"].items():
        parts.append(contrast_table(palette.get("name", mode), palette))
        parts.append("")
    parts += ["## Usage", "", "```bash", "./scripts/dreamcoder auto", "./scripts/dreamcoder light", "./scripts/dreamcoder dark", "./scripts/dreamcoder verify", "```", ""]
    parts += ["## Design notes", "", "- Main backgrounds avoid pure black and pure white.", "- Main text targets AAA contrast for long coding sessions.", "- Cocoa/Lúcuma accents are identity colors; cyan is diagnostic, not decoration.", "- opencode uses one canonical theme: `dreamcoder`.", ""]
    OUT.write_text("\n".join(parts))
    print(f"Generated {OUT}")

if __name__ == "__main__":
    main()
