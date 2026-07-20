# ============================================================================
# BATS tests: generate-custom-lua.sh
# ============================================================================

load '../helpers/setup'

@test "generate-custom-lua: --help exits cleanly" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"generate-custom-lua.sh"* ]]
  [[ "$output" == *"machine profile"* ]]
}

@test "generate-custom-lua: --list-profiles shows all profiles" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" --list-profiles
  [ "$status" -eq 0 ]
  [[ "$output" == *"default"* ]]
  [[ "$output" == *"asus-vivobook15"* ]]
}

@test "generate-custom-lua: --validate passes for default" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile default --validate
  [ "$status" -eq 0 ]
}

@test "generate-custom-lua: --validate passes for asus-vivobook15" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile asus-vivobook15 --validate
  [ "$status" -eq 0 ]
}

@test "generate-custom-lua: --validate fails for missing profile" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile nonexistent --validate
  [ "$status" -ne 0 ]
}

@test "generate-custom-lua: --dry-run produces valid Lua for default" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile default --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"SUPER + SHIFT + D"* ]]
  [[ "$output" == *"Toggle Dreamcoder"* ]]
  [[ "$output" == *"local mainMod"* ]]
}

@test "generate-custom-lua: --dry-run produces valid Lua for asus-vivobook15" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile asus-vivobook15 --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"F1"* ]]
  [[ "$output" == *"Mutear audio"* ]]
  [[ "$output" == *"code:238"* ]]
  [[ "$output" == *"hl.bind"* ]]
}

@test "generate-custom-lua: dry-run output passes luac syntax check" {
  if ! command -v luac >/dev/null; then
    skip "luac not available"
  fi

  # Capture just the Lua body by finding lines between the two ═══ markers
  local lua_output
  lua_output="$(
    "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
      --profile default --dry-run 2>&1 \
      | sed -n '/^-- ===/,/^═══ Would write to/p' \
      | head -n -1
  )"

  # Write to temp and check with luac
  local tmpfile
  tmpfile="$(mktemp /tmp/test_generated_lua.XXXXXX)"
  echo "$lua_output" > "$tmpfile"
  run luac -p "$tmpfile"
  echo "# luac output: $output" >&3
  rm -f "$tmpfile"
  [ "$status" -eq 0 ]
}

@test "generate-custom-lua: generates correct number of bindings for default" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile default --dry-run
  [ "$status" -eq 0 ]
  # Count only hl.bind lines (not the comment lines)
  local count
  count="$(echo "$output" | grep '^hl.bind' | wc -l)"
  [ "$count" -eq 3 ]
}

@test "generate-custom-lua: asus-vivobook15 has 19 bindings (inc. mouse, release)" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile asus-vivobook15 --dry-run
  [ "$status" -eq 0 ]
  local count
  count="$(echo "$output" | grep -cE '^hl\.(bind|bindl|mouse_bind)\(' || true)"
  echo "# bind function calls: $count" >&3
  [ "$count" -eq 19 ]
}
    
@test "generate-custom-lua: each binding has exec_cmd" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile asus-vivobook15 --dry-run
  [ "$status" -eq 0 ]
  local cmds
  cmds="$(echo "$output" | grep -c 'hl.dsp.exec_cmd' || true)"
  echo "# exec_cmd count: $cmds" >&3
  [ "$cmds" -eq 19 ]
}

@test "generate-custom-lua: bare Fn keys have no SUPER prefix" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile asus-vivobook15 --dry-run
  [ "$status" -eq 0 ]
  # F1-F12 should NOT have SUPER
  [[ "$output" == *'"F1"'* ]]
  [[ "$output" != *'SUPER + F1'* ]]
}

@test "generate-custom-lua: --validate reports profile name" {
  run bash "${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh" \
    --profile default --validate
  [ "$status" -eq 0 ]
  [[ "$output" == *"default.json"* ]]
}
