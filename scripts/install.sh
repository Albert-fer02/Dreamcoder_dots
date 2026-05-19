#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
BACKUP_DIR="${CONFIG_HOME}/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"
MODULES=(Shell Kitty Ghostty Fastfetch Warp Systemd)
TARGETS=("${CONFIG_HOME}/kitty" "${CONFIG_HOME}/ghostty" "${CONFIG_HOME}/fastfetch" "${DATA_HOME}/warp-terminal/themes" "${CONFIG_HOME}/starship.toml")

fail() { printf '✗ %s\n' "$*" >&2; exit 1; }
backup_path() {
    local path="$1"
    [[ -e "${path}" && ! -L "${path}" ]] || return 0
    mkdir -p "${BACKUP_DIR}"
    mv "${path}" "${BACKUP_DIR}/"
    printf '→ Backed up %s\n' "${path}"
}

command -v stow >/dev/null || fail 'Missing dependency: stow'
command -v git >/dev/null || fail 'Missing dependency: git'
cd "${DREAMCODER_DOTS_DIR}"
for target in "${TARGETS[@]}"; do backup_path "${target}"; done
stow -t "${HOME}" "${MODULES[@]}"
printf '✓ Dreamcoder dotfiles installed\n'
