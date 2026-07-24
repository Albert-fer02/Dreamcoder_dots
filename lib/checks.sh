#!/usr/bin/env bash
# ── Dreamcoder Dots — Command Checks ─────────────────────────────────
set -euo pipefail

require_command() {
    local cmd="$1"
    local friendly_name="${2:-$cmd}"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        log_error "${friendly_name} is required but not installed"
        return 1
    fi
}

optional_command() { command -v "$1" >/dev/null 2>&1; }
