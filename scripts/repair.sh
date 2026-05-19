#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"

"${DREAMCODER_DOTS_DIR}/scripts/apply-ml4w-hooks.sh"
if command -v stow >/dev/null; then
    stow -t "${HOME}" Shell Kitty Ghostty Fastfetch Warp Systemd
fi
if command -v systemctl >/dev/null; then
    systemctl --user daemon-reload || true
    systemctl --user enable --now dreamcoder-theme-auto.timer || true
fi
"${DREAMCODER_DOTS_DIR}/scripts/theme-auto.sh"
"${DREAMCODER_DOTS_DIR}/scripts/verify.sh"
printf '✓ Dreamcoder repair complete\n'
