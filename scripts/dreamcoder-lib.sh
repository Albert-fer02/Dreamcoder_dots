#!/usr/bin/env bash
set -euo pipefail
DREAMCODER_MODULES=(Shell Kitty Ghostty Fastfetch Warp Bat Systemd)
DREAMCODER_TARGETS=("${CONFIG_HOME}/kitty" "${CONFIG_HOME}/ghostty" "${CONFIG_HOME}/fastfetch" "${CONFIG_HOME}/dreamcoder" "${CONFIG_HOME}/fish" "${CONFIG_HOME}/starship.toml" "${CONFIG_HOME}/bat" "${DATA_HOME}/warp-terminal/themes")
dreamcoder_control() { PYTHONPATH="${DREAMCODER_DOTS_DIR}/scripts${PYTHONPATH:+:${PYTHONPATH}}" python3 -m dreamcoder_theme.control "$@"; }
dreamcoder_json_get() { python3 -c 'import json,sys; print(json.load(sys.stdin)[sys.argv[1]])' "$1"; }
dreamcoder_backup() { dreamcoder_control backup create "${DREAMCODER_TARGETS[@]}" --reason "${1}" --json; }
dreamcoder_apply_hooks() { "${DREAMCODER_DOTS_DIR}/scripts/apply-ml4w-hooks.sh"; "${DREAMCODER_DOTS_DIR}/scripts/apply-cli-env-hooks.sh"; "${DREAMCODER_DOTS_DIR}/scripts/apply-fastfetch-assets.sh"; }
dreamcoder_enable_timer() { command -v systemctl >/dev/null || return 0; systemctl --user daemon-reload || true; systemctl --user enable --now dreamcoder-theme-auto.timer || true; }
