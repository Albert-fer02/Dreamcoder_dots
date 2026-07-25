# test helper for ml4w bats tests
# Usage: bats tests/ml4w/*.bats

setup() {
  # Ensure we're in the repo root
  TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  export DREAMCODER_DOTS_DIR="${TEST_DIR}"

  # Set up a temporary home for tests that generate files
  export TEST_TEMP_HOME="$(mktemp -d)"
  export HOME="${TEST_TEMP_HOME}"

  # Profiles dir
  export PROFILES_DIR="${TEST_DIR}/DreamcoderProfiles/dreamcoder"
  export SCHEMA_FILE="${PROFILES_DIR}/profile.schema.json"
}

teardown() {
  rm -rf "${TEST_TEMP_HOME}"
}

# Assert helpers
assert_json_valid() {
  jq empty "$1" 2>/dev/null
}

assert_lua_valid() {
  if command -v luac >/dev/null; then
    luac -p "$1" 2>/dev/null
  else
    # Skip lua check if luac not available
    return 0
  fi
}

dump_on_failure() {
  local label="$1"
  local file="$2"
  if [[ "$BATS_ERROR_STATUS" -ne 0 ]]; then
    echo "# === ${label} ===" >&3
    if [[ -f "$file" ]]; then
      head -20 "$file" >&3
    else
      echo "# (file not found)" >&3
    fi
  fi
}
