setup() { load test_helper; }

@test "status.sh prints Dreamcoder Status header" {
    run "$SCRIPTS_DIR/status.sh"
    [[ "$output" == *"Dreamcoder Status"* ]]
}

@test "status.sh shows expected theme mode" {
    run "$SCRIPTS_DIR/status.sh"
    [[ "$output" == *"expected="* ]]
}

@test "status.sh checks theme components" {
    run "$SCRIPTS_DIR/status.sh"
    [[ "$output" == *"ghostty"* ]]
    [[ "$output" == *"kitty"* ]]
    [[ "$output" == *"opencode"* ]]
}
