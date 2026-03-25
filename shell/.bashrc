[[ -z "$TERM" || "$TERM" == "dumb" ]] && export TERM="xterm-256color"
[[ $- != *i* ]] && return

# Enable options
shopt -s histappend cmdhist autocd cdspell globstar

# History
export HISTFILE=~/.bash_history
HISTSIZE=50000
HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups

# PATH - include all important bins
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$HOME/.cargo/bin:$HOME/.volta/bin:$HOME/.bun/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:$HOME/.config:$PATH"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load bash completion
[[ -f /usr/share/bash-completion/bash_completion ]] && source $_

# Load custom shell config
_shell_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
for d in core aliases functions; do
    for f in "$_shell_dir"/$d/*.sh; do [[ -f "$f" ]] && source "$f"; done
done

# Integrations
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v starship &>/dev/null && eval "$(starship init bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
