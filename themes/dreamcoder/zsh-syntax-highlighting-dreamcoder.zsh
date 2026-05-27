# ========================================================
# Dreamcoder Ember Noir — Zsh-syntax-highlighting theme
# Source this from .zshrc AFTER zsh-syntax-highlighting plugin.
# ========================================================

typeset -A ZSH_HIGHLIGHT_STYLES

# Main
ZSH_HIGHLIGHT_STYLES[default]='fg=#f0e7dc'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e98272'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#e6a15c,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#d66f50'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#d66f50'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e6a15c'
ZSH_HIGHLIGHT_STYLES[function]='fg=#d66f50'
ZSH_HIGHLIGHT_STYLES[command]='fg=#e6a15c'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#e6a15c,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#c7b9aa'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#e6a15c'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#d2a268'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#e6a15c'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#d2a268,underline'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=#e8b866,underline'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#c9a8dc'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#c9a8dc'

# Quoting & Brackets
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#d2a268'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#d2a268'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#f0e7dc'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#d66f50'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#9c826d,italic'
ZSH_HIGHLIGHT_STYLES[variable]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[mathvar]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[null]='fg=#c7b9aa'

# Brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#e6a15c'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#d2a268'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#c9a8dc'

# Cursor
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=#15100d,bg=#e6a15c'
