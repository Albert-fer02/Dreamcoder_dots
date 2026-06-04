#!/usr/bin/env python3
import json
import plistlib
import re
from pathlib import Path
from dreamcoder_theme.palette import ansi as terminal_ansi

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
KITTY_FILE = ROOT / "Kitty" / ".config" / "kitty" / "colors-dreamcoder-dark.conf"
STARSHIP_FILE = ROOT / "Shell" / ".config" / "starship-dark.toml"
GHOSTTY_FILE = ROOT / "Ghostty" / ".config" / "ghostty" / "themes" / "dreamcoder-dark"
WAYBAR_FILE = ROOT / "themes" / "dreamcoder" / "waybar-dark.css"
HYPRLAND_FILE = ROOT / "themes" / "dreamcoder" / "hyprland-dark.conf"
ROFI_FILE = ROOT / "themes" / "dreamcoder" / "rofi-dark.rasi"
HYPR_COLORS_LUA_GLOB = list((ROOT / "themes" / "dreamcoder").glob("hypr-colors-*.lua"))
HYPR_COLORS_CONF_GLOB = list((ROOT / "themes" / "dreamcoder").glob("hypr-colors-*.conf"))
BTOP_FILE = ROOT / "themes" / "dreamcoder" / "btop-dreamcoder-dark.theme"
DUNST_FILE = ROOT / "themes" / "dreamcoder" / "dunst-dreamcoder-dark.conf"
FZF_FILE = ROOT / "themes" / "dreamcoder" / "fzf-dreamcoder-dark.sh"
TEXT_KEYS = ["text", "textMuted", "primary", "info", "success", "error", "warning"]
UI_KEYS = ["border", "borderActive", "borderFocus"]
QUIET_UI_KEYS = ["border"]
BACKGROUND_KEYS = [
    "backgroundPanel",
    "backgroundElement",
    "backgroundHover",
    "backgroundCode",
    "backgroundLine",
    "diffAddedBg",
    "diffRemovedBg",
    "diffHunkHeaderBg",
]
SELECTED_BACKGROUND_KEYS = ["backgroundSelected"]
SYNTAX_KEYS = [
    "syntaxKeyword",
    "syntaxFunction",
    "syntaxMethod",
    "syntaxVariable",
    "syntaxParameter",
    "syntaxProperty",
    "syntaxField",
    "syntaxString",
    "syntaxType",
    "syntaxEnum",
    "syntaxOperator",
    "syntaxComment",
    "syntaxTodo",
    "syntaxDeprecated",
]
TOKEN_TEXT_KEYS = [
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
TOKEN_BODY_APCA_KEYS = ["text", "diagnostic", "error", "warning"]
TOKEN_ACCENT_APCA_KEYS = ["accent", "accent_2", "sage"]
TOKEN_QUIET_APCA_KEYS = ["muted", "comment", "subtle"]
TOKEN_UI_KEYS = ["border_ui", "focus"]
HEX = re.compile(r"^#[0-9a-fA-F]{6}$")
# RGBA pattern: rgba(r, g, b, a) with r/g/b 0-255 and a 0.0-1.0
RGBA = re.compile(
    r"^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(0|1|0?\.?\d+)\s*\)$"
)


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


def require(condition, message):
    if not condition:
        raise SystemExit(message)


def is_valid_rgba(value: str) -> bool:
    """Validate RGBA format and component ranges."""
    match = RGBA.match(value)
    if not match:
        return False
    r, g, b, a = (
        int(match.group(1)),
        int(match.group(2)),
        int(match.group(3)),
        float(match.group(4)),
    )
    return all(0 <= v <= 255 for v in (r, g, b)) and 0.0 <= a <= 1.0


def check_rgba_tokens():
    """Validate all rgba and inactive_border fields in tokens.json."""
    tokens = json.loads(TOKEN_FILE.read_text())
    rgba_keys = ["panel_rgba", "module_rgba", "active_rgba", "inactive_border"]

    for mode, palette in tokens["modes"].items():
        for key in rgba_keys:
            if key not in palette:
                continue
            value = palette[key]
            require(
                is_valid_rgba(value),
                f"tokens:{mode}:{key} invalid RGBA format: {value}",
            )


def check_apca_or_warn(mode, key, value, bg, threshold):
    """Check APCA contrast, log warning but don't fail (APCA is public beta, not a standard)."""
    import os

    lc = apca_lc(value, bg)
    if os.environ.get("DREAMCODER_ENFORCE_APCA", "") and lc < threshold:
        require(
            False,
            f"tokens:{mode}:{key} APCA Lc {lc:.1f} < {threshold} (APCA enforcement enabled)",
        )
    if lc < threshold:
        print(
            f"  ⚠ APCA advisory: tokens:{mode}:{key} Lc {lc:.1f} < {threshold} (WCAG {contrast(bg, value):.2f}:1 passes)"
        )


def check_tokens():
    tokens = json.loads(TOKEN_FILE.read_text())
    guardrails = tokens["guardrails"]
    apca_body_light = guardrails.get("minimum_apca_body", 75)
    apca_body_dark = guardrails.get("minimum_apca_body_dark", 60)
    apca_quiet = guardrails.get("minimum_apca_quiet", 55)
    apca_ui_light = guardrails.get("minimum_apca_ui", 60)
    apca_ui_dark = guardrails.get("minimum_apca_ui_dark", 28)
    terminal_ansi_min = guardrails.get("minimum_terminal_ansi_contrast", 4.5)
    terminal_cursor_min = guardrails.get("minimum_terminal_cursor_contrast", 4.5)
    terminal_selection_min = guardrails.get("minimum_terminal_selection_contrast", 7.0)
    require(
        tokens["guardrails"]["canonical_opencode_theme"] == "dreamcoder",
        "tokens: canonical opencode theme must be dreamcoder",
    )
    for mode, palette in tokens["modes"].items():
        bg = palette["bg"]
        require(HEX.match(bg), f"tokens:{mode}: invalid background")
        require(
            bg.lower() not in {"#000000", "#ffffff"}, f"tokens:{mode}: harsh background"
        )
        for key in TOKEN_TEXT_KEYS:
            require(key in palette, f"tokens:{mode}:{key}: missing token")
            value = palette[key]
            require(HEX.match(value), f"tokens:{mode}:{key}: invalid hex")
            require(
                contrast(bg, value) >= 4.5, f"tokens:{mode}:{key} contrast below 4.5"
            )
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
            check_apca_or_warn(mode, key, value, bg, apca_body)
        for key in apca_accent_keys:
            value = palette[key]
            check_apca_or_warn(mode, key, value, bg, apca_accent)
        for key in TOKEN_QUIET_APCA_KEYS:
            if key not in palette:
                continue
            value = palette[key]
            check_apca_or_warn(mode, key, value, bg, apca_quiet)
        require(
            contrast(bg, palette["text"]) >= 7, f"tokens:{mode}: main text below AAA"
        )
        check_apca_or_warn(mode, "text", palette["text"], bg, apca_body)
        for index, color in enumerate(terminal_ansi(palette)):
            require(
                contrast(color, bg) >= terminal_ansi_min,
                f"tokens:{mode}: ANSI color{index} contrast {contrast(color, bg):.2f} < {terminal_ansi_min}",
            )
        invert = palette.get("details") == "lighter"
        sel_fg = palette["bg"] if invert else palette["text"]
        sel_bg = palette["text"] if invert else palette["selection"]
        require(
            contrast(palette["accent"], bg) >= terminal_cursor_min,
            f"tokens:{mode}: cursor contrast {contrast(palette['accent'], bg):.2f} < {terminal_cursor_min}",
        )
        require(
            contrast(sel_fg, sel_bg) >= terminal_selection_min,
            f"tokens:{mode}: selection pair contrast {contrast(sel_fg, sel_bg):.2f} < {terminal_selection_min}",
        )
        require(
            palette["border_ui"] != palette["border_hi"],
            f"tokens:{mode}: border_ui and border_hi must differ",
        )
        require(
            palette["comment"] != palette["subtle"],
            f"tokens:{mode}: comment and subtle must differ",
        )
        require(
            palette["focus"] != palette["diagnostic"],
            f"tokens:{mode}: focus and diagnostic must differ",
        )
        require(
            palette["accent"] != palette["accent_2"],
            f"tokens:{mode}: accent and accent_2 must differ",
        )
        apca_ui = apca_ui_light if mode in {"light", "dusk"} else apca_ui_dark
        for key in TOKEN_UI_KEYS:
            require(key in palette, f"tokens:{mode}:{key}: missing UI token")
            value = palette[key]
            require(HEX.match(value), f"tokens:{mode}:{key}: invalid hex")
            require(contrast(bg, value) >= 3, f"tokens:{mode}:{key} contrast below 3.0")
            check_apca_or_warn(mode, key, value, bg, apca_ui)


def check_theme_file(file):
    if not file.exists():
        return
    theme = json.loads(file.read_text())["theme"]
    bg = theme["background"]
    require(
        bg not in {"#000000", "#ffffff"},
        f"{file}: background uses harsh pure black/white",
    )
    require(
        0.004 < lum(bg) < 0.94, f"{file}: background luminance is outside comfort band"
    )
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
        require(ratio >= 1.05, f"{file}: {key} surface contrast {ratio:.2f} < 1.05")
        require(ratio <= 2.4, f"{file}: {key} surface contrast {ratio:.2f} > 2.4")
    require(
        contrast(theme["terminalCyan"], theme["background"])
        >= contrast(theme["terminalBlue"], theme["background"]),
        f"{file}: terminal cyan should be at least as legible as terminal blue",
    )
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
    require(contrast(bg, settings["selection"]) >= 1.05, f"{file}: selection too faint")
    require(contrast(bg, settings["selection"]) <= 2.4, f"{file}: selection too loud")
    if lum(bg) > 0.5:
        require(
            contrast(bg, settings["lineHighlight"]) >= 1.15,
            f"{file}: light line highlight too faint",
        )
        require(
            contrast(bg, settings["gutter"]) >= 1.45, f"{file}: light gutter too faint"
        )


def check_opencode_repo():
    names = sorted(path.name for path in OPENCODE_THEME_DIR.glob("*.json"))
    require(
        names == ["dreamcoder.json"],
        f"opencode repo themes must only contain dreamcoder.json, got {names}",
    )


def check_kitty_colors(file):
    """Validate Kitty colors file has valid hex colors."""
    if not file.exists():
        return
    content = file.read_text()
    # Check for required color definitions
    for color_key in ["background", "foreground"]:
        if re.search(rf"^{color_key}\s+#[0-9a-fA-F]{{6}}", content, re.M):
            continue
        require(False, f"{file}: missing {color_key} definition")


def check_starship_config(file):
    """Validate Starship config has valid hex for key elements."""
    if not file.exists():
        return
    content = file.read_text()
    # Check that at least some style blocks exist with valid hex
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 4, f"{file}: missing sufficient hex color definitions")


def check_ghostty_theme(file):
    """Validate Ghostty theme has valid hex background/foreground."""
    if not file.exists():
        return
    content = file.read_text()
    for key in ["background", "foreground"]:
        match = re.search(rf"^{key}\s*=\s*#[0-9a-fA-F]{{6}}", content, re.M)
        require(bool(match), f"{file}: missing or invalid {key}")


def check_waybar_css(file):
    """Validate Waybar CSS has valid colors."""
    if not file.exists():
        return
    content = file.read_text()
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 2, f"{file}: missing sufficient hex color definitions")


def check_hypr_config(file):
    """Validate Hyprland config has valid colors for borders/backgrounds."""
    if not file.exists():
        return
    content = file.read_text()
    # Hyprland uses rgba(RRGGBBAA) compact format and col.*= hex formats
    has_rgba = bool(re.search(r"rgba\([0-9a-fA-F]{8}\)", content))
    has_hex = bool(re.search(r"col\.[a-z_]+\s*=\s*#[0-9a-fA-F]{6}", content))
    require(has_rgba or has_hex, f"{file}: missing valid color definitions")


def check_rofi_theme(file):
    """Validate Rofi CSS has valid colors."""
    if not file.exists():
        return
    content = file.read_text()
    # Rofi .rasi files use hex colors in * { color: #RRGGBB; } blocks
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 4, f"{file}: missing sufficient hex color definitions")


def check_btop_theme(file):
    """Validate Btop theme has valid colors."""
    if not file.exists():
        return
    content = file.read_text()
    # Btop themes use color definitions like: color0=XXXXXX
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 4, f"{file}: missing sufficient hex color definitions")


def check_dunst_theme(file):
    """Validate Dunst config has valid colors."""
    if not file.exists():
        return
    content = file.read_text()
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 1, f"{file}: missing hex color definitions")


def check_fzf_theme(file):
    """Validate Fzf shell snippet has valid exports."""
    if not file.exists():
        return
    content = file.read_text()
    hex_matches = re.findall(r"#[0-9a-fA-F]{6}", content)
    require(len(hex_matches) >= 1, f"{file}: missing hex color definitions")


def check_hypr_colors_file(file):
    """Validate a hypr-colors lua/conf file has valid color definitions."""
    if not file.exists():
        return
    content = file.read_text()
    has_rgba = bool(re.search(r"rgba\([0-9a-fA-F]{8}\)", content))
    require(has_rgba, f"{file}: missing valid rgba color definitions")


check_rgba_tokens()
check_tokens()
for file in FILES:
    check_theme_file(file)
for file in CODEX_CLI_FILES:
    check_codex_cli_theme(file)
check_opencode_repo()
# Optional target validations (skip if files don't exist)
check_kitty_colors(KITTY_FILE)
check_starship_config(STARSHIP_FILE)
check_ghostty_theme(GHOSTTY_FILE)
check_waybar_css(WAYBAR_FILE)
check_hypr_config(HYPRLAND_FILE)
check_rofi_theme(ROFI_FILE)
check_btop_theme(BTOP_FILE)
check_dunst_theme(DUNST_FILE)
check_fzf_theme(FZF_FILE)
for file in HYPR_COLORS_LUA_GLOB:
    check_hypr_colors_file(file)
for file in HYPR_COLORS_CONF_GLOB:
    check_hypr_colors_file(file)
print("✓ Dreamcoder theme health guardrails passed")
