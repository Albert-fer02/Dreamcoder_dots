#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
WALLPAPER="${1:-${WALLPAPER:-}}"

if [[ -z "${WALLPAPER}" ]] && command -v swww >/dev/null; then
    WALLPAPER="$(swww query 2>/dev/null | sed 's/.*image: //' || true)"
fi

if [[ -z "${WALLPAPER}" || ! -f "${WALLPAPER}" ]]; then
    printf '✗ Wallpaper not found: %s\n' "${WALLPAPER:-none}" >&2
    exit 1
fi

command -v matugen >/dev/null && matugen image "${WALLPAPER}" -m dark >/dev/null 2>&1 || true
WALLPAPER="${WALLPAPER}" "${DREAMCODER_DOTS_DIR}/scripts/sync-dreamcoder-theme.py"
pkill -SIGUSR1 kitty 2>/dev/null || true
printf '✓ Dreamcoder identity reapplied\n'
