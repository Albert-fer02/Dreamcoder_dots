# ========================================================
# Dreamcoder Light — Zsh-syntax-highlighting theme
# Source this from .zshrc AFTER zsh-syntax-highlighting plugin.
# ========================================================

typeset -A ZSH_HIGHLIGHT_STYLES

# Main
ZSH_HIGHLIGHT_STYLES[default]='fg=#17120d'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#842f24'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#824f16,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a7471c'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a7471c'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#824f16'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a7471c'
ZSH_HIGHLIGHT_STYLES[command]='fg=#824f16'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#824f16,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#3d3228'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#824f16'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#15516e'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#824f16'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#15516e,underline'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=#654300,underline'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#57478b'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#57478b'

# Quoting & Brackets
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#15516e'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#15516e'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#3f6b35'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#3f6b35'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#3f6b35'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#3f6b35'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#17120d'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#a7471c'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#66523f,italic'
ZSH_HIGHLIGHT_STYLES[variable]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[mathvar]='fg=#7d3e64'
ZSH_HIGHLIGHT_STYLES[null]='fg=#3d3228'

# Brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#824f16'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#15516e'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#3f6b35'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#57478b'

# Cursor
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=#f3eadc,bg=#824f16'
