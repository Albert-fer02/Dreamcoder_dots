#!/usr/bin/env python3
"""Generate Dreamcoder theme files for terminal and desktop UI."""

import json
import os
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
mode = os.environ.get("DREAMCODER_THEME_MODE", "dark").lower()
if mode not in {"dark", "light"}:
    raise SystemExit("DREAMCODER_THEME_MODE must be 'dark' or 'light'")

kitty = Path(os.environ.get("KITTY_COLORS", config_home / "kitty/colors-dreamcoder.conf"))
ghostty = Path(os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder"))
starship = Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml"))
warp = Path(os.environ.get("WARP_THEME", data_home / "warp-terminal/themes/Dreamcoder.yaml"))
opencode = Path(os.environ.get("OPENCODE_THEME", config_home / "opencode/themes/dreamcoder.json"))
opencode_alias = Path(os.environ.get("OPENCODE_THEME_ALIAS", config_home / "opencode/themes/gentleman-dreamcoder-legible.json"))
wallpaper = Path(os.environ.get("DREAMCODER_WALLPAPER", ""))
adaptive = os.environ.get("DREAMCODER_ADAPTIVE", "1") != "0"

VARIANTS = {
    "dark": {
        "name": "Dreamcoder Dark",
        "bg": "#101216",
        "bg_soft": "#161922",
        "surface0": "#1c222b",
        "surface1": "#282e38",
        "surface2": "#353b45",
        "text": "#e8e1d7",
        "muted": "#b8b0a5",
        "subtle": "#928a80",
        "comment": "#8c857c",
        "border": "#3d4350",
        "border_hi": "#c8bda9",
        "accent": "#d9ad67",
        "accent_2": "#b87a48",
        "diagnostic": "#92c7cd",
        "sage": "#a5b89c",
        "lavender": "#c4b3df",
        "mauve": "#d2a3c3",
        "error": "#d78373",
        "warning": "#ddb36b",
        "selection": "#32291f",
        "panel_rgba": "rgba(16, 18, 22, 0.76)",
        "module_rgba": "rgba(232, 225, 215, 0.07)",
        "active_rgba": "rgba(217, 173, 103, 0.14)",
        "inactive_border": "rgba(3d4350b3)",
        "details": "darker",
        "prompt_bg": "#19120c",
        "prompt_surface0": "#2a1d13",
        "prompt_surface1": "#402c18",
        "prompt_surface2": "#5a3a1f",
        "prompt_text": "#f4e9dd",
        "prompt_muted": "#d5c3b5",
        "prompt_accent": "#e8aa67",
        "prompt_accent_2": "#be7d42",
    },
    "light": {
        "name": "Dreamcoder Light",
        "bg": "#f6f1e8",
        "bg_soft": "#ece4d8",
        "surface0": "#fbf8f1",
        "surface1": "#ded3c4",
        "surface2": "#c2b39f",
        "text": "#15130f",
        "muted": "#4a463f",
        "subtle": "#6b6458",
        "comment": "#6a6258",
        "border": "#b7a78f",
        "border_hi": "#75644f",
        "accent": "#855719",
        "accent_2": "#7f4a27",
        "diagnostic": "#1e6871",
        "sage": "#496f45",
        "lavender": "#665593",
        "mauve": "#844c71",
        "error": "#9b4b40",
        "warning": "#765019",
        "selection": "#dcc49e",
        "panel_rgba": "rgba(246, 241, 232, 0.90)",
        "module_rgba": "rgba(21, 19, 15, 0.075)",
        "active_rgba": "rgba(133, 87, 25, 0.15)",
        "inactive_border": "rgba(b7a78fdf)",
        "details": "lighter",
        "prompt_bg": "#f6f1e8",
        "prompt_surface0": "#fbefd9",
        "prompt_surface1": "#dcc094",
        "prompt_surface2": "#bd905a",
        "prompt_text": "#241911",
        "prompt_muted": "#63503e",
        "prompt_accent": "#985d2b",
        "prompt_accent_2": "#7a5028",
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


def matugen_scheme(path: Path, mode_name: str) -> dict[str, str]:
    if not adaptive or not path.is_file():
        return {}
    result = subprocess.run(
        ["matugen", "image", str(path), "--json", "hex", "-m", mode_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        check=False,
    )
    match = re.search(r"\{.*\}", result.stdout, flags=re.S)
    if not match:
        return {}
    return json.loads(match.group(0)).get("colors", {}).get(mode_name, {})


def adaptive_palette(base: dict[str, str], mode_name: str) -> dict[str, str]:
    scheme = matugen_scheme(wallpaper, mode_name)
    if not scheme:
        return base

    c = dict(base)
    bg = mix(c["bg"], scheme.get("background", c["bg"]), 0.18)
    if contrast(bg, c["text"]) >= 7:
        c["bg"] = bg
    c["surface0"] = mix(c["surface0"], scheme.get("surface_container", c["surface0"]), 0.16)
    c["surface1"] = mix(c["surface1"], scheme.get("surface_container_high", c["surface1"]), 0.18)
    c["surface2"] = mix(c["surface2"], scheme.get("surface_variant", c["surface2"]), 0.18)
    c["accent"] = guard(mix(c["prompt_accent"], scheme.get("primary", c["accent"]), 0.25), c["bg"], mode_name)
    c["accent_2"] = guard(mix(c["prompt_accent_2"], scheme.get("secondary", c["accent_2"]), 0.22), c["bg"], mode_name)
    c["diagnostic"] = guard(mix(c["diagnostic"], scheme.get("tertiary", c["diagnostic"]), 0.45), c["bg"], mode_name)
    c["border"] = mix(c["border"], scheme.get("outline", c["border"]), 0.25)
    c["selection"] = mix(c["selection"], scheme.get("primary_container", c["selection"]), 0.18)
    c["prompt_accent"] = c["accent"]
    c["prompt_accent_2"] = c["accent_2"]
    return c


def ansi(palette: dict[str, str]) -> list[str]:
    return [resolve_color(palette, key) for key in ANSI_KEYS]


def write_if_changed(path: Path, content: str) -> bool:
    old = path.read_text() if path.exists() else ""
    if old == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    return True


def valid_starship(path: Path) -> bool:
    return subprocess.run(
        ["starship", "explain"],
        env={**os.environ, "STARSHIP_CONFIG": str(path)},
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    ).returncode == 0


def kitty_content(c: dict[str, str]) -> str:
    p = ansi(c)
    return f"""# ==========================================================
#              {c['name']}
# ==========================================================
# Color-only theme layer. Keep ML4W/Gentleman behavior elsewhere.

foreground              {c['text']}
background              {c['bg']}
selection_foreground    {c['text']}
selection_background    {c['selection']}
url_color               {c['diagnostic']}

cursor                  {c['accent']}
cursor_text_color       {c['bg']}
cursor_shape            block
cursor_blink_interval   0.5
cursor_stop_blinking_after 15.0

active_tab_foreground   {c['bg']}
active_tab_background   {c['accent']}
inactive_tab_foreground {c['muted']}
inactive_tab_background {c['surface0']}
tab_bar_background      {c['bg']}

active_border_color     {c['accent']}
inactive_border_color   {c['border']}
bell_border_color       {c['error']}

color0  {p[0]}
color1  {p[1]}
color2  {p[2]}
color3  {p[3]}
color4  {p[4]}
color5  {p[5]}
color6  {p[6]}
color7  {p[7]}
color8  {p[8]}
color9  {p[9]}
color10 {p[10]}
color11 {p[11]}
color12 {p[12]}
color13 {p[13]}
color14 {p[14]}
color15 {p[15]}
color16 {c['accent_2']}
color17 {c['error']}

mark1_foreground        {c['bg']}
mark1_background        {c['accent']}
mark2_foreground        {c['bg']}
mark2_background        {c['diagnostic']}
mark3_foreground        {c['bg']}
mark3_background        {c['mauve']}
"""


def ghostty_content(c: dict[str, str]) -> str:
    lines = [
        f"# {c['name']}",
        f"background = {c['bg']}",
        f"foreground = {c['text']}",
        f"cursor-color = {c['accent']}",
        f"cursor-text = {c['bg']}",
        f"selection-background = {c['selection']}",
        f"selection-foreground = {c['text']}",
        "",
    ]
    lines.extend(f"palette = {i}={color}" for i, color in enumerate(ansi(c)))
    return "\n".join(lines) + "\n"


def warp_content(c: dict[str, str]) -> str:
    p = ansi(c)
    return f"""name: {c['name']}
accent: '{c['accent']}'
cursor: '{c['accent']}'
background: '{c['bg']}'
foreground: '{c['text']}'
details: {c['details']}
terminal_colors:
  normal:
    black: '{p[0]}'
    red: '{p[1]}'
    green: '{p[2]}'
    yellow: '{p[3]}'
    blue: '{p[4]}'
    magenta: '{p[5]}'
    cyan: '{p[6]}'
    white: '{p[7]}'
  bright:
    black: '{p[8]}'
    red: '{p[9]}'
    green: '{p[10]}'
    yellow: '{p[11]}'
    blue: '{p[12]}'
    magenta: '{p[13]}'
    cyan: '{p[14]}'
    white: '{p[15]}'
"""



def opencode_tokens(c: dict[str, str]) -> dict[str, str]:
    mode_name = "dark" if c["details"] == "darker" else "light"
    keyword = guard(mix(c["accent"], c["warning"], 0.22), c["bg"], mode_name)
    function = guard(c["diagnostic"], c["bg"], mode_name)
    type_color = guard(c["lavender"], c["bg"], mode_name)
    constant = guard(mix(c["accent_2"], c["mauve"], 0.24), c["bg"], mode_name)
    return {
        "keyword": keyword,
        "function": function,
        "method": guard(mix(function, c["text"], 0.10), c["bg"], mode_name),
        "variable": c["text"],
        "parameter": guard(mix(c["text"], c["accent_2"], 0.18), c["bg"], mode_name),
        "property": guard(mix(c["text"], c["diagnostic"], 0.34), c["bg"], mode_name),
        "field": guard(mix(c["text"], c["sage"], 0.22), c["bg"], mode_name),
        "string": guard(c["sage"], c["bg"], mode_name),
        "number": guard(c["accent_2"], c["bg"], mode_name),
        "constant": constant,
        "type": type_color,
        "constructor": guard(mix(type_color, c["accent"], 0.18), c["bg"], mode_name),
        "enum": guard(mix(type_color, c["sage"], 0.18), c["bg"], mode_name),
        "operator": guard(c["mauve"], c["bg"], mode_name),
        "punctuation": guard(c["muted"], c["bg"], mode_name),
        "comment": guard(c["comment"], c["bg"], mode_name),
        "todo": guard(mix(c["warning"], c["text"], 0.12), c["bg"], mode_name),
        "deprecated": guard(mix(c["error"], c["muted"], 0.28), c["bg"], mode_name),
        "code_bg": mix(c["surface0"], c["bg"], 0.28),
        "selection": c["selection"],
        "search": mix(c["warning"], c["bg"], 0.72),
    }

def opencode_content(c: dict[str, str]) -> str:
    t = opencode_tokens(c)
    mode_name = "dark" if c["details"] == "darker" else "light"
    added_bg = mix(c["sage"], c["bg"], 0.82)
    removed_bg = mix(c["error"], c["bg"], 0.84)
    hunk_bg = mix(c["lavender"], c["bg"], 0.84)
    line_bg = mix(c["surface0"], c["bg"], 0.62)
    assistant = guard(mix(c["diagnostic"], c["text"], 0.18), c["bg"], mode_name)
    user = guard(mix(c["accent"], c["text"], 0.15), c["bg"], mode_name)
    return f'''{{
  "$schema": "https://opencode.ai/theme.json",
  "defs": {{
    "dreamBackground": "{c['bg']}",
    "dreamPanel": "{c['surface0']}",
    "dreamElement": "{c['bg_soft']}",
    "dreamText": "{c['text']}",
    "dreamMuted": "{c['muted']}",
    "dreamCocoa": "{c['accent_2']}",
    "dreamLucuma": "{c['accent']}",
    "dreamDiagnostic": "{c['diagnostic']}",
    "dreamSage": "{c['sage']}",
    "dreamViolet": "{c['lavender']}",
    "dreamMauve": "{c['mauve']}",
    "dreamCoral": "{c['error']}",
    "dreamWarning": "{c['warning']}"
  }},
  "theme": {{
    "background": "{c['bg']}",
    "backgroundPanel": "{c['surface0']}",
    "backgroundElement": "{c['bg_soft']}",
    "backgroundHover": "{mix(c['surface1'], c['bg'], 0.45)}",
    "backgroundSelected": "{t['selection']}",
    "backgroundCode": "{t['code_bg']}",
    "backgroundSearch": "{t['search']}",
    "backgroundLine": "{line_bg}",
    "backgroundAssistant": "{mix(c['diagnostic'], c['bg'], 0.84)}",
    "backgroundUser": "{mix(c['accent'], c['bg'], 0.84)}",
    "backgroundTool": "{mix(c['lavender'], c['bg'], 0.86)}",
    "text": "{c['text']}",
    "textMuted": "{c['muted']}",
    "textSubtle": "{c['subtle']}",
    "textPlaceholder": "{c['comment']}",
    "textAssistant": "{assistant}",
    "textUser": "{user}",
    "textTool": "{t['type']}",
    "primary": "{c['accent']}",
    "secondary": "{c['accent_2']}",
    "accent": "{c['accent']}",
    "accentMuted": "{mix(c['accent'], c['bg'], 0.48)}",
    "error": "{c['error']}",
    "warning": "{c['warning']}",
    "success": "{c['sage']}",
    "info": "{c['diagnostic']}",
    "border": "{c['border_hi']}",
    "borderActive": "{c['accent']}",
    "borderSubtle": "{c['border']}",
    "borderFocus": "{c['diagnostic']}",
    "shadow": "{mix(c['bg'], '#000000', 0.25)}",
    "diffAdded": "{c['sage']}",
    "diffRemoved": "{c['error']}",
    "diffContext": "{c['muted']}",
    "diffHunkHeader": "{c['lavender']}",
    "diffHighlightAdded": "{c['sage']}",
    "diffHighlightRemoved": "{c['error']}",
    "diffAddedBg": "{added_bg}",
    "diffRemovedBg": "{removed_bg}",
    "diffContextBg": "{c['bg']}",
    "diffLineNumber": "{c['subtle']}",
    "diffAddedLineNumberBg": "{added_bg}",
    "diffRemovedLineNumberBg": "{removed_bg}",
    "diffHunkHeaderBg": "{hunk_bg}",
    "diffFold": "{c['comment']}",
    "diffFoldBg": "{mix(c['surface1'], c['bg'], 0.82)}",
    "markdownText": "{c['text']}",
    "markdownHeading": "{c['accent']}",
    "markdownLink": "{c['diagnostic']}",
    "markdownLinkText": "{c['accent']}",
    "markdownCode": "{c['sage']}",
    "markdownBlockQuote": "{c['accent_2']}",
    "markdownEmph": "{c['diagnostic']}",
    "markdownStrong": "{c['accent']}",
    "markdownHorizontalRule": "{c['border']}",
    "markdownListItem": "{c['accent']}",
    "markdownListEnumeration": "{c['lavender']}",
    "markdownTableBorder": "{c['border_hi']}",
    "markdownTableHeader": "{c['accent_2']}",
    "markdownImage": "{c['mauve']}",
    "markdownImageText": "{c['text']}",
    "markdownCodeBlock": "{c['text']}",
    "markdownCodeBlockBg": "{t['code_bg']}",
    "markdownInlineCodeBg": "{mix(c['sage'], c['bg'], 0.84)}",
    "syntaxComment": "{t['comment']}",
    "syntaxKeyword": "{t['keyword']}",
    "syntaxFunction": "{t['function']}",
    "syntaxMethod": "{t['method']}",
    "syntaxVariable": "{t['variable']}",
    "syntaxParameter": "{t['parameter']}",
    "syntaxProperty": "{t['property']}",
    "syntaxField": "{t['field']}",
    "syntaxString": "{t['string']}",
    "syntaxNumber": "{t['number']}",
    "syntaxBoolean": "{t['constant']}",
    "syntaxConstant": "{t['constant']}",
    "syntaxType": "{t['type']}",
    "syntaxClass": "{t['constructor']}",
    "syntaxInterface": "{mix(t['type'], c['diagnostic'], 0.22)}",
    "syntaxEnum": "{t['enum']}",
    "syntaxOperator": "{t['operator']}",
    "syntaxPunctuation": "{t['punctuation']}",
    "syntaxTag": "{t['keyword']}",
    "syntaxAttribute": "{t['property']}",
    "syntaxRegexp": "{mix(c['mauve'], c['error'], 0.28)}",
    "syntaxEscape": "{c['warning']}",
    "syntaxNamespace": "{t['type']}",
    "syntaxModule": "{t['type']}",
    "syntaxDecorator": "{t['operator']}",
    "syntaxBuiltin": "{t['constant']}",
    "syntaxSpecial": "{c['warning']}",
    "syntaxTodo": "{t['todo']}",
    "syntaxDeprecated": "{t['deprecated']}",
    "terminalBlack": "{c['surface0']}",
    "terminalRed": "{c['error']}",
    "terminalGreen": "{c['sage']}",
    "terminalYellow": "{c['warning']}",
    "terminalBlue": "{c['diagnostic']}",
    "terminalMagenta": "{c['mauve']}",
    "terminalCyan": "{c['lavender']}",
    "terminalWhite": "{c['text']}",
    "terminalBrightBlack": "{c['subtle']}",
    "terminalBrightRed": "{guard(mix(c['error'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightGreen": "{guard(mix(c['sage'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightYellow": "{guard(mix(c['warning'], c['text'], 0.16), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightBlue": "{guard(mix(c['diagnostic'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightMagenta": "{guard(mix(c['mauve'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightCyan": "{guard(mix(c['lavender'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightWhite": "{c['text']}"
  }}
}}
'''


def starship_content(c: dict[str, str]) -> str:
    return f'''add_newline = true
palette = "dreamcoder"

format = """
[](fg:prompt_surface0)\\
$username\\
[](bg:prompt_surface1 fg:prompt_surface0)\\
$directory\\
[](bg:prompt_accent fg:prompt_surface1)\\
$git_branch\\
$git_status\\
[](fg:prompt_accent)\\
$fill\\
$hostname\\
$cmd_duration
$character"""

[palettes.dreamcoder]
bg = "{c['bg']}"
text = "{c['text']}"
muted = "{c['muted']}"
prompt_bg = "{c['prompt_bg']}"
prompt_surface0 = "{c['prompt_surface0']}"
prompt_surface1 = "{c['prompt_surface1']}"
prompt_surface2 = "{c['prompt_surface2']}"
prompt_text = "{c['prompt_text']}"
prompt_muted = "{c['prompt_muted']}"
prompt_accent = "{c['prompt_accent']}"
prompt_accent_2 = "{c['prompt_accent_2']}"
sage = "{c['sage']}"
diagnostic = "{c['diagnostic']}"
lavender = "{c['lavender']}"
mauve = "{c['mauve']}"
error = "{c['error']}"

[username]
show_always = true
style_user = "bg:prompt_surface0 fg:prompt_text bold"
style_root = "bg:prompt_surface0 fg:error bold"
format = "[  $user ]($style)"

[hostname]
ssh_only = true
style = "fg:prompt_muted bold"
format = "[ 󰣇 $hostname ]($style) "

[directory]
style = "bg:prompt_surface1 fg:prompt_text bold"
format = "[  $path ]($style)"
truncation_length = 2
truncate_to_repo = true

[git_branch]
symbol = ""
style = "bg:prompt_accent fg:prompt_bg bold"
format = "[ $symbol $branch ]($style)"

[git_status]
style = "bg:prompt_accent fg:prompt_bg bold"
format = "[$all_status$ahead_behind ]($style)"
conflicted = "${{count}} "
ahead = "⇡${{count}} "
behind = "⇣${{count}} "
diverged = "⇕⇡${{ahead_count}}⇣${{behind_count}} "
untracked = "?${{count}} "
stashed = "󰏗${{count}} "
modified = "~${{count}} "
staged = "+${{count}} "
renamed = "»${{count}} "
deleted = "✘${{count}} "

[fill]
symbol = " "

[bun]
symbol = ""
style = "fg:prompt_accent bold"
format = "[ $symbol $version]($style)"

[nodejs]
symbol = ""
style = "fg:sage bold"
format = "[ $symbol $version]($style)"

[python]
symbol = ""
style = "fg:diagnostic bold"
format = "[ $symbol $version]($style)"

[golang]
symbol = ""
style = "fg:lavender bold"
format = "[ $symbol $version]($style)"

[rust]
symbol = ""
style = "fg:mauve bold"
format = "[ $symbol $version]($style)"

[docker_context]
symbol = ""
style = "fg:diagnostic bold"
format = "[ $symbol $context]($style)"
only_with_files = true

[cmd_duration]
min_time = 2500
style = "fg:prompt_muted"
format = "[  $duration ]($style) "

[time]
disabled = true

[character]
success_symbol = "[❯](bold fg:prompt_accent)"
error_symbol = "[❯](bold fg:error)"
vimcmd_symbol = "[❮](bold fg:sage)"
'''


def hypr_content(c: dict[str, str]) -> str:
    return f"""# Dreamcoder color layer for Hyprland.
# Import after ML4W/Gentleman defaults; this changes colors only.

general {{
    col.active_border = rgba({c['accent'][1:]}ff) rgba({c['diagnostic'][1:]}ff) 45deg
    col.inactive_border = {c['inactive_border']}
}}

misc {{
    background_color = rgba({c['bg'][1:]}ff)
}}
"""


def waybar_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Waybar. */
@define-color bg {c['bg']};
@define-color bg-soft {c['bg_soft']};
@define-color surface {c['surface0']};
@define-color text {c['text']};
@define-color muted {c['muted']};
@define-color border {c['border']};
@define-color accent {c['accent']};
@define-color accent-2 {c['accent_2']};
@define-color diagnostic {c['diagnostic']};
@define-color error {c['error']};
@define-color success {c['sage']};
@define-color warning {c['warning']};

window#waybar {{
  background: {c['panel_rgba']};
  color: @text;
  border-bottom: 1px solid alpha(@accent, 0.26);
}}

#workspaces button {{
  color: @muted;
  background: transparent;
}}

#workspaces button.active {{
  color: @accent;
  background: {c['active_rgba']};
}}

#clock,
#battery,
#network,
#pulseaudio,
#cpu,
#memory,
#tray {{
  background: {c['module_rgba']};
  color: @text;
  border: 1px solid alpha(@border, 0.45);
}}

#battery.warning {{ color: @warning; }}
#battery.critical {{ color: @error; }}
#network.disconnected {{ color: @error; }}
"""


def rofi_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Rofi. */
* {{
  background: {c['panel_rgba']};
  background-alt: {c['surface0']};
  foreground: {c['text']};
  muted: {c['muted']};
  selected: {c['active_rgba']};
  active: {c['accent']};
  urgent: {c['error']};
  border-color: {c['accent']};
}}

window {{
  background-color: @background;
  border: 1px;
  border-color: @border-color;
  border-radius: 18px;
}}

entry {{
  background-color: @selected;
  text-color: @foreground;
  border-radius: 12px;
}}

element selected {{
  background-color: @selected;
  text-color: @foreground;
}}

element-text {{ text-color: @muted; }}
element selected element-text {{ text-color: @foreground; }}
"""


def readme_content() -> str:
    return """# Dreamcoder Palette Layer

This directory contains color-only snippets for applying the Dreamcoder identity on top of ML4W/Gentleman Dots.

- `*-dark.*`: Warp-inspired dark glass mode for daily work.
- `*-light.*`: Codex/OpenAI-inspired light mode for clean showcase and daytime use.

Import these snippets after your existing ML4W/Gentleman files so layouts, keybinds, wallpaper scripts, gaps, animations, and behavior remain owned by those systems.
"""


def write_variant_files(base: Path, dark_name: str, light_name: str, builder) -> list[bool]:
    dark = VARIANTS["dark"]
    light = VARIANTS["light"]
    return [
        write_if_changed(base / dark_name, builder(dark)),
        write_if_changed(base / light_name, builder(light)),
    ]


active = adaptive_palette(VARIANTS[mode], mode)
changed = {
    "kitty": write_if_changed(kitty, kitty_content(active)),
    "ghostty": write_if_changed(ghostty, ghostty_content(active)),
    "warp": write_if_changed(warp, warp_content(active)),
    "opencode": write_if_changed(opencode, opencode_content(active)),
    "opencode_alias": write_if_changed(opencode_alias, opencode_content(active)),
    "starship": write_if_changed(starship, starship_content(active)),
}

repo_changes = []
repo_changes += write_variant_files(ROOT / "Kitty/.config/kitty", "colors-dreamcoder-dark.conf", "colors-dreamcoder-light.conf", kitty_content)
repo_changes += write_variant_files(ROOT / "Ghostty/.config/ghostty/themes", "dreamcoder-dark", "dreamcoder-light", ghostty_content)
repo_changes += write_variant_files(ROOT / "Warp/.local/share/warp-terminal/themes", "Dreamcoder-Dark.yaml", "Dreamcoder-Light.yaml", warp_content)
repo_changes += write_variant_files(ROOT / "Shell/.config", "starship-dark.toml", "starship-light.toml", starship_content)
repo_changes += write_variant_files(ROOT / "Codex-App", "Dreamcoder-Dark.codex-theme.json", "Dreamcoder-Light.codex-theme.json", opencode_content)
repo_changes.append(write_if_changed(ROOT / "Codex-App/Dreamcoder.codex-theme.json", opencode_content(active)))
repo_changes.append(write_if_changed(ROOT / ".opencode/themes/dreamcoder.json", opencode_content(active)))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/hyprland-dark.conf", hypr_content(VARIANTS["dark"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/hyprland-light.conf", hypr_content(VARIANTS["light"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/waybar-dark.css", waybar_content(VARIANTS["dark"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/waybar-light.css", waybar_content(VARIANTS["light"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/rofi-dark.rasi", rofi_content(VARIANTS["dark"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/rofi-light.rasi", rofi_content(VARIANTS["light"])))
repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/README.md", readme_content()))

if not valid_starship(starship):
    raise SystemExit(f"Generated Starship config is invalid: {starship}")

print(f"Synced Dreamcoder {mode} identity")
print(f"Kitty: {kitty}")
print(f"Ghostty: {ghostty}")
print(f"Warp: {warp}")
print(f"opencode: {opencode}")
print(f"opencode alias: {opencode_alias}")
print(f"Starship: {starship}")
print("Changed: " + " ".join(f"{key}={value}" for key, value in changed.items()))
print(f"Repo variant/snippet changes: {sum(repo_changes)}")
