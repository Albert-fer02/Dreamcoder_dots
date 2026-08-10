#!/usr/bin/env bats
# ============================================================================
# Tests for scripts/dreamcoder dispatch (upstream-diff route)
# ============================================================================

setup() {
    TEST_DIR="$(mktemp -d)"
    mkdir -p "${TEST_DIR}/scripts" "${TEST_DIR}/lib" "${TEST_DIR}/docs"
    cp scripts/dreamcoder scripts/dreamcoder-env.sh "${TEST_DIR}/scripts/"
    cp scripts/upstream-diff.py "${TEST_DIR}/scripts/"
    cp lib/logging.sh lib/env.sh "${TEST_DIR}/lib/"
    cp docs/upstream-manifest.json docs/upstream-manifest.schema.json "${TEST_DIR}/docs/"
}

teardown() {
    rm -rf "${TEST_DIR}"
}

@test "dreamcoder has valid syntax" {
    run bash -n scripts/dreamcoder
    [ "$status" -eq 0 ]
}

@test "dreamcoder upstream-diff route reports no mappings without network" {
    run bash "${TEST_DIR}/scripts/dreamcoder" upstream-diff --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c '
import json, sys
report = json.load(sys.stdin)
assert report["result"] == "no-mappings", report
assert report["mode"] == "diff", report
'
}

@test "dreamcoder upstream-diff passes --upstream selection through" {
    run bash "${TEST_DIR}/scripts/dreamcoder" upstream-diff --upstream ml4w --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c '
import json, sys
report = json.load(sys.stdin)
assert list(report["upstreams"]) == ["ml4w"], report
assert report["upstreams"]["ml4w"]["mappings"] == [], report
'
}

@test "dreamcoder rejects unknown commands" {
    run bash "${TEST_DIR}/scripts/dreamcoder" no-such-command
    [ "$status" -eq 2 ]
    [[ "$output" == *"Usage: dreamcoder"* ]]
    [[ "$output" == *"upstream-diff"* ]]
}
