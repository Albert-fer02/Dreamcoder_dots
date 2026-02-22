[[ -z "$TERM" || "$TERM" == "dumb" ]] && export TERM="xterm-256color"
[[ $- != *i* ]] && return

shopt -s histappend cmdhist autocd cdspell globstar
export HISTFILE=~/.bash_history HISTSIZE=50000 HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups

[[ -f /usr/share/bash-completion/bash_completion ]] && source $_

_shell_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
for d in core aliases functions; do
    for f in "$_shell_dir"/$d/*.sh; do [[ -f "$f" ]] && source "$f"; done
done

command -v starship &>/dev/null && eval "$(starship init bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
