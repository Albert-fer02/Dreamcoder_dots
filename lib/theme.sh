#!/usr/bin/env bash
# ── Dreamcoder Dots — Theme Utilities ────────────────────────────────
set -euo pipefail

detect_theme_mode() {
    local tokens_file="${DREAMCODER_DOTS_DIR}/DreamcoderThemes/dreamcoder/tokens.json"
    if [[ -f "${tokens_file}" ]]; then
        python3 -c "import json,sys; d=json.load(open('${tokens_file}')); print(d.get('active_mode','light'))"
    else
        echo "light"
    fi
}

load_theme_tokens() {
    local mode="${1:-light}"
    local tokens_file="${DREAMCODER_DOTS_DIR}/DreamcoderThemes/dreamcoder/tokens.json"
    python3 -c "
import json, sys
d = json.load(open('${tokens_file}'))
print(json.dumps(d['modes'].get('${mode}', d['modes']['light'])))
"
}
