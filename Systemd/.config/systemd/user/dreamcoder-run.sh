#!/usr/bin/env bash
# Resolve and execute theme-auto.sh from available dotfiles locations
set -euo pipefail

# Build fallback locations dynamically from XDG standards + env override
DOTFILES_FALLBACKS=(
    "${DREAMCODER_DOTS_DIR:-}"
    "${XDG_CONFIG_HOME:-${HOME}/.config}/dreamcoder-dots"
    "${HOME}/.local/share/dreamcoder-dots"
    "${HOME}/.dotfiles"
)

# Try each fallback location
for DOTFILES_DIR in "${DOTFILES_FALLBACKS[@]}"; do
    if [[ -n "${DOTFILES_DIR}" && -f "${DOTFILES_DIR}/scripts/theme-auto.sh" ]]; then
        exec "${DOTFILES_DIR}/scripts/theme-auto.sh" "$@"
    fi
done

printf 'Error: Could not find dreamcoder-dots/scripts/theme-auto.sh in any location\n' >&2
exit 1