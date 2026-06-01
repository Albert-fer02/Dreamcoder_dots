"""Focused terminal and prompt theme renderers."""

from __future__ import annotations

from .palette import guard, mix
from .renderers_core import ansi


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
