#!/bin/bash
# Dreamcoder Dotfiles - Script de Verificación
# Versión: 1.0.0
# Verifica que la instalación se completó correctamente

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }

show_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   🔍 DREAMCODER DOTFILES VERIFY 🔍    ║"
    echo "║        Verificación de Instalación    ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

verify_arch_linux() {
    log_info "Verificando sistema operativo..."
    if [[ -f /etc/arch-release ]]; then
        log_success "Sistema: Arch Linux"
        return 0
    else
        log_error "Este sistema no es Arch Linux"
        return 1
    fi
}

verify_packages() {
    log_info "Verificando paquetes esenciales..."
    local errors=0

    local essential_packages=(
        zsh git curl wget
        kitty fastfetch nano starship
        fzf bat eza fd ripgrep zoxide
        tmux github-cli jq stow pass btop
    )

    for pkg in "${essential_packages[@]}"; do
        if command -v "$pkg" &>/dev/null; then
            log_success "Paquete instalado: $pkg"
        else
            log_error "Paquete faltante: $pkg"
            ((errors++))
        fi
    done

    return $errors
}

verify_config_files() {
    log_info "Verificando archivos de configuración..."
    local errors=0

    local config_files=(
        "$HOME/.zshrc:ZSH configuration"
        "$HOME/.bashrc:Bash configuration"
        "$HOME/.tmux.conf:Tmux configuration"
        "$HOME/.nanorc:Nano configuration"
        "$HOME/.config/kitty/kitty.conf:Kitty configuration"
        "$HOME/.config/fastfetch/config.jsonc:Fastfetch configuration"
        "$HOME/.config/starship.toml:Starship configuration"
        "$HOME/.p10k.zsh:PowerLevel10k configuration"
    )

    for entry in "${config_files[@]}"; do
        local file="${entry%%:*}"
        local desc="${entry##*:}"

        if [[ -f "$file" ]]; then
            log_success "$desc: $file"
        else
            log_error "Archivo faltante: $file ($desc)"
            ((errors++))
        fi
    done

    return $errors
}

verify_directories() {
    log_info "Verificando directorios necesarios..."
    local errors=0

    local directories=(
        "$HOME/.oh-my-zsh:Oh-My-Zsh"
        "$HOME/.oh-my-zsh/custom/themes/powerlevel10k:PowerLevel10k"
        "$HOME/.nano/backups:Nano backups"
        "$HOME/.config:Config directory"
    )

    for entry in "${directories[@]}"; do
        local dir="${entry%%:*}"
        local desc="${entry##*:}"

        if [[ -d "$dir" ]]; then
            log_success "$desc: $dir"
        else
            log_warning "Directorio faltante: $dir ($desc)"
            ((errors++))
        fi
    done

    return $errors
}

verify_shell() {
    log_info "Verificando shell por defecto..."

    if [[ "$SHELL" == */zsh ]]; then
        log_success "Shell por defecto: ZSH"
        return 0
    else
        log_warning "Shell actual: $SHELL (se recomienda ZSH)"
        log_info "Ejecuta: chsh -s /usr/bin/zsh"
        return 1
    fi
}

verify_editor() {
    log_info "Verificando editor por defecto..."

    if [[ -n "${EDITOR:-}" ]]; then
        if command -v "$EDITOR" &>/dev/null; then
            log_success "Editor configurado: $EDITOR"
            return 0
        else
            log_error "Editor '$EDITOR' no encontrado"
            return 1
        fi
    else
        log_warning "Variable EDITOR no configurada"
        return 1
    fi
}

verify_zsh_plugins() {
    log_info "Verificando plugins de ZSH..."
    local errors=0

    # Verificar que ZSH tenga los plugins instalados
    if [[ -f "$HOME/.zshrc" ]]; then
        if grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
            log_success "Plugin: zsh-autosuggestions configurado"
        else
            log_warning "Plugin: zsh-autosuggestions no encontrado en .zshrc"
            ((errors++))
        fi

        if grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
            log_success "Plugin: zsh-syntax-highlighting configurado"
        else
            log_warning "Plugin: zsh-syntax-highlighting no encontrado en .zshrc"
            ((errors++))
        fi
    fi

    return $errors
}

verify_modern_tools() {
    log_info "Verificando herramientas modernas CLI..."
    local errors=0

    # Verificar que las herramientas modernas funcionan
    local tools=(
        "fzf --version:FZF"
        "bat --version:Bat"
        "eza --version:Eza"
        "fd --version:Fd"
        "rg --version:Ripgrep"
        "zoxide --version:Zoxide"
        "gh --version:GitHub CLI"
        "jq --version:JQ"
        "tmux -V:Tmux"
        "btop --version:Btop"
    )

    for entry in "${tools[@]}"; do
        local cmd="${entry%%:*}"
        local name="${entry##*:}"

        if $cmd &>/dev/null; then
            log_success "$name funcional"
        else
            log_warning "$name: comando no funcional o no instalado"
            ((errors++))
        fi
    done

    return $errors
}

check_portability_issues() {
    log_info "Verificando problemas de portabilidad..."
    local warnings=0

    # Verificar username hardcoded
    if grep -q "/home/dreamcoder08" "$HOME/.zshrc" 2>/dev/null; then
        log_warning "Username hardcoded encontrado en .zshrc"
        ((warnings++))
    fi

    # Verificar dependencias externas
    if [[ -f "$HOME/.config/kitty/kitty.conf" ]]; then
        if grep -q "ml4w" "$HOME/.config/kitty/kitty.conf" 2>/dev/null && \
           ! grep -q "^#.*ml4w" "$HOME/.config/kitty/kitty.conf" 2>/dev/null; then
            log_warning "Dependencia ml4w no comentada en kitty.conf"
            ((warnings++))
        fi
    fi

    # Verificar aliases específicos de hardware
    if grep -q "DisplayPort-0" "$HOME/.zshrc" 2>/dev/null && \
       ! grep -q "^#.*DisplayPort-0" "$HOME/.zshrc" 2>/dev/null; then
        if ! xrandr 2>/dev/null | grep -q "DisplayPort-0 connected"; then
            log_warning "Aliases de DisplayPort-0 activos pero display no conectado"
            ((warnings++))
        fi
    fi

    return $warnings
}

generate_report() {
    local total_errors=$1
    local total_warnings=$2

    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           REPORTE DE VERIFICACIÓN     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""

    if [[ $total_errors -eq 0 && $total_warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ INSTALACIÓN PERFECTA${NC}"
        echo "   Todos los componentes verificados exitosamente"
        return 0
    elif [[ $total_errors -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  INSTALACIÓN COMPLETA CON ADVERTENCIAS${NC}"
        echo "   Errores: $total_errors"
        echo "   Advertencias: $total_warnings"
        echo ""
        echo "   La instalación funciona pero tiene advertencias menores"
        return 0
    else
        echo -e "${RED}❌ INSTALACIÓN INCOMPLETA${NC}"
        echo "   Errores: $total_errors"
        echo "   Advertencias: $total_warnings"
        echo ""
        echo "   Se encontraron problemas que deben corregirse"
        echo "   Ejecuta: ./install.sh"
        return 1
    fi
}

main() {
    show_banner

    local total_errors=0
    local total_warnings=0

    # Verificaciones con conteo de errores
    verify_arch_linux || ((total_errors++))
    echo ""

    verify_packages || total_errors=$((total_errors + $?))
    echo ""

    verify_config_files || total_errors=$((total_errors + $?))
    echo ""

    verify_directories || total_warnings=$((total_warnings + $?))
    echo ""

    verify_shell || ((total_warnings++))
    echo ""

    verify_zsh_plugins || total_warnings=$((total_warnings + $?))
    echo ""

    verify_modern_tools || total_warnings=$((total_warnings + $?))
    echo ""

    check_portability_issues || total_warnings=$((total_warnings + $?))
    echo ""

    # Generar reporte final
    generate_report $total_errors $total_warnings
    exit $?
}

main "$@"
