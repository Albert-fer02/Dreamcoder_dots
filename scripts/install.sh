#!/usr/bin/env bash
set -euo pipefail
# backup create/backup restore are handled by dreamcoder-maintenance.sh.
exec "${0%/*}/dreamcoder-maintenance.sh" install "${@}"
