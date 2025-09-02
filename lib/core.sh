#!/bin/bash

# 🔧 Dreamcoder Setup - Funciones Core
# Funciones básicas y utilidades compartidas

# Verificar si ya fue cargado
if [[ "${DREAMCODER_CORE_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_CORE_LOADED=true

# ================================
# CONFIGURACIÓN GLOBAL
# ================================
SCRIPT_VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
BACKUP_DIR="$HOME/.dreamcoder-backups/$(date +%Y%m%d_%H%M%S)"
LIB_DIR="$SCRIPT_DIR/lib"
CONFIG_DIR="$SCRIPT_DIR/config"

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # Sin Color

# ================================
# FUNCIONES DE SALIDA
# ================================
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_step() { echo -e "\n${CYAN}🔧 $1${NC}"; echo -e "${CYAN}$(printf '=%.0s' {1..50})${NC}"; }
print_substep() { echo -e "\n${PURPLE}▶ $1${NC}"; }

# ================================
# FUNCIONES UTILIDAD
# ================================
command_exists() { 
    command -v "$1" >/dev/null 2>&1 
}

# Cargar un módulo de forma segura
load_module() {
    local module_name="$1"
    local module_path="$LIB_DIR/$module_name.sh"
    
    if [[ -f "$module_path" ]]; then
        source "$module_path"
        print_info "Módulo cargado: $module_name"
    else
        print_error "No se pudo cargar el módulo: $module_name"
        return 1
    fi
}

# Verificar prerrequisitos del sistema
check_prerequisites() {
    print_step "VERIFICANDO PRERREQUISITOS"
    
    # Verificar privilegios sudo
    if ! sudo -n true 2>/dev/null; then
        print_info "Se necesitan privilegios sudo"
        sudo echo "Privilegios confirmados" >/dev/null
    fi
    
    # Verificar comandos básicos
    local required_commands=("curl" "git")
    local missing_commands=()
    
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        print_warning "Comandos faltantes: ${missing_commands[*]}"
        return 1
    fi
    
    print_success "Prerrequisitos verificados"
    return 0
}

# Función de limpieza al salir
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        print_error "Script terminado con errores (código: $exit_code)"
        print_info "Consulta los logs para más detalles"
    fi
}

# Configurar trap para limpieza
trap cleanup EXIT

# ================================
# LOGGING
# ================================
LOG_FILE="$HOME/.dreamcoder-setup.log"

log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

log_info() { log_message "INFO" "$1"; }
log_warn() { log_message "WARN" "$1"; }
log_error() { log_message "ERROR" "$1"; }
log_debug() { log_message "DEBUG" "$1"; }

# ================================
# VALIDACIONES
# ================================
validate_path() {
    local path="$1"
    if [[ ! -e "$path" ]]; then
        log_error "Ruta no encontrada: $path"
        return 1
    fi
    return 0
}

validate_url() {
    local url="$1"
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        return 0
    else
        log_error "URL no accesible: $url"
        return 1
    fi
}

# ================================
# INICIALIZACIÓN
# ================================
init_core() {
    print_info "Inicializando Dreamcoder Setup v$SCRIPT_VERSION"
    
    # Crear directorios necesarios
    mkdir -p "$BACKUP_DIR"
    
    # Inicializar log
    echo "=== Dreamcoder Setup Session Started ===" >> "$LOG_FILE"
    log_info "Directorio de trabajo: $SCRIPT_DIR"
    log_info "Directorio de respaldos: $BACKUP_DIR"
    
    return 0
}