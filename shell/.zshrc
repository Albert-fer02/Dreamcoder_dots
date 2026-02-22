# P10K instant prompt
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

HISTFILE=~/.zsh_history HISTSIZE=50000 SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY AUTO_CD

_shell_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
for d in core aliases functions; do
    for f in "$_shell_dir/$d"/*.sh(N); do source "$f"; done
done

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
