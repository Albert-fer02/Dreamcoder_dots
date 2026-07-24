#!/usr/bin/env bats
# ============================================================================
# Tests for scripts/doctor.sh
# ============================================================================

setup() {
    TEST_DIR="$(mktemp -d)"
    export DREAMCODER_DOTS_DIR="${TEST_DIR}"
    export HOME="${TEST_DIR}"
    mkdir -p "${TEST_DIR}/lib" "${TEST_DIR}/scripts" "${TEST_DIR}/.config"
    cp lib/*.sh "${TEST_DIR}/lib/"
    cp scripts/doctor.sh "${TEST_DIR}/scripts/"
}

teardown() {
    rm -rf "${TEST_DIR}"
}

@test "doctor.sh has valid syntax" {
    run bash -n scripts/doctor.sh
    [ "$status" -eq 0 ]
}
