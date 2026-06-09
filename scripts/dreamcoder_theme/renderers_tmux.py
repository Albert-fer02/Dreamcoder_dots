"""tmux theme renderer for Dreamcoder."""

from __future__ import annotations


def tmux_content(c: dict[str, str]) -> str:
    """Return a tmux config snippet using the Dreamcoder palette."""
    is_dark = c["details"] == "darker"
    mode = "dark" if is_dark else "light"

    bg_pane = c["bg"]
    bg_bar = c["bg_soft"]
    text = c["text"]
    muted = c["muted"]
    accent = c["accent"]
    accent_2 = c["accent_2"]
    highlight = c["focus"] if is_dark else c["focus"]
    sel = c["surface1"]
    surface2 = c["surface2"]
    error = c["error"]
    warn = c["warning"]
    info = c["diagnostic"]
    surface0 = c["surface0"]

    # Inverted text uses bg_pane (=c["bg"]) on accent for the status-left
    # and current-window blocks. Matches ukiyo plugin's default
    # left_icon_fg=bg_pane and left_icon_bg=accent.
    pane_fg = surface2
    pane_active_fg = highlight
    inverted_fg = c["bg"]
    inverted_bg = accent

    return f"""# {c["name"]} — tmux {mode} theme
# Source: tmux source-file ~/.config/tmux/tmux-dreamcoder-{mode}.conf

# Default terminal colours (truecolor)
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
set -ga terminal-overrides '*:Ss=\\E[%p1%d q:Se=\\E[2 q'

# Panes
set -g pane-border-style "fg={pane_fg},bg=default"
set -g pane-active-border-style "fg={pane_active_fg},bg=default"
set -g display-panes-colour "{accent}"
set -g display-panes-active-colour "{accent}"

# Status bar
set -g status-style "fg={text},bg={bg_bar}"
set -g status-left-style "fg={inverted_fg},bg={inverted_bg}"
set -g status-right-style "fg={muted},bg={bg_bar}"

set -g status-left "#[fg={inverted_fg},bg={inverted_bg},bold]  #S #[fg={inverted_bg},bg={bg_bar},nobold]"
set -g status-right "#[fg={bg_bar},bg={bg_bar}]#[fg={muted},bg={bg_bar}] %H:%M #[fg={sel}]#[fg={muted},bg={sel}] %d-%b-%y "

# Status position
set -g status-position top
set -g status-interval 5

# Window tabs
setw -g window-status-style "fg={muted},bg={bg_bar}"
setw -g window-status-current-style "fg={inverted_fg},bg={inverted_bg},bold"
setw -g window-status-format " #I:#W "
setw -g window-status-current-format " #I:#W "
setw -g window-status-separator ""

# Message
set -g message-style "fg={text},bg={surface0}"
set -g message-command-style "fg={text},bg={surface0}"

# Mode (copy mode)
setw -g mode-style "fg={bg_pane},bg={highlight}"

# Bell
setw -g window-status-bell-style "fg={bg_pane},bg={error},bold"
"""
