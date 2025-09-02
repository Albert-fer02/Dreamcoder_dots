#!/bin/bash

# 🔒 Dreamcoder Setup - Sistema de Respaldos
# Gestión de respaldos y restauración de configuraciones

# Verificar si ya fue cargado
if [[ "${DREAMCODER_BACKUP_LOADED:-}" == "true" ]]; then
    return 0
fi
DREAMCODER_BACKUP_LOADED=true

# ================================
# FUNCIONES DE RESPALDO
# ================================
create_backup() {
    local file="$1"
    local description="${2:-$file}"
    
    if [[ ! -f "$file" && ! -d "$file" ]]; then
        log_debug "No se puede respaldar (no existe): $file"
        return 1
    fi
    
    # Crear directorio de respaldo si no existe
    mkdir -p "$BACKUP_DIR"
    
    local backup_name=$(basename "$file")
    local backup_path="$BACKUP_DIR/$backup_name"
    
    # Si ya existe un respaldo con ese nombre, agregar número
    local counter=1
    while [[ -e "$backup_path" ]]; do
        backup_path="$BACKUP_DIR/${backup_name}.${counter}"
        ((counter++))
    done
    
    # Crear respaldo
    if cp -r "$file" "$backup_path" 2>/dev/null; then
        echo "$file|$backup_path|$description|$(date '+%Y-%m-%d %H:%M:%S')" >> "$BACKUP_DIR/backup_log.txt"
        print_info "Respaldo creado: $description"
        log_info "Respaldo creado: $file -> $backup_path"
        return 0
    else
        print_error "Error creando respaldo de: $file"
        log_error "Error creando respaldo: $file"
        return 1
    fi
}

list_backups() {
    local backup_log="$BACKUP_DIR/backup_log.txt"
    
    if [[ ! -f "$backup_log" ]]; then
        print_warning "No se encontraron respaldos"
        return 1
    fi
    
    print_step "RESPALDOS DISPONIBLES"
    echo -e "${CYAN}┌─ LISTA DE RESPALDOS ─────────────────────────────────────────┐${NC}"
    
    local count=0
    while IFS='|' read -r original backup desc timestamp; do
        ((count++))
        echo -e "${CYAN}│${NC} $count. ${BOLD}$desc${NC}"
        echo -e "${CYAN}│${NC}    Original: $original"
        echo -e "${CYAN}│${NC}    Respaldo: $backup"
        echo -e "${CYAN}│${NC}    Fecha: $timestamp"
        echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    done < "$backup_log"
    
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    
    if [[ $count -eq 0 ]]; then
        print_warning "No hay respaldos para mostrar"
        return 1
    fi
    
    return 0
}

restore_backups() {
    local backup_log="$BACKUP_DIR/backup_log.txt"
    
    if [[ ! -f "$backup_log" ]]; then
        print_warning "No se encontraron respaldos para restaurar"
        return 1
    fi
    
    print_step "RESTAURANDO RESPALDOS"
    
    local restored=0
    local failed=0
    
    while IFS='|' read -r original backup desc timestamp; do
        if [[ -f "$backup" || -d "$backup" ]]; then
            if cp -r "$backup" "$original" 2>/dev/null; then
                print_success "Restaurado: $desc"
                log_info "Restaurado exitosamente: $original"
                ((restored++))
            else
                print_error "Error restaurando: $desc"
                log_error "Error restaurando: $original"
                ((failed++))
            fi
        else
            print_warning "Respaldo no encontrado: $backup"
            log_warn "Archivo de respaldo no encontrado: $backup"
            ((failed++))
        fi
    done < "$backup_log"
    
    print_step "RESULTADO DE RESTAURACIÓN"
    echo -e "✅ Archivos restaurados: ${BOLD}$restored${NC}"
    echo -e "❌ Errores: ${BOLD}$failed${NC}"
    
    if [[ $restored -gt 0 ]]; then
        print_success "Restauración completada"
        return 0
    else
        print_error "No se pudo restaurar ningún archivo"
        return 1
    fi
}

restore_specific_backup() {
    local backup_number="$1"
    local backup_log="$BACKUP_DIR/backup_log.txt"
    
    if [[ ! -f "$backup_log" ]]; then
        print_error "No se encontraron respaldos"
        return 1
    fi
    
    local line=$(sed -n "${backup_number}p" "$backup_log")
    if [[ -z "$line" ]]; then
        print_error "Respaldo número $backup_number no encontrado"
        return 1
    fi
    
    IFS='|' read -r original backup desc timestamp <<< "$line"
    
    if [[ -f "$backup" || -d "$backup" ]]; then
        if cp -r "$backup" "$original" 2>/dev/null; then
            print_success "Restaurado: $desc"
            log_info "Restaurado específico: $original"
            return 0
        else
            print_error "Error restaurando: $desc"
            log_error "Error restaurando específico: $original"
            return 1
        fi
    else
        print_error "Archivo de respaldo no encontrado: $backup"
        return 1
    fi
}

# ================================
# GESTIÓN DE DIRECTORIOS DE RESPALDO
# ================================
cleanup_old_backups() {
    local days="${1:-7}"  # Por defecto, mantener respaldos de 7 días
    local backup_base_dir="$HOME/.dreamcoder-backups"
    
    if [[ ! -d "$backup_base_dir" ]]; then
        return 0
    fi
    
    print_substep "Limpiando respaldos antiguos (más de $days días)"
    
    local cleaned=0
    while IFS= read -r -d '' backup_dir; do
        if [[ -d "$backup_dir" ]]; then
            # Obtener fecha del directorio (formato YYYYMMDD_HHMMSS)
            local dir_name=$(basename "$backup_dir")
            local dir_date=$(echo "$dir_name" | cut -d'_' -f1)
            
            # Convertir a timestamp
            if date -d "$dir_date" >/dev/null 2>&1; then
                local dir_timestamp=$(date -d "$dir_date" +%s)
                local now_timestamp=$(date +%s)
                local age_days=$(( (now_timestamp - dir_timestamp) / 86400 ))
                
                if [[ $age_days -gt $days ]]; then
                    rm -rf "$backup_dir"
                    print_info "Respaldo antiguo eliminado: $dir_name"
                    ((cleaned++))
                fi
            fi
        fi
    done < <(find "$backup_base_dir" -maxdepth 1 -type d -print0)
    
    if [[ $cleaned -gt 0 ]]; then
        print_success "Respaldos antiguos limpiados: $cleaned"
    fi
}

get_backup_size() {
    if [[ -d "$BACKUP_DIR" ]]; then
        du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1
    else
        echo "0B"
    fi
}

# ================================
# VALIDACIÓN DE RESPALDOS
# ================================
verify_backup_integrity() {
    local backup_log="$BACKUP_DIR/backup_log.txt"
    
    if [[ ! -f "$backup_log" ]]; then
        return 0
    fi
    
    print_substep "Verificando integridad de respaldos"
    
    local total=0
    local valid=0
    local invalid=0
    
    while IFS='|' read -r original backup desc timestamp; do
        ((total++))
        if [[ -f "$backup" || -d "$backup" ]]; then
            ((valid++))
        else
            print_warning "Respaldo dañado: $desc"
            ((invalid++))
        fi
    done < "$backup_log"
    
    if [[ $invalid -eq 0 ]]; then
        print_success "Todos los respaldos están íntegros ($valid/$total)"
    else
        print_warning "Respaldos dañados encontrados: $invalid/$total"
    fi
    
    return $invalid
}