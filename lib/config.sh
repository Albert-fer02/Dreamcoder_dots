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
    ["zsh"]="zshrc/.zshrc|$HOME/.zshrc|Configuración de ZSH|shell"
    ["bash"]="bashrc/.bashrc|$HOME/.bashrc|Configuración de Bash|shell"
    ["kitty"]="kitty|$HOME/.config/kitty|Terminal Kitty|terminal"
    ["fastfetch"]="fastfetch|$HOME/.config/fastfetch|Fastfetch con imágenes|system"
    ["nano"]="nano/nanorc|$HOME/.nanorc|Editor Nano|editor"
    ["starship"]="starship.toml|$HOME/.config/starship.toml|Prompt Starship|prompt"
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
    
    if [[ ! -f "$source_path" && ! -d "$source_path" ]]; then
        print_warning "Configuración no encontrada: $source_path"
        log_warn "Archivo/directorio de configuración no encontrado: $source_path"
        return 1
    fi
    
    print_substep "Instalando $description"
    log_info "Instalando configuración: $config_name ($source_path -> $dest_path)"
    
    # Crear directorio destino
    local dest_dir=$(dirname "$dest_path")
    if ! mkdir -p "$dest_dir" 2>/dev/null; then
        print_error "No se pudo crear directorio: $dest_dir"
        log_error "Error creando directorio destino: $dest_dir"
        return 1
    fi
    
    # Crear respaldo
    create_backup "$dest_path" "$description"
    
    # Copiar configuración
    if [[ -d "$source_path" ]]; then
        # Es un directorio - copiar contenido
        if cp -r "$source_path"/* "$dest_dir/" 2>/dev/null; then
            print_success "$description instalada (directorio)"
            log_info "Configuración de directorio instalada exitosamente: $config_name"
        else
            print_error "Error copiando directorio: $source_path"
            log_error "Error copiando directorio de configuración: $source_path"
            return 1
        fi
    else
        # Es un archivo - copiar directamente
        if cp "$source_path" "$dest_path" 2>/dev/null; then
            print_success "$description instalada (archivo)"
            log_info "Configuración de archivo instalada exitosamente: $config_name"
        else
            print_error "Error copiando archivo: $source_path"
            log_error "Error copiando archivo de configuración: $source_path"
            return 1
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
        
        local status="❌ No instalado"
        if [[ -f "$dest" || -d "$dest" ]]; then
            status="✅ Instalado"
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
    
    if [[ -f "$dest" || -d "$dest" ]]; then
        echo "installed"
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
    for config in "${installed_configs[@]}"; do
        if [[ "$config" == "zsh" || "$config" == "bash" ]]; then
            shell_installed=true
            break
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
    
    # Mensaje final
    print_success "Tareas post-instalación completadas"
    print_info "Puede ser necesario reiniciar la terminal para aplicar todos los cambios"
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