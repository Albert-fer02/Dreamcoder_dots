#!/usr/bin/env python3
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FILES = [
    ROOT / "Codex-App/Dreamcoder.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Light.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Dark.codex-theme.json",
]
TOKEN_FILE = ROOT / "themes/dreamcoder/tokens.json"
OPENCODE_THEME_DIR = ROOT / ".opencode/themes"
TEXT_KEYS = ["text", "textMuted", "primary", "info", "success", "error", "warning"]
SYNTAX_KEYS = [
    "syntaxKeyword", "syntaxFunction", "syntaxMethod", "syntaxVariable",
    "syntaxParameter", "syntaxProperty", "syntaxField", "syntaxString",
    "syntaxType", "syntaxEnum", "syntaxOperator", "syntaxComment",
    "syntaxTodo", "syntaxDeprecated",
]
TOKEN_TEXT_KEYS = ["text", "muted", "comment", "accent", "accent_2", "diagnostic", "sage", "error", "warning"]
HEX = re.compile(r"^#[0-9a-fA-F]{6}$")

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

def require(condition, message):
    if not condition:
        raise SystemExit(message)

def check_tokens():
    tokens = json.loads(TOKEN_FILE.read_text())
    require(tokens["guardrails"]["canonical_opencode_theme"] == "dreamcoder", "tokens: canonical opencode theme must be dreamcoder")
    for mode, palette in tokens["modes"].items():
        bg = palette["bg"]
        require(HEX.match(bg), f"tokens:{mode}: invalid background")
        require(bg.lower() not in {"#000000", "#ffffff"}, f"tokens:{mode}: harsh background")
        for key in TOKEN_TEXT_KEYS:
            value = palette[key]
            require(HEX.match(value), f"tokens:{mode}:{key}: invalid hex")
            require(contrast(bg, value) >= 4.5, f"tokens:{mode}:{key} contrast below 4.5")
        require(contrast(bg, palette["text"]) >= 7, f"tokens:{mode}: main text below AAA")

def check_theme_file(file):
    theme = json.loads(file.read_text())["theme"]
    bg = theme["background"]
    require(bg not in {"#000000", "#ffffff"}, f"{file}: background uses harsh pure black/white")
    require(0.004 < lum(bg) < 0.94, f"{file}: background luminance is outside comfort band")
    for key in TEXT_KEYS + SYNTAX_KEYS:
        ratio = contrast(bg, theme[key])
        require(ratio >= 4.5, f"{file}: {key} contrast {ratio:.2f} < 4.5")
    require(contrast(bg, theme["text"]) >= 7, f"{file}: main text contrast below AAA")

def check_opencode_repo():
    names = sorted(path.name for path in OPENCODE_THEME_DIR.glob("*.json"))
    require(names == ["dreamcoder.json"], f"opencode repo themes must only contain dreamcoder.json, got {names}")

check_tokens()
for file in FILES:
    check_theme_file(file)
check_opencode_repo()
print("✓ Dreamcoder theme health guardrails passed")
