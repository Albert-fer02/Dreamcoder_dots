#!/usr/bin/env bash
set -euo pipefail

# Docker E2E test runner for dreamcoder-dots installer
# Usage: bash docker-test.sh [distro]
#   distro: ubuntu (default), debian, fedora, alpine, all

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
E2E_DIR="${ROOT}/installer/e2e"
DISTRO="${1:-ubuntu}"

run_test() {
  local distro="$1"
  local dockerfile="${E2E_DIR}/Dockerfile.${distro}"

  if [[ ! -f "${dockerfile}" ]]; then
    echo "✗ No Dockerfile for '${distro}' at ${dockerfile}"
    return 1
  fi

  echo ":: Testing ${distro}..."
  docker build -t "dreamcoder-e2e-${distro}" \
    -f "${dockerfile}" \
    "${ROOT}/installer" 2>&1 | tail -3

  echo "✓ ${distro} passed"
}

case "${DISTRO}" in
all)
  for d in ubuntu debian fedora alpine; do
    run_test "${d}"
  done
  ;;
*)
  run_test "${DISTRO}"
  ;;
esac

echo ""
echo "=== All tests passed ==="
