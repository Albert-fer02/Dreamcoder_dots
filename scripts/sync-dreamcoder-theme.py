#!/usr/bin/env python3
import os
import subprocess
from pathlib import Path

config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
kitty = Path(os.environ.get("KITTY_COLORS", config_home / "kitty/colors-matugen.conf"))
ghostty = Path(os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder"))
starship = Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml"))

C = {
    "bg": "#19120c",
    "fg": "#eee0d5",
    "cursor": "#fbb974",
    "cursor_text": "#492900",
    "selection_bg": "#58432c",
    "selection_fg": "#feddbe",
    "black": "#302921",
    "red": "#ffb4ab",
    "green": "#e1c1a3",
    "yellow": "#bfcc9b",
    "blue": "#fbb974",
    "magenta": "#bfcc9b",
    "cyan": "#e1c1a3",
    "white": "#eee0d5",
    "bright_black": "#9d8e81",
    "bright_white": "#e7e7e7",
    "surface1": "#251e17",
    "muted": "#d5c3b5",
}

PALETTE = [
    C["black"], C["red"], C["green"], C["yellow"],
    C["blue"], C["magenta"], C["cyan"], C["white"],
    C["bright_black"], C["red"], C["green"], C["yellow"],
    C["blue"], C["magenta"], C["cyan"], C["bright_white"],
]


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


kitty_content = f'''cursor {C["fg"]}
cursor_text_color {C["muted"]}

foreground            {C["fg"]}
background            {C["bg"]}
selection_foreground  {C["selection_fg"]}
selection_background  {C["selection_bg"]}
url_color             {C["blue"]}

# black
color0   {PALETTE[0]}
color8   {PALETTE[8]}

# red
color1   {PALETTE[1]}
color9   {PALETTE[9]}

# green
color2   {PALETTE[2]}
color10  {PALETTE[10]}

# yellow
color3   {PALETTE[3]}
color11  {PALETTE[11]}

# blue
color4   {PALETTE[4]}
color12  {PALETTE[12]}

# magenta
color5   {PALETTE[5]}
color13  {PALETTE[13]}

# cyan
color6   {PALETTE[6]}
color14  {PALETTE[14]}

# white
color7   {PALETTE[7]}
color15  {PALETTE[15]}
'''

ghostty_content = "\n".join([
    f"background = {C['bg']}",
    f"foreground = {C['fg']}",
    f"cursor-color = {C['cursor']}",
    f"cursor-text = {C['cursor_text']}",
    f"selection-background = {C['selection_bg']}",
    f"selection-foreground = {C['selection_fg']}",
    "",
    *[f"palette = {i}={color}" for i, color in enumerate(PALETTE)],
    "",
])

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
bg = "{C['bg']}"
surface0 = "{C['black']}"
surface1 = "{C['surface1']}"
cream = "{C['fg']}"
muted = "{C['muted']}"
beige = "{C['selection_bg']}"
lucuma = "{C['blue']}"
sage = "{C['green']}"
cyan = "{C['cyan']}"
lavender = "{C['blue']}"
mauve = "{C['magenta']}"
red = "{C['red']}"

[username]
show_always = true
style_user = "bg:surface0 fg:cream bold"
style_root = "bg:surface0 fg:red bold"
format = "[  $user ]($style)"

[hostname]
ssh_only = true
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
error_symbol = "[✗](bold fg:red)"
vimcmd_symbol = "[❮](bold fg:sage)"
'''

changed_kitty = write_if_changed(kitty, kitty_content)
changed_ghostty = write_if_changed(ghostty, ghostty_content)
changed_starship = write_if_changed(starship, starship_content)
if not valid_starship(starship):
    raise SystemExit(f"Generated Starship config is invalid: {starship}")

print("Synced fixed Dreamcoder identity")
print(f"Kitty: {kitty}")
print(f"Ghostty: {ghostty}")
print(f"Starship: {starship}")
print(f"Changed: kitty={changed_kitty} ghostty={changed_ghostty} starship={changed_starship}")
