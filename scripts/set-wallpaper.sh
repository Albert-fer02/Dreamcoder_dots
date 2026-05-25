#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
WALLPAPER="${1:-}"
WALLPAPER="$("${DREAMCODER_DOTS_DIR}/scripts/normalize-wallpaper-path.sh" "${WALLPAPER}")"

[[ -f "${WALLPAPER}" ]] || {
    printf 'Usage: %s <wallpaper>\n' "$0" >&2
    exit 1
}

if command -v swww >/dev/null && swww img "${WALLPAPER}" --transition-type wipe --transition-duration 2; then
    true
elif command -v hyprctl >/dev/null; then
    hyprctl hyprpaper preload "${WALLPAPER}" >/dev/null || true
    hyprctl hyprpaper wallpaper ",${WALLPAPER}" >/dev/null || true
else
    printf '✗ Missing wallpaper backend: swww or hyprctl\n' >&2
    exit 1
fi

"${DREAMCODER_DOTS_DIR}/scripts/wallpaper-hook.sh" "${WALLPAPER}"
printf '✓ Wallpaper and Dreamcoder colors updated\n'
