#!/bin/bash

# 🎨 Dreamcoder Setup - Interfaz de Usuario
# Menús interactivos y elementos de interfaz

# Verificar si ya fue cargado
if [[ "${DREAMCODER_UI_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_UI_LOADED=true

# ================================
# INTERFAZ VISUAL
# ================================
show_banner() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                    🚀 DREAMCODER SETUP 🚀                    ║
║              Sistema Modular de Configuración               ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    local distro_info=$(get_distro_info)
    IFS='|' read -r distro name version <<< "$distro_info"
    
    echo -e "Versión: ${BOLD}$SCRIPT_VERSION${NC} | Sistema: ${BOLD}$name${NC} | Directorio: ${BOLD}$SCRIPT_DIR${NC}\n"
}

show_main_menu() {
    echo -e "${CYAN}┌─ MENÚ PRINCIPAL ─────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 1. 📦 Gestionar configuraciones                           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 2. 🛠️  Gestionar herramientas                             ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 3. 🚀 Instalación completa                               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 4. 🔄 Actualizar sistema                                 ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 5. 🔙 Gestionar respaldos                                ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 6. ℹ️  Información del sistema                           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 7. ⚙️  Configuración avanzada                            ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 0. ❌ Salir                                              ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
}

show_config_menu() {
    echo -e "${CYAN}┌─ GESTIÓN DE CONFIGURACIONES ────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 1. 📋 Ver configuraciones disponibles                    ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 2. 🔧 Instalar configuraciones (selectivo)               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 3. 📂 Instalar por categoría                             ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 4. 📊 Ver estado de configuraciones                      ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 0. ⬅️  Volver al menú principal                          ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
}

show_backup_menu() {
    echo -e "${CYAN}┌─ GESTIÓN DE RESPALDOS ───────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 1. 📋 Ver respaldos disponibles                          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 2. 🔙 Restaurar todos los respaldos                      ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 3. 🎯 Restaurar respaldo específico                      ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 4. 🧹 Limpiar respaldos antiguos                         ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 5. ✅ Verificar integridad de respaldos                  ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 0. ⬅️  Volver al menú principal                          ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
}

# ================================
# SELECTORES INTERACTIVOS
# ================================
select_configs() {
    local selected=()

    echo -e "${CYAN}┌─ SELECCIONAR CONFIGURACIONES ───────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} Selecciona las configuraciones que deseas instalar:      ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo

    for config in "${!CONFIGS[@]}"; do
        IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"

        local status="❌"
        if [[ -f "$dest" || -d "$dest" ]]; then
            status="✅"
        fi

        echo -n "$status ¿Instalar $desc? [y/N]: "
        read -r response

        # Validar entrada de usuario
        if ! validate_user_input "$response" 1; then
            print_warning "Entrada inválida, omitiendo configuración: $desc"
            continue
        fi

        if [[ $response =~ ^[Yy]$ ]]; then
            selected+=("$config")
        fi
    done

    if [[ ${#selected[@]} -eq 0 ]]; then
        print_warning "No se seleccionaron configuraciones"
        return 1
    fi

    printf '%s\n' "${selected[@]}"
}

select_config_categories() {
    local available_categories=("shell" "terminal" "system" "editor" "prompt")
    local category_descriptions=(
        "Shell (ZSH, Bash)" 
        "Terminal (Kitty, etc.)" 
        "Sistema (Fastfetch, etc.)" 
        "Editores (Nano, etc.)" 
        "Prompt (Starship)"
    )
    local selected=()
    
    echo -e "${CYAN}┌─ SELECCIONAR CATEGORÍAS ─────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} Selecciona las categorías que deseas instalar:           ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
    
    for i in "${!available_categories[@]}"; do
        local category="${available_categories[$i]}"
        local description="${category_descriptions[$i]}"
        
        echo -n "¿Instalar ${description}? [y/N]: "
        read -r response
        if [[ $response =~ ^[Yy]$ ]]; then
            selected+=("$category")
        fi
    done
    
    if [[ ${#selected[@]} -eq 0 ]]; then
        print_warning "No se seleccionaron categorías"
        return 1
    fi
    
    printf '%s\n' "${selected[@]}"
}

select_tools() {
    local categories=("core" "modern" "terminal" "starship" "zsh" "nodejs")
    local descriptions=(
        "Paquetes básicos (git, curl, etc.)" 
        "CLI modernas (eza, bat, fzf, etc.)" 
        "Terminal (kitty, fastfetch)" 
        "Starship prompt" 
        "Oh-My-Zsh y plugins" 
        "Node.js tools (Bun, FNM)"
    )
    local selected=()
    
    echo -e "${CYAN}┌─ SELECCIONAR HERRAMIENTAS ───────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} Selecciona las categorías de herramientas a instalar:     ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
    
    for i in "${!categories[@]}"; do
        echo -n "¿Instalar ${descriptions[$i]}? [y/N]: "
        read -r response
        if [[ $response =~ ^[Yy]$ ]]; then
            selected+=("${categories[$i]}")
        fi
    done
    
    if [[ ${#selected[@]} -eq 0 ]]; then
        print_warning "No se seleccionaron herramientas"
        return 1
    fi
    
    printf '%s\n' "${selected[@]}"
}

# ================================
# INFORMACIÓN DEL SISTEMA
# ================================
show_system_info() {
    print_step "INFORMACIÓN DEL SISTEMA"
    
    local distro_info=$(get_distro_info)
    IFS='|' read -r distro name version <<< "$distro_info"
    
    echo -e "🐧 Sistema: ${BOLD}$name${NC}"
    echo -e "📋 Distribución: ${BOLD}$distro${NC}"
    echo -e "📟 Versión: ${BOLD}$version${NC}"
    echo -e "🏠 Directorio home: ${BOLD}$HOME${NC}"
    echo -e "💾 Directorio script: ${BOLD}$SCRIPT_DIR${NC}"
    echo -e "📁 Directorio respaldos: ${BOLD}$BACKUP_DIR${NC}"
    echo -e "💿 Tamaño respaldos: ${BOLD}$(get_backup_size)${NC}"
    
    echo -e "\n${CYAN}🔧 Herramientas instaladas:${NC}"
    local tools=("zsh" "git" "curl" "wget" "kitty" "fastfetch" "starship" "eza" "bat" "fd" "rg" "fzf")
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version=$(command "$tool" --version 2>/dev/null | head -1 | cut -d' ' -f2 2>/dev/null || echo "instalado")
            echo -e "  ✅ ${BOLD}$tool${NC}: $version"
        else
            echo -e "  ❌ ${BOLD}$tool${NC}: no instalado"
        fi
    done
    
    echo -e "\n${CYAN}📁 Configuraciones:${NC}"
    for config in "${!CONFIGS[@]}"; do
        IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
        local status="❌ No instalado"
        if [[ -f "$dest" || -d "$dest" ]]; then
            status="✅ Instalado"
        fi
        echo -e "  $status ${BOLD}$config${NC}: $desc"
    done
}

# ================================
# CONFIRMACIONES Y DIÁLOGOS
# ================================
confirm_action() {
    local message="$1"
    local default="${2:-N}"
    
    echo -e "\n${YELLOW}⚠️  $message${NC}"
    if [[ "$default" == "Y" ]]; then
        echo -n "¿Continuar? [Y/n]: "
    else
        echo -n "¿Continuar? [y/N]: "
    fi
    
    read -r response
    
    if [[ "$default" == "Y" ]]; then
        [[ ! $response =~ ^[Nn]$ ]]
    else
        [[ $response =~ ^[Yy]$ ]]
    fi
}

show_progress_bar() {
    local current="$1"
    local total="$2"
    local description="$3"
    local width=50
    
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${CYAN}[${NC}"
    printf "%*s" "$filled" | tr ' ' '█'
    printf "%*s" "$empty" | tr ' ' '░'
    printf "${CYAN}] ${BOLD}%d%%${NC} - %s" "$percentage" "$description"
    
    if [[ $current -eq $total ]]; then
        echo
    fi
}

wait_for_keypress() {
    local message="${1:-Presiona Enter para continuar...}"
    echo -e "\n${BLUE}$message${NC}"
    read -r
}

# ================================
# CONFIGURACIÓN AVANZADA
# ================================
show_advanced_menu() {
    echo -e "${CYAN}┌─ CONFIGURACIÓN AVANZADA ─────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 1. 🔧 Configurar variables de entorno                     ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 2. 📝 Ver/editar archivos de configuración                ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 3. 🧹 Limpiar sistema                                     ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 4. 📊 Generar reporte del sistema                         ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 5. ⚡ Optimizar configuraciones                           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 0. ⬅️  Volver al menú principal                          ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
}

# ================================
# UTILIDADES DE INTERFAZ
# ================================
center_text() {
    local text="$1"
    local width="${2:-80}"
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

draw_separator() {
    local width="${1:-80}"
    local char="${2:-─}"
    printf "%*s\n" $width | tr ' ' "$char"
}