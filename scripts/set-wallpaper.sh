#!/bin/bash
# Script para cambiar wallpaper Y actualizar colores de terminal
# Uso: ./set-wallpaper.sh [wallpaper.jpg]

WALLPAPER="${1:-}"

if [ -z "$WALLPAPER" ]; then
    echo "❌ Usage: $0 <wallpaper.jpg>"
    exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
    echo "❌ Wallpaper no encontrado: $WALLPAPER"
    exit 1
fi

# Obtener directorio del wallpaper
WALLPAPER_DIR="$(dirname "$WALLPAPER")"
WALLPAPER_NAME="$(basename "$WALLPAPER")"

# Cambiar wallpaper en Hyprland
swww img "$WALLPAPER" --transition-type wipe --transition-duration 2 2>/dev/null || \
    hyprpaper &>/dev/null &

echo "🎨 Wallpaper: $WALLPAPER_NAME"

# Generar colores con matugen
matugen image "$WALLPAPER" -m dark 2>/dev/null

# Recargar Kitty
pkill -SIGUSR1 kitty 2>/dev/null

# Recargar Ghostty si está corriendo
pkill -SIGUSR1 ghostty 2>/dev/null

echo "✅ Colores actualizados para Kitty y Ghostty"
