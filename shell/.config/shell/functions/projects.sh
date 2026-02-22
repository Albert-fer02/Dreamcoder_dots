projects() { cd "${PROJECTS_DIR:-$HOME/Documents/Projects}" && ls -la; }
zp() {
    local dir="${PROJECTS_DIR:-$HOME/Documents/Projects}"
    [[ ! -d "$dir" ]] && return 1
    local sel=$(find "$dir" -maxdepth 2 -type d 2>/dev/null | fzf --height 40% --reverse)
    [[ -n "$sel" ]] && cd "$sel"
}
