#!/bin/bash
# Dreamcoder Dotfiles - Engineer Grade Verifier
# Version: 2.0.0 - Powered by GNU Stow & Lua Check
# Author: Dreamcoder (Based on Dreamcoder Logic)

set -euo pipefail

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="$DOTFILES_DIR/verify.log"

# Colors (Dreamcoder Palette)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }
log_step() { echo -e "\n${PURPLE}--- $* ---
${NC}"; }

# Modules to Verify
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
    "DreamcoderOpenCode"
    "DreamcoderShell"
)

show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════╗"
    echo "║    🔍 DREAMCODER SYSTEM VERIFIER 🔍   ║"
    echo "║        Quality & Integrity Audit       ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

verify_stow_integrity() {
    log_step "Auditing Symlink Integrity (GNU Stow)"
    local errors=0

    # Targets to check (could be the file itself or its parent directory)
    local targets=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.p10k.zsh"
        "$HOME/.p10k_dreamcoder.zsh"
        "$HOME/.config/nvim"
        "$HOME/.config/kitty"
        "$HOME/.config/ghostty"
        "$HOME/.config/zellij"
        "$HOME/.config/fish"
        "$HOME/.config/nushell"
        "$HOME/.tmux.conf"
    )

    for target in "${targets[@]}"; do
        if [[ -L "$target" ]]; then
            link_path=$(readlink -f "$target")
            if [[ "$link_path" == *"$DOTFILES_DIR"* ]]; then
                log_success "Link OK: $target -> $link_path"
            else
                log_warning "Link Foreign: $target points outside repo ($link_path)"
                ((errors++))
            fi
        else
            if [[ -e "$target" ]]; then
                log_error "Conflict: $target is a PHYSICAL path, not a symlink."
            else
                log_error "Missing: $target does not exist."
            fi
            ((errors++))
        fi
    done
    return $errors
}

verify_neovim_syntax() {
    log_step "Auditing Neovim Configuration (Lua Syntax)"
    if ! command -v nvim &>/dev/null; then
        log_error "Neovim not installed."
        return 1
    fi

    # Run nvim in headless mode to check for errors in init.lua
    if nvim --headless +qa 2> "$LOG_FILE"; then
        log_success "Neovim init.lua syntax is valid."
    else
        log_error "Neovim configuration has errors. See $LOG_FILE"
        cat "$LOG_FILE"
        return 1
    fi
}

verify_zsh_syntax() {
    log_step "Auditing Shell Configuration (Zsh Syntax)"
    if [[ -f "$HOME/.zshrc" ]]; then
        # -n: check syntax without executing
        if zsh -n "$HOME/.zshrc" 2>> "$LOG_FILE"; then
            log_success ".zshrc syntax is valid."
        else
            log_error ".zshrc has syntax errors."
            return 1
        fi
    fi
}

verify_skills_integrity() {
    log_step "Auditing IA Skills Integrity"
    local skills_dir=".gemini/skills"
    if [[ -d "$skills_dir" ]]; then
        for skill in "$skills_dir"/*; do
            if [[ -f "$skill/SKILL.md" ]]; then
                log_success "Skill OK: $(basename "$skill")"
            else
                log_warning "Skill Corrupt: $(basename "$skill") (Missing SKILL.md)"
            fi
        done
    else
        log_error "IA Skills directory missing."
        return 1
    fi
}

main() {
    show_banner
    
    local total_errors=0
    
    verify_stow_integrity || ((total_errors++))
    verify_neovim_syntax || ((total_errors++))
    verify_zsh_syntax || ((total_errors++))
    verify_skills_integrity || ((total_errors++))

    echo ""
    if [[ $total_errors -eq 0 ]]; then
        echo -e "${GREEN}✅ ALL SYSTEMS OPERATIONAL - DREAMCODER GRADE${NC}"
    else
        echo -e "${RED}❌ AUDIT FAILED - $total_errors ISSUES FOUND${NC}"
        echo -e "${YELLOW}Run ./install.sh to fix symlink issues.${NC}"
    fi
}

main "$@"