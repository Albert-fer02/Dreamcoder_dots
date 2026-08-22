#!/usr/bin/env bash
# Launch a review agent in a Herdr pane split to review the current diff.
set -euo pipefail
# shellcheck source=herdr-lib.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/herdr-lib.sh"

KIND="${1:-pi}"
TARGET="${2:-HEAD}"
PROJECT_DIR="${3:-$PWD}"

herdr_require
herdr_require_dir "${PROJECT_DIR}"

split="$(herdr pane split --current --direction right --ratio 0.40 --no-focus)"
pane_id="$(jq -r '.result.pane.pane_id' <<<"${split}")"
herdr_start_agent reviewer "${KIND}" "${pane_id}"

herdr agent prompt reviewer "Review the ${TARGET} diff in ${PROJECT_DIR}: bugs, edge cases, security. Report findings concisely." --wait --timeout 300000
herdr agent read reviewer --source recent-unwrapped --lines 120
