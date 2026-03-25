#!/bin/bash
# Script para actualizar colores de terminal según wallpaper
# Uso: ./update-colors.sh [wallpaper.jpg]

WALLPAPER="${1:-$(ls ~/.ml4w-hyprland/*/wallpapers/*.jpg 2>/dev/null | shuf | head -1)}"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "❌ Wallpaper no encontrado"
    exit 1
fi

echo "🎨 Generando colores desde: $WALLPAPER"

# Generar colores para Kitty
matugen image "$WALLPAPER" -m dark 2>/dev/null

# Recargar Kitty
pkill -SIGUSR1 kitty 2>/dev/null && echo "✅ Kitty recargado" || echo "⚠️ Kitty no estaba corriendo"

echo "✅ Colores actualizados"
