#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
WALLPAPER="${1:-}"

[[ -f "${WALLPAPER}" ]] || {
    printf 'Usage: %s <wallpaper>\n' "$0" >&2
    exit 1
}

if command -v swww >/dev/null; then
    swww img "${WALLPAPER}" --transition-type wipe --transition-duration 2
elif command -v hyprctl >/dev/null; then
    hyprctl hyprpaper wallpaper ",${WALLPAPER}" >/dev/null || true
else
    printf '✗ Missing wallpaper backend: swww or hyprctl\n' >&2
    exit 1
fi

"${DREAMCODER_DOTS_DIR}/scripts/auto-colors.sh" "${WALLPAPER}"
printf '✓ Wallpaper and Dreamcoder colors updated\n'
