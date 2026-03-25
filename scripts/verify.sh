#!/bin/bash
# DreamcoderDots Verifier
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC} $*"; }
log_err() { echo -e "${RED}✗${NC} $*"; }
log_info() { echo -e "${BLUE}→${NC} $*"; }

verify_stow() {
    log_info "Checking symlinks..."
    local errors=0
    local targets=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.p10k.zsh"
        "$HOME/.config/nvim"
        "$HOME/.config/kitty"
        "$HOME/.config/ghostty"
        "$HOME/.config/tmux.conf"
        "$HOME/.config/zellij"
        "$HOME/.config/fish"
    )

    for target in "${targets[@]}"; do
        if [[ -L "$target" ]]; then
            [[ "$(readlink -f "$target")" == *"$DOTFILES_DIR"* ]] && log_ok "$target" || log_err "$target (foreign)"
        elif [[ -e "$target" ]]; then
            log_err "$target (physical, not symlink)"
            ((errors++))
        fi
    done
    return $errors
}

verify_syntax() {
    log_info "Checking shell syntax..."
    [[ -f "$HOME/.zshrc" ]] && zsh -n "$HOME/.zshrc" && log_ok "zshrc" || log_err "zshrc"
    [[ -f "$HOME/.bashrc" ]] && bash -n "$HOME/.bashrc" && log_ok "bashrc" || log_err "bashrc"
}

main() {
    echo -e "${CYAN}═══ DreamcoderDots Verify ═══${NC}"
    local total=0
    verify_stow || ((total++))
    verify_syntax
    echo -e "${CYAN}═══ Complete ═══${NC}"
}

main "$@"
