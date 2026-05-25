#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
WALLPAPER="${1:-${WALLPAPER:-}}"
ML4W_WALLPAPER="${HOME}/.cache/ml4w/hyprland-dotfiles/current_wallpaper"

if [[ -z "${WALLPAPER}" && -f "${ML4W_WALLPAPER}" ]]; then
    WALLPAPER="$(cat "${ML4W_WALLPAPER}")"
fi

if [[ -z "${WALLPAPER}" ]] && command -v swww >/dev/null; then
    WALLPAPER="$(swww query 2>/dev/null | sed 's/.*image: //' || true)"
fi
WALLPAPER="$("${DREAMCODER_DOTS_DIR}/scripts/normalize-wallpaper-path.sh" "${WALLPAPER}")"

if [[ -z "${WALLPAPER}" || ! -f "${WALLPAPER}" ]]; then
    printf '✗ Wallpaper not found: %s\n' "${WALLPAPER:-none}" >&2
    exit 1
fi

"${DREAMCODER_DOTS_DIR}/scripts/theme-auto.sh" "${WALLPAPER}"
printf '✓ Dreamcoder wallpaper colors refreshed\n'
