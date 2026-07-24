#!/usr/bin/env bash
# ── Dreamcoder Dots — Safety Utilities ───────────────────────────────
set -euo pipefail

safe_source() {
    local file="$1"
    [[ -f "${file}" ]] && source "${file}" || true
}

on_error() {
    log_error "Script failed at line ${1} (exit code: ${2})"
    exit "${2}"
}

enable_error_trapping() { trap 'on_error ${LINENO} $?' ERR; }
