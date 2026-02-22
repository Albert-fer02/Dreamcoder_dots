command -v bat &>/dev/null && alias cat='bat --style=auto --paging=never'
command -v btop &>/dev/null && alias top='btop' htop='btop'
command -v rg &>/dev/null && alias grep='rg --smart-case'
command -v fd &>/dev/null && alias fd='fd --hidden --follow'
