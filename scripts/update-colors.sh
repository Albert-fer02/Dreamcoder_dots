#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER="${1:-}"

if [[ -z "${WALLPAPER}" ]]; then
    WALLPAPER="$(find "${HOME}/.ml4w-hyprland" -path '*/wallpapers/*.jpg' -type f 2>/dev/null | shuf | head -1)"
fi

if [[ -z "${WALLPAPER}" || ! -f "${WALLPAPER}" ]]; then
    echo "❌ Wallpaper no encontrado"
    exit 1
fi

echo "🎨 Generando colores desde: ${WALLPAPER}"

matugen image "${WALLPAPER}" -m dark 2>/dev/null
WALLPAPER="${WALLPAPER}" "${DOTFILES_DIR}/scripts/sync-dreamcoder-theme.py"

pkill -SIGUSR1 kitty 2>/dev/null && echo "✅ Kitty recargado" || echo "⚠️ Kitty no estaba corriendo"
pkill -SIGUSR1 ghostty 2>/dev/null && echo "✅ Ghostty recargado" || echo "⚠️ Ghostty no estaba corriendo"

echo "✅ Colores actualizados"
