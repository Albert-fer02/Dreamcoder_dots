#!/usr/bin/env bash
# ============================================================================
# setup-hyprland.sh — Wire Dreamcoder theme into ML4W Hyprland environment
# ============================================================================
# Idempotent setup that integrates Dreamcoder theme colours and keybindings
# into an existing ML4W Hyprland installation.
#
# Usage:
#   ./scripts/setup-hyprland.sh                 # auto-detect profile
#   ./scripts/setup-hyprland.sh --profile asus-vivobook15  # explicit profile
#   ./scripts/setup-hyprland.sh --dry-run                 # preview only
#   ./scripts/setup-hyprland.sh --help                    # this message
#
# What it does:
#   1. Symlinks wlogout/colors.css → waybar/colors.css
#   2. Symlinks swaync/colors.css  → waybar/colors.css
#   3. Generates ~/.config/hypr/custom.lua from machine profile
#   4. Installs dreamcoder-toggle-theme.sh to ~/.config/hypr/scripts/
#   5. Applies wallpaper hooks (calls apply-ml4w-hooks.sh)
#   6. Reloads Hyprland configuration
#   7. Logs a summary of the integration
#
# Dependencies:
#   - jq (for custom.lua generation)
#   - luac (optional, for Lua syntax verification)
#   - Hyprland running (for reload)
# ============================================================================
set -euo pipefail

# ── configuration ───────────────────────────────────────────────────────────
DREAMCODER_DOTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS_DIR="${DREAMCODER_DOTS_DIR}/ml4w_assets"
GENERATOR="${DREAMCODER_DOTS_DIR}/scripts/generate-custom-lua.sh"
ML4W_HOOKS="${DREAMCODER_DOTS_DIR}/scripts/apply-ml4w-hooks.sh"

# System target paths
HYPR_DIR="${HOME}/.config/hypr"
HYPR_SCRIPTS="${HYPR_DIR}/scripts"
WLOGOUT_DIR="${HOME}/.config/wlogout"
SWAYNC_DIR="${HOME}/.config/swaync"

# Source assets
TOGGLE_SOURCE="${ASSETS_DIR}/hypr/scripts/dreamcoder-toggle-theme.sh"
TOGGLE_TARGET="${HYPR_SCRIPTS}/dreamcoder-toggle-theme.sh"

# ── flags ──────────────────────────────────────────────────────────────────
DRY_RUN=false
PROFILE_NAME=""

# ── helpers ─────────────────────────────────────────────────────────────────
info() { printf '  ✓ %s\n' "$*"; }
warn() { printf '  ⚠ %s\n' "$*" >&2; }
step() { printf '  • %s\n' "$*"; }
ok() { printf '  ✅ %s\n' "$*"; }
die() {
  printf '✖ %s\n' "$*" >&2
  exit 1
}
usage() {
  grep -E '^# ' "$0" | sed -n '4,/^$/{s/^# //;p}' | head -n -2
  echo ""
  echo "Options:"
  echo "  --profile NAME   Machine profile (default: auto-detect)"
  echo "  --dry-run        Preview changes without applying"
  echo "  --verbose        Show detailed output"
  echo "  --help, -h       Show this help"
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --profile)
    shift
    PROFILE_NAME="$1"
    ;;
  --dry-run) DRY_RUN=true ;;
  --help | -h) usage ;;
  *) die "Unknown option: $1" ;;
  esac
  shift
done

# ── profile auto-detection ─────────────────────────────────────────────────
if [[ -z "${PROFILE_NAME}" ]]; then
  HOSTNAME="$(hostname -s 2>/dev/null || echo "unknown")"
  case "$(echo "${HOSTNAME}" | tr '[:upper:]' '[:lower:]')" in
  *asus* | *vivobook*) PROFILE_NAME="asus-vivobook15" ;;
  *) PROFILE_NAME="default" ;;
  esac
  step "Auto-detected profile: ${PROFILE_NAME} (hostname: ${HOSTNAME})"
else
  step "Using profile: ${PROFILE_NAME}"
fi

# ── verify dependencies ────────────────────────────────────────────────────
if $DRY_RUN; then
  step "Dry-run mode — no files will be modified"
  echo ""
fi

command -v jq >/dev/null || die "jq is required but not installed."

# ── 1. Symlink wlogout → waybar colors ────────────────────────────────────
echo ""
echo "═══ Step 1: Symlink Wlogout colors → Waybar ═══"
if $DRY_RUN; then
  step "Would symlink: ${WLOGOUT_DIR}/colors.css → ../../waybar/colors.css"
  step "Would symlink: ${SWAYNC_DIR}/colors.css  → ../../waybar/colors.css"
else
  for target_dir in "${WLOGOUT_DIR}" "${SWAYNC_DIR}"; do
    local_colors="${target_dir}/colors.css"
    backup="${local_colors}.bak"

    if [[ -L "${local_colors}" ]]; then
      current_target=$(readlink "${local_colors}")
      if [[ "${current_target}" == "../../waybar/colors.css" ]]; then
        ok "Already linked: ${local_colors} → ${current_target}"
        continue
      fi
    fi

    # Backup if it's a regular file (not a symlink)
    if [[ -f "${local_colors}" && ! -L "${local_colors}" ]]; then
      cp "${local_colors}" "${backup}"
      info "Backed up: ${backup}"
    fi

    rm -f "${local_colors}"
    ln -sf "../../waybar/colors.css" "${local_colors}"
    info "Linked:  ${local_colors} → $(readlink "${local_colors}")"
  done
fi

# ── 2. Generate custom.lua from profile ───────────────────────────────────
echo ""
echo "═══ Step 2: Generate custom.lua from profile ═══"
if $DRY_RUN; then
  bash "${GENERATOR}" --profile "${PROFILE_NAME}" --dry-run 2>&1
else
  if [[ ! -f "${GENERATOR}" ]]; then
    die "Generator script not found: ${GENERATOR}"
  fi

  # Generate custom.lua
  bash "${GENERATOR}" --profile "${PROFILE_NAME}" 2>&1

  # Verify Lua syntax
  if command -v luac >/dev/null; then
    if luac -p "${HYPR_DIR}/custom.lua" 2>/dev/null; then
      ok "Lua syntax: valid"
    else
      warn "Lua syntax check FAILED — disabling custom.lua"
      mv "${HYPR_DIR}/custom.lua" "${HYPR_DIR}/custom.lua.err"
    fi
  fi
fi

# ── 3. Install dreamcoder-toggle-theme.sh ─────────────────────────────────
echo ""
echo "═══ Step 3: Install dreamcoder-toggle-theme.sh ═══"
if $DRY_RUN; then
  step "Would install: ${TOGGLE_TARGET}"
else
  mkdir -p "${HYPR_SCRIPTS}"
  cp "${TOGGLE_SOURCE}" "${TOGGLE_TARGET}"
  chmod +x "${TOGGLE_TARGET}"
  info "Installed: ${TOGGLE_TARGET}"

  # Verify shell syntax
  if command -v bash >/dev/null; then
    bash -n "${TOGGLE_TARGET}" && ok "Shell syntax: valid"
  fi
fi

# ── 4. Apply ML4W wallpaper hooks ─────────────────────────────────────────
echo ""
echo "═══ Step 4: Apply ML4W wallpaper hooks ═══"
if $DRY_RUN; then
  step "Would run: ${ML4W_HOOKS}"
else
  if [[ -f "${ML4W_HOOKS}" ]]; then
    bash "${ML4W_HOOKS}" 2>&1
    ok "ML4W wallpaper hooks applied"
  else
    warn "ML4W hooks script not found: ${ML4W_HOOKS} — skipping"
  fi
fi

# ── 5. Reload Hyprland ────────────────────────────────────────────────────
echo ""
echo "═══ Step 5: Reload Hyprland ═══"
if $DRY_RUN; then
  step "Would run: hyprctl reload"
else
  if command -v hyprctl >/dev/null; then
    if hyprctl reload 2>&1 | grep -q "ok"; then
      ok "Hyprland reloaded successfully"
    else
      warn "Hyprland reload failed — check config syntax"
    fi
  else
    warn "hyprctl not available — Hyprland may not be running"
  fi
fi

# ── summary ────────────────────────────────────────────────────────────────
bindings_count=0
if [[ -f "${HYPR_DIR}/custom.lua" ]]; then
  bindings_count=$(grep -c 'hl.bind' "${HYPR_DIR}/custom.lua" || true)
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅ Dreamcoder ML4W setup complete"
echo "═══════════════════════════════════════════════"
echo "  Profile:       ${PROFILE_NAME}"
echo "  Keybindings:   ${bindings_count} in custom.lua"
echo "  Toggle script: installed → ${TOGGLE_TARGET}"
echo "  Wlogout/Swaync: shared → waybar/colors.css"
echo ""
echo "  Next steps:"
echo "    1. Edit keybindings → DreamcoderProfiles/dreamcoder/${PROFILE_NAME}.json"
echo "    2. Regenerate    → ./scripts/generate-custom-lua.sh [--profile ${PROFILE_NAME}]"
echo "    3. Reload        → hyprctl reload"
echo "    4. Verify        → ./scripts/dreamcoder doctor"
echo "═══════════════════════════════════════════════"
