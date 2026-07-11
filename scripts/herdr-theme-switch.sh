#!/usr/bin/env bash
# Switch Herdr theme between dreamcoder dark/light variants
set -euo pipefail

MODE="${1:-dark}"
CONFIG_DIR="${HOME}/.config/herdr"

case "${MODE}" in
dark)
  ln -sf config.dark.toml "${CONFIG_DIR}/config.toml"
  ;;
light)
  ln -sf config.light.toml "${CONFIG_DIR}/config.toml"
  ;;
*)
  echo "Usage: $0 {dark|light}" >&2
  exit 1
  ;;
esac

# Reload running Herdr server if active
if command -v herdr &>/dev/null; then
  herdr server reload-config 2>/dev/null || true
fi
