#!/bin/bash
# DreamcoderDots Verifier
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GREEN='\033[0;32m' RED='\033[0;31m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC} $*"; }
log_err() { echo -e "${RED}✗${NC} $*"; }
log_info() { echo -e "${BLUE}→${NC} $*"; }

verify_stow() {
    log_info "Checking symlinks..."
    local targets=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.config/kitty" "$HOME/.config/ghostty" "$HOME/.config/fastfetch")
    local real_dotfiles="$(readlink -f "$DOTFILES_DIR")"
    for target in "${targets[@]}"; do
        if [[ -L "$target" ]]; then
            local target_real="$(readlink -f "$target")"
            [[ "$target_real" == *"$real_dotfiles"* ]] && log_ok "$target" || log_err "$target"
        elif [[ -e "$target" ]]; then
            log_err "$target (physical)"
        else
            log_err "$target (missing)"
        fi
    done
}

verify_syntax() {
    log_info "Checking syntax..."
    [[ -f "$HOME/.zshrc" ]] && zsh -n "$HOME/.zshrc" && log_ok "zshrc" || log_err "zshrc"
}

main() {
    echo -e "${CYAN}═══ DreamcoderDots Verify ═══${NC}"
    verify_stow
    verify_syntax
    echo -e "${CYAN}═══ Done ═══${NC}"
}

main "$@"
