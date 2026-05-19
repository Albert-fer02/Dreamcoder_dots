#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
MODULES=(kitty ghostty fastfetch)

ok() { printf '✓ %s\n' "$*"; }
fail() { printf '✗ %s\n' "$*" >&2; return 1; }
check_path() {
    local path="$1"
    [[ -e "${path}" ]] || { fail "${path} is missing"; return; }
    ok "${path}"
}
command -v starship >/dev/null || fail 'Missing dependency: starship'
for app in "${MODULES[@]}"; do check_path "${CONFIG_HOME}/${app}"; done
check_path "${CONFIG_HOME}/starship.toml"
check_path "${DATA_HOME}/warp-terminal/themes"
STARSHIP_CONFIG="${DREAMCODER_DOTS_DIR}/Shell/.config/starship.toml" starship explain >/dev/null
STARSHIP_CONFIG="${DREAMCODER_DOTS_DIR}/Shell/.config/starship-light.toml" starship explain >/dev/null
"${DREAMCODER_DOTS_DIR}/scripts/verify-theme-health.py" >/dev/null
[[ -x "${DREAMCODER_DOTS_DIR}/scripts/doctor.sh" ]] || fail 'Missing doctor.sh'
[[ -x "${DREAMCODER_DOTS_DIR}/scripts/repair.sh" ]] || fail 'Missing repair.sh'
ok 'Starship configs and theme health valid'
