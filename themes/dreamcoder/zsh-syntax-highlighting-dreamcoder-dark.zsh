# ========================================================
# Dreamcoder Ember Noir — Zsh-syntax-highlighting theme
# Source this from .zshrc AFTER zsh-syntax-highlighting plugin.
# ========================================================

typeset -A ZSH_HIGHLIGHT_STYLES

# Main
ZSH_HIGHLIGHT_STYLES[default]='fg=#e8dfd0'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e98272'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#d99555,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#c96a45'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#c96a45'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#d99555'
ZSH_HIGHLIGHT_STYLES[function]='fg=#c96a45'
ZSH_HIGHLIGHT_STYLES[command]='fg=#d99555'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#d99555,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#b8a99a'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#d99555'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#c8b2a2'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#d99555'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c8b2a2,underline'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=#e8b866,underline'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#c9a8dc'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#c9a8dc'

# Quoting & Brackets
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#c8b2a2'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#c8b2a2'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#e8dfd0'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#c96a45'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#9c826d,italic'
ZSH_HIGHLIGHT_STYLES[variable]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[mathvar]='fg=#d98aa9'
ZSH_HIGHLIGHT_STYLES[null]='fg=#b8a99a'

# Brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#d99555'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#c8b2a2'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#b8bf84'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#c9a8dc'

# Cursor
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=#12100e,bg=#d99555'
