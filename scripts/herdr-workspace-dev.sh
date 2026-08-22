#!/usr/bin/env bash
# Open a Herdr workspace with pi, lazygit, and shell tabs for a project.
set -euo pipefail
# shellcheck source=herdr-lib.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/herdr-lib.sh"

PROJECT_DIR="${1:-$PWD}"
LABEL="${2:-$(basename "${PROJECT_DIR}")}"

herdr_require
herdr_require_dir "${PROJECT_DIR}"

created="$(herdr workspace create --cwd "${PROJECT_DIR}" --label "${LABEL}" --no-focus)"
workspace_id="$(jq -r '.result.workspace.workspace_id' <<<"${created}")"
root_tab="$(jq -r '.result.tab.tab_id' <<<"${created}")"
root_pane="$(jq -r '.result.root_pane.pane_id' <<<"${created}")"
herdr tab rename "${root_tab}" pi >/dev/null
herdr_wait_shell "${root_pane}"
agent_name="dev-$(printf '%s' "${LABEL}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9_-' '-' | cut -c1-27)"
herdr_start_agent "${agent_name}" pi "${root_pane}"

git_tab="$(herdr tab create --workspace "${workspace_id}" --cwd "${PROJECT_DIR}" --label git --no-focus)"
git_pane="$(jq -r '.result.root_pane.pane_id' <<<"${git_tab}")"
herdr_wait_shell "${git_pane}"
herdr pane run "${git_pane}" lazygit
shell_tab="$(herdr tab create --workspace "${workspace_id}" --cwd "${PROJECT_DIR}" --label shell --no-focus)"
shell_pane="$(jq -r '.result.root_pane.pane_id' <<<"${shell_tab}")"
herdr_wait_shell "${shell_pane}"
echo "workspace: ${workspace_id}"
echo "tabs: ${root_tab} (pi) ${git_pane} (lazygit) ${shell_pane} (shell)"
