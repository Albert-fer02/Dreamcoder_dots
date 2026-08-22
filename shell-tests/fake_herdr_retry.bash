#!/usr/bin/env bash
# Fake herdr that fails agent start twice, then succeeds (bats retry test).
# State persists in $FAKE_COUNTER because each invocation is a fresh process.
set -euo pipefail
counter="${FAKE_COUNTER:?set by the bats test}"
count=0
[[ -f "${counter}" ]] && count="$(cat "${counter}")"
count=$((count + 1))
echo "${count}" >"${counter}"
case "${1:-}" in
pane)
  case "${2:-}" in
  split) echo '{"result":{"pane":{"pane_id":"w1:p2"}}}' ;;
  get) echo '{"result":{"pane":{"terminal_title":"shell"}}}' ;;
  esac
  ;;
agent)
  if [[ "${2:-}" == start ]] && ((count <= 2)); then
    echo '{"error":{"code":"agent_pane_busy","message":"busy"}}'
    exit 1
  fi
  echo 'agent-output-review-ok'
  ;;
esac
