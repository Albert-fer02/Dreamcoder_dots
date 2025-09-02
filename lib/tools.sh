#!/bin/bash

# 🛠️ Dreamcoder Setup - Gestión de Herramientas
# Instalación y actualización de herramientas de desarrollo

# Verificar si ya fue cargado
if [[ "${DREAMCODER_TOOLS_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_TOOLS_LOADED=true

# ================================
# INSTALACIÓN DE HERRAMIENTAS
# ================================
install_tools() {
    local distro="$1"
    shift
    local selected_categories=("$@")
    
    if [[ ${#selected_categories[@]} -eq 0 ]]; then
        print_warning "No se seleccionaron categorías de herramientas"
        return 0
    fi
    
    print_step "INSTALANDO HERRAMIENTAS"
    log_info "Instalando herramientas para categorías: ${selected_categories[*]}"
    
    local total_installed=0
    local total_failed=0
    
    # Paquetes core (fundamentales)
    if [[ " ${selected_categories[*]} " =~ " core " ]]; then
        print_substep "Instalando paquetes core"
        local core_packages=($(get_core_packages "$distro"))
        
        if install_packages "$distro" "${core_packages[@]}"; then
            ((total_installed++))
        else
            ((total_failed++))
        fi
    fi
    
    # CLI Tools modernos
    if [[ " ${selected_categories[*]} " =~ " modern " ]]; then
        print_substep "Instalando herramientas CLI modernas"
        local modern_packages=($(get_modern_cli_packages "$distro"))
        
        if [[ ${#modern_packages[@]} -gt 0 ]]; then
            install_packages "$distro" "${modern_packages[@]}" || true
        fi
        
        # Instalar herramientas adicionales via scripts
        install_modern_cli_extras "$distro"
        ((total_installed++))
    fi
    
    # Terminal tools
    if [[ " ${selected_categories[*]} " =~ " terminal " ]]; then
        print_substep "Instalando herramientas de terminal"
        local terminal_packages=($(get_terminal_packages "$distro"))
        
        if [[ ${#terminal_packages[@]} -gt 0 ]]; then
            install_packages "$distro" "${terminal_packages[@]}" || {
                # Método alternativo para distribuciones sin estos paquetes
                install_terminal_alternatives "$distro"
            }
        else
            install_terminal_alternatives "$distro"
        fi
        ((total_installed++))
    fi
    
    # Starship prompt
    if [[ " ${selected_categories[*]} " =~ " starship " ]]; then
        install_starship
        ((total_installed++))
    fi
    
    # Oh-My-Zsh y plugins
    if [[ " ${selected_categories[*]} " =~ " zsh " ]]; then
        install_zsh_ecosystem
        ((total_installed++))
    fi
    
    # Node.js tools
    if [[ " ${selected_categories[*]} " =~ " nodejs " ]]; then
        install_nodejs_tools
        ((total_installed++))
    fi
    
    print_step "RESULTADO DE INSTALACIÓN DE HERRAMIENTAS"
    echo -e "✅ Categorías procesadas: ${BOLD}$total_installed${NC}"
    echo -e "❌ Errores: ${BOLD}$total_failed${NC}"
    
    return 0
}

# ================================
# INSTALADORES ESPECÍFICOS
# ================================
install_modern_cli_extras() {
    local distro="$1"
    
    # zoxide (si no está disponible en repos)
    if ! command_exists zoxide; then
        print_substep "Instalando zoxide"
        if curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash; then
            print_success "zoxide instalado"
        else
            print_warning "Error instalando zoxide"
        fi
    fi
    
    # Instalar rust si no está disponible (para herramientas rust)
    if ! command_exists cargo && [[ "$distro" != "arch" ]]; then
        print_substep "Instalando Rust para herramientas adicionales"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env" 2>/dev/null || true
    fi
}

install_terminal_alternatives() {
    local distro="$1"
    
    # Kitty (método alternativo)
    if ! command_exists kitty; then
        print_substep "Instalando Kitty via método alternativo"
        if curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin; then
            print_success "Kitty instalado"
            
            # Crear enlace simbólico
            mkdir -p "$HOME/.local/bin"
            ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/"
        else
            print_warning "Error instalando Kitty"
        fi
    fi
    
    # Fastfetch (si no está disponible)
    if ! command_exists fastfetch; then
        print_substep "Intentando instalar Fastfetch desde repositorio"
        case $distro in
            "debian")
                # Añadir repositorio si es necesario
                print_info "Fastfetch puede no estar disponible en esta versión"
                ;;
            "redhat")
                print_info "Fastfetch puede requerir repositorios adicionales"
                ;;
        esac
    fi
}

install_starship() {
    print_substep "Instalando Starship Prompt"
    
    if ! command_exists starship; then
        if curl -sS https://starship.rs/install.sh | sh -s -- --yes; then
            print_success "Starship instalado"
            log_info "Starship prompt instalado exitosamente"
        else
            print_error "Error instalando Starship"
            log_error "Fallo en la instalación de Starship"
        fi
    else
        print_info "Starship ya está instalado"
    fi
}

install_zsh_ecosystem() {
    print_substep "Instalando ecosistema ZSH"
    
    # Oh-My-Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_substep "Instalando Oh-My-Zsh"
        if RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
            print_success "Oh-My-Zsh instalado"
        else
            print_error "Error instalando Oh-My-Zsh"
            return 1
        fi
    else
        print_info "Oh-My-Zsh ya está instalado"
    fi
    
    # Plugins personalizados
    install_zsh_plugins
}

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_warning "Oh-My-Zsh no está instalado, saltando plugins"
        return 1
    fi
    
    local plugins=(
        "fast-syntax-highlighting|https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        "you-should-use|https://github.com/MichaelAquilina/zsh-you-should-use.git"
        "auto-notify|https://github.com/MichaelAquilina/zsh-auto-notify.git"
        "zsh-completions|https://github.com/zsh-users/zsh-completions.git"
    )
    
    print_substep "Instalando plugins de ZSH"
    
    for plugin_info in "${plugins[@]}"; do
        IFS='|' read -r plugin_name repo_url <<< "$plugin_info"
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"
        
        if [[ ! -d "$plugin_dir" ]]; then
            if git clone "$repo_url" "$plugin_dir" 2>/dev/null; then
                print_success "Plugin instalado: $plugin_name"
            else
                print_warning "Error instalando plugin: $plugin_name"
            fi
        else
            print_info "Plugin ya instalado: $plugin_name"
        fi
    done
}

install_nodejs_tools() {
    print_substep "Instalando herramientas Node.js"
    
    # Bun
    if ! command_exists bun; then
        print_substep "Instalando Bun"
        if curl -fsSL https://bun.sh/install | bash; then
            print_success "Bun instalado"
        else
            print_warning "Error instalando Bun"
        fi
    else
        print_info "Bun ya está instalado"
    fi
    
    # FNM (Fast Node Manager)
    if ! command_exists fnm; then
        print_substep "Instalando FNM"
        if curl -fsSL https://fnm.vercel.app/install | bash; then
            print_success "FNM instalado"
        else
            print_warning "Error instalando FNM"
        fi
    else
        print_info "FNM ya está instalado"
    fi
    
    # Pnpm (alternativa a npm)
    if ! command_exists pnpm; then
        print_substep "Instalando pnpm"
        if curl -fsSL https://get.pnpm.io/install.sh | sh; then
            print_success "pnpm instalado"
        else
            print_info "pnpm no se pudo instalar (opcional)"
        fi
    fi
}

# ================================
# ACTUALIZACIÓN DE HERRAMIENTAS
# ================================
update_tools() {
    local distro="$1"
    
    print_step "ACTUALIZANDO HERRAMIENTAS"
    
    # Actualizar sistema base
    update_system "$distro"
    
    # Actualizar Oh-My-Zsh y plugins
    update_zsh_ecosystem
    
    # Actualizar herramientas específicas
    update_specific_tools
    
    print_success "Actualización de herramientas completada"
}

update_zsh_ecosystem() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        return 0
    fi
    
    print_substep "Actualizando Oh-My-Zsh"
    if (cd "$HOME/.oh-my-zsh" && git pull); then
        print_success "Oh-My-Zsh actualizado"
    else
        print_warning "Error actualizando Oh-My-Zsh"
    fi
    
    # Actualizar plugins
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    for plugin_dir in "$ZSH_CUSTOM/plugins"/*; do
        if [[ -d "$plugin_dir/.git" ]]; then
            local plugin_name=$(basename "$plugin_dir")
            print_substep "Actualizando plugin: $plugin_name"
            if (cd "$plugin_dir" && git pull); then
                print_success "Plugin actualizado: $plugin_name"
            else
                print_warning "Error actualizando plugin: $plugin_name"
            fi
        fi
    done
}

update_specific_tools() {
    # Actualizar Starship
    if command_exists starship; then
        print_substep "Actualizando Starship"
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
        print_success "Starship actualizado"
    fi
    
    # Actualizar Bun
    if command_exists bun; then
        print_substep "Actualizando Bun"
        if bun upgrade; then
            print_success "Bun actualizado"
        else
            print_warning "Error actualizando Bun"
        fi
    fi
    
    # Actualizar Rust toolchain
    if command_exists rustup; then
        print_substep "Actualizando Rust toolchain"
        rustup update
        print_success "Rust actualizado"
    fi
}

# ================================
# VERIFICACIÓN DE HERRAMIENTAS
# ================================
verify_tools_installation() {
    print_step "VERIFICANDO INSTALACIÓN DE HERRAMIENTAS"
    
    local essential_tools=("git" "curl" "wget")
    local optional_tools=("zsh" "starship" "kitty" "fastfetch" "eza" "bat" "fd" "rg" "fzf")
    
    echo -e "${CYAN}Herramientas esenciales:${NC}"
    for tool in "${essential_tools[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool instalado"
        else
            print_error "$tool NO instalado"
        fi
    done
    
    echo -e "\n${CYAN}Herramientas opcionales:${NC}"
    for tool in "${optional_tools[@]}"; do
        if command_exists "$tool"; then
            local version=$(command "$tool" --version 2>/dev/null | head -1 || echo "instalado")
            print_success "$tool: $version"
        else
            print_warning "$tool no instalado"
        fi
    done
}

# ================================
# POST-INSTALACIÓN
# ================================
setup_tool_paths() {
    print_substep "Configurando PATHs de herramientas"
    
    local paths_to_add=(
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
        "$HOME/go/bin"
        "$HOME/.bun/bin"
    )
    
    for shell_rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [[ -f "$shell_rc" ]]; then
            for path in "${paths_to_add[@]}"; do
                local path_export="export PATH=\"$path:\$PATH\""
                if ! grep -q "$path_export" "$shell_rc" 2>/dev/null; then
                    echo "$path_export" >> "$shell_rc"
                    print_info "PATH agregado a $(basename "$shell_rc"): $path"
                fi
            done
        fi
    done
}