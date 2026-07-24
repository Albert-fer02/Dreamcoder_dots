#!/usr/bin/env bash
# ============================================================================
# generate-custom-lua.sh — Generate Hyprland custom.lua from machine profile
# ============================================================================
# Reads keybinding definitions from the active Dreamcoder machine profile
# (JSON) and emits a well-formed Lua file at ~/.config/hypr/custom.lua.
#
# Usage:
#   ./scripts/generate-custom-lua.sh                           # auto-detect profile
#   ./scripts/generate-custom-lua.sh --profile asus-vivobook15  # explicit profile
#   ./scripts/generate-custom-lua.sh --dry-run                  # preview only
#   ./scripts/generate-custom-lua.sh --validate                 # validate + exit
#   ./scripts/generate-custom-lua.sh --list-profiles            # list available
#   ./scripts/generate-custom-lua.sh --help                    # this message
#
# Dependencies: jq (JSON processor)
# ============================================================================
set -euo pipefail

# ── helpers ─────────────────────────────────────────────────────────────────
info() { printf '  ✓ %s\n' "$*"; }
warn() { printf '  ⚠ %s\n' "$*" >&2; }
die() {
  printf '✖ %s\n' "$*" >&2
  exit 1
}

# ── paths ────────────────────────────────────────────────────────────────────
DREAMCODER_DOTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT="${HOME}/.config/hypr/custom.lua"
PROFILES_DIR="${DREAMCODER_DOTS_DIR}/DreamcoderProfiles/dreamcoder"

# ── profile resolution ──────────────────────────────────────────────────────
PROFILE_NAME="${DREAMCODER_PROFILE:-}"
DRY_RUN=false
VALIDATE_ONLY=false
LIST_PROFILES=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --profile)
    shift
    PROFILE_NAME="$1"
    ;;
  --dry-run) DRY_RUN=true ;;
  --validate) VALIDATE_ONLY=true ;;
  --list-profiles) LIST_PROFILES=true ;;
  --help | -h)
    sed -n '/^# ====/,/^# ====/p' "$0" | grep -E '^# ' | sed 's/^# //'
    exit 0
    ;;
  *) die "Unknown option: $1" ;;
  esac
  shift
done

# ── --list-profiles ─────────────────────────────────────────────────────────
if $LIST_PROFILES; then
  echo "Available profiles:"
  for f in "${PROFILES_DIR}"/*.json; do
    name="$(basename "${f}" .json)"
    [[ "${name}" == "profile.schema" ]] && continue
    desc="$(jq -r '.description // "(no description)"' "${f}" 2>/dev/null || echo "(invalid)")"
    printf '  • %-20s %s\n' "${name}" "${desc}"
  done
  exit 0
fi

# ── auto-detect profile ─────────────────────────────────────────────────────
if [[ -z "${PROFILE_NAME}" ]]; then
  HOSTNAME="$(hostname -s 2>/dev/null || echo "unknown")"
  case "$(echo "${HOSTNAME}" | tr '[:upper:]' '[:lower:]')" in
  *asus* | *vivobook*) PROFILE_NAME="asus-vivobook15" ;;
  *) PROFILE_NAME="default" ;;
  esac
  info "Auto-detected profile: ${PROFILE_NAME} (hostname: ${HOSTNAME})"
fi

PROFILE_FILE="${PROFILES_DIR}/${PROFILE_NAME}.json"
SCHEMA_FILE="${PROFILES_DIR}/profile.schema.json"

if [[ ! -f "${PROFILE_FILE}" ]]; then
  die "Profile not found: ${PROFILE_FILE}"
fi

# ── pre-flight ──────────────────────────────────────────────────────────────
command -v jq >/dev/null || die "jq is required but not installed."

# Validate JSON syntax
if ! jq empty "${PROFILE_FILE}" 2>/dev/null; then
  die "Profile is not valid JSON: ${PROFILE_FILE}"
fi

# Validate against schema (optional — requires check-json or Python + jsonschema)
if [[ -f "${SCHEMA_FILE}" ]]; then
  SCHEMA_OK=false
  if command -v check-json >/dev/null; then
    if check-json --schema "${SCHEMA_FILE}" "${PROFILE_FILE}" 2>/dev/null; then
      SCHEMA_OK=true
    fi
  elif command -v python3 >/dev/null && python3 -c "import jsonschema" 2>/dev/null; then
    if python3 -c "
    import json, sys
    with open('${SCHEMA_FILE}') as f:
        schema = json.load(f)
    with open('${PROFILE_FILE}') as f:
        profile = json.load(f)
    import jsonschema
    try:
        jsonschema.validate(instance=profile, schema=schema)
        sys.exit(0)
    except jsonschema.ValidationError as e:
        print(f'Schema error: {e.message}', file=sys.stderr)
        sys.exit(1)
    " 2>/dev/null; then
      SCHEMA_OK=true
    fi
  fi
  if $SCHEMA_OK; then
    info "Profile JSON valid — matches schema"
  else
    warn "Profile schema validation unavailable or failed"
  fi
fi

# Exit early if --validate only
if $VALIDATE_ONLY; then
  info "Profile validation complete: ${PROFILE_FILE}"
  exit 0
fi

# ── read keybindings from profile ───────────────────────────────────────────
SUPER_MOD=$(jq -r '.keybindings.super_mod // "SUPER"' "${PROFILE_FILE}")
BINDINGS_COUNT=$(jq '.keybindings.bindings | length' "${PROFILE_FILE}")

if [[ "${BINDINGS_COUNT}" -eq 0 ]]; then
  warn "No keybindings defined in profile '${PROFILE_NAME}' — generating empty custom.lua"
fi

# ── generate Lua ────────────────────────────────────────────────────────────
generate() {
  local header_printed=false

  while IFS=$'\t' read -r mods_json key command description locked repeating disable_workspace_consume bind_type mouse button submap_entry; do
    # Build modifier string: SUPER + SHIFT + ... or empty for bare keys
    local mod_string=""
    local mods_count
    mods_count=$(echo "${mods_json}" | jq 'length' 2>/dev/null || echo "0")
    local bind_type="${bind_type:-press}"
    local mouse="${mouse:-false}"
    local button="${button:-}"
    local submap_entry="${submap_entry:-}"

    if [[ "${mods_count}" -gt 0 ]]; then
      # Collect mods (already uppercase from JSON)
      while IFS= read -r mod; do
        mod_string="${mod_string}${mod} + "
      done < <(echo "${mods_json}" | jq -r '.[]')
      mod_string="${mod_string}${key}"
    else
      # Bare key (F1, code:238, etc.) — no SUPER prefix
      mod_string="${key}"
    fi

    # Build Lua options table
    local opts=""
    local opts_parts=()
    if [[ "${locked}" == "true" ]]; then opts_parts+=("locked = true"); fi
    if [[ "${repeating}" == "true" ]]; then opts_parts+=("repeating = true"); fi
    if [[ "${disable_workspace_consume}" == "true" ]]; then opts_parts+=("disable_workspace_consume = true"); fi

    if [[ ${#opts_parts[@]} -gt 0 ]]; then
      local joined=""
      local first=true
      for part in "${opts_parts[@]}"; do
        if $first; then
          joined="${part}"
          first=false
        else joined="${joined}, ${part}"; fi
      done
      opts="{ ${joined}, description = \"${description}\" }"
    else
      opts="{ description = \"${description}\" }"
    fi

    # Determine binding function: hl.bind(), hl.bindl(), or hl.mouse_bind()
    local bind_fn="hl.bind"
    local mod_display="${mod_string}"
    if [[ "${bind_type}" == "release" ]]; then
      bind_fn="hl.bindl"
    fi
    if [[ "${mouse}" == "true" && -n "${button}" ]]; then
      bind_fn="hl.mouse_bind"
      # Mouse bindings: use button name instead of key in the mod string
      if [[ "${mods_count}" -gt 0 ]]; then
        # Remove trailing " + " and append button
        local mod_prefix="${mod_string% + *}"
        mod_display="${mod_prefix} + ${button}"
      else
        mod_display="${button}"
      fi
    fi

    # Handle submap_entry
    local cmd="${command}"
    if [[ -n "${submap_entry}" && "${command}" != hl.submap* ]]; then
      cmd="hl.submap('${submap_entry}')"
    fi

    # Emit header comment on first binding
    if ! $header_printed; then
      cat <<LUA_HEADER
-- ============================================================================
-- custom.lua — AUTO-GENERATED by generate-custom-lua.sh
-- Source: ${PROFILE_FILE}
-- Last generated: $(date '+%Y-%m-%d %H:%M:%S')
-- ============================================================================
-- Edit the profile JSON (${PROFILE_NAME}.json) and re-run this script.
-- Manual changes to this file will be overwritten.
-- ============================================================================

local mainMod = "${SUPER_MOD}"

-- Keybindings (${BINDINGS_COUNT} total)
LUA_HEADER
      header_printed=true
    fi

    cat <<LUA_BINDING

-- ${description}
${bind_fn}(
  "${mod_display}",
  hl.dsp.exec_cmd("${cmd}"),
  ${opts}
)
LUA_BINDING
  done

  # Close with a blank line
  echo ""
}

# ── build the file ──────────────────────────────────────────────────────────
build() {
  # Extract bindings from JSON, flatten options onto each record as tab-separated fields
  jq -r '
    .keybindings.bindings[] |
    [
      ((.mods // []) | @json),
      .key,
      .command,
      .description,
      (.options.locked // false),
      (.options.repeating // false),
      (.options.disable_workspace_consume // false),
      (.bind_type // "press"),
      (.mouse // false),
      (.button // ""),
      (.submap_entry // "")
    ] | @tsv
  ' "${PROFILE_FILE}" | generate
}

# ── dry-run or write ────────────────────────────────────────────────────────
if $DRY_RUN; then
  echo "═══ Dry-run: ${PROFILE_FILE} ═══"
  echo ""
  build
  echo ""
  echo "═══ Would write to: ${OUTPUT} ═══"
  exit 0
fi

mkdir -p "$(dirname "${OUTPUT}")"
build >"${OUTPUT}"

# Verify Lua syntax
if command -v luac >/dev/null; then
  if luac -p "${OUTPUT}" 2>/dev/null; then
    info "Generated: ${OUTPUT} (${BINDINGS_COUNT} bindings from ${PROFILE_NAME})"
  else
    warn "Lua syntax check FAILED — check ${OUTPUT} for errors"
    exit 1
  fi
else
  info "Generated: ${OUTPUT} (${BINDINGS_COUNT} bindings from ${PROFILE_NAME}) — luac not available, syntax not verified"
fi
