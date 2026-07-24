#!/usr/bin/env bats
# ============================================================================
# Tests for scripts/apply-theme-mode.sh
# ============================================================================

setup() {
    TEST_DIR="$(mktemp -d)"
    export DREAMCODER_DOTS_DIR="${TEST_DIR}"
    mkdir -p "${TEST_DIR}/lib" "${TEST_DIR}/scripts" "${TEST_DIR}/DreamcoderThemes/dreamcoder"
    cp lib/*.sh "${TEST_DIR}/lib/"
    cp scripts/apply-theme-mode.sh "${TEST_DIR}/scripts/"
    echo '{"active_mode":"light","modes":{"light":{"bg":"#fff"},"dark":{"bg":"#000"}}}' > "${TEST_DIR}/DreamcoderThemes/dreamcoder/tokens.json"
}

teardown() {
    rm -rf "${TEST_DIR}"
}

@test "apply-theme-mode.sh has valid syntax" {
    run bash -n scripts/apply-theme-mode.sh
    [ "$status" -eq 0 ]
}

@test "apply-theme-mode.sh with invalid mode exits non-zero" {
    run bash scripts/apply-theme-mode.sh invalid 2>&1
    [ "$status" -eq 1 ]
}
