#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
MODULES=(kitty ghostty fastfetch)

ok() { printf '✓ %s\n' "$*"; }
fail() { printf '✗ %s\n' "$*" >&2; return 1; }
check_link() {
    local path="$1"
    [[ -L "${path}" ]] || { fail "${path} is not a symlink"; return; }
    [[ "$(readlink -f "${path}")" == "${DREAMCODER_DOTS_DIR}"* ]] || fail "${path} points outside repo"
    ok "${path}"
}

command -v starship >/dev/null || fail 'Missing dependency: starship'
for app in "${MODULES[@]}"; do check_link "${CONFIG_HOME}/${app}"; done
check_link "${CONFIG_HOME}/starship.toml"
check_link "${DATA_HOME}/warp-terminal/themes"
STARSHIP_CONFIG="${DREAMCODER_DOTS_DIR}/Shell/.config/starship.toml" starship explain >/dev/null
STARSHIP_CONFIG="${DREAMCODER_DOTS_DIR}/Shell/.config/starship-light.toml" starship explain >/dev/null
ok 'Starship configs valid'
