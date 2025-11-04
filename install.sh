#!/bin/bash
# Dreamcoder Dotfiles - Instalador Simplificado para Arch Linux
# Versión: 3.0.0 - Enfoque minimalista

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR="$SCRIPT_DIR"
readonly BACKUP_DIR="$HOME/.config/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

check_arch_linux() {
    if [[ ! -f /etc/arch-release ]]; then
        log_error "Este script solo funciona en Arch Linux"
        exit 1
    fi
}

check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_warning "Se requieren privilegios de administrador"
        log_info "Ejecuta: sudo pacman -S --needed zsh git curl wget kitty fastfetch nano starship zsh-autosuggestions zsh-syntax-highlighting fzf bat eza fd ripgrep zoxide tmux github-cli jq stow pass btop"
        log_info "Luego ejecuta nuevamente: ./install.sh --skip-packages"
        exit 1
    fi
}

install_packages() {
    local packages=(
        # Shell y herramientas base
        zsh git curl wget
        # Terminal y display
        kitty fastfetch nano
        # Prompt
        starship zsh-autosuggestions zsh-syntax-highlighting
        # Herramientas CLI modernas
        fzf bat eza fd ripgrep zoxide
        # Productividad y desarrollo
        tmux github-cli jq stow pass
        # Monitoreo de sistema
        btop
    )

    log_info "Instalando paquetes esenciales y herramientas CLI modernas..."

    if sudo pacman -S --needed --noconfirm "${packages[@]}"; then
        log_success "Paquetes instalados correctamente"
    else
        log_error "Error instalando paquetes"
        exit 1
    fi
}

setup_oh_my_zsh() {
    # Verificar que git esté disponible
    if ! command -v git &>/dev/null; then
        log_error "Git no está instalado. Ejecuta primero sin --skip-packages"
        exit 1
    fi

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Instalando Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh-My-Zsh instalado"
    fi

    # Install Powerlevel10k if not present
    if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        log_info "Instalando Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        log_success "Powerlevel10k instalado"
    fi
}

backup_existing() {
    local files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.config/kitty"
        "$HOME/.config/fastfetch"
        "$HOME/.nanorc"
        "$HOME/.tmux.conf"
    )

    local backup_needed=false
    for file in "${files_to_backup[@]}"; do
        [[ -e "$file" ]] && backup_needed=true && break
    done

    if [[ "$backup_needed" == true ]]; then
        log_info "Creando respaldo en $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"

        for file in "${files_to_backup[@]}"; do
            if [[ -e "$file" ]]; then
                if cp -r "$file" "$BACKUP_DIR/"; then
                    log_info "Respaldo creado para $file"
                else
                    log_error "Error creando respaldo para $file"
                    exit 1
                fi
            fi
        done

        log_success "Respaldo creado"
    fi
}

remove_broken_symlinks() {
    local files=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.nanorc"
        "$HOME/.tmux.conf"
        "$HOME/.config/kitty"
        "$HOME/.config/fastfetch"
        "$HOME/.config/starship.toml"
        "$HOME/.p10k.zsh"
        "$HOME/.p10k_dreamcoder.zsh"
    )

    for file in "${files[@]}"; do
        # Remover symlinks rotos
        if [[ -L "$file" && ! -e "$file" ]]; then
            log_info "Removiendo symlink roto: $file"
            rm "$file"
        fi
        # Remover symlinks que apuntan a otros dotfiles (para reemplazar con DreamCoder)
        if [[ -L "$file" ]] && [[ -e "$file" ]]; then
            local target=$(readlink "$file")
            if [[ "$target" != *"Dreamcoder_dots"* ]]; then
                log_info "Removiendo symlink externo: $file -> $target"
                rm "$file"
            fi
        fi
    done
}

install_dotfiles() {
    log_info "Instalando configuraciones..."

    # ZSH
    [[ -f "$DOTFILES_DIR/zshrc/.zshrc" ]] && {
        if [[ ! -f "$HOME/.zshrc" ]] || ! cmp -s "$DOTFILES_DIR/zshrc/.zshrc" "$HOME/.zshrc"; then
            if cp "$DOTFILES_DIR/zshrc/.zshrc" "$HOME/"; then
                log_success "ZSH configurado"
            else
                log_error "Error copiando .zshrc"
                exit 1
            fi
        else
            log_info "ZSH ya está actualizado"
        fi
    }

    # Bash
    [[ -f "$DOTFILES_DIR/bashrc/.bashrc" ]] && {
        if [[ ! -f "$HOME/.bashrc" ]] || ! cmp -s "$DOTFILES_DIR/bashrc/.bashrc" "$HOME/.bashrc"; then
            if cp "$DOTFILES_DIR/bashrc/.bashrc" "$HOME/"; then
                log_success "Bash configurado"
            else
                log_error "Error copiando .bashrc"
                exit 1
            fi
        else
            log_info "Bash ya está actualizado"
        fi
    }

    # Bash Profile
    [[ -f "$DOTFILES_DIR/bash_profile/.bash_profile" ]] && {
        if [[ ! -f "$HOME/.bash_profile" ]] || ! cmp -s "$DOTFILES_DIR/bash_profile/.bash_profile" "$HOME/.bash_profile"; then
            # Eliminar symlink roto si existe
            [[ -L "$HOME/.bash_profile" && ! -e "$HOME/.bash_profile" ]] && rm -f "$HOME/.bash_profile"
            if cp "$DOTFILES_DIR/bash_profile/.bash_profile" "$HOME/"; then
                log_success "Bash profile configurado"
            else
                log_error "Error copiando bash profile"
                exit 1
            fi
        else
            log_info "Bash profile ya está actualizado"
        fi
    }

    # Kitty
    [[ -d "$DOTFILES_DIR/kitty" ]] && {
        mkdir -p "$HOME/.config"
        if [[ ! -d "$HOME/.config/kitty" ]] || ! diff -r "$DOTFILES_DIR/kitty" "$HOME/.config/kitty" >/dev/null 2>&1; then
            [[ -e "$HOME/.config/kitty" ]] && rm -rf "$HOME/.config/kitty"
            if cp -r "$DOTFILES_DIR/kitty" "$HOME/.config/"; then
                log_success "Kitty configurado"
            else
                log_error "Error copiando kitty"
                exit 1
            fi
        else
            log_info "Kitty ya está actualizado"
        fi
    }

    # Fastfetch
    [[ -d "$DOTFILES_DIR/fastfetch" ]] && {
        mkdir -p "$HOME/.config"
        if [[ ! -d "$HOME/.config/fastfetch" ]] || ! diff -r "$DOTFILES_DIR/fastfetch" "$HOME/.config/fastfetch" >/dev/null 2>&1; then
            [[ -e "$HOME/.config/fastfetch" ]] && rm -rf "$HOME/.config/fastfetch"
            if cp -r "$DOTFILES_DIR/fastfetch" "$HOME/.config/"; then
                log_success "Fastfetch configurado"
            else
                log_error "Error copiando fastfetch"
                exit 1
            fi
        else
            log_info "Fastfetch ya está actualizado"
        fi
    }

    # Nano
    [[ -f "$DOTFILES_DIR/nano/.nanorc" ]] && {
        if [[ ! -f "$HOME/.nanorc" ]] || ! cmp -s "$DOTFILES_DIR/nano/.nanorc" "$HOME/.nanorc"; then
            if cp "$DOTFILES_DIR/nano/.nanorc" "$HOME/"; then
                # Crear directorio de backups de nano
                mkdir -p "$HOME/.nano/backups"
                log_success "Nano configurado"
            else
                log_error "Error copiando .nanorc"
                exit 1
            fi
        else
            log_info "Nano ya está actualizado"
        fi
    }

    # Tmux
    [[ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]] && {
        if [[ ! -f "$HOME/.tmux.conf" ]] || ! cmp -s "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"; then
            if cp "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/"; then
                log_success "Tmux configurado"
            else
                log_error "Error copiando .tmux.conf"
                exit 1
            fi
        else
            log_info "Tmux ya está actualizado"
        fi
    }

    # Powerlevel10k configuration
    [[ -f "$DOTFILES_DIR/.p10k.zsh" ]] && {
        if [[ ! -f "$HOME/.p10k.zsh" ]] || ! cmp -s "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"; then
            if cp "$DOTFILES_DIR/.p10k.zsh" "$HOME/"; then
                log_success "Powerlevel10k configurado"
            else
                log_error "Error copiando .p10k.zsh"
                exit 1
            fi
        else
            log_info "Powerlevel10k ya está actualizado"
        fi
    }

    # Dreamcoder p10k theme
    [[ -f "$DOTFILES_DIR/p10k_dreamcoder.zsh" ]] && {
        if [[ ! -f "$HOME/.p10k_dreamcoder.zsh" ]] || ! cmp -s "$DOTFILES_DIR/p10k_dreamcoder.zsh" "$HOME/.p10k_dreamcoder.zsh"; then
            if cp "$DOTFILES_DIR/p10k_dreamcoder.zsh" "$HOME/.p10k_dreamcoder.zsh"; then
                log_success "Tema Dreamcoder p10k configurado"
            else
                log_error "Error copiando p10k_dreamcoder.zsh"
                exit 1
            fi
        else
            log_info "Tema Dreamcoder p10k ya está actualizado"
        fi
    }

    # Starship configuration (DreamCoder v2.0)
    [[ -f "$DOTFILES_DIR/starship.toml" ]] && {
        mkdir -p "$HOME/.config"
        # Remover symlink externo o roto
        if [[ -L "$HOME/.config/starship.toml" ]]; then
            log_info "Removiendo symlink existente de starship.toml"
            rm "$HOME/.config/starship.toml"
        fi
        if [[ ! -f "$HOME/.config/starship.toml" ]] || ! cmp -s "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"; then
            if cp "$DOTFILES_DIR/starship.toml" "$HOME/.config/"; then
                log_success "Starship v2.0 configurado (Neon Cyber)"
            else
                log_error "Error copiando starship.toml"
                exit 1
            fi
        else
            log_info "Starship ya está actualizado"
        fi
    }
}

setup_zsh() {
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Cambiando shell por defecto a ZSH..."
        if chsh -s /usr/bin/zsh 2>/dev/null; then
            log_success "Shell cambiado a ZSH"
        else
            log_warning "No se pudo cambiar shell automáticamente"
            log_info "Ejecuta manualmente: chsh -s /usr/bin/zsh"
            log_info "O reinicia la sesión y el shell cambiará automáticamente"
        fi
    fi
}

self_update() {
    log_info "Actualizando Dreamcoder Dotfiles..."

    if [[ -d "$SCRIPT_DIR/.git" ]]; then
        cd "$SCRIPT_DIR"
        git fetch origin
        local_commit=$(git rev-parse HEAD)
        default_branch=$(git remote show origin | grep "HEAD branch" | cut -d: -f2 | xargs)

        if [[ -z "$default_branch" ]]; then
            default_branch="main"
        fi

        remote_commit=$(git rev-parse "origin/$default_branch")

        if [[ "$local_commit" != "$remote_commit" ]]; then
            git pull origin "$default_branch"
            log_success "Dotfiles actualizados"
            log_info "Ejecuta './install.sh' para aplicar cambios"
        else
            log_info "Ya tienes la versión más reciente"
        fi
    else
        log_warning "No es un repositorio git, clona desde GitHub para auto-actualizaciones"
    fi
}

show_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║       🚀 DREAMCODER DOTFILES 🚀       ║"
    echo "║          Instalador Minimalista       ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "No ejecutar este script como root"
        exit 1
    fi
}

main() {
    show_banner
    check_root

    case "${1:-install}" in
        "install")
            log_info "Iniciando instalación..."
            check_arch_linux
            backup_existing
            remove_broken_symlinks
            check_sudo
            install_packages
            setup_oh_my_zsh
            install_dotfiles
            setup_zsh
            log_success "🎉 Instalación completada"
            log_info "Reinicia la terminal o ejecuta: source ~/.zshrc"
            ;;
        "--skip-packages")
            log_info "Instalando solo configuraciones..."
            check_arch_linux
            backup_existing
            remove_broken_symlinks
            setup_oh_my_zsh
            install_dotfiles
            setup_zsh
            log_success "🎉 Configuraciones instaladas"
            log_info "Reinicia la terminal o ejecuta: source ~/.zshrc"
            ;;
        "update")
            self_update
            ;;
        "help"|"--help"|"-h")
            echo "Uso: $0 [install|update|help|--skip-packages]"
            echo "  install         - Instala las configuraciones (por defecto)"
            echo "  --skip-packages - Solo instala configuraciones (sin sudo)"
            echo "  update          - Actualiza desde GitHub"
            echo "  help            - Muestra esta ayuda"
            ;;
        *)
            log_error "Opción inválida: $1"
            echo "Usa '$0 help' para ver opciones disponibles"
            exit 1
            ;;
    esac
}

main "$@"