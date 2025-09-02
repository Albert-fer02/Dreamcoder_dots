#!/bin/bash

# 🚀 Dreamcoder Setup - Sistema Modular
# Script principal que orquesta todos los módulos

set -e  # Salir si hay algún error

# ================================
# INICIALIZACIÓN
# ================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar módulo core (siempre primero)
if [[ -f "$SCRIPT_DIR/lib/core.sh" ]]; then
    source "$SCRIPT_DIR/lib/core.sh"
else
    echo "❌ Error: No se pudo cargar el módulo core"
    exit 1
fi

# Inicializar sistema
init_core

# ================================
# CARGAR MÓDULOS
# ================================
load_modules() {
    local modules=("distro" "backup" "config" "tools" "ui")
    
    for module in "${modules[@]}"; do
        if ! load_module "$module"; then
            print_error "Fallo al cargar módulo: $module"
            exit 1
        fi
    done
    
    print_success "Todos los módulos cargados correctamente"
}

# ================================
# FUNCIONES PRINCIPALES
# ================================
handle_config_management() {
    while true; do
        show_banner
        show_config_menu
        
        echo -n "Selecciona una opción [0-4]: "
        read -r choice
        
        case $choice in
            1)  # Ver configuraciones disponibles
                list_available_configs
                wait_for_keypress
                ;;
            2)  # Instalar configuraciones (selectivo)
                echo
                if configs=($(select_configs)); then
                    install_selected_configs "${configs[@]}"
                    post_install_tasks "${configs[@]}"
                    echo -e "\n${GREEN}✅ Configuraciones instaladas exitosamente${NC}"
                fi
                wait_for_keypress
                ;;
            3)  # Instalar por categoría
                echo
                if categories=($(select_config_categories)); then
                    local all_configs=()
                    for category in "${categories[@]}"; do
                        local category_configs=($(get_configs_by_category "$category"))
                        all_configs+=("${category_configs[@]}")
                    done
                    
                    if [[ ${#all_configs[@]} -gt 0 ]]; then
                        install_selected_configs "${all_configs[@]}"
                        post_install_tasks "${all_configs[@]}"
                        echo -e "\n${GREEN}✅ Configuraciones de categoría instaladas${NC}"
                    fi
                fi
                wait_for_keypress
                ;;
            4)  # Ver estado de configuraciones
                list_available_configs
                wait_for_keypress
                ;;
            0)  # Volver
                break
                ;;
            *)
                print_error "Opción inválida"
                sleep 1
                ;;
        esac
    done
}

handle_backup_management() {
    while true; do
        show_banner
        show_backup_menu
        
        echo -n "Selecciona una opción [0-5]: "
        read -r choice
        
        case $choice in
            1)  # Ver respaldos
                list_backups
                wait_for_keypress
                ;;
            2)  # Restaurar todos
                if confirm_action "Esto restaurará TODOS los respaldos del directorio actual"; then
                    restore_backups
                fi
                wait_for_keypress
                ;;
            3)  # Restaurar específico
                if list_backups; then
                    echo -n "Número de respaldo a restaurar: "
                    read -r backup_num
                    restore_specific_backup "$backup_num"
                fi
                wait_for_keypress
                ;;
            4)  # Limpiar respaldos antiguos
                echo -n "¿Días de antigüedad para limpiar? [7]: "
                read -r days
                days=${days:-7}
                if confirm_action "Se eliminarán respaldos de más de $days días"; then
                    cleanup_old_backups "$days"
                fi
                wait_for_keypress
                ;;
            5)  # Verificar integridad
                verify_backup_integrity
                wait_for_keypress
                ;;
            0)  # Volver
                break
                ;;
            *)
                print_error "Opción inválida"
                sleep 1
                ;;
        esac
    done
}

handle_advanced_config() {
    while true; do
        show_banner
        show_advanced_menu
        
        echo -n "Selecciona una opción [0-5]: "
        read -r choice
        
        case $choice in
            1)  # Variables de entorno
                setup_tool_paths
                print_success "Variables de entorno configuradas"
                wait_for_keypress
                ;;
            2)  # Ver/editar configuraciones
                echo "Funcionalidad en desarrollo"
                wait_for_keypress
                ;;
            3)  # Limpiar sistema
                if confirm_action "Esto limpiará caches y archivos temporales"; then
                    cleanup_old_backups 3
                    print_success "Limpieza completada"
                fi
                wait_for_keypress
                ;;
            4)  # Generar reporte
                show_system_info
                verify_tools_installation
                wait_for_keypress
                ;;
            5)  # Optimizar configuraciones
                echo "Funcionalidad en desarrollo"
                wait_for_keypress
                ;;
            0)  # Volver
                break
                ;;
            *)
                print_error "Opción inválida"
                sleep 1
                ;;
        esac
    done
}

# ================================
# MENÚ PRINCIPAL
# ================================
main_loop() {
    while true; do
        show_banner
        show_main_menu
        
        echo -n "Selecciona una opción [0-7]: "
        read -r choice
        
        case $choice in
            1)  # Gestionar configuraciones
                handle_config_management
                ;;
            2)  # Gestionar herramientas
                echo
                local distro=$(detect_distro)
                if tools=($(select_tools)); then
                    install_tools "$distro" "${tools[@]}"
                    setup_tool_paths
                    echo -e "\n${GREEN}✅ Herramientas instaladas exitosamente${NC}"
                fi
                wait_for_keypress
                ;;
            3)  # Instalación completa
                if confirm_action "Esto instalará TODAS las configuraciones y herramientas"; then
                    local distro=$(detect_distro)
                    
                    # Instalar todas las configuraciones
                    local all_configs=("${!CONFIGS[@]}")
                    install_selected_configs "${all_configs[@]}"
                    post_install_tasks "${all_configs[@]}"
                    
                    # Instalar todas las herramientas
                    local all_tools=("core" "modern" "terminal" "starship" "zsh" "nodejs")
                    install_tools "$distro" "${all_tools[@]}"
                    setup_tool_paths
                    
                    echo -e "\n${GREEN}🎉 ¡Instalación completa finalizada!${NC}"
                fi
                wait_for_keypress
                ;;
            4)  # Actualizar sistema
                if confirm_action "Esto actualizará el sistema y todas las herramientas"; then
                    local distro=$(detect_distro)
                    update_tools "$distro"
                    echo -e "\n${GREEN}✅ Sistema actualizado${NC}"
                fi
                wait_for_keypress
                ;;
            5)  # Gestionar respaldos
                handle_backup_management
                ;;
            6)  # Información del sistema
                show_system_info
                echo
                verify_tools_installation
                wait_for_keypress
                ;;
            7)  # Configuración avanzada
                handle_advanced_config
                ;;
            0)  # Salir
                echo -e "\n${GREEN}¡Gracias por usar Dreamcoder Setup! 🚀${NC}\n"
                log_info "Sesión finalizada por el usuario"
                exit 0
                ;;
            *)  # Opción inválida
                print_error "Opción inválida. Intenta de nuevo."
                sleep 1
                ;;
        esac
    done
}

# ================================
# FUNCIÓN PRINCIPAL
# ================================
main() {
    # Verificar prerrequisitos
    if ! check_prerequisites; then
        print_error "Faltan prerrequisitos del sistema"
        exit 1
    fi
    
    # Validar distribución
    if ! validate_distro_support; then
        exit 1
    fi
    
    # Cargar módulos
    load_modules
    
    # Ejecutar interfaz principal
    main_loop
}

# ================================
# MANEJO DE ARGUMENTOS
# ================================
if [[ $# -gt 0 ]]; then
    case "$1" in
        "--help"|"-h")
            echo "Dreamcoder Setup v$SCRIPT_VERSION - Sistema Modular"
            echo
            echo "Uso: $0 [opciones]"
            echo
            echo "Opciones:"
            echo "  -h, --help      Mostrar esta ayuda"
            echo "  --update        Actualizar sistema sin interfaz"
            echo "  --install-all   Instalar todo automáticamente"
            echo "  --info          Mostrar información del sistema"
            echo "  --configs       Instalar solo configuraciones"
            echo "  --tools         Instalar solo herramientas"
            echo "  --verify        Verificar instalación"
            echo
            exit 0
            ;;
        "--update")
            load_modules
            update_tools "$(detect_distro)"
            exit 0
            ;;
        "--install-all")
            load_modules
            local distro=$(detect_distro)
            local all_configs=("${!CONFIGS[@]}")
            local all_tools=("core" "modern" "terminal" "starship" "zsh" "nodejs")
            install_selected_configs "${all_configs[@]}"
            install_tools "$distro" "${all_tools[@]}"
            exit 0
            ;;
        "--info")
            load_modules
            show_system_info
            exit 0
            ;;
        "--verify")
            load_modules
            verify_tools_installation
            exit 0
            ;;
        *)
            echo "Opción desconocida: $1"
            echo "Usa --help para ver las opciones disponibles"
            exit 1
            ;;
    esac
fi

# Ejecutar función principal
main