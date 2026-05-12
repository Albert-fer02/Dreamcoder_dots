#!/usr/bin/env python3
import os
import subprocess
from pathlib import Path


config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))

kitty = Path(
    os.environ.get("KITTY_COLORS", config_home / "kitty/colors-dreamcoder.conf")
)
ghostty = Path(
    os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder")
)
starship = Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml"))
warp = Path(
    os.environ.get("WARP_THEME", data_home / "warp-terminal/themes/Dreamcoder.yaml")
)
opencode = Path(
    os.environ.get("OPENCODE_THEME", config_home / "opencode/themes/dreamcoder.json")
)

C = {
    "bg": "#19120c",
    "surface0": "#2a1d13",
    "surface1": "#402c18",
    "cream": "#eee0d5",
    "muted": "#d5c3b5",
    "muted_ui": "#c8b09c",
    "comment": "#8a7667",
    "border_warm": "#332417",
    "info_bright": "#9fd4d2",
    "beige": "#d7b995",
    "lucuma": "#fbb974",
    "sage": "#9ec49f",
    "cyan": "#9ec3c4",
    "lavender": "#a39ec4",
    "mauve": "#c49ec4",
    "red": "#ffb4ab",
    "bright_black": "#6f5d50",
    "bright_red": "#ffd0ca",
    "bright_green": "#b8d9b8",
    "bright_yellow": "#ffd19a",
    "bright_blue": "#b8d9da",
    "bright_magenta": "#d9b8d9",
    "bright_cyan": "#c0bce0",
    "hot_red": "#ff8f86",
}

PALETTE = [
    C["surface0"],
    C["red"],
    C["sage"],
    C["lucuma"],
    C["cyan"],
    C["mauve"],
    C["lavender"],
    C["muted"],
    C["bright_black"],
    C["bright_red"],
    C["bright_green"],
    C["bright_yellow"],
    C["bright_blue"],
    C["bright_magenta"],
    C["bright_cyan"],
    C["cream"],
]


def write_if_changed(path: Path, content: str) -> bool:
    old = path.read_text() if path.exists() else ""
    if old == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    return True


def valid_starship(path: Path) -> bool:
    return (
        subprocess.run(
            ["starship", "explain"],
            env={**os.environ, "STARSHIP_CONFIG": str(path)},
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        ).returncode
        == 0
    )


kitty_content = f"""# ==========================================================
#              Dreamcoder — Cocoa Lucuma Identity
# ==========================================================
# Warm dark terminal palette with distinct ANSI roles.

foreground              {C["cream"]}
background              {C["bg"]}
selection_foreground    {C["bg"]}
selection_background    {C["beige"]}
url_color               {C["lucuma"]}

cursor                  {C["lucuma"]}
cursor_text_color       {C["bg"]}
cursor_shape            block
cursor_blink_interval   0.5
cursor_stop_blinking_after 15.0

active_tab_foreground   {C["bg"]}
active_tab_background   {C["lucuma"]}
inactive_tab_foreground {C["muted"]}
inactive_tab_background {C["surface0"]}
tab_bar_background      {C["bg"]}

active_border_color     {C["lucuma"]}
inactive_border_color   {C["surface1"]}
bell_border_color       {C["red"]}

# Normal ANSI colors
color0  {PALETTE[0]}
color1  {PALETTE[1]}
color2  {PALETTE[2]}
color3  {PALETTE[3]}
color4  {PALETTE[4]}
color5  {PALETTE[5]}
color6  {PALETTE[6]}
color7  {PALETTE[7]}

# Bright ANSI colors
color8  {PALETTE[8]}
color9  {PALETTE[9]}
color10 {PALETTE[10]}
color11 {PALETTE[11]}
color12 {PALETTE[12]}
color13 {PALETTE[13]}
color14 {PALETTE[14]}
color15 {PALETTE[15]}

# Extended accents
color16 {C["beige"]}
color17 {C["hot_red"]}

# Marks / hints
mark1_foreground        {C["bg"]}
mark1_background        {C["lucuma"]}
mark2_foreground        {C["bg"]}
mark2_background        {C["cyan"]}
mark3_foreground        {C["bg"]}
mark3_background        {C["mauve"]}
"""

ghostty_content = "\n".join(
    [
        f"background = {C['bg']}",
        f"foreground = {C['cream']}",
        f"cursor-color = {C['lucuma']}",
        f"cursor-text = {C['bg']}",
        f"selection-background = {C['beige']}",
        f"selection-foreground = {C['bg']}",
        "",
        *[f"palette = {i}={color}" for i, color in enumerate(PALETTE)],
        "",
    ]
)

warp_content = f"""name: Dreamcoder
accent: '{C["lucuma"]}'
cursor: '{C["lucuma"]}'
background: '{C["bg"]}'
foreground: '{C["cream"]}'
details: darker
terminal_colors:
  normal:
    black: '{PALETTE[0]}'
    red: '{PALETTE[1]}'
    green: '{PALETTE[2]}'
    yellow: '{PALETTE[3]}'
    blue: '{PALETTE[4]}'
    magenta: '{PALETTE[5]}'
    cyan: '{PALETTE[6]}'
    white: '{PALETTE[7]}'
  bright:
    black: '{PALETTE[8]}'
    red: '{PALETTE[9]}'
    green: '{PALETTE[10]}'
    yellow: '{PALETTE[11]}'
    blue: '{PALETTE[12]}'
    magenta: '{PALETTE[13]}'
    cyan: '{PALETTE[14]}'
    white: '{PALETTE[15]}'
"""

opencode_content = f'''{{
  "$schema": "https://opencode.ai/theme.json",
  "theme": {{
    "background": "none",
    "backgroundPanel": "#160f0a",
    "backgroundElement": "#0d0907",
    "text": "#f4e9dd",
    "textMuted": "{C["muted_ui"]}",
    "primary": "{C["lucuma"]}",
    "secondary": "{C["beige"]}",
    "accent": "{C["lucuma"]}",
    "error": "{C["red"]}",
    "warning": "#f0c17a",
    "success": "#a8cfa5",
    "info": "{C["info_bright"]}",
    "border": "{C["border_warm"]}",
    "borderActive": "{C["lucuma"]}",
    "borderSubtle": "#21160f",
    "diffAdded": "#a8cfa5",
    "diffRemoved": "{C["red"]}",
    "diffContext": "{C["muted_ui"]}",
    "diffHunkHeader": "{C["lavender"]}",
    "diffHighlightAdded": "{C["bright_green"]}",
    "diffHighlightRemoved": "{C["bright_red"]}",
    "diffAddedBg": "#1b2f1c",
    "diffRemovedBg": "#3a1d18",
    "diffContextBg": "#160f0a",
    "diffLineNumber": "{C["bright_black"]}",
    "diffAddedLineNumberBg": "#1b2f1c",
    "diffRemovedLineNumberBg": "#3a1d18",
    "markdownText": "#f4e9dd",
    "markdownHeading": "{C["lucuma"]}",
    "markdownLink": "{C["info_bright"]}",
    "markdownLinkText": "{C["lucuma"]}",
    "markdownCode": "#a8cfa5",
    "markdownBlockQuote": "{C["beige"]}",
    "markdownEmph": "{C["info_bright"]}",
    "markdownStrong": "{C["lucuma"]}",
    "markdownHorizontalRule": "{C["surface1"]}",
    "markdownListItem": "{C["lucuma"]}",
    "markdownListEnumeration": "{C["lavender"]}",
    "markdownImage": "{C["mauve"]}",
    "markdownImageText": "#f4e9dd",
    "markdownCodeBlock": "#f4e9dd",
    "syntaxComment": "{C["comment"]}",
    "syntaxKeyword": "{C["lucuma"]}",
    "syntaxFunction": "#e6c7a8",
    "syntaxVariable": "#f4e9dd",
    "syntaxString": "#ffd08f",
    "syntaxNumber": "#a8cfa5",
    "syntaxType": "{C["info_bright"]}",
    "syntaxOperator": "#b8a7d6",
    "syntaxPunctuation": "{C["muted_ui"]}"
  }}
}}
'''

starship_content = f'''add_newline = true
palette = "dreamcoder"

format = """
[](fg:surface0)\\
$username\\
[](bg:cream fg:surface0)\\
$directory\\
[](bg:lucuma fg:cream)\\
$git_branch\\
$git_status\\
[](fg:lucuma)\\
$fill\\
$hostname\\
$bun\\
$nodejs\\
$python\\
$golang\\
$rust\\
$docker_context\\
$cmd_duration\\
$time
$character"""

[palettes.dreamcoder]
bg = "{C["bg"]}"
surface0 = "{C["surface0"]}"
surface1 = "{C["surface1"]}"
cream = "{C["cream"]}"
muted = "{C["muted"]}"
beige = "{C["beige"]}"
lucuma = "{C["lucuma"]}"
sage = "{C["sage"]}"
cyan = "{C["cyan"]}"
lavender = "{C["lavender"]}"
mauve = "{C["mauve"]}"
red = "{C["red"]}"

[username]
show_always = true
style_user = "bg:surface0 fg:cream bold"
style_root = "bg:surface0 fg:red bold"
format = "[  $user ]($style)"

[hostname]
ssh_only = false
style = "fg:muted bold"
format = "[ 󰣇 $hostname ]($style) "

[directory]
style = "bg:cream fg:bg bold"
format = "[  $path ]($style)"
truncation_length = 3
truncate_to_repo = false

[git_branch]
symbol = ""
style = "bg:lucuma fg:bg bold"
format = "[ $symbol $branch ]($style)"

[git_status]
style = "bg:lucuma fg:bg bold"
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
style = "fg:lucuma bold"
format = "[ $symbol $version]($style)"

[nodejs]
symbol = ""
style = "fg:sage bold"
format = "[ $symbol $version]($style)"

[python]
symbol = ""
style = "fg:cyan bold"
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
style = "fg:cyan bold"
format = "[ $symbol $context]($style)"
only_with_files = true

[cmd_duration]
min_time = 1000
style = "fg:muted"
format = "[  $duration ]($style) "

[time]
disabled = false
time_format = "%H:%M:%S"
style = "fg:muted"
format = "[ ✓ $time ]($style)"

[character]
success_symbol = "[❯](bold fg:lucuma)"
error_symbol = "[❯](bold fg:red)"
vimcmd_symbol = "[❮](bold fg:sage)"
'''

changed_kitty = write_if_changed(kitty, kitty_content)
changed_ghostty = write_if_changed(ghostty, ghostty_content)
changed_warp = write_if_changed(warp, warp_content)
changed_opencode = write_if_changed(opencode, opencode_content)
changed_starship = write_if_changed(starship, starship_content)

if not valid_starship(starship):
    raise SystemExit(f"Generated Starship config is invalid: {starship}")

print("Synced Dreamcoder identity")
print(f"Kitty: {kitty}")
print(f"Ghostty: {ghostty}")
print(f"Warp: {warp}")
print(f"opencode: {opencode}")
print(f"Starship: {starship}")
print(
    "Changed: "
    f"kitty={changed_kitty} "
    f"ghostty={changed_ghostty} "
    f"warp={changed_warp} "
    f"opencode={changed_opencode} "
    f"starship={changed_starship}"
)
