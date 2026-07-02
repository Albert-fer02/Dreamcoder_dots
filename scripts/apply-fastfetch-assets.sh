#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"

SOURCE_DIR="${DREAMCODER_DOTS_DIR}/DreamcoderFastfetch/.config/dreamcoder"
TARGET_DIR="${CONFIG_HOME}/dreamcoder"
BACKUP_DIR="${CONFIG_HOME}/dreamcoder-backup-$(date +%Y%m%d-%H%M%S)"

[[ -f "${SOURCE_DIR}/Dreamcoder01.jpg" ]] || {
    printf '✗ Missing Fastfetch logo: %s\n' "${SOURCE_DIR}/Dreamcoder01.jpg" >&2
    exit 1
}

mkdir -p "${CONFIG_HOME}"
if [[ -e "${TARGET_DIR}" && ! -L "${TARGET_DIR}" ]]; then
    mkdir -p "${BACKUP_DIR}"
    mv "${TARGET_DIR}" "${BACKUP_DIR}/"
fi

ln -sfn "${SOURCE_DIR}" "${TARGET_DIR}"
printf '✓ Fastfetch assets linked: %s\n' "${TARGET_DIR}"
