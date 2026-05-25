#!/usr/bin/env bash
set -euo pipefail

CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
HOOK_NAME="90-dreamcoder-ai-cli.sh"
ZSH_DIR="${ZSHRC_DIR:-${HOME}/.config/zshrc}"
BASH_DIR="${BASHRC_DIR:-${HOME}/.config/bashrc}"
ENV_FILE="${CACHE_HOME}/dreamcoder/cursor-cli.env"

write_hook() {
    local dir="$1"
    local file="${dir}/${HOOK_NAME}"
    mkdir -p "${dir}"
    cat >"${file}" <<'HOOK'
# Dreamcoder AI CLI contrast environment.
env_file="${XDG_CACHE_HOME:-${HOME}/.cache}/dreamcoder/cursor-cli.env"
[[ -f "${env_file}" ]] && source "${env_file}"
unset env_file
HOOK
}

mkdir -p "$(dirname "${ENV_FILE}")"
[[ -f "${ENV_FILE}" ]] || printf 'export COLORTERM="truecolor"\n' >"${ENV_FILE}"
write_hook "${ZSH_DIR}"
write_hook "${BASH_DIR}"
printf '✓ Dreamcoder AI CLI shell hooks applied\n'
