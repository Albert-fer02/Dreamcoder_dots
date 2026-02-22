_fzf_setup() {
    command -v fzf &>/dev/null || return
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    local preview="cat {}"
    command -v bat &>/dev/null && preview="bat --style=numbers --color=always {}"
    export FZF_DEFAULT_OPTS="--height=90% --layout=reverse --border=rounded --preview='$preview' --color=fg:#cdd6f4,bg:#1e1e2e"
    command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
}
_fzf_setup
unfunction _fzf_setup 2>/dev/null || true
