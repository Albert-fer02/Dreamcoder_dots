#!/usr/bin/env python3
"""Generate Dreamcoder theme files for terminal and desktop UI."""

import os
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

VARIANTS = {
    "dark": {
        "name": "Dreamcoder Dark",
        "bg": "#0b0c0e",
        "bg_soft": "#111318",
        "surface0": "#171a20",
        "surface1": "#242831",
        "surface2": "#30343d",
        "text": "#f1eee7",
        "muted": "#b9bcc2",
        "subtle": "#858b94",
        "comment": "#707781",
        "border": "#343943",
        "border_hi": "#d8d6ce",
        "accent": "#d8b56d",
        "accent_2": "#b97945",
        "diagnostic": "#9ecad0",
        "sage": "#9fb99f",
        "lavender": "#c7b6e8",
        "mauve": "#d6a8ca",
        "error": "#d98a7a",
        "warning": "#e2bd73",
        "selection": "#2a241d",
        "panel_rgba": "rgba(11, 12, 14, 0.72)",
        "module_rgba": "rgba(241, 238, 231, 0.06)",
        "active_rgba": "rgba(216, 181, 109, 0.12)",
        "inactive_border": "rgba(343943b3)",
        "details": "darker",
        "prompt_bg": "#19120c",
        "prompt_surface0": "#2a1d13",
        "prompt_surface1": "#402c18",
        "prompt_surface2": "#5a3a1f",
        "prompt_text": "#f4e9dd",
        "prompt_muted": "#d5c3b5",
        "prompt_accent": "#fbb974",
        "prompt_accent_2": "#c9863f",
    },
    "light": {
        "name": "Dreamcoder Light",
        "bg": "#f7f5f0",
        "bg_soft": "#efede7",
        "surface0": "#ffffff",
        "surface1": "#e7e2d8",
        "surface2": "#d5cec2",
        "text": "#101113",
        "muted": "#565b63",
        "subtle": "#757b84",
        "comment": "#7b746b",
        "border": "#c9c3b8",
        "border_hi": "#948978",
        "accent": "#9a6f24",
        "accent_2": "#8f5730",
        "diagnostic": "#2f7882",
        "sage": "#587f5d",
        "lavender": "#6d5aa7",
        "mauve": "#985f86",
        "error": "#b65f51",
        "warning": "#8b641f",
        "selection": "#eadfc8",
        "panel_rgba": "rgba(247, 245, 240, 0.82)",
        "module_rgba": "rgba(16, 17, 19, 0.055)",
        "active_rgba": "rgba(154, 111, 36, 0.12)",
        "inactive_border": "rgba(c9c3b8d9)",
        "details": "lighter",
        "prompt_bg": "#f7f5f0",
        "prompt_surface0": "#fff8ee",
        "prompt_surface1": "#ead8bf",
        "prompt_surface2": "#d8bd93",
        "prompt_text": "#2a1d13",
        "prompt_muted": "#745f4e",
        "prompt_accent": "#b97945",
        "prompt_accent_2": "#9a6a32",
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


def opencode_content(c: dict[str, str]) -> str:
    return f'''{{
  "$schema": "https://opencode.ai/theme.json",
  "theme": {{
    "background": "none",
    "backgroundPanel": "{c['bg_soft']}",
    "backgroundElement": "{c['surface0']}",
    "text": "{c['text']}",
    "textMuted": "{c['muted']}",
    "primary": "{c['accent']}",
    "secondary": "{c['accent_2']}",
    "accent": "{c['accent']}",
    "error": "{c['error']}",
    "warning": "{c['warning']}",
    "success": "{c['sage']}",
    "info": "{c['diagnostic']}",
    "border": "{c['border']}",
    "borderActive": "{c['accent']}",
    "borderSubtle": "{c['surface1']}",
    "diffAdded": "{c['sage']}",
    "diffRemoved": "{c['error']}",
    "diffContext": "{c['muted']}",
    "diffHunkHeader": "{c['lavender']}",
    "diffHighlightAdded": "{c['sage']}",
    "diffHighlightRemoved": "{c['error']}",
    "diffAddedBg": "{c['bg_soft']}",
    "diffRemovedBg": "{c['bg_soft']}",
    "diffContextBg": "{c['bg']}",
    "diffLineNumber": "{c['subtle']}",
    "diffAddedLineNumberBg": "{c['bg_soft']}",
    "diffRemovedLineNumberBg": "{c['bg_soft']}",
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
    "markdownImage": "{c['mauve']}",
    "markdownImageText": "{c['text']}",
    "markdownCodeBlock": "{c['text']}",
    "syntaxComment": "{c['comment']}",
    "syntaxKeyword": "{c['accent']}",
    "syntaxFunction": "{c['diagnostic']}",
    "syntaxVariable": "{c['text']}",
    "syntaxString": "{c['sage']}",
    "syntaxNumber": "{c['accent_2']}",
    "syntaxType": "{c['lavender']}",
    "syntaxOperator": "{c['mauve']}",
    "syntaxPunctuation": "{c['muted']}"
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
$bun\\
$nodejs\\
$python\\
$golang\\
$rust\\
$docker_context\\
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
ssh_only = false
style = "fg:prompt_muted bold"
format = "[ 󰣇 $hostname ]($style) "

[directory]
style = "bg:prompt_surface1 fg:prompt_text bold"
format = "[  $path ]($style)"
truncation_length = 3
truncate_to_repo = false

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
min_time = 1500
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


active = VARIANTS[mode]
changed = {
    "kitty": write_if_changed(kitty, kitty_content(active)),
    "ghostty": write_if_changed(ghostty, ghostty_content(active)),
    "warp": write_if_changed(warp, warp_content(active)),
    "opencode": write_if_changed(opencode, opencode_content(active)),
    "starship": write_if_changed(starship, starship_content(active)),
}

repo_changes = []
repo_changes += write_variant_files(ROOT / "Kitty/.config/kitty", "colors-dreamcoder-dark.conf", "colors-dreamcoder-light.conf", kitty_content)
repo_changes += write_variant_files(ROOT / "Ghostty/.config/ghostty/themes", "dreamcoder-dark", "dreamcoder-light", ghostty_content)
repo_changes += write_variant_files(ROOT / "Warp/.local/share/warp-terminal/themes", "Dreamcoder-Dark.yaml", "Dreamcoder-Light.yaml", warp_content)
repo_changes += write_variant_files(ROOT / "Shell/.config", "starship-dark.toml", "starship-light.toml", starship_content)
repo_changes += write_variant_files(ROOT / "Codex-App", "Dreamcoder-Dark.codex-theme.json", "Dreamcoder-Light.codex-theme.json", opencode_content)
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
print(f"Starship: {starship}")
print("Changed: " + " ".join(f"{key}={value}" for key, value in changed.items()))
print(f"Repo variant/snippet changes: {sum(repo_changes)}")
