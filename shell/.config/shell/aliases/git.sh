alias g='git' alias gs='git status -s' alias ga='git add'
alias gc='git commit -m' alias gp='git push' alias gl='git pull'
alias gd='git diff' alias gco='git checkout' alias gb='git branch'
gpsup() { git push --set-upstream origin "$(git branch --show-current 2>/dev/null || echo main)"; }
