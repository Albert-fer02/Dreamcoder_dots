# ============================================================================
# BATS tests: JSON profiles and schema validation
# ============================================================================

load '../helpers/setup'

@test "profiles: default.json is valid JSON" {
  assert_json_valid "${PROFILES_DIR}/default.json"
}

@test "profiles: asus-vivobook15.json is valid JSON" {
  assert_json_valid "${PROFILES_DIR}/asus-vivobook15.json"
}

@test "profiles: schema.json is valid JSON Schema" {
  assert_json_valid "${SCHEMA_FILE}"
}

@test "profiles: default.json has required fields" {
  local missing=0
  for field in name description keybindings; do
    if ! jq -e ".$field" "${PROFILES_DIR}/default.json" >/dev/null 2>&1; then
      echo "# Missing required field: $field" >&3
      ((missing++))
    fi
  done
  [ "$missing" -eq 0 ]
}

@test "profiles: asus-vivobook15.json has required fields" {
  local missing=0
  for field in name description keybindings; do
    if ! jq -e ".$field" "${PROFILES_DIR}/asus-vivobook15.json" >/dev/null 2>&1; then
      echo "# Missing required field: $field" >&3
      ((missing++))
    fi
  done
  [ "$missing" -eq 0 ]
}

@test "profiles: all bindings have key, command, description" {
  local errors=0
  for profile in default asus-vivobook15; do
    local file="${PROFILES_DIR}/${profile}.json"
    local count
    count=$(jq '.keybindings.bindings | length' "$file")

    for i in $(seq 0 $((count - 1))); do
      for field in key command description; do
        if ! jq -e ".keybindings.bindings[$i].$field" "$file" >/dev/null 2>&1; then
          echo "# ${profile}.json binding[$i]: missing $field" >&3
          ((errors++))
        fi
      done
    done
  done
  [ "$errors" -eq 0 ]
}

@test "profiles: super_mod is uppercase" {
  for profile in default asus-vivobook15; do
    local super_mod
    super_mod=$(jq -r '.keybindings.super_mod // "SUPER"' "${PROFILES_DIR}/${profile}.json")
    [ "$super_mod" = "$(echo "$super_mod" | tr '[:lower:]' '[:upper:]')" ]
  done
}

@test "profiles: Fn keys have empty mods array" {
  local file="${PROFILES_DIR}/asus-vivobook15.json"
  local errors=0
  local count
  count=$(jq '.keybindings.bindings | length' "$file")

  for i in $(seq 0 $((count - 1))); do
    local key
    key=$(jq -r ".keybindings.bindings[$i].key" "$file")
    if [[ "$key" =~ ^F[0-9] ]] || [[ "$key" == code:* ]]; then
      local mods_length
      mods_length=$(jq ".keybindings.bindings[$i].mods | length" "$file")
      if [[ "$mods_length" -ne 0 ]]; then
        echo "# ${profile}.json: Fn key $key has non-empty mods" >&3
        ((errors++))
      fi
    fi
  done
  [ "$errors" -eq 0 ]
}

@test "profiles: all mods values are valid" {
  local valid_mods='["SUPER","SHIFT","CTRL","ALT","CTRL_SHIFT","SUPER_SHIFT"]'
  local file="${PROFILES_DIR}/asus-vivobook15.json"
  local errors=0
  local count
  count=$(jq '.keybindings.bindings | length' "$file")

  for i in $(seq 0 $((count - 1))); do
    local mods_json
    mods_json=$(jq -c ".keybindings.bindings[$i].mods" "$file" 2>/dev/null || echo "[]")
    if [[ "$mods_json" != "[]" ]]; then
      local mod
      for mod in $(echo "$mods_json" | jq -r '.[]'); do
        if ! echo "$valid_mods" | jq -e ". | index(\"$mod\")" >/dev/null 2>&1; then
          echo "# Invalid mod: $mod in binding[$i]" >&3
          ((errors++))
        fi
      done
    fi
  done
  [ "$errors" -eq 0 ]
}

@test "profiles: all key values match expected pattern" {
  local errors=0
  for profile in default asus-vivobook15; do
    local file="${PROFILES_DIR}/${profile}.json"
    local count
    count=$(jq '.keybindings.bindings | length' "$file")

    for i in $(seq 0 $((count - 1))); do
      local key
      key=$(jq -r ".keybindings.bindings[$i].key" "$file")
      if [[ ! "$key" =~ ^[A-Z0-9_]+$ ]] && \
         [[ ! "$key" =~ ^code:[0-9]+$ ]] && \
         [[ ! "$key" =~ ^F(1[0-2]?|[2-9])$ ]]; then
        echo "# ${profile}.json binding[$i]: invalid key '${key}'" >&3
        ((errors++))
      fi
    done
  done
  [ "$errors" -eq 0 ]
}

@test "profiles: no duplicate key+mods combinations" {
  local errors=0
  for profile in default asus-vivobook15; do
    local file="${PROFILES_DIR}/${profile}.json"
    local count
    count=$(jq '.keybindings.bindings | length' "$file")

    for i in $(seq 0 $((count - 1))); do
      local key_i mods_i
      key_i=$(jq -r ".keybindings.bindings[$i].key" "$file")
      mods_i=$(jq -c ".keybindings.bindings[$i].mods // []" "$file")

      for j in $(seq $((i + 1)) $((count - 1))); do
        local key_j mods_j
        key_j=$(jq -r ".keybindings.bindings[$j].key" "$file")
        mods_j=$(jq -c ".keybindings.bindings[$j].mods // []" "$file")

        if [[ "$key_i" == "$key_j" ]] && [[ "$mods_i" == "$mods_j" ]]; then
          echo "# ${profile}.json: duplicate binding $key_i at index $i and $j" >&3
          ((errors++))
        fi
      done
    done
  done
  [ "$errors" -eq 0 ]
}
