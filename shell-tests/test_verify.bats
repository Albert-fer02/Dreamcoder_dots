setup() { load test_helper; }

@test "verify.sh exists and is executable" {
    [ -x "$SCRIPTS_DIR/verify.sh" ]
}

@test "verify.sh runs and checks paths" {
    run "$SCRIPTS_DIR/verify.sh"
    [[ "$output" == *"kitty"* ]]
}

@test "verify.sh checks starship dependency" {
    run "$SCRIPTS_DIR/verify.sh"
    [[ "$output" == *"starship"* ]]
}
