"""Focused terminal and prompt theme renderers."""

from __future__ import annotations

from .palette import guard, mix
from .renderers_core import ansi


def kitty_content(c: dict[str, str]) -> str:
    p = ansi(c)
    invert = c.get("details") == "lighter"
    sel_fg = c["bg"] if invert else c["text"]
    # Dark mode: use surface1 instead of selection for better visibility
    sel_bg = c["text"] if invert else c["surface1"]
    return f"""# ==========================================================
#              {c["name"]}
# ==========================================================
# Color-only theme layer. Keep ML4W/Gentleman behavior elsewhere.

foreground              {c["text"]}
background              {c["bg"]}
selection_foreground    {sel_fg}
selection_background    {sel_bg}
url_color               {c["diagnostic"]}

cursor                  {c["accent"]}
cursor_text_color       {c["bg"]}
cursor_shape            block
cursor_blink_interval   0.5
cursor_stop_blinking_after 15.0

active_tab_foreground   {c["bg"]}
active_tab_background   {c["accent"]}
inactive_tab_foreground {c["muted"]}
inactive_tab_background {c["bg"]}
tab_bar_background      {c["bg"]}

active_border_color     {c["accent"]}
inactive_border_color   {c["border"]}
bell_border_color       {c["error"]}

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
color16 {c["accent_2"]}
color17 {c["error"]}

mark1_foreground        {c["bg"]}
mark1_background        {c["accent"]}
mark2_foreground        {c["bg"]}
mark2_background        {c["diagnostic"]}
mark3_foreground        {c["bg"]}
mark3_background        {c["mauve"]}
"""


def kitty_ui_content(c: dict[str, str]) -> str:
    opacity = "0.98" if c["details"] == "lighter" else "0.76"
    return """# Dreamcoder Kitty UI parity layer
# Loaded last so ML4W can keep behavior while Dreamcoder owns readability.

font_family           JetBrainsMono Nerd Font
bold_font             auto
italic_font           auto
bold_italic_font      auto
font_size             14
disable_ligatures     cursor
symbol_map            U+E000-U+F8FF,U+F0000-U+10FFFF Symbols Nerd Font
box_drawing_scale     0.001, 1, 1.5, 2
text_composition_strategy platform
shell                 fish --login

window_padding_width  18 20 18 20
single_window_padding_width -1
placement_strategy    center
initial_window_width  1180
initial_window_height 780
background_opacity    {opacity}
dynamic_background_opacity no
background_blur       0
input_delay           0
repaint_delay         1

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

# Dreamcoder terminal shortcuts.
map ctrl+l            clear_terminal reset active
map ctrl+shift+l      clear_terminal scrollback active
map ctrl+backspace    send_text all \\x17
map ctrl+delete       send_text all \\ed

# Dreamcoder Motion: ML4W-inspired cursor trail, kept local and portable.
cursor_trail          1
""".format(opacity=opacity)
