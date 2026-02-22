#!/usr/bin/env bash
# Dreamcoder Dotfiles - Modular Installer
# Version: 5.0.0 - Clean Architecture

set -euo pipefail

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"
readonly LOG_FILE="$DOTFILES_DIR/install.log"

# Colors
readonly RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'

log() { echo -e "${BLUE}→${NC} $*"; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
err() { echo -e "${RED}✗${NC} $*" >&2; }

# Modules (simplified names)
readonly MODULES=(shell nvim kitty ghostty tmux gitconfig fastfetch zellij fish nushell claude opencode)

check_deps() {
    local missing=()
    command -v stow &>/dev/null || missing+=(stow)
    command -v git &>/dev/null || missing+=(git)
    [[ ${#missing[@]} -gt 0 ]] && { err "Missing: ${missing[*]}"; exit 1; }
}

install_packages() {
    [[ "${1:-}" == "--skip-pkg" ]] && return
    log "Installing packages..."
    local pkgs=(git stow curl wget base-devel zsh fish starship zsh-autosuggestions zsh-syntax-highlighting fzf zoxide bat eza fd ripgrep neovim kitty fastfetch ghostty tmux npm python-pip go ttf-jetbrains-mono-nerd)
    command -v pacman &>/dev/null && sudo pacman -S --needed --noconfirm "${pkgs[@]}" || err "Pacman not found"
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
    for m in "${MODULES[@]}"; do
        [[ -d "$DOTFILES_DIR/$m" ]] || continue
        
        case "$m" in
            shell) 
                for f in .zshrc .bashrc .bash_profile .p10k.zsh; do backup_conflict "$HOME/$f"; done
                backup_conflict "$HOME/.config/starship.toml"
                ;;
            tmux) backup_conflict "$HOME/.tmux.conf" ;;
            gitconfig) backup_conflict "$HOME/.config/git" ;;
        esac
        
        stow -R -t "$HOME" -d "$DOTFILES_DIR" "$m" 2>>"$LOG_FILE" && ok "$m" || err "$m failed"
    done
}

post_install() {
    log "Setting up TPM..."
    local tpm="$HOME/.tmux/plugins/tpm"
    [[ ! -d "$tpm" ]] && git clone -q https://github.com/tmux-plugins/tpm "$tpm"
    
    echo ""
    echo -e "${CYAN}══════════════════════════════════${NC}"
    ok "Installation complete!"
    echo -e "  Backup: ${BLUE}$BACKUP_DIR${NC}"
    echo -e "  Next: ${CYAN}exec \$SHELL${NC}"
    echo -e "  Tmux: ${CYAN}Prefix + I${NC} for plugins"
    echo -e "${CYAN}══════════════════════════════════${NC}"
}

main() {
    check_deps
    install_packages "$@"
    stow_modules
    post_install
}

main "$@"
