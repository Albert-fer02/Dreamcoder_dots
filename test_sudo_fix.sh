#!/bin/bash

# Script de prueba para verificar la corrección del problema de sudo
# Dreamcoder Setup - Sudo Fix Test

echo "🧪 Probando corrección del problema de sudo..."
echo "=============================================="

# Cargar funciones necesarias
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

if [[ -f "$LIB_DIR/core.sh" ]]; then
    source "$LIB_DIR/core.sh"
    echo "✅ Funciones del core cargadas correctamente"
else
    echo "❌ Error: No se pudo cargar $LIB_DIR/core.sh"
    exit 1
fi

echo ""
echo "🔍 Ejecutando diagnóstico de sudo..."
echo "===================================="

# Ejecutar diagnóstico
if diagnose_sudo_issues; then
    echo ""
    echo "✅ Diagnóstico completado exitosamente"
    echo ""
    echo "💡 Si aún tienes problemas con sudo:"
    echo "   1. Ejecuta: ./dreamcoder-setup.sh --diagnose-sudo"
    echo "   2. Verifica que tu usuario esté en el grupo sudo"
    echo "   3. Asegúrate de que /etc/sudoers esté configurado correctamente"
    echo "   4. Intenta en una terminal sin entorno gráfico si es necesario"
else
    echo ""
    echo "❌ Se encontraron problemas en el diagnóstico"
    echo "Revisa la salida anterior para más detalles"
fi

echo ""
echo "🎯 Test completado"