#!/usr/bin/env bats
# ============================================================================
# Tests for lib/core utilities
# ============================================================================

setup() {
    TEST_DIR="$(mktemp -d)"
    export DREAMCODER_DOTS_DIR="${TEST_DIR}"
    mkdir -p "${TEST_DIR}/lib"
    cp lib/logging.sh lib/env.sh lib/checks.sh lib/safety.sh "${TEST_DIR}/lib/"
}

teardown() {
    rm -rf "${TEST_DIR}"
}

# ── ensure_dots_dir ──────────────────────────────────────────────────

@test "ensure_dots_dir sets DREAMCODER_DOTS_DIR when unset" {
    source "${TEST_DIR}/lib/env.sh"
    # Must run in subshell to avoid unbound variable error from set -u
    result="$(unset DREAMCODER_DOTS_DIR; source "${TEST_DIR}/lib/env.sh"; ensure_dots_dir >/dev/null 2>&1; echo "${DREAMCODER_DOTS_DIR}")"
    [ -n "${result}" ]
}

@test "ensure_dots_dir preserves existing DREAMCODER_DOTS_DIR" {
    export DREAMCODER_DOTS_DIR="/custom/path"
    source "${TEST_DIR}/lib/env.sh"
    run ensure_dots_dir
    [ "${DREAMCODER_DOTS_DIR}" = "/custom/path" ]
}

# ── is_gui_session ───────────────────────────────────────────────────

@test "is_gui_session returns false with no display" {
    unset WAYLAND_DISPLAY DISPLAY
    source "${TEST_DIR}/lib/env.sh"
    run is_gui_session
    [ "$status" -eq 1 ]
}

@test "is_gui_session returns true with DISPLAY set" {
    export DISPLAY=":0"
    unset WAYLAND_DISPLAY
    source "${TEST_DIR}/lib/env.sh"
    run is_gui_session
    [ "$status" -eq 0 ]
}

# ── require_command ──────────────────────────────────────────────────

@test "require_command finds existing command" {
    source "${TEST_DIR}/lib/checks.sh"
    run require_command bash
    [ "$status" -eq 0 ]
}

@test "require_command fails for missing command" {
    source "${TEST_DIR}/lib/checks.sh"
    run require_command nonexistent_command_xyz
    [ "$status" -eq 1 ]
}

# ── safe_source ──────────────────────────────────────────────────────

@test "safe_source sources existing file" {
    echo "export TEST_VAR=hello" > "${TEST_DIR}/test_file.sh"
    source "${TEST_DIR}/lib/safety.sh"
    safe_source "${TEST_DIR}/test_file.sh"
    [ "${TEST_VAR}" = "hello" ]
}

@test "safe_source ignores missing file" {
    source "${TEST_DIR}/lib/safety.sh"
    run safe_source "${TEST_DIR}/nonexistent.sh"
    [ "$status" -eq 0 ]
}
