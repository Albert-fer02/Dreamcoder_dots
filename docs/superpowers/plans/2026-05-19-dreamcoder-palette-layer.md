# Dreamcoder Palette Layer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Dreamcoder palette layer with dark and light variants while preserving ML4W/Gentleman Dots behavior.

**Architecture:** Keep compositor/window-manager behavior untouched and centralize color output in `scripts/sync-dreamcoder-theme.py`. Generate active terminal/prompt themes plus sibling light/dark variants and portable ML4W-style snippets under `DreamcoderThemes/dreamcoder/`.

**Tech Stack:** Python theme generator, Ghostty, Kitty, Warp, Starship, CSS/Rasi/Hyprland snippets.

---

### Task 1: Centralize Dreamcoder semantic palettes

**Files:**

- Modify: `scripts/sync-dreamcoder-theme.py`
- Create: `DreamcoderThemes/dreamcoder/README.md`

- [x] Define dark palette inspired by Warp Terminal AI dark glass.
- [x] Define light palette inspired by OpenAI/Codex App neutral UI.
- [x] Keep `Dreamcoder` naming as the public identity and `Dreamcoder` as the only visible identity.

### Task 2: Generate app themes without rewriting app behavior

**Files:**

- Modify: `DreamcoderGhostty/.config/ghostty/themes/dreamcoder`
- Create: `DreamcoderGhostty/.config/ghostty/themes/dreamcoder-light`
- Modify: `DreamcoderKitty/.config/kitty/colors-dreamcoder.conf`
- Create: `DreamcoderKitty/.config/kitty/colors-dreamcoder-light.conf`
- Modify: `DreamcoderWarp/.local/share/warp-terminal/themes/Dreamcoder.yaml`
- Create: `DreamcoderWarp/.local/share/warp-terminal/themes/Dreamcoder-Light.yaml`
- Modify: `DreamcoderShell/.config/starship.toml`
- Create: `DreamcoderShell/.config/starship-light.toml`

- [x] Make dark active by default.
- [x] Generate light variants as opt-in files.
- [x] Remove prompt time noise to match prior Dreamcoder preference.

### Task 3: Add ML4W/Gentleman-compatible snippets

**Files:**

- Create: `DreamcoderThemes/dreamcoder/hyprland-dark.conf`
- Create: `DreamcoderThemes/dreamcoder/hyprland-light.conf`
- Create: `DreamcoderThemes/dreamcoder/waybar-dark.css`
- Create: `DreamcoderThemes/dreamcoder/waybar-light.css`
- Create: `DreamcoderThemes/dreamcoder/rofi-dark.rasi`
- Create: `DreamcoderThemes/dreamcoder/rofi-light.rasi`

- [x] Provide color-only snippets.
- [x] Avoid keybind/layout/wallpaper logic changes.

### Task 4: Verify generated files

**Files:**

- Verify: generated TOML/YAML/JSON/script syntax.

- [x] Run Python compilation.
- [x] Run theme sync into repository paths.
- [x] Check git diff.
