#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
LIGHT_START="${DREAMCODER_LIGHT_START:-7}"
DUSK_START="${DREAMCODER_DUSK_START:-16}"
DARK_START="${DREAMCODER_DARK_START:-18}"
HOUR="$(date +%H)"
MODE="dark"
if (( 10#${HOUR} >= LIGHT_START && 10#${HOUR} < DUSK_START )); then MODE="light"; fi
if (( 10#${HOUR} >= DUSK_START && 10#${HOUR} < DARK_START )); then MODE="dusk"; fi
exec "${DREAMCODER_DOTS_DIR}/scripts/apply-theme-mode.sh" "${MODE}" "$@"
