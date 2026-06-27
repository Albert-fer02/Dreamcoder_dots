setup() { load test_helper; }

@test "repair.sh exists and is executable" {
    [ -x "$SCRIPTS_DIR/repair.sh" ]
}

@test "repair.sh delegates to dreamcoder-maintenance.sh" {
    run "$SCRIPTS_DIR/repair.sh"
    [[ "$status" -ne 0 ]]
    [[ "$output" != "" ]]
}

@test "dreamcoder-maintenance.sh exists and is executable" {
    [ -x "$SCRIPTS_DIR/dreamcoder-maintenance.sh" ]
}
