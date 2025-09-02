#!/bin/bash

# 🐧 Dreamcoder Setup - Detección de Distribución
# Gestión específica por distribución Linux

# Verificar si ya fue cargado
if [[ "${DREAMCODER_DISTRO_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_DISTRO_LOADED=true

# ================================
# DETECCIÓN DE DISTRIBUCIÓN
# ================================
detect_distro() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]] || [[ -f /etc/fedora-release ]]; then
        echo "redhat"
    elif [[ -f /etc/alpine-release ]]; then
        echo "alpine"
    elif [[ -f /etc/gentoo-release ]]; then
        echo "gentoo"
    else
        echo "unknown"
    fi
}

get_distro_info() {
    local distro=$(detect_distro)
    local version="unknown"
    local name="unknown"
    
    case $distro in
        "arch")
            name="Arch Linux"
            if command_exists pacman; then
                version=$(pacman -Q linux 2>/dev/null | awk '{print $2}' | head -1)
            fi
            ;;
        "debian")
            name="Debian/Ubuntu"
            if [[ -f /etc/debian_version ]]; then
                version=$(cat /etc/debian_version)
            fi
            ;;
        "redhat")
            name="Red Hat/Fedora"
            if [[ -f /etc/fedora-release ]]; then
                version=$(cat /etc/fedora-release)
            elif [[ -f /etc/redhat-release ]]; then
                version=$(cat /etc/redhat-release)
            fi
            ;;
        "alpine")
            name="Alpine Linux"
            version=$(cat /etc/alpine-release 2>/dev/null)
            ;;
    esac
    
    echo "$distro|$name|$version"
}

# ================================
# GESTIÓN DE PAQUETES
# ================================
install_packages() {
    local distro="$1"
    shift
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        log_warn "No se especificaron paquetes para instalar"
        return 0
    fi
    
    print_substep "Instalando paquetes: ${packages[*]}"
    log_info "Instalando paquetes en $distro: ${packages[*]}"
    
    case $distro in
        "arch")
            sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null || {
                print_warning "Algunos paquetes no se pudieron instalar con pacman"
                log_warn "Error instalando paquetes con pacman: ${packages[*]}"
                return 1
            }
            ;;
        "debian")
            sudo apt update >/dev/null 2>&1
            sudo apt install -y "${packages[@]}" 2>/dev/null || {
                print_warning "Algunos paquetes no se pudieron instalar con apt"
                log_warn "Error instalando paquetes con apt: ${packages[*]}"
                return 1
            }
            ;;
        "redhat")
            sudo dnf install -y "${packages[@]}" 2>/dev/null || {
                print_warning "Algunos paquetes no se pudieron instalar con dnf"
                log_warn "Error instalando paquetes con dnf: ${packages[*]}"
                return 1
            }
            ;;
        "alpine")
            sudo apk add "${packages[@]}" 2>/dev/null || {
                print_warning "Algunos paquetes no se pudieron instalar con apk"
                return 1
            }
            ;;
        *)
            print_error "Distribución no soportada: $distro"
            log_error "Distribución no soportada para instalación: $distro"
            return 1
            ;;
    esac
    
    print_success "Paquetes instalados correctamente"
    return 0
}

update_system() {
    local distro="$1"
    
    print_substep "Actualizando sistema $distro"
    log_info "Actualizando sistema: $distro"
    
    case $distro in
        "arch")
            sudo pacman -Syu --noconfirm || {
                print_error "Error actualizando sistema Arch"
                return 1
            }
            ;;
        "debian")
            sudo apt update && sudo apt upgrade -y || {
                print_error "Error actualizando sistema Debian/Ubuntu"
                return 1
            }
            ;;
        "redhat")
            sudo dnf update -y || {
                print_error "Error actualizando sistema Red Hat/Fedora"
                return 1
            }
            ;;
        "alpine")
            sudo apk update && sudo apk upgrade || {
                print_error "Error actualizando sistema Alpine"
                return 1
            }
            ;;
        *)
            print_warning "Actualización automática no soportada para: $distro"
            return 1
            ;;
    esac
    
    print_success "Sistema actualizado correctamente"
    return 0
}

# ================================
# PAQUETES POR DISTRIBUCIÓN
# ================================
get_core_packages() {
    local distro="$1"
    
    case $distro in
        "arch")
            echo "zsh git curl wget base-devel"
            ;;
        "debian")
            echo "zsh git curl wget build-essential"
            ;;
        "redhat")
            echo "zsh git curl wget gcc gcc-c++ make"
            ;;
        "alpine")
            echo "zsh git curl wget build-base"
            ;;
        *)
            echo "git curl wget"
            ;;
    esac
}

get_modern_cli_packages() {
    local distro="$1"
    
    case $distro in
        "arch")
            echo "eza bat fd ripgrep fzf zoxide dust duf procs bottom hyperfine tokei"
            ;;
        "debian")
            echo "exa bat fd-find ripgrep fzf"
            ;;
        "redhat")
            echo "exa bat fd-find ripgrep fzf"
            ;;
        *)
            echo ""
            ;;
    esac
}

get_terminal_packages() {
    local distro="$1"
    
    case $distro in
        "arch")
            echo "kitty fastfetch"
            ;;
        "debian")
            echo "kitty"
            ;;
        "redhat")
            echo "kitty"
            ;;
        *)
            echo ""
            ;;
    esac
}

# ================================
# VALIDACIONES ESPECÍFICAS
# ================================
validate_distro_support() {
    local distro=$(detect_distro)
    
    case $distro in
        "arch"|"debian"|"redhat")
            return 0
            ;;
        "alpine"|"gentoo")
            print_warning "Soporte experimental para $distro"
            return 0
            ;;
        *)
            print_error "Distribución no soportada: $distro"
            print_info "Distribuciones soportadas: Arch Linux, Debian/Ubuntu, Red Hat/Fedora"
            return 1
            ;;
    esac
}