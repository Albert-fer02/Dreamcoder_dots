#!/usr/bin/env bash
# Fake herdr CLI for bats tests: prints stable JSON, never talks to a server.
# Each tab create increments $FAKE_COUNTER so distinct tab/pane ids come back
# (w1:t2/w1:p2, w1:t3/w1:p3, ...); every invocation appends its argv to
# $FAKE_LOG when set so tests can assert tab order, renames, waits, and runs.
set -euo pipefail

log="${FAKE_LOG:-}"
if [[ -n "${log}" ]]; then
  printf '%s\n' "$*" >>"${log}"
fi

case "${1:-}" in
workspace)
  if [[ "${2:-}" == create ]]; then
    echo '{"result":{"workspace":{"workspace_id":"w1"},"tab":{"tab_id":"w1:t1"},"root_pane":{"pane_id":"w1:p1"}}}'
  fi
  ;;
tab)
  case "${2:-}" in
  create)
    counter="${FAKE_COUNTER:?set by the bats test}"
    count=0
    [[ -f "${counter}" ]] && count="$(cat "${counter}")"
    count=$((count + 1))
    echo "${count}" >"${counter}"
    echo "{\"result\":{\"tab\":{\"tab_id\":\"w1:t$((count + 1))\"},\"root_pane\":{\"pane_id\":\"w1:p$((count + 1))\"}}}"
    ;;
  rename) : ;;
  esac
  ;;
pane)
  case "${2:-}" in
  split)
    counter="${FAKE_COUNTER:?set by the bats test}"
    count=0
    [[ -f "${counter}" ]] && count="$(cat "${counter}")"
    count=$((count + 1))
    echo "${count}" >"${counter}"
    echo "{\"result\":{\"pane\":{\"pane_id\":\"w1:p$((count + 1))\"}}}"
    ;;
  get) echo '{"result":{"pane":{"terminal_title":"shell"}}}' ;;
  esac
  ;;
agent)
  echo 'agent-output-review-ok'
  ;;
esac
