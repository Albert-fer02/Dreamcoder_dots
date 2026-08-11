#!/usr/bin/env bats
# ============================================================================
# Tests for DreamcoderPi/.pi/agent/scripts/pi-theme.sh (profile-aware selector,
# design §5 row 9, task 4.6)
# ============================================================================

setup() {
    TEST_DIR="$(mktemp -d)"
    export DREAMCODER_DOTS_DIR="${TEST_DIR}"
    export DOTS_DIR="${TEST_DIR}"
    export HOME="${TEST_DIR}/home"
    export PI_AGENT_DIR="${TEST_DIR}/home/.pi/agent"
    export DREAMCODER_THEME_MODE="dark"
    unset DREAMCODER_THEME_PROFILE
    mkdir -p "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes"
    mkdir -p "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts"
    cp DreamcoderPi/.pi/agent/scripts/pi-theme.sh \
        "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh"
    touch "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes/dreamcoder-dark.json"
    touch "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes/dreamcoder-night.json"
}

teardown() {
    rm -rf "${TEST_DIR}"
}

@test "pi-theme.sh selects night artifact when profile=night" {
    run env DREAMCODER_THEME_PROFILE=night bash "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh" 2>&1
    [ "$status" -eq 0 ]
    [ "$(readlink "${PI_AGENT_DIR}/themes/dreamcoder.json")" = "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes/dreamcoder-night.json" ]
}

@test "pi-theme.sh keeps dark artifact for standard profile" {
    run bash "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh" 2>&1
    [ "$status" -eq 0 ]
    [ "$(readlink "${PI_AGENT_DIR}/themes/dreamcoder.json")" = "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes/dreamcoder-dark.json" ]
}

@test "pi-theme.sh rejects an invalid profile" {
    run env DREAMCODER_THEME_PROFILE=dusk bash "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh" 2>&1
    [ "$status" -eq 1 ]
    [[ "$output" == *"invalid render profile"* ]]
}

@test "pi-theme.sh fails closed when night artifact is missing" {
    rm "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/themes/dreamcoder-night.json"
    run env DREAMCODER_THEME_PROFILE=night bash "${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh" 2>&1
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}
