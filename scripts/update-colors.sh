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

echo "🎨 Wallpaper cambiado: ${WALLPAPER}"
echo "🟤 Reaplicando identidad fija Dreamcoder"

matugen image "${WALLPAPER}" -m dark 2>/dev/null
WALLPAPER="${WALLPAPER}" "${DOTFILES_DIR}/scripts/sync-dreamcoder-theme.py"

pkill -SIGUSR1 kitty 2>/dev/null && echo "✅ Kitty recargado" || echo "⚠️ Kitty no estaba corriendo"
echo "ℹ️ Ghostty escribió el theme; recarga con Ctrl+Shift+R"
command -v hyprctl >/dev/null && hyprctl notify 1 3500 "rgb(fbb974)" "Ghostty: Ctrl+Shift+R para recargar theme" >/dev/null 2>&1 || true

echo "✅ Identidad Dreamcoder actualizada"
