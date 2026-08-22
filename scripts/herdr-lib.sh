#!/usr/bin/env bash
# Shared helpers for Herdr workflow scripts (sourced, never executed).
set -euo pipefail

herdr_require() {
  command -v herdr >/dev/null 2>&1 || {
    echo "error: herdr not found" >&2
    exit 1
  }
  command -v jq >/dev/null 2>&1 || {
    echo "error: jq not found" >&2
    exit 1
  }
}

herdr_require_dir() {
  [[ -d "${1:-}" ]] || {
    echo "error: not a directory: ${1}" >&2
    exit 1
  }
}

# Wait until a fresh pane's shell renders its prompt (terminal title set).
# A brand-new pane reports no terminal title until the shell draws the prompt;
# commands sent earlier (pane run) or agent start are lost or fail.
herdr_wait_shell() {
  local pane_id="${1}" i title
  for ((i = 1; i <= 30; i++)); do
    title="$(herdr pane get "${pane_id}" 2>/dev/null | jq -r '.result.pane.terminal_title // empty' 2>/dev/null || true)"
    if [[ -n "${title}" ]]; then
      return 0
    fi
    sleep 1
  done
  echo "error: pane ${pane_id} never showed a shell prompt" >&2
  return 1
}

# Wait for the shell, then start the agent. agent start on a pane that is not
# yet an available shell returns agent_pane_busy or a startup timeout.
herdr_start_agent() {
  local name="${1}" kind="${2}" pane_id="${3}" i attempt
  herdr_wait_shell "${pane_id}" || return 1
  for ((i = 1; i <= 3; i++)); do
    if attempt="$(herdr agent start "${name}" --kind "${kind}" --pane "${pane_id}" --timeout 30000 2>&1)"; then
      return 0
    fi
    [[ "${attempt}" == *agent_pane_busy* ]] || break
    sleep 1
  done
  echo "error: pane ${pane_id} never became an available shell" >&2
  return 1
}
