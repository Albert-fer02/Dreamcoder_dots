#!/usr/bin/env python3
import json
import plistlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FILES = [
    ROOT / "Codex-App/Dreamcoder.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Light.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Dark.codex-theme.json",
    ROOT / "Codex-App/Dreamcoder-Dusk.codex-theme.json",
]
TOKEN_FILE = ROOT / "themes/dreamcoder/tokens.json"
OPENCODE_THEME_DIR = ROOT / ".opencode/themes"
CODEX_CLI_FILES = [
    ROOT / "Codex-CLI/Dreamcoder.tmTheme",
    ROOT / "Codex-CLI/Dreamcoder-Light.tmTheme",
    ROOT / "Codex-CLI/Dreamcoder-Dark.tmTheme",
    ROOT / "Codex-CLI/Dreamcoder-Dusk.tmTheme",
]
TEXT_KEYS = ["text", "textMuted", "primary", "info", "success", "error", "warning"]
UI_KEYS = ["border", "borderActive", "borderFocus"]
QUIET_UI_KEYS = ["border"]
BACKGROUND_KEYS = ["backgroundPanel", "backgroundElement", "backgroundHover", "backgroundCode", "backgroundLine", "diffAddedBg", "diffRemovedBg", "diffHunkHeaderBg"]
SELECTED_BACKGROUND_KEYS = ["backgroundSelected"]
SYNTAX_KEYS = [
    "syntaxKeyword", "syntaxFunction", "syntaxMethod", "syntaxVariable",
    "syntaxParameter", "syntaxProperty", "syntaxField", "syntaxString",
    "syntaxType", "syntaxEnum", "syntaxOperator", "syntaxComment",
    "syntaxTodo", "syntaxDeprecated",
]
TOKEN_TEXT_KEYS = ["text", "muted", "comment", "accent", "accent_2", "diagnostic", "sage", "error", "warning"]
TOKEN_BODY_APCA_KEYS = ["text", "diagnostic", "error", "warning"]
TOKEN_ACCENT_APCA_KEYS = ["accent", "accent_2", "sage"]
TOKEN_QUIET_APCA_KEYS = ["muted", "comment", "subtle"]
TOKEN_UI_KEYS = ["border_ui", "focus"]
HEX = re.compile(r"^#[0-9a-fA-F]{6}$")

def rgb(value):
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))

def srgb_lin(channel):
    channel /= 255
    return channel / 12.92 if channel <= 0.040448236 else ((channel + 0.055) / 1.055) ** 2.4

def apca_y(value):
    r, g, b = (srgb_lin(part) for part in rgb(value))
    y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b
    return y ** 0.56

def apca_lc(foreground, background):
    y_fg, y_bg = apca_y(foreground), apca_y(background)
    if y_bg >= y_fg:
        return (y_bg - y_fg) * 1.14 * 100
    return (y_fg - y_bg) * 1.14 * 100

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
    guardrails = tokens["guardrails"]
    apca_body_light = guardrails.get("minimum_apca_body", 75)
    apca_body_dark = guardrails.get("minimum_apca_body_dark", 60)
    apca_quiet = guardrails.get("minimum_apca_quiet", 55)
    apca_ui_light = guardrails.get("minimum_apca_ui", 60)
    apca_ui_dark = guardrails.get("minimum_apca_ui_dark", 28)
    require(tokens["guardrails"]["canonical_opencode_theme"] == "dreamcoder", "tokens: canonical opencode theme must be dreamcoder")
    for mode, palette in tokens["modes"].items():
        bg = palette["bg"]
        require(HEX.match(bg), f"tokens:{mode}: invalid background")
        require(bg.lower() not in {"#000000", "#ffffff"}, f"tokens:{mode}: harsh background")
        for key in TOKEN_TEXT_KEYS:
            require(key in palette, f"tokens:{mode}:{key}: missing token")
            value = palette[key]
            require(HEX.match(value), f"tokens:{mode}:{key}: invalid hex")
            require(contrast(bg, value) >= 4.5, f"tokens:{mode}:{key} contrast below 4.5")
        if palette.get("details") == "lighter":
            apca_body = apca_body_light
            apca_body_keys = TOKEN_BODY_APCA_KEYS
            apca_accent = apca_body_dark
            apca_accent_keys = TOKEN_ACCENT_APCA_KEYS
        else:
            apca_body = apca_body_dark
            apca_body_keys = TOKEN_BODY_APCA_KEYS
            apca_accent_keys = []
            apca_accent = apca_body_dark
        for key in apca_body_keys:
            value = palette[key]
            require(apca_lc(value, bg) >= apca_body, f"tokens:{mode}:{key} APCA Lc {apca_lc(value, bg):.1f} < {apca_body}")
        for key in apca_accent_keys:
            value = palette[key]
            require(apca_lc(value, bg) >= apca_accent, f"tokens:{mode}:{key} APCA Lc {apca_lc(value, bg):.1f} < {apca_accent}")
        for key in TOKEN_QUIET_APCA_KEYS:
            if key not in palette:
                continue
            value = palette[key]
            require(apca_lc(value, bg) >= apca_quiet, f"tokens:{mode}:{key} APCA Lc {apca_lc(value, bg):.1f} < {apca_quiet}")
        require(contrast(bg, palette["text"]) >= 7, f"tokens:{mode}: main text below AAA")
        require(apca_lc(palette["text"], bg) >= apca_body, f"tokens:{mode}: main text APCA below {apca_body}")
        require(palette["border_ui"] != palette["border_hi"], f"tokens:{mode}: border_ui and border_hi must differ")
        require(palette["comment"] != palette["subtle"], f"tokens:{mode}: comment and subtle must differ")
        require(palette["focus"] != palette["diagnostic"], f"tokens:{mode}: focus and diagnostic must differ")
        require(palette["accent"] != palette["accent_2"], f"tokens:{mode}: accent and accent_2 must differ")
        apca_ui = apca_ui_light if mode in {"light", "dusk"} else apca_ui_dark
        for key in TOKEN_UI_KEYS:
            require(key in palette, f"tokens:{mode}:{key}: missing UI token")
            value = palette[key]
            require(HEX.match(value), f"tokens:{mode}:{key}: invalid hex")
            require(contrast(bg, value) >= 3, f"tokens:{mode}:{key} contrast below 3.0")
            require(apca_lc(value, bg) >= apca_ui, f"tokens:{mode}:{key} APCA Lc {apca_lc(value, bg):.1f} < {apca_ui}")

def check_theme_file(file):
    if not file.exists():
        return
    theme = json.loads(file.read_text())["theme"]
    bg = theme["background"]
    require(bg not in {"#000000", "#ffffff"}, f"{file}: background uses harsh pure black/white")
    require(0.004 < lum(bg) < 0.94, f"{file}: background luminance is outside comfort band")
    for key in TEXT_KEYS + SYNTAX_KEYS:
        ratio = contrast(bg, theme[key])
        require(ratio >= 4.5, f"{file}: {key} contrast {ratio:.2f} < 4.5")
    for key in UI_KEYS:
        ratio = contrast(bg, theme[key])
        require(ratio >= 3, f"{file}: {key} UI contrast {ratio:.2f} < 3")
        if key in QUIET_UI_KEYS:
            require(ratio <= 7, f"{file}: {key} UI contrast {ratio:.2f} is too loud")
    for key in BACKGROUND_KEYS:
        ratio = contrast(bg, theme[key])
        require(ratio >= 1.05, f"{file}: {key} surface contrast {ratio:.2f} < 1.05")
        require(ratio <= 2.4, f"{file}: {key} surface contrast {ratio:.2f} > 2.4")
    for key in SELECTED_BACKGROUND_KEYS:
        ratio = contrast(bg, theme[key])
        if lum(bg) > 0.5:
            require(ratio >= 7, f"{file}: {key} light selection contrast {ratio:.2f} < 7")
        else:
            require(ratio >= 1.05, f"{file}: {key} surface contrast {ratio:.2f} < 1.05")
            require(ratio <= 2.4, f"{file}: {key} surface contrast {ratio:.2f} > 2.4")
    require(contrast(theme["terminalCyan"], theme["background"]) >= contrast(theme["terminalBlue"], theme["background"]), f"{file}: terminal cyan should be at least as legible as terminal blue")
    require(contrast(bg, theme["text"]) >= 7, f"{file}: main text contrast below AAA")

def check_codex_cli_theme(file):
    if not file.exists():
        return
    data = plistlib.loads(file.read_bytes())
    settings = data["settings"][0]["settings"]
    bg = settings["background"]
    fg = settings["foreground"]
    require(HEX.match(bg), f"{file}: invalid background")
    require(HEX.match(fg), f"{file}: invalid foreground")
    require(contrast(bg, fg) >= 7, f"{file}: foreground contrast below AAA")
    require(contrast(bg, settings["selection"]) >= 1.2, f"{file}: selection too faint")
    if lum(bg) > 0.5:
        require(contrast(bg, settings["selection"]) >= 7, f"{file}: light selection must invert strongly")
        require(contrast(bg, settings["lineHighlight"]) >= 1.15, f"{file}: light line highlight too faint")
        require(contrast(bg, settings["gutter"]) >= 1.45, f"{file}: light gutter too faint")

def check_opencode_repo():
    names = sorted(path.name for path in OPENCODE_THEME_DIR.glob("*.json"))
    require(names == ["dreamcoder.json"], f"opencode repo themes must only contain dreamcoder.json, got {names}")

check_tokens()
for file in FILES:
    check_theme_file(file)
for file in CODEX_CLI_FILES:
    check_codex_cli_theme(file)
check_opencode_repo()
print("✓ Dreamcoder theme health guardrails passed")
