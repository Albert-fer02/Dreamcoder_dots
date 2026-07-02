#!/usr/bin/env bash
# ==========================================================
# Install Dreamcoder theme hooks — symlinks, includes, copies
# ==========================================================
# Run this ONCE to wire up the new Dreamcoder theme snippets
# to their respective apps. Idempotent and safe.
#
# Usage:
#   ./install-dreamcoder-hooks.sh           # normal run
#   ./install-dreamcoder-hooks.sh --dry-run # preview only
#   ./install-dreamcoder-hooks.sh --help    # this message
# ==========================================================
set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && {
  sed -n '/^# ==========/,/^# ==/p' "$0" | grep -E '^# ' | sed 's/^# //'
  exit 0
}

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEME_DIR="${ROOT}/DreamcoderThemes/dreamcoder"

# ---- helpers ----
info()  { printf '  ✓ %s\n' "$*"; }
warn()  { printf '  ⚠ %s\n' "$*" >&2; }
skip()  { printf '  – %s\n' "$*"; }
dry()   { [[ "${DRY_RUN}" != "true" ]] && return 0; printf '  ~ would: %s\n' "$*"; }
run()   { dry "$@"; [[ "${DRY_RUN}" == "true" ]] && return 0; "$@" || warn "failed: $*"; }
ln_sf() { local src="$1" dst="$2"; mkdir -p "$(dirname "${dst}")" 2>/dev/null || true; run ln -sf "${src}" "${dst}"; info "${dst} → ${src}"; }

# ---- Detect mode ----
DC_MODE="${DREAMCODER_THEME_MODE:-dark}"
DC_THEME_FILE="${THEME_DIR}/nvim-dreamcoder-${DC_MODE}.lua"

echo "== Dreamcoder Theme Hooks Installer =="
echo "  Mode: ${DC_MODE}"
echo "  Theme dir: ${THEME_DIR}"
echo "  Dry run: ${DRY_RUN}"
echo ""

# ---- 1. Neovim ----
echo "── Neovim ──"
NVIM_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"
NVIM_LUA_DIR="${NVIM_DIR}/lua"
if [[ -d "${NVIM_DIR}" ]]; then
  run mkdir -p "${NVIM_LUA_DIR}"
  ln_sf "${DC_THEME_FILE}" "${NVIM_LUA_DIR}/dreamcoder.lua"
  # Also symlink to colors/ for :colorscheme support
  run mkdir -p "${NVIM_DIR}/colors"
  ln_sf "${DC_THEME_FILE}" "${NVIM_DIR}/colors/dreamcoder.lua"

  # Add colorscheme to init.lua if not present
  if [[ -f "${NVIM_DIR}/init.lua" ]] && ! grep -q 'colorscheme.*dreamcoder' "${NVIM_DIR}/init.lua" 2>/dev/null; then
    {
      echo ""
      echo "-- Dreamcoder colorscheme"
      echo 'vim.cmd.colorscheme("dreamcoder")'
    } >> "${NVIM_DIR}/init.lua"
    info "Added vim.cmd.colorscheme('dreamcoder') to init.lua"
  elif [[ -f "${NVIM_DIR}/init.lua" ]]; then
    info "Neovim already uses dreamcoder colorscheme."
  else
    warn "No init.lua found. Create one with:"
    warn "  vim.cmd.colorscheme('dreamcoder')"
  fi
else
  skip "Neovim config dir not found at ${NVIM_DIR}"
fi

# ---- 2. Btop ----
echo ""
echo "── Btop ──"
BTOP_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/btop"
BTOP_THEMES="${BTOP_DIR}/themes"
if command -v btop &>/dev/null; then
  run mkdir -p "${BTOP_THEMES}"
  ln_sf "${THEME_DIR}/btop-dreamcoder-${DC_MODE}.theme" "${BTOP_THEMES}/dreamcoder.theme"
  info "Select 'dreamcoder' in Btop → Options → Color Theme"
else
  skip "Btop not installed. Symlink created anyway if you install later."
  run mkdir -p "${BTOP_THEMES}"
  ln_sf "${THEME_DIR}/btop-dreamcoder-${DC_MODE}.theme" "${BTOP_THEMES}/dreamcoder.theme"
fi

# ---- 3. Dunst ----
echo ""
echo "── Dunst ──"
DUNST_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/dunst"
DUNST_INCLUDE="${DUNST_DIR}/dreamcoder-dunst.conf"
if command -v dunst &>/dev/null || [[ -d "${DUNST_DIR}" ]]; then
  run mkdir -p "${DUNST_DIR}"
  ln_sf "${THEME_DIR}/dunst-dreamcoder-${DC_MODE}.conf" "${DUNST_INCLUDE}"

  # Ensure include is in dunstrc
  DUNSTRC="${DUNST_DIR}/dunstrc"
  if [[ -f "${DUNSTRC}" ]] && ! grep -q 'dreamcoder-dunst' "${DUNSTRC}" 2>/dev/null; then
    warn "Add to ${DUNSTRC}:"
    warn "  [include] ${DUNST_INCLUDE}"
  elif [[ -f "${DUNSTRC}" ]]; then
    info "Dunst already includes dreamcoder theme."
  else
    warn "No dunstrc found. Start with:"
    warn "  echo '[include] ${DUNST_INCLUDE}' > ${DUNSTRC}"
  fi
else
  skip "Dunst not installed. Symlink created anyway."
  run mkdir -p "${DUNST_DIR}"
  ln_sf "${THEME_DIR}/dunst-dreamcoder-${DC_MODE}.conf" "${DUNST_INCLUDE}"
fi

# ---- 4. Cava ----
echo ""
echo "── Cava ──"
CAVA_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/cava"
CAVA_CONFIG="${CAVA_DIR}/config"
CAVA_INCLUDE="${CAVA_DIR}/dreamcoder-cava.config"
if command -v cava &>/dev/null || [[ -d "${CAVA_DIR}" ]]; then
  run mkdir -p "${CAVA_DIR}"
  ln_sf "${THEME_DIR}/cava-dreamcoder-${DC_MODE}.config" "${CAVA_INCLUDE}"

  if [[ -f "${CAVA_CONFIG}" ]] && ! grep -q 'dreamcoder-cava' "${CAVA_CONFIG}" 2>/dev/null; then
    warn "Add to ${CAVA_CONFIG}:"
    warn "  [include] dreamcoder-cava.config"
  elif [[ -f "${CAVA_CONFIG}" ]]; then
    info "Cava already includes dreamcoder theme."
  else
    warn "No cava config found. Create one that includes:"
    warn "  [include] dreamcoder-cava.config"
  fi
else
  skip "Cava not installed. Symlink created anyway."
  run mkdir -p "${CAVA_DIR}"
  ln_sf "${THEME_DIR}/cava-dreamcoder-${DC_MODE}.config" "${CAVA_INCLUDE}"
fi

# ---- 5. Firefox ----
echo ""
echo "── Firefox ──"
FIREFOX_PROFILE=""
# Try to find the default Firefox profile
for profile_dir in "${HOME}/.mozilla/firefox/"*.default* "${HOME}/.mozilla/firefox/"*.default-release; do
  if [[ -d "${profile_dir}/chrome" ]] || [[ -d "${profile_dir}" ]]; then
    FIREFOX_PROFILE="${profile_dir}"
    break
  fi
done
if [[ -n "${FIREFOX_PROFILE}" ]]; then
  CHROME_DIR="${FIREFOX_PROFILE}/chrome"
  run mkdir -p "${CHROME_DIR}"
  ln_sf "${THEME_DIR}/firefox-dreamcoder-${DC_MODE}.css" "${CHROME_DIR}/userChrome.css"
  warn "Firefox: set toolkit.legacyUserProfileCustomizations.stylesheets = true in about:config"
else
  warn "Firefox profile not found. To install manually:"
  warn "  Copy ${THEME_DIR}/firefox-dreamcoder-${DC_MODE}.css to:"
  warn "  ~/.mozilla/firefox/<profile>/chrome/userChrome.css"
fi

# ---- 6. Obsidian ----
echo ""
echo "── Obsidian ──"
# Guess the most common Obsidian vault locations
OBSIDIAN_VAULTS=()
for v in "${HOME}/Documents"/*; do
  [[ -d "${v}/.obsidian/snippets" ]] && OBSIDIAN_VAULTS+=("${v}")
done
if [[ ${#OBSIDIAN_VAULTS[@]} -gt 0 ]]; then
  for vault in "${OBSIDIAN_VAULTS[@]}"; do
    SNIPPETS_DIR="${vault}/.obsidian/snippets"
    run mkdir -p "${SNIPPETS_DIR}"
    ln_sf "${THEME_DIR}/obsidian-dreamcoder-${DC_MODE}.css" "${SNIPPETS_DIR}/dreamcoder.css"
  done
  warn "Obsidian: Enable 'dreamcoder' CSS snippet in Settings → Appearance → CSS snippets"
else
  warn "No Obsidian vaults found with .obsidian/snippets. To install:"
  warn "  Copy ${THEME_DIR}/obsidian-dreamcoder-${DC_MODE}.css to:"
  warn "  <your-vault>/.obsidian/snippets/dreamcoder.css"
fi

# ---- 7. Delta (git) ----
echo ""
echo "── Git Delta ──"
GIT_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/git"
GIT_DELTA_LINK="${GIT_CONFIG_DIR}/delta-dreamcoder.gitconfig"
run mkdir -p "${GIT_CONFIG_DIR}"
ln_sf "${THEME_DIR}/delta-dreamcoder-${DC_MODE}.gitconfig" "${GIT_DELTA_LINK}"

GIT_CONFIG="${GIT_CONFIG_DIR}/config"
if [[ -f "${GIT_CONFIG}" ]] && grep -q 'delta-dreamcoder' "${GIT_CONFIG}" 2>/dev/null; then
  info "Git config already includes delta-dreamcoder.gitconfig"
else
  warn "Add to ${GIT_CONFIG}:"
  warn "  [include]"
  warn "      path = ~/.config/git/delta-dreamcoder.gitconfig"
fi

# ---- Summary ----
echo ""
echo "== Done =="
echo ""
echo "What's next:"
echo "  1. Reload your shell: exec zsh"
echo "  2. For Neovim: add 'require(\"dreamcoder\")' to init.lua"
echo "  3. For Btop: select theme in UI"
echo "  4. For Dunst: restart: pkill dunst && dunst &"
echo "  5. Firefox: enable userChrome in about:config"
echo "  6. Obsidian: enable snippet in Settings"
echo ""
echo "Theme files auto-update on each sync-dreamcoder-theme.py run."
echo "Mode switching (dark/light) is automatic via apply-theme-mode.sh."
