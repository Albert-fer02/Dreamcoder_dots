# PI CLI Dreamcoder Theme Design

## Goal

Apply the Dreamcoder visual identity to the PI CLI globally.

## Approved Approach

Use the existing token-driven generator (`scripts/sync-dreamcoder-theme.py`) as the single source of truth. The generator writes the active mode to `~/.pi/agent/themes/dreamcoder.json` and safely updates `~/.pi/agent/settings.json` with `"theme": "dreamcoder"`.

## Runtime Architecture

`DreamcoderThemes/dreamcoder/tokens.json` defines dark, light, and dusk palettes. `apply-theme-mode.sh` sets `DREAMCODER_THEME_MODE` and calls `sync-dreamcoder-theme.py`. The sync script generates all existing terminal/editor outputs plus the PI CLI theme. PI reads the theme globally from `~/.pi/agent/themes/dreamcoder.json`.

## Theme Mapping

PI requires 51 color tokens. Dreamcoder maps core UI tokens from canonical colors (`accent`, `accent_2`, `diagnostic`, `sage`, `error`, `warning`, `muted`, `subtle`, `border_ui`) and syntax tokens from the guarded mapping already used for opencode/Codex. Text tokens that PI examples leave as terminal defaults remain `""` where appropriate.

## Settings Safety

The settings merge only adds or updates the `theme` field. Existing provider, model, packages, MCP, and user settings remain untouched. Invalid JSON is treated as an empty settings file, matching the existing opencode settings behavior.

## Verification

Automated tests validate generation without touching the real home directory by using temporary `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `PI_AGENT_DIR`, and output path overrides. `scripts/verify.sh` validates the global PI theme file and settings.
