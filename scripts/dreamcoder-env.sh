#!/usr/bin/env bash
set -euo pipefail

DREAMCODER_DOTS_DIR="${DREAMCODER_DOTS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
