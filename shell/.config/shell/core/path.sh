# PATH management
_safe_path_add() {
    [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && export PATH="$PATH:$1"
}
_init_paths() {
    _safe_path_add "$HOME/.cargo/bin"
    _safe_path_add "$HOME/.local/bin"
    _safe_path_add "$HOME/go/bin"
    _safe_path_add "$HOME/.bun/bin"
    _safe_path_add "$HOME/.npm-global/bin"
    export PNPM_HOME="$HOME/.local/share/pnpm"
    [[ -d "$PNPM_HOME" ]] && _safe_path_add "$PNPM_HOME"
}
_init_paths
unfunction _safe_path_add _init_paths 2>/dev/null || true
