#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
ML4W_HOME="${ML4W_HOME:-}"
WALLPAPER="${1:-}"

if [[ -z "${WALLPAPER}" ]]; then
    [[ -n "${ML4W_HOME}" ]] && WALLPAPER="$(find "${ML4W_HOME}" -path '*/wallpapers/*.jpg' -type f 2>/dev/null | sort | head -1 || true)"
fi

"${DREAMCODER_DOTS_DIR}/scripts/auto-colors.sh" "${WALLPAPER}"
