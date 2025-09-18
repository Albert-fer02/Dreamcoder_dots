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

    # Verificar privilegios sudo de forma segura
    if ! validate_sudo_access; then
        return 1
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

# Función segura para validar acceso sudo
validate_sudo_access() {
    # Verificar si ya tenemos privilegios de root
    if [[ $EUID -eq 0 ]]; then
        print_info "Ejecutando como root - sin necesidad de sudo"
        return 0
    fi

    # Verificar si sudo está disponible
    if ! command_exists sudo; then
        print_error "sudo no está instalado en el sistema"
        return 1
    fi

    # Verificar si podemos usar sudo sin contraseña
    if sudo -n true 2>/dev/null; then
        print_info "Privilegios sudo disponibles"
        return 0
    fi

    # Solicitar validación manual de sudo
    print_warning "Se requieren privilegios de administrador"
    print_info "Por favor, ejecuta: sudo -v"
    print_info "O proporciona tu contraseña cuando se solicite"

    # Intentar validar sudo con timeout
    if timeout 30 sudo -v 2>/dev/null; then
        print_success "Privilegios sudo confirmados"
        return 0
    else
        print_error "No se pudieron obtener privilegios sudo"
        print_info "Asegúrate de tener permisos de administrador"
        return 1
    fi
}

# Función de limpieza al salir
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        print_error "Script terminado con errores (código: $exit_code)"
        print_info "Consulta los logs para más detalles"
    fi
}

# Función para manejo de errores consistente
handle_error() {
    local error_message="$1"
    local error_code="${2:-1}"
    local log_level="${3:-error}"

    # Log del error
    case $log_level in
        "debug") log_debug "$error_message" ;;
        "info") log_info "$error_message" ;;
        "warn") log_warn "$error_message" ;;
        "error") log_error "$error_message" ;;
    esac

    # Mostrar mensaje al usuario
    print_error "$error_message"

    # Salir si se especifica código de error
    if [[ $error_code -ne 0 ]]; then
        exit $error_code
    fi
}

# Función para ejecutar comandos con manejo de errores
execute_with_error_handling() {
    local command="$1"
    local error_message="${2:-Comando falló}"
    local continue_on_error="${3:-false}"

    if ! eval "$command"; then
        if [[ "$continue_on_error" == "true" ]]; then
            log_warn "$error_message (continuando)"
            print_warning "$error_message"
            return 1
        else
            handle_error "$error_message"
        fi
    fi

    return 0
}

# Función para validar dependencias
check_dependencies() {
    local dependencies=("$@")
    local missing_deps=()

    for dep in "${dependencies[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        handle_error "Dependencias faltantes: ${missing_deps[*]}"
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
    # Sanitizar URL básica
    if [[ -z "$url" || "$url" =~ ^[[:space:]]*$ ]]; then
        log_error "URL vacía o inválida"
        return 1
    fi

    # Verificar formato básico de URL
    if [[ ! "$url" =~ ^https?:// ]]; then
        log_error "URL debe comenzar con http:// o https://"
        return 1
    fi

    if curl -s --head --max-time 10 "$url" | head -n 1 | grep -q "200 OK"; then
        return 0
    else
        log_error "URL no accesible: $url"
        return 1
    fi
}

# Función para sanitizar rutas de archivo
sanitize_path() {
    local path="$1"

    # Verificar que la entrada no esté vacía
    if [[ -z "$path" ]]; then
        log_error "Ruta vacía proporcionada"
        return 1
    fi

    # Remover caracteres peligrosos y secuencias peligrosas
    if [[ "$path" =~ \.\. ]]; then
        log_error "Ruta contiene secuencia peligrosa (..): $path"
        return 1
    fi

    # Remover otros caracteres peligrosos
    if [[ "$path" =~ [\;\|\&\$\`\<\>\(\)\[\]\{\}\*\?] ]]; then
        log_error "Ruta contiene caracteres peligrosos: $path"
        return 1
    fi

    # Remover secuencias de escape y caracteres de control
    path=$(printf '%q' "$path" 2>/dev/null || echo "$path")

    # Normalizar separadores de directorio
    path="${path//\/\//\/}"

    echo "$path"
    return 0
}

# Función para validar entrada de usuario
validate_user_input() {
    local input="$1"
    local max_length="${2:-100}"

    # Verificar longitud
    if [[ ${#input} -gt $max_length ]]; then
        log_error "Entrada demasiado larga (máx $max_length caracteres)"
        return 1
    fi

    # Verificar caracteres peligrosos
    if [[ "$input" =~ [\;\|\&\$\`\<\>\(\)\[\]\{\}] ]]; then
        log_error "Entrada contiene caracteres peligrosos"
        return 1
    fi

    return 0
}

# Función para validar números
validate_number() {
    local number="$1"
    local min_val="${2:-0}"
    local max_val="${3:-999999}"

    if ! [[ "$number" =~ ^[0-9]+$ ]]; then
        log_error "Valor no es un número válido: $number"
        return 1
    fi

    if [[ $number -lt $min_val || $number -gt $max_val ]]; then
        log_error "Número fuera de rango ($min_val-$max_val): $number"
        return 1
    fi

    return 0
}

# ================================
# CACHE Y OPTIMIZACIONES
# ================================
declare -g CACHED_DISTRO=""
declare -g CACHED_DISTRO_INFO=""

# Función para obtener distribución con cache
get_cached_distro() {
    if [[ -z "$CACHED_DISTRO" ]]; then
        CACHED_DISTRO=$(detect_distro)
        log_debug "Distribución detectada y cacheada: $CACHED_DISTRO"
    fi
    echo "$CACHED_DISTRO"
}

# Función para obtener información de distribución con cache
get_cached_distro_info() {
    if [[ -z "$CACHED_DISTRO_INFO" ]]; then
        CACHED_DISTRO_INFO=$(get_distro_info)
        log_debug "Información de distribución cacheada"
    fi
    echo "$CACHED_DISTRO_INFO"
}

# Función para ejecutar comandos con cache
execute_with_cache() {
    local cache_key="$1"
    local command="$2"
    local cache_file="$SCRIPT_DIR/.cache/$cache_key"

    # Crear directorio de cache si no existe
    mkdir -p "$SCRIPT_DIR/.cache"

    # Verificar si el cache es válido (menos de 1 hora)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || date +%s))) -lt 3600 ]]; then
        cat "$cache_file"
        return 0
    fi

    # Ejecutar comando y cachear resultado
    if eval "$command" > "$cache_file" 2>/dev/null; then
        cat "$cache_file"
        return 0
    else
        log_error "Error ejecutando comando cacheado: $command"
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
    mkdir -p "$SCRIPT_DIR/.cache"

    # Inicializar log
    echo "=== Dreamcoder Setup Session Started ===" >> "$LOG_FILE"
    log_info "Directorio de trabajo: $SCRIPT_DIR"
    log_info "Directorio de respaldos: $BACKUP_DIR"

    # Limpiar cache antiguo
    find "$SCRIPT_DIR/.cache" -name "*.cache" -type f -mtime +7 -delete 2>/dev/null || true

    return 0
}