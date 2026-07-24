#!/usr/bin/env bash
# ── Dreamcoder Dots — Logging ────────────────────────────────────────
set -euo pipefail

log_info()  { echo "ℹ️  $*"; }
log_warn()  { echo "⚠️  $*" >&2; }
log_error() { echo "❌ $*" >&2; }
log_ok()    { echo "✅ $*"; }
