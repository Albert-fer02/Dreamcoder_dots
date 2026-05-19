#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FILES = [
    ROOT / "Codex-App/Dreamcoder.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Light.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Dark.codex-theme.json",
]
TEXT_KEYS = ["text", "textMuted", "primary", "info", "success", "error", "warning"]
SYNTAX_KEYS = [
    "syntaxKeyword", "syntaxFunction", "syntaxMethod", "syntaxVariable",
    "syntaxParameter", "syntaxProperty", "syntaxField", "syntaxString",
    "syntaxType", "syntaxEnum", "syntaxOperator", "syntaxComment",
    "syntaxTodo", "syntaxDeprecated",
]

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

for file in FILES:
    theme = json.loads(file.read_text())["theme"]
    bg = theme["background"]
    if bg in {"#000000", "#ffffff"}:
        raise SystemExit(f"{file}: background uses harsh pure black/white")
    if not 0.004 < lum(bg) < 0.94:
        raise SystemExit(f"{file}: background luminance is outside comfort band")
    for key in TEXT_KEYS + SYNTAX_KEYS:
        ratio = contrast(bg, theme[key])
        if ratio < 4.5:
            raise SystemExit(f"{file}: {key} contrast {ratio:.2f} < 4.5")
    if contrast(bg, theme["text"]) < 7:
        raise SystemExit(f"{file}: main text contrast below AAA")
print("✓ Dreamcoder theme health guardrails passed")
