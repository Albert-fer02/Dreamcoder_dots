#!/bin/bash

# 📁 Dreamcoder Setup - Gestión de Configuraciones
# Instalación y gestión de archivos de configuración

# Verificar si ya fue cargado
if [[ "${DREAMCODER_CONFIG_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_CONFIG_LOADED=true

# ================================
# CONFIGURACIONES DISPONIBLES
# ================================
declare -A CONFIGS=(
    ["zsh"]="zshrc/.zshrc|$HOME/.zshrc|Configuración de ZSH usuario|shell"
    ["zsh-root"]="zshrc/root_example.zsh|/root/.zshrc|Configuración de ZSH para root|shell"
    ["bash"]="bashrc/.bashrc|$HOME/.bashrc|Configuración de Bash|shell"
    ["kitty"]="kitty|$HOME/.config/kitty|Terminal Kitty|terminal"
    ["fastfetch"]="fastfetch|$HOME/.config/fastfetch|Fastfetch con imágenes|system"
    ["nano"]="nano/nanorc|$HOME/.nanorc|Editor Nano|editor"
    ["starship"]="starship.toml|$HOME/.config/starship.toml|Prompt Starship usuario|prompt"
    ["starship-root"]="starship/starship_root.toml|/root/.config/starship.toml|Prompt Starship para root|prompt"
)

# ================================
# FUNCIONES DE CONFIGURACIÓN
# ================================
load_config_definitions() {
    local config_file="$CONFIG_DIR/configs.conf"
    
    if [[ -f "$config_file" ]]; then
        print_info "Cargando definiciones de configuración desde archivo"
        
        while IFS='=' read -r key value; do
            # Ignorar líneas vacías y comentarios
            if [[ -n "$key" && ! "$key" =~ ^[[:space:]]*# ]]; then
                CONFIGS["$key"]="$value"
            fi
        done < "$config_file"
        
        log_info "Definiciones de configuración cargadas desde: $config_file"
    else
        log_info "Usando definiciones de configuración por defecto"
    fi
}

install_config() {
    local config_name="$1"
    local source_path="$2"
    local dest_path="$3"
    local description="$4"

    # Validar y sanitizar rutas
    source_path=$(sanitize_path "$source_path") || {
        print_error "Ruta fuente inválida: $2"
        return 1
    }

    dest_path=$(sanitize_path "$dest_path") || {
        print_error "Ruta destino inválida: $3"
        return 1
    }

    # Expandir ~ a la ruta completa del home de forma segura
    if [[ "$dest_path" == \~* ]]; then
        dest_path="${dest_path/#\~/$HOME}"
    fi

    # Verificar que las rutas no contengan caracteres peligrosos después de expansión
    if [[ "$dest_path" =~ \.\. || "$source_path" =~ \.\. ]]; then
        print_error "Rutas contienen secuencias peligrosas (..)"
        log_error "Intento de path traversal detectado: $source_path -> $dest_path"
        return 1
    fi

    if [[ ! -f "$source_path" && ! -d "$source_path" ]]; then
        print_warning "Configuración no encontrada: $source_path"
        log_warn "Archivo/directorio de configuración no encontrado: $source_path"
        return 1
    fi
    
    print_substep "Instalando $description"
    log_info "Instalando configuración: $config_name ($source_path -> $dest_path)"
    
    # Detectar si es una configuración de root
    local needs_sudo=false
    if [[ "$dest_path" == /root/* ]]; then
        needs_sudo=true
        print_info "Configuración requiere permisos de root"
    fi
    
    # Preparar directorio destino
    local dest_dir
    if [[ -d "$source_path" ]]; then
        # Para directorios, el destino es la carpeta completa
        dest_dir="$dest_path"
    else
        # Para archivos, usar el directorio contenedor
        dest_dir=$(dirname "$dest_path")
    fi
    
    if [[ "$needs_sudo" == "true" ]]; then
        if ! sudo mkdir -p "$dest_dir" 2>/dev/null; then
            print_error "No se pudo crear directorio con sudo: $dest_dir"
            log_error "Error creando directorio destino con sudo: $dest_dir"
            return 1
        fi
    else
        if ! mkdir -p "$dest_dir" 2>/dev/null; then
            print_error "No se pudo crear directorio: $dest_dir"
            log_error "Error creando directorio destino: $dest_dir"
            return 1
        fi
    fi
    
    # Crear respaldo (solo si no es root o el usuario puede crear backups)
    if [[ "$needs_sudo" != "true" ]]; then
        create_backup "$dest_path" "$description"
    else
        print_info "Saltando respaldo para configuración de root"
    fi
    
    # Crear enlace simbólico
    if [[ -d "$source_path" ]]; then
        # Es un directorio - crear enlace simbólico al directorio
        if [[ "$needs_sudo" == "true" ]]; then
            if sudo ln -sf "$source_path" "$dest_path" 2>/dev/null; then
                print_success "$description enlazada (directorio, root)"
                log_info "Configuración de directorio root enlazada exitosamente: $config_name"
            else
                print_error "Error creando enlace de directorio root: $source_path"
                log_error "Error creando enlace de directorio de configuración root: $source_path"
                return 1
            fi
        else
            if ln -sf "$source_path" "$dest_path" 2>/dev/null; then
                print_success "$description enlazada (directorio)"
                log_info "Configuración de directorio enlazada exitosamente: $config_name"
            else
                print_error "Error creando enlace de directorio: $source_path"
                log_error "Error creando enlace de directorio de configuración: $source_path"
                return 1
            fi
        fi
    else
        # Es un archivo - crear enlace simbólico al archivo
        if [[ "$needs_sudo" == "true" ]]; then
            if sudo ln -sf "$source_path" "$dest_path" 2>/dev/null; then
                print_success "$description enlazada (archivo, root)"
                log_info "Configuración de archivo root enlazada exitosamente: $config_name"
            else
                print_error "Error creando enlace de archivo root: $source_path"
                log_error "Error creando enlace de archivo de configuración root: $source_path"
                return 1
            fi
        else
            if ln -sf "$source_path" "$dest_path" 2>/dev/null; then
                print_success "$description enlazada (archivo)"
                log_info "Configuración de archivo enlazada exitosamente: $config_name"
            else
                print_error "Error creando enlace de archivo: $source_path"
                log_error "Error creando enlace de archivo de configuración: $source_path"
                return 1
            fi
        fi
    fi
    
    return 0
}

install_selected_configs() {
    local selected_configs=("$@")
    
    if [[ ${#selected_configs[@]} -eq 0 ]]; then
        print_warning "No se seleccionaron configuraciones para instalar"
        return 0
    fi
    
    print_step "INSTALANDO CONFIGURACIONES SELECCIONADAS"
    log_info "Iniciando instalación de configuraciones: ${selected_configs[*]}"
    
    local installed=0
    local failed=0
    
    for config in "${selected_configs[@]}"; do
        if [[ -n "${CONFIGS[$config]}" ]]; then
            IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
            
            if install_config "$config" "$SCRIPT_DIR/$source" "$dest" "$desc"; then
                ((installed++))
            else
                ((failed++))
            fi
        else
            print_error "Configuración desconocida: $config"
            log_error "Configuración no encontrada en definiciones: $config"
            ((failed++))
        fi
    done
    
    print_step "RESULTADO DE INSTALACIÓN"
    echo -e "✅ Configuraciones instaladas: ${BOLD}$installed${NC}"
    echo -e "❌ Errores: ${BOLD}$failed${NC}"
    
    if [[ $failed -eq 0 ]]; then
        print_success "Todas las configuraciones se instalaron correctamente"
        return 0
    else
        print_warning "Se completó la instalación con algunos errores"
        return 1
    fi
}

# ================================
# GESTIÓN DE CONFIGURACIONES
# ================================
list_available_configs() {
    print_step "CONFIGURACIONES DISPONIBLES"
    
    echo -e "${CYAN}┌─ CONFIGURACIONES ────────────────────────────────────────────┐${NC}"
    
    for config in "${!CONFIGS[@]}"; do
        IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
        # Expandir ~ a la ruta completa del home
        dest="${dest/#\~/$HOME}"
        
        local status="❌ No instalado"
        if [[ -f "$dest" || -d "$dest" ]]; then
            if [[ -L "$dest" ]]; then
                status="🔗 Enlazado"
            else
                status="✅ Instalado"
            fi
        fi
        
        echo -e "${CYAN}│${NC} ${BOLD}$config${NC} - $desc"
        echo -e "${CYAN}│${NC}   Destino: $dest"
        echo -e "${CYAN}│${NC}   Estado: $status"
        echo -e "${CYAN}│${NC}   Categoría: $category"
        echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    done
    
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
}

get_configs_by_category() {
    local target_category="$1"
    local result=()
    
    for config in "${!CONFIGS[@]}"; do
        IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
        if [[ "$category" == "$target_category" ]]; then
            result+=("$config")
        fi
    done
    
    printf '%s\n' "${result[@]}"
}

check_config_status() {
    local config="$1"
    
    if [[ -z "${CONFIGS[$config]}" ]]; then
        echo "unknown"
        return 1
    fi
    
    IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
    # Expandir ~ a la ruta completa del home
    dest="${dest/#\~/$HOME}"
    
    if [[ -f "$dest" || -d "$dest" ]]; then
        if [[ -L "$dest" ]]; then
            echo "linked"
        else
            echo "installed"
        fi
        return 0
    else
        echo "not_installed"
        return 1
    fi
}

# ================================
# POST-INSTALACIÓN
# ================================
post_install_tasks() {
    local installed_configs=("$@")
    
    print_step "TAREAS POST-INSTALACIÓN"
    
    # Verificar si se instaló ZSH o Bash
    local shell_installed=false
    local root_shell_installed=false
    
    for config in "${installed_configs[@]}"; do
        if [[ "$config" == "zsh" || "$config" == "bash" ]]; then
            shell_installed=true
        fi
        if [[ "$config" == "zsh-root" ]]; then
            root_shell_installed=true
        fi
    done
    
    if [[ "$shell_installed" == "true" ]]; then
        print_substep "Configuración de shell detectada"
        
        # Sugerir recarga de configuración
        if [[ -f "$HOME/.zshrc" && "$SHELL" == *"zsh"* ]]; then
            print_info "Para aplicar la nueva configuración de ZSH:"
            echo -e "  ${BOLD}source ~/.zshrc${NC}"
        elif [[ -f "$HOME/.bashrc" && "$SHELL" == *"bash"* ]]; then
            print_info "Para aplicar la nueva configuración de Bash:"
            echo -e "  ${BOLD}source ~/.bashrc${NC}"
        fi
        
        # Verificar si el shell actual coincide con la configuración
        local current_shell=$(basename "$SHELL")
        if [[ -f "$HOME/.zshrc" && "$current_shell" != "zsh" ]]; then
            print_warning "Se instaló configuración de ZSH pero el shell actual es: $current_shell"
            print_info "Para cambiar a ZSH: ${BOLD}chsh -s $(which zsh)${NC}"
        fi
    fi
    
    if [[ "$root_shell_installed" == "true" ]]; then
        print_substep "Configuración de ZSH root detectada"
        print_info "Configuración de ZSH para root instalada exitosamente"
        print_warning "Para cambiar shell de root a ZSH: ${BOLD}sudo chsh -s $(which zsh) root${NC}"
    fi
    
    # Verificar configuraciones de Starship
    local starship_configs=()
    for config in "${installed_configs[@]}"; do
        if [[ "$config" == "starship" ]]; then
            starship_configs+=("usuario")
        elif [[ "$config" == "starship-root" ]]; then
            starship_configs+=("root")
        fi
    done
    
    if [[ ${#starship_configs[@]} -gt 0 ]]; then
        print_substep "Configuraciones de Starship detectadas"
        for starship_type in "${starship_configs[@]}"; do
            print_info "Starship configurado para: $starship_type"
        done
        
        if ! command_exists starship; then
            print_warning "Starship no está instalado. Instálalo con:"
            echo -e "  ${BOLD}sudo pacman -S starship${NC}"
        fi
    fi
    
    # Verificar configuración de terminal
    for config in "${installed_configs[@]}"; do
        if [[ "$config" == "kitty" ]]; then
            print_info "Configuración de Kitty instalada"
            if command_exists kitty; then
                print_info "Reinicia Kitty para aplicar la nueva configuración"
            else
                print_warning "Kitty no está instalado. Usa el instalador de herramientas."
            fi
            break
        fi
    done
    
    # Verificar herramientas modernas requeridas
    check_modern_tools_requirements "${installed_configs[@]}"
    
    # Mensaje final
    print_success "Tareas post-instalación completadas"
    print_info "Puede ser necesario reiniciar la terminal para aplicar todos los cambios"
}

# ================================
# HERRAMIENTAS MODERNAS
# ================================
check_modern_tools_requirements() {
    local installed_configs=("$@")
    
    # Definir herramientas requeridas por configuración
    local -A config_requirements=(
        ["zsh"]="eza,bat,fd,rg,fzf,zoxide,mcfly"
        ["zsh-root"]="eza,bat,fd,rg,fzf,duf,dust,btm,procs"
        ["starship"]="starship"
        ["starship-root"]="starship"
    )
    
    local missing_tools=()
    local suggested_packages=()
    
    for config in "${installed_configs[@]}"; do
        if [[ -n "${config_requirements[$config]}" ]]; then
            IFS=',' read -ra tools <<< "${config_requirements[$config]}"
            for tool in "${tools[@]}"; do
                if ! command_exists "$tool"; then
                    if [[ ! " ${missing_tools[@]} " =~ " ${tool} " ]]; then
                        missing_tools+=("$tool")
                        
                        # Mapear herramientas a paquetes de Arch
                        case "$tool" in
                            "eza") suggested_packages+=("eza") ;;
                            "bat") suggested_packages+=("bat") ;;
                            "fd") suggested_packages+=("fd") ;;
                            "rg") suggested_packages+=("ripgrep") ;;
                            "fzf") suggested_packages+=("fzf") ;;
                            "zoxide") suggested_packages+=("zoxide") ;;
                            "mcfly") suggested_packages+=("mcfly") ;;
                            "duf") suggested_packages+=("duf") ;;
                            "dust") suggested_packages+=("dust") ;;
                            "btm") suggested_packages+=("bottom") ;;
                            "procs") suggested_packages+=("procs") ;;
                            "starship") suggested_packages+=("starship") ;;
                        esac
                    fi
                fi
            done
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_substep "Herramientas modernas recomendadas"
        print_warning "Faltan herramientas para funcionalidad completa:"
        
        for tool in "${missing_tools[@]}"; do
            echo -e "  ${YELLOW}◦${NC} $tool"
        done
        
        if [[ ${#suggested_packages[@]} -gt 0 ]]; then
            print_info "Para instalar todas las herramientas sugeridas:"
            echo -e "  ${BOLD}sudo pacman -S ${suggested_packages[*]}${NC}"
            print_info "O usa la opción 'Gestionar herramientas' del menú principal"
        fi
    else
        print_success "Todas las herramientas modernas están disponibles"
    fi
}

# ================================
# VALIDACIONES
# ================================
validate_config_source() {
    local config="$1"
    
    if [[ -z "${CONFIGS[$config]}" ]]; then
        return 1
    fi
    
    IFS='|' read -r source dest desc category <<< "${CONFIGS[$config]}"
    local source_path="$SCRIPT_DIR/$source"
    
    if [[ ! -f "$source_path" && ! -d "$source_path" ]]; then
        log_error "Archivo/directorio fuente no encontrado: $source_path"
        return 1
    fi
    
    return 0
}

# Cargar configuraciones al inicializar el módulo
load_config_definitions