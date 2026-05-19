#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="${1:-${WALLPAPER:-}}"
DREAMCODER_DOTS_DIR="${DREAMCODER_DOTS_DIR:-$(cd "${0%/*}/.." && pwd)}"
CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
ML4W_CACHE_DIR="${ML4W_CACHE_DIR:-${CACHE_HOME}/ml4w/hyprland-dotfiles}"
SAFE_DIR="${CACHE_HOME}/dreamcoder"
EXT="${WALLPAPER##*.}"
SAFE_WALLPAPER="${SAFE_DIR}/wallpaper.${EXT}"
ML4W_WALLPAPER="${ML4W_CACHE_DIR}/current_wallpaper"

[[ -f "${WALLPAPER}" ]] || { printf '✗ Wallpaper not found: %s\n' "${WALLPAPER:-none}" >&2; exit 1; }
mkdir -p "${SAFE_DIR}"
mkdir -p "$(dirname "${ML4W_WALLPAPER}")"
printf '%s\n' "${WALLPAPER}" >"${ML4W_WALLPAPER}"
ln -sfn "${WALLPAPER}" "${SAFE_WALLPAPER}"

if command -v hyprctl >/dev/null; then
    hyprctl monitors | awk '/^Monitor / {print $2}' | while read -r MONITOR; do
        hyprctl hyprpaper wallpaper "${MONITOR},${SAFE_WALLPAPER}" >/dev/null || true
    done
fi

"${DREAMCODER_DOTS_DIR}/scripts/theme-auto.sh" "${WALLPAPER}"
printf '✓ Dreamcoder wallpaper hook applied\n'
