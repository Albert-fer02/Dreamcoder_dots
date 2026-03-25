#!/usr/bin/env bash
# DreamcoderDots Installer
# Usage: ./install.sh [--skip-packages]

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log() { echo -e "${BLUE}→${NC} $*"; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
err() { echo -e "${RED}✗${NC} $*"; }

MODULES=(Shell Kitty Ghostty Fastfetch)

check_deps() {
    command -v stow >/dev/null 2>&1 || { err "Missing: stow"; return 1; }
    command -v git >/dev/null 2>&1 || { err "Missing: git"; return 1; }
}

install_packages() {
    [[ "$1" == "--skip-packages" ]] && return
    log "Installing packages..."
    local pkgs=(kitty ghostty stow git fastfetch zsh)
    command -v pacman >/dev/null 2>&1 && sudo pacman -S --needed --noconfirm "${pkgs[@]}" 2>/dev/null || true
}

backup_conflict() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
        log "Backed up: $file"
    elif [[ -L "$file" ]]; then
        local target="$(readlink -f "$file")"
        if [[ "$target" != *"$DOTFILES_DIR"* ]]; then
            rm "$file"
            log "Removed old symlink: $file"
        fi
    fi
}

stow_modules() {
    log "Creating symlinks..."
    
    # Shell configs
    for f in .zshrc .bashrc .bash_profile .p10k.zsh .zshenv .inputrc .nanorc; do
        backup_conflict "$HOME/$f"
    done
    
    # Apps to .config
    for app in Kitty Ghostty Fastfetch; do
        backup_conflict "$HOME/.config/${app,,}"
    done
    
    # Stow
    cd "$DOTFILES_DIR"
    stow -t "$HOME" "${MODULES[@]}" 2>&1 | grep -v "^C" || true
    ok "Stow complete"
}

main() {
    echo -e "${CYAN}═══ DreamcoderDots Installer ═══${NC}"
    check_deps || exit 1
    install_packages "$@"
    stow_modules
    echo ""
    echo -e "${CYAN}═══ Installation Complete ═══${NC}"
    echo "  Restart shell: exec \$SHELL"
    echo "  Verify: ~/.dotfiles/scripts/verify.sh"
    echo -e "${CYAN}══════════════════════════════════════${NC}"
}

main "$@"
