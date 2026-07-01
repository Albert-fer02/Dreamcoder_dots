"""Focused terminal and prompt theme renderers."""

from __future__ import annotations

from .palette import guard


def starship_content(c: dict[str, str]) -> str:
    mode = "dark" if c["details"] == "darker" else "light"
    # Prompt surfaces are powerline segment backgrounds — need aesthetic
    # gradient, not text contrast. Use raw token values, not guard().
    prom_acc = guard(c["prompt_accent"], c["bg"], mode)
    prom_s0 = c["prompt_surface0"]  # segment bg, no guard
    prom_s1 = c["prompt_surface1"]  # segment bg, no guard
    prom_s2 = c["prompt_surface2"]  # segment bg, no guard
    prom_text = guard(c["prompt_text"], prom_s0, mode)  # text on darkest surface
    prom_muted = guard(c["prompt_muted"], c["bg"], mode)
    error = guard(c["error"], c["bg"], mode)
    warning = guard(c["warning"], c["bg"], mode)

    return f'''# ========================================================
# {c["name"]} — Starship prompt
# ========================================================
# Modern two-line layout with powerline segments.
# Line 1: context (directory, git)
# Line 2: input character only (clean)

add_newline = true
palette = "dreamcoder"
command_timeout = 500

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
$cmd_duration\\
$time
$character"""

right_format = ""

[palettes.dreamcoder]
bg = "{c["bg"]}"
text = "{c["text"]}"
muted = "{c["muted"]}"
prompt_bg = "{c["prompt_bg"]}"
prompt_surface0 = "{prom_s0}"
prompt_surface1 = "{prom_s1}"
prompt_surface2 = "{prom_s2}"
prompt_text = "{prom_text}"
prompt_muted = "{prom_muted}"
prompt_accent = "{prom_acc}"
prompt_accent_2 = "{c["prompt_accent_2"]}"
sage = "{c["sage"]}"
diagnostic = "{c["diagnostic"]}"
lavender = "{c["lavender"]}"
mauve = "{c["mauve"]}"
error = "{error}"
warning = "{warning}"
border = "{c["border_ui"]}"
focus = "{c["focus"]}"
link = "{c["link"]}"

[username]
show_always = true
style_user = "bg:prompt_surface0 fg:prompt_text bold"
style_root = "bg:prompt_surface0 fg:error bold"
format = "[  $user ]($style)"

[directory]
style = "bg:prompt_surface1 fg:prompt_text bold"
format = "[  $path ]($style)"
truncation_length = 2
truncate_to_repo = true
home_symbol = ""

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

[cmd_duration]
min_time = 2500
style = "fg:prompt_muted"
format = "[  $duration ]($style)"

[time]
disabled = false
format = "[ $time ]($style)"
style = "fg:prompt_muted"

[character]
success_symbol = "[❯](bold fg:prompt_accent)"
error_symbol = "[❯](bold fg:error)"
vimcmd_symbol = "[❮](bold fg:sage)"

# Runtime versions - show only when relevant, keep compact
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
'''
