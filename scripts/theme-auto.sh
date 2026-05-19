#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
LIGHT_START="${DREAMCODER_LIGHT_START:-7}"
DARK_START="${DREAMCODER_DARK_START:-18}"
HOUR="$(date +%H)"
WALLPAPER="${1:-${DREAMCODER_WALLPAPER:-${WALLPAPER:-}}}"

if (( 10#${HOUR} >= LIGHT_START && 10#${HOUR} < DARK_START )); then
    MODE="light"
else
    MODE="dark"
fi

if [[ -n "${WALLPAPER}" && -f "${WALLPAPER}" ]] && command -v matugen >/dev/null; then
    matugen image "${WALLPAPER}" -m "${MODE}" >/dev/null 2>&1 || true
fi

DREAMCODER_THEME_MODE="${MODE}" \
DREAMCODER_WALLPAPER="${WALLPAPER}" \
    "${DREAMCODER_DOTS_DIR}/scripts/sync-dreamcoder-theme.py"
command -v pkill >/dev/null && pkill -SIGUSR1 kitty 2>/dev/null || true
printf '✓ Dreamcoder %s mode applied\n' "${MODE}"
