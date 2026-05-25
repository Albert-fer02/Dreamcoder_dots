#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
MODE="${1:-light}"
WALLPAPER="${2:-${DREAMCODER_WALLPAPER:-${WALLPAPER:-}}}"
ML4W_WALLPAPER="${ML4W_CACHE_DIR}/current_wallpaper"
[[ "${MODE}" == "light" || "${MODE}" == "dark" || "${MODE}" == "dusk" ]] || { printf 'Invalid mode: %s\n' "${MODE}" >&2; exit 1; }
if [[ -z "${WALLPAPER}" && -f "${ML4W_WALLPAPER}" ]]; then WALLPAPER="$(cat "${ML4W_WALLPAPER}")"; fi

CURSOR_CLI_ENV="${CACHE_HOME:-${HOME}/.cache}/dreamcoder/cursor-cli.env"
case "${MODE}" in
    light|dusk) CLI_COLORFGBG="0;15" ;;
    dark) CLI_COLORFGBG="15;0" ;;
esac
mkdir -p "$(dirname "${CURSOR_CLI_ENV}")"
printf 'export COLORFGBG="%s"\nexport DREAMCODER_THEME_MODE="%s"\nexport COLORTERM="truecolor"\nexport FORCE_COLOR="3"\nexport CLICOLOR_FORCE="1"\nunset NO_COLOR\n' "${CLI_COLORFGBG}" "${MODE}" >"${CURSOR_CLI_ENV}"

"${DREAMCODER_DOTS_DIR}/scripts/apply-system-mode.sh" "${MODE}"
if [[ -n "${WALLPAPER}" && -f "${WALLPAPER}" ]] && command -v matugen >/dev/null; then
    matugen image "${WALLPAPER}" -m "${MODE}" >/dev/null 2>&1 || true
fi
DREAMCODER_THEME_MODE="${MODE}" DREAMCODER_WALLPAPER="${WALLPAPER}" \
    "${DREAMCODER_DOTS_DIR}/scripts/sync-dreamcoder-theme.py"
command -v pkill >/dev/null && pkill -SIGUSR1 kitty 2>/dev/null || true
printf '✓ Dreamcoder %s mode applied\n' "${MODE}"
