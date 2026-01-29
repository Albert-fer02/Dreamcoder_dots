#!/bin/bash
# Dreamcoder Dotfiles - Engineer Grade Installer
# Version: 4.0.0 - Powered by GNU Stow & Neovim
# Author: Dreamcoder (Based on Dreamcoder Logic)

set -euo pipefail

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"
readonly LOG_FILE="$DOTFILES_DIR/install.log"

# Colores (Dreamcoder Palette)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_step() { echo -e "${PURPLE}[STEP]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Modules to Stow
readonly MODULES=(
    "DreamcoderNvim"
    "DreamcoderKitty"
    "DreamcoderGhostty"
    "DreamcoderFastfetch"
    "DreamcoderTmux"
    "DreamcoderZellij"
    "DreamcoderFish"
    "DreamcoderNushell"
    "DreamcoderClaude"
    "DreamcoderShell"
)

check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is optimized for Arch Linux."
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
    fi
}

install_packages() {
    log_step "Installing Base Engineering Packages..."
    
    local packages=(
        # Core
        git stow curl wget base-devel
        # Shell
        zsh fish nushell starship zsh-autosuggestions zsh-syntax-highlighting fzf zoxide bat eza fd ripgrep
        # Editors
        neovim nano
        # Terminal & UX
        kitty fastfetch ghostty tmux zellij
        # Dev Tools (Neovim dependencies)
        npm python-pip go lazygit
        # Fonts
        ttf-jetbrains-mono-nerd
    )

    if command -v pacman &>/dev/null; then
        sudo pacman -S --needed --noconfirm "${packages[@]}" || log_error "Failed to install some packages."
    else
        log_error "Pacman not found. Please install: ${packages[*]}"
    fi
}

backup_conflict() {
    local file=$1
    if [[ -e "$file" && ! -L "$file" ]]; then
        log_info "Backing up conflict: $file"
        mkdir -p "$BACKUP_DIR"
        # Handle directories differently
        if [[ -d "$file" ]]; then
            cp -r "$file" "$BACKUP_DIR/"
            rm -rf "$file"
        else
            mv "$file" "$BACKUP_DIR/"
        fi
    fi
    # If it's a broken link, remove it
    if [[ -L "$file" && ! -e "$file" ]]; then
        rm "$file"
    fi
}

stow_modules() {
    log_step "Deploying Configurations via GNU Stow..."

    for module in "${MODULES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$module" ]]; then
            log_info "Stowing $module..."
            
            case $module in
                "DreamcoderShell")
                    backup_conflict "$HOME/.zshrc"
                    backup_conflict "$HOME/.bashrc"
                    backup_conflict "$HOME/.bash_profile"
                    backup_conflict "$HOME/.p10k.zsh"
                    backup_conflict "$HOME/.p10k_dreamcoder.zsh"
                    backup_conflict "$HOME/.nanorc"
                    ;;
                "DreamcoderTmux")
                    backup_conflict "$HOME/.tmux.conf"
                    ;;
                "DreamcoderZellij")
                    backup_conflict "$HOME/.config/zellij"
                    ;;
                "DreamcoderFish")
                    backup_conflict "$HOME/.config/fish"
                    ;;
                "DreamcoderNushell")
                    backup_conflict "$HOME/.config/nushell"
                    ;;
                "DreamcoderClaude")
                    backup_conflict "$HOME/.claude"
                    backup_conflict "$HOME/.config/dreamcoder-claude"
                    # Claude desktop usually looks at ~/.claude.json or similar
                    # But here we are stowing into a specific config dir
                    ;;
                *)
                    # Config folders
                    app_name=$(echo "$module" | sed 's/Dreamcoder//' | tr '[:upper:]' '[:lower:]')
                    backup_conflict "$HOME/.config/$app_name"
                    ;;
            esac

            # Execute Stow
            # -v: verbose, -R: restow (delete then stow), -t: target
            stow -v -R -t "$HOME" -d "$DOTFILES_DIR" "$module" 2>> "$LOG_FILE"
            
            if [[ $? -eq 0 ]]; then
                log_success "$module deployed."
            else
                log_error "Stow failed for $module. Check $LOG_FILE"
            fi
        else
            log_error "Module $module not found!"
        fi
    done
}

setup_neovim_env() {
    log_step "Setting up Neovim Environment..."
    # Ensure npm is ready for LSPs
    if ! command -v npm &>/dev/null; then
        log_error "npm is not installed. Required for Neovim LSPs."
    fi
}

main() {
    echo -e "${CYAN}🚀 Dreamcoder Dotfiles v4.0 (Dreamcoder Edition) 🚀${NC}"
    check_arch
    
    if [[ "${1:-}" != "--skip-pkg" ]]; then
        install_packages
    fi

    stow_modules
    setup_neovim_env

    echo ""
    log_success "Installation Complete."
    log_info "Backup stored in: $BACKUP_DIR"
    log_info "Restart your shell to see changes."
}

main "$@"
