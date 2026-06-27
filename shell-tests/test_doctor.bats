setup() { load test_helper; }

@test "doctor.sh prints Dreamcoder Doctor header" {
    run "$SCRIPTS_DIR/doctor.sh"
    [[ "$output" == *"Dreamcoder Doctor"* ]]
}

@test "doctor.sh checks structured health section" {
    run "$SCRIPTS_DIR/doctor.sh"
    [[ "$output" == *"Structured health"* ]]
}

@test "doctor.sh checks legacy checks section" {
    run "$SCRIPTS_DIR/doctor.sh"
    [[ "$output" == *"Legacy checks"* ]]
}
