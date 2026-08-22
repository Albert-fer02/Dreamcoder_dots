setup() { load test_helper; }

@test "herdr-workspace-dev.sh exists and is executable" {
  [ -x "$SCRIPTS_DIR/herdr-workspace-dev.sh" ]
}

@test "herdr-workspace-dev.sh fails with clear message when herdr is missing" {
  run env PATH="/usr/bin:/bin" "$SCRIPTS_DIR/herdr-workspace-dev.sh" /tmp
  [ "$status" -ne 0 ]
  [[ "$output" == *"herdr not found"* ]]
}

@test "herdr-workspace-dev.sh rejects a missing project directory" {
  run "$SCRIPTS_DIR/herdr-workspace-dev.sh" /no-such-dir-xyz
  [ "$status" -ne 0 ]
  [[ "$output" == *"not a directory"* ]]
}

@test "herdr-workspace-dev.sh creates a workspace with pi, git, and shell tabs" {
  fake="$(mktemp -d)"
  counter="$(mktemp)"
  cp "${PROJECT_ROOT}/shell-tests/fake_herdr.bash" "${fake}/herdr"
  chmod +x "${fake}/herdr"
  run env FAKE_COUNTER="${counter}" PATH="${fake}:$(dirname "$(command -v jq)")" "$SCRIPTS_DIR/herdr-workspace-dev.sh" /tmp
  [ "$status" -eq 0 ]
  [[ "$output" == *"workspace: w1"* ]]
  [[ "$output" == *"(pi)"* ]]
  [[ "$output" == *"(lazygit)"* ]]
  [[ "$output" == *"(shell)"* ]]
  rm -rf "${fake}" "${counter}"
}

@test "herdr-workspace-dev.sh renames the root tab to pi, then adds git and shell tabs without splits" {
  fake="$(mktemp -d)"
  counter="$(mktemp)"
  log="$(mktemp)"
  cp "${PROJECT_ROOT}/shell-tests/fake_herdr.bash" "${fake}/herdr"
  chmod +x "${fake}/herdr"
  run env FAKE_COUNTER="${counter}" FAKE_LOG="${log}" \
    PATH="${fake}:$(dirname "$(command -v jq)")" \
    "$SCRIPTS_DIR/herdr-workspace-dev.sh" /tmp
  [ "$status" -eq 0 ]
  rename="$(grep -n 'tab rename w1:t1 pi' "${log}" | head -n1 | cut -d: -f1)"
  wait_pi="$(grep -n 'get w1:p1' "${log}" | head -n1 | cut -d: -f1)"
  agent="$(grep -n 'agent start dev-tmp --kind pi --pane w1:p1 --timeout 30000' "${log}" | head -n1 | cut -d: -f1)"
  git_tab="$(grep -n 'tab create --workspace w1 --cwd /tmp --label git --no-focus' "${log}" | head -n1 | cut -d: -f1)"
  wait_git="$(grep -n 'get w1:p2' "${log}" | head -n1 | cut -d: -f1)"
  run_lazygit="$(grep -n 'run w1:p2 lazygit' "${log}" | head -n1 | cut -d: -f1)"
  shell_tab="$(grep -n 'tab create --workspace w1 --cwd /tmp --label shell --no-focus' "${log}" | head -n1 | cut -d: -f1)"
  wait_shell="$(grep -n 'get w1:p3' "${log}" | head -n1 | cut -d: -f1)"
  [[ -n "${rename}" && -n "${wait_pi}" && -n "${agent}" && -n "${git_tab}" && -n "${wait_git}" && -n "${run_lazygit}" && -n "${shell_tab}" && -n "${wait_shell}" ]]
  [[ "${rename}" -lt "${wait_pi}" ]]
  [[ "${wait_pi}" -lt "${agent}" ]]
  [[ "${agent}" -lt "${git_tab}" ]]
  [[ "${git_tab}" -lt "${wait_git}" ]]
  [[ "${wait_git}" -lt "${run_lazygit}" ]]
  [[ "${run_lazygit}" -lt "${shell_tab}" ]]
  [[ "${shell_tab}" -lt "${wait_shell}" ]]
  ! grep -q 'pane split' "${log}"
  rm -rf "${fake}" "${counter}" "${log}"
}
