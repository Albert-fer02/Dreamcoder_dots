# ============================================================================
# BATS tests: setup-hyprland.sh
# ============================================================================
# These tests use a mock HOME with no ML4W installation.
# The script will fail pre-flight checks, but we verify correct error messages.

load '../helpers/setup'

@test "setup-hyprland: --help exits cleanly" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "setup-hyprland: unknown option fails gracefully" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" --bogus 2>&1
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option"* ]]
}

@test "setup-hyprland: pre-flight shows profile info before failing" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile default --dry-run 2>&1
  # Pre-flight will fail (no ML4W), but we check partial output
  [[ "$output" == *"Using profile: default"* ]]
  [[ "$output" == *"Dry-run mode"* ]]
  [[ "$output" == *"Pre-flight checks"* ]]
}

@test "setup-hyprland: partial output shows correct paths" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile asus-vivobook15 --dry-run 2>&1
  [[ "$output" == *"asus-vivobook15"* ]]
  [[ "$output" == *"Pre-flight checks"* ]]
}

@test "setup-hyprland: --dry-run with empty profile name fails" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile "" --dry-run 2>&1
  [ "$status" -ne 0 ]
}

@test "setup-hyprland: --profile flag appears in output" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile default --dry-run 2>&1
  [[ "$output" == *"default"* ]]
}

@test "setup-hyprland: script validates jq availability" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile default --dry-run 2>&1
  [[ "$output" == *"jq is installed"* ]]
}

@test "setup-hyprland: script exits with failure without ML4W" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile default --dry-run 2>&1
  [ "$status" -ne 0 ]
}

@test "setup-hyprland: profile detection runs before failure" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/setup-hyprland.sh" \
    --profile default --dry-run 2>&1
  [[ "$output" == *"Pre-flight"* ]]
  [[ "$output" == *"jq is installed"* ]]
}
