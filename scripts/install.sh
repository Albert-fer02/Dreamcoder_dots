#!/usr/bin/env bash
# DreamcoderDots Installer
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log() { echo -e "${BLUE}→${NC} $*"; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
err() { echo -e "${RED}✗${NC} $*"; }

MODULES=(
    "Fish"
    "Ghostty"
    "Kitty"
    "Nvim"
    "Tmux"
    "Zellij"
    "Nushell"
)

check_deps() {
    local missing=()
    command -v stow &>/dev/null || missing+=(stow)
    command -v git &>/dev/null || missing+=(git)
    [[ ${#missing[@]} -gt 0 ]] && { err "Missing: ${missing[*]}"; return 1; }
}

install_packages() {
    [[ "${1:-}" == "--skip-packages" ]] && return
    log "Installing packages..."
    local pkgs=(git stow zsh fish starship fzf zoxide bat eza fd ripgrep neovim kitty fastfetch tmux)
    command -v pacman &>/dev/null && sudo pacman -S --needed --noconfirm "${pkgs[@]}" || log "Skipping package install"
}

backup_conflict() {
    local file="$1"
    [[ -e "$file" && ! -L "$file" ]] && {
        log "Backing up: $file"
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/" 2>/dev/null || rm -rf "$file"
    }
    [[ -L "$file" ]] && [[ "$(readlink -f "$file")" != *"$DOTFILES_DIR"* ]] && rm "$file"
}

stow_modules() {
    log "Deploying configs..."
    
    # Shell configs to root
    for f in .zshrc .bashrc .bash_profile .p10k.zsh .zshenv .inputrc .nanorc; do
        backup_conflict "$HOME/$f"
    done
    
    stow -R -t "$HOME" -d "$DOTFILES_DIR" "${MODULES[@]}" && ok "Stow complete" || err "Stow failed"
}

main() {
    echo -e "${CYAN}═══ DreamcoderDots Installer ═══${NC}"
    check_deps
    install_packages "$@"
    stow_modules
    echo -e "${CYAN}═══ Done! Run: exec \$SHELL ═══${NC}"
}

main "$@"
