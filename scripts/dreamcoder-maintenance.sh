#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-}"; shift || true
ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
LIB_FILE="${DREAMCODER_DOTS_DIR}/scripts/dreamcoder-lib.sh"
# shellcheck source=/dev/null
[[ -f "${LIB_FILE}" ]] && source "${LIB_FILE}"
fail() { printf '✗ %s\n' "${*}" >&2; exit 1; }
backup_path() { local path="${1}" legacy_dir="${CONFIG_HOME}/dreamcoder/install-conflicts/${BACKUP_ID}"; [[ -e "${path}" && ! -L "${path}" ]] || return 0; mkdir -p "${legacy_dir}"; mv "${path}" "${legacy_dir}/"; printf '→ Moved stow conflict %s to %s\n' "${path}" "${legacy_dir}"; }
command -v python3 >/dev/null || fail 'Missing dependency: python3'
BACKUP_JSON="$(dreamcoder_backup "${MODE}-preflight")"; BACKUP_ID="$(printf '%s' "${BACKUP_JSON}" | dreamcoder_json_get backup_id)"
printf '→ Backup manifest: %s\n  rollback: ./scripts/dreamcoder backup restore %s --json\n' "${BACKUP_ID}" "${BACKUP_ID}"
[[ "${MODE}" == install ]] && command -v stow >/dev/null || [[ "${MODE}" == repair ]] || fail 'Usage: dreamcoder-maintenance.sh {install|repair}'
cd "${DREAMCODER_DOTS_DIR}"
if [[ "${MODE}" == install ]]; then for target in "${DREAMCODER_TARGETS[@]}"; do backup_path "${target}"; done; stow -t "${HOME}" "${DREAMCODER_MODULES[@]}"; fi
dreamcoder_apply_hooks
if [[ "${MODE}" == repair ]]; then command -v stow >/dev/null && stow -t "${HOME}" "${DREAMCODER_MODULES[@]}"; fi
dreamcoder_enable_timer
"${DREAMCODER_DOTS_DIR}/scripts/theme-auto.sh"
[[ "${MODE}" == repair ]] && "${DREAMCODER_DOTS_DIR}/scripts/verify.sh"
printf '✓ Dreamcoder %s complete\n' "${MODE}"
