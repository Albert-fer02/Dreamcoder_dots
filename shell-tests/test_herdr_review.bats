setup() { load test_helper; }

@test "herdr-review.sh exists and is executable" {
  [ -x "$SCRIPTS_DIR/herdr-review.sh" ]
}

@test "herdr-review.sh fails with clear message when herdr is missing" {
  run env PATH="/usr/bin:/bin" "$SCRIPTS_DIR/herdr-review.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"herdr not found"* ]]
}

@test "herdr-review.sh runs the review flow via fake herdr" {
  fake="$(mktemp -d)"
  counter="$(mktemp)"
  cp "${PROJECT_ROOT}/shell-tests/fake_herdr.bash" "${fake}/herdr"
  chmod +x "${fake}/herdr"
  run env FAKE_COUNTER="${counter}" PATH="${fake}:$(dirname "$(command -v jq)")" "$SCRIPTS_DIR/herdr-review.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent-output-review-ok"* ]]
  rm -rf "${fake}" "${counter}"
}

@test "herdr-review.sh retries agent start until the pane is available" {
  fake="$(mktemp -d)"
  counter="$(mktemp)"
  cp "${PROJECT_ROOT}/shell-tests/fake_herdr_retry.bash" "${fake}/herdr"
  chmod +x "${fake}/herdr"
  run env FAKE_COUNTER="${counter}" PATH="${fake}:$(dirname "$(command -v jq)")" "$SCRIPTS_DIR/herdr-review.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent-output-review-ok"* ]]
  rm -rf "${fake}" "${counter}"
}
