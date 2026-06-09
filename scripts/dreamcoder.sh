#!/usr/bin/env bash
set -euo pipefail

# Dreamcoder CLI — quick theme switching
# Usage: dreamcoder {dark|light}

DOTS_DIR="${DREAMCODER_DOTS_DIR:-${HOME}/Documents/PROYECTOS/dreamcoder-dots}"
APPLY_SCRIPT="${DOTS_DIR}/scripts/apply-theme-mode.sh"

case "${1:-}" in
    dark|light)
        export DREAMCODER_THEME_MODE="${1}"
        if [[ -f "${APPLY_SCRIPT}" ]]; then
            bash "${APPLY_SCRIPT}" "${1}"
        else
            echo "Error: ${APPLY_SCRIPT} not found" >&2
            exit 1
        fi
        ;;
    help|--help|-h)
        echo "Usage: dreamcoder {dark|light}"
        echo ""
        echo "Switch Dreamcoder theme mode across all terminals and apps."
        echo "  dark   → Ember Noir OLED (dark mode)"
        echo "  light  → Dreamcoder Light"
        exit 0
        ;;
    *)
        echo "Usage: dreamcoder {dark|light}" >&2
        exit 1
        ;;
esac
