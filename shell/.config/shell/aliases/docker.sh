if command -v docker &>/dev/null; then
    alias d='docker' alias dc='docker compose'
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}"'
fi
