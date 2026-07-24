# Tasks: Fix ML4W Keybindings & Waybar

## Task Breakdown

### T1: Update `default.json` Profile

- **Estimate**: 30 min
- **Dependencies**: None
- **Description**: Add 30+ standard ML4W keybindings to `DreamcoderProfiles/dreamcoder/default.json`
- **Acceptance**: `validate-ml4w-profiles.py` passes, 40+ bindings total
- **Files**: `DreamcoderProfiles/dreamcoder/default.json`

### T2: Update `asus-vivobook15.json` Profile

- **Estimate**: 15 min
- **Dependencies**: T1 (copy bindings)
- **Description**: Add same ML4W keybindings to `DreamcoderProfiles/dreamcoder/asus-vivobook15.json`, preserving laptop-specific bindings (brightness, volume, media, keyboard backlight)
- **Acceptance**: `validate-ml4w-profiles.py` passes, 50+ bindings total
- **Files**: `DreamcoderProfiles/dreamcoder/asus-vivobook15.json`

### T3: Create Waybar Config

- **Estimate**: 20 min
- **Dependencies**: None
- **Description**: Create `DreamcoderWaybar/.config/waybar/config.jsonc` with taskbar + standard modules + Dreamcoder CSS import
- **Acceptance**: Valid JSONC, contains `hyprland/workspaces` module, references Dreamcoder CSS
- **Files**: `DreamcoderWaybar/.config/waybar/config.jsonc`

### T4: Create Waybar Style

- **Estimate**: 10 min
- **Dependencies**: T3
- **Description**: Create `DreamcoderWaybar/.config/waybar/style.css` with layout-only rules (spacing, padding, fonts) and `@import` of Dreamcoder colors CSS
- **Acceptance**: Valid CSS, no color definitions (colors via import only)
- **Files**: `DreamcoderWaybar/.config/waybar/style.css`

### T5: Validate & Generate

- **Estimate**: 10 min
- **Dependencies**: T1, T2
- **Description**: Run `validate-ml4w-profiles.py` and `generate-custom-lua.sh` to verify profiles produce valid Lua
- **Acceptance**: Both scripts exit 0, Lua output syntactically valid
- **Files**: `scripts/validate-ml4w-profiles.py`, `scripts/generate-custom-lua.sh`

### T6: Integration Test

- **Estimate**: 15 min
- **Dependencies**: T1–T5
- **Description**: Verify end-to-end: profile JSON → validation → Lua generation → Waybar config loads
- **Acceptance**: All checks pass, no errors
- **Files**: All modified/created files

## Execution Order

```
T1 ──→ T2 ──→ T5 ──→ T6
T3 ──→ T4 ────────────↗
```

## Review Workload Forecast

- **Total changed lines**: ~200 (JSON additions + new config files)
- **Chained PRs recommended**: No — single cohesive change
- **400-line budget risk**: Low
- **Decision needed before apply**: No
