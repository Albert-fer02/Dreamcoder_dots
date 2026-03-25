#!/usr/bin/env bash
# DreamcoderDots Installer
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log() { echo -e "${BLUE}→${NC} $*"; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
err() { echo -e "${RED}✗${NC} $*"; }

MODULES=(Kitty Ghostty)

check_deps() {
    command -v stow &>/dev/null || { err "Missing: stow"; return 1; }
    command -v git &>/dev/null || { err "Missing: git"; return 1; }
}

install_packages() {
    [[ "${1:-}" == "--skip-packages" ]] && return
    log "Installing packages..."
    local pkgs=(kitty ghostty stow git)
    command -v pacman &>/dev/null && sudo pacman -S --needed --noconfirm "${pkgs[@]}" || log "Skipping packages"
}

backup_conflict() {
    local file="$1"
    [[ -e "$file" && ! -L "$file" ]] && {
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
        log "Backed up: $file"
    }
}

stow_modules() {
    for f in .zshrc .bashrc .bash_profile .p10k.zsh .zshenv .inputrc .nanorc; do
        backup_conflict "$HOME/$f"
    done
    stow -R -t "$HOME" -d "$DOTFILES_DIR" "${MODULES[@]}" && ok "Stow complete" || err "Stow failed"
}

main() {
    echo -e "${CYAN}═══ DreamcoderDots ═══${NC}"
    check_deps || exit 1
    install_packages "$@"
    stow_modules
    echo -e "${CYAN}═══ Done! Run: exec \$SHELL ═══${NC}"
}

main "$@"
