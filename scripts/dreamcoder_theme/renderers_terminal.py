"""Terminal and prompt theme renderers."""

from __future__ import annotations

from .palette import guard, mix
from .renderers_core import ansi

def kitty_content(c: dict[str, str]) -> str:
    p = ansi(c)
    invert = c.get("details") == "lighter"
    sel_fg = c['bg'] if invert else c['text']
    sel_bg = c['text'] if invert else c['selection']
    return f"""# ==========================================================
#              {c['name']}
# ==========================================================
# Color-only theme layer. Keep ML4W/Gentleman behavior elsewhere.

foreground              {c['text']}
background              {c['bg']}
selection_foreground    {sel_fg}
selection_background    {sel_bg}
url_color               {c['diagnostic']}

cursor                  {c['accent']}
cursor_text_color       {c['bg']}
cursor_shape            block
cursor_blink_interval   0.5
cursor_stop_blinking_after 15.0

active_tab_foreground   {c['bg']}
active_tab_background   {c['accent']}
inactive_tab_foreground {c['muted']}
inactive_tab_background {c['bg']}
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

def kitty_ui_content(c: dict[str, str]) -> str:
    opacity = "0.98" if c["details"] == "lighter" else "0.76"
    return """# Dreamcoder Kitty UI parity layer
# Loaded last so ML4W can keep behavior while Dreamcoder owns readability.

include colors-dreamcoder.conf

font_family           JetBrainsMono Nerd Font
bold_font             auto
italic_font           auto
bold_italic_font      auto
font_size             14
disable_ligatures     cursor
box_drawing_scale     0.001, 1, 1.5, 2
text_composition_strategy platform

window_padding_width  18 20 18 20
single_window_padding_width -1
placement_strategy    center
initial_window_width  1180
initial_window_height 780
background_opacity    {opacity}
dynamic_background_opacity no
background_blur       0

tab_bar_edge          top
tab_bar_style         fade
tab_bar_min_tabs      2
tab_bar_margin_color  none
active_tab_font_style bold
inactive_tab_font_style normal

shell_integration     enabled no-cursor
mouse_hide_wait       2.0
copy_on_select        clipboard
dim_opacity           0.65
inactive_text_alpha   0.92
""".format(opacity=opacity)

def ghostty_content(c: dict[str, str]) -> str:
    invert = c.get("details") == "lighter"
    sel_bg = c['text'] if invert else c['selection']
    sel_fg = c['bg'] if invert else c['text']
    lines = [
        f"# {c['name']}",
        f"background = {c['bg']}",
        f"foreground = {c['text']}",
        f"cursor-color = {c['accent']}",
        f"cursor-text = {c['bg']}",
        f"selection-background = {sel_bg}",
        f"selection-foreground = {sel_fg}",
        "minimum-contrast = 4.5",
        "background-opacity-cells = true",
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
