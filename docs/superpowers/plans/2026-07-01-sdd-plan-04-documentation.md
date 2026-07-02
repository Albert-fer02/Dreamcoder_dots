# SDD Plan 04: Documentation & Developer Experience

> **Goal:** Create crystal-clear documentation for the 3-step install flow (Gentleman.Dots → ML4W → dreamcoder-dots), plus a comparison page showing what dreamcoder adds vs the competition.
> **Target:** README.md overhaul, INSTALL.md creation, COMPARISON.md creation
> **Priority:** 🟡 HIGH — without docs, nobody knows how to use dreamcoder
> **Estimated diff:** ~500 lines across 5 files

## Context

The biggest problem with dreamcoder-dots currently is that **nuevo usuario no sabe cómo instalarlo ni qué hace**. La documentación actual asume que el usuario sabe que necesita Gentleman.Dots + ML4W primero.

## Scope

### README.md Overhaul

Current: Technical description of theme pipeline, focused on developers contributing.
Target: **User-centric** — "How to get Dreamcoder running in 10 minutes."

Sections:

```markdown
# Dreamcoder OS

> La capa visual premium para Gentleman.Dots + ML4W.
> Café/Lúcuma. Ember Noir. Contraste saludable. Identidad.

## Quick Start (3-Step Install)

### 1. Install Gentleman.Dots

`brew install gentleman-dots` or download from GitHub
→ Provides: Neovim (29 plugins), Ghostty shaders, Tmux/Zellij, Vim Trainer, Fish/Zsh/Nushell

### 2. Install ML4W OS

`bash <(curl -s https://ml4w.com/os/stable)`
→ Provides: Hyprland config, Waybar, Rofi, Dunst, animations, keybindings

### 3. Install Dreamcoder

`git clone ... && ./scripts/dreamcoder install`
→ **Applies**: dreamcoder dark/light/dusk color system across all components
→ **Adds**: custom shell aliases, AI session prompt, smart functions, auto-theme-switching
```

### New Files

| File                     | Purpose                                                          |
| ------------------------ | ---------------------------------------------------------------- |
| `INSTALL.md`             | Detailed install guide with screenshots                          |
| `COMPARISON.md`          | What dreamcoder adds vs Gentleman alone vs ML4W alone            |
| `docs/ai-integration.md` | How dreamcoder integrates with Claude/OpenCode/Pi                |
| `docs/theme-tokens.md`   | Reference for tokens.json (schema, guardrails, color philosophy) |

### COMPARISON.md Content

| Feature              | Gentleman.Dots      | ML4W             | dreamcoder-dots                   |
| -------------------- | ------------------- | ---------------- | --------------------------------- |
| Hyprland config      | ❌                  | ✅ Complete      | 🔶 Color overlay only             |
| Neovim plugins       | ✅ 29 plugins       | ❌               | 🔶 Dreamcoder colorscheme         |
| Shell configs        | ✅ Fish/Zsh/Nushell | ✅ Fish/Bash     | 🔶 Aliases + functions overlay    |
| Theme engine         | ❌ Uses catppuccin  | ✅ Matugen-based | ✅ **Token-based with WCAG/APCA** |
| Light/Dark switching | ❌                  | ✅               | ✅ **+ Dusk transition mode**     |
| AI integration       | ✅ Neovim plugins   | ❌               | ✅ **+ AI session in prompt**     |
| Ghostty shaders      | ✅ 45+ GLSL         | ❌               | 🔶 Uses Gentleman's shaders       |
| Installer            | ✅ Go TUI           | ✅ bash script   | ✅ **Go TUI with Vim Trainer**    |
| Prompt               | ❌ Basic            | ❌ Basic         | ✅ **Starship with AI state**     |
| Accessibility        | ❌                  | ❌               | ✅ **WCAG 4.5:1 + APCA guards**   |

## Acceptance Criteria

1. New user can follow INSTALL.md from zero to dreamcoder desktop in under 30 minutes
2. COMPARISON.md answers "why should I use dreamcoder?" in one glance
3. README.md has the 3-step install flow prominently at the top
4. All docs link to the actual source repos for Gentleman.Dots and ML4W
5. ai-integration.md explains how dreamcoder's Pi theme works with the user's Pi agent

## Tasks

### Task 1: README.md Rewrite

- Rewrite with 3-step install flow as hero section
- Add badges: "Works with Gentleman.Dots" + "Works with ML4W" + "WCAG/APCA Certified"
- Add screenshot showcase (dark mode, light mode, command-line)
- Add philosophy section (health > flashiness)
- Keep tech stack and architecture sections but move lower

### Task 2: INSTALL.md

- Prerequisites (Gentleman.Dots, ML4W, Arch Linux)
- Step-by-step with screenshots
- Post-install verification checklist
- Troubleshooting section

### Task 3: COMPARISON.md

- Feature comparison table
- "What stays from Gentleman" section
- "What stays from ML4W" section
- "What dreamcoder adds" section
- Screenshot comparison (same app, different theme)

### Task 4: AI Integration Docs

- How dreamcoder integrates with Pi agent themes
- How dreamcoder's tokens interact with opencode themes
- How AI session prompt module works

### Task 5: Theme Tokens Reference

- Visual reference for every token in tokens.json
- Explanation of WCAG 4.5:1 and APCA minimums
- How to add a new token
- Color ramp visualization (hex values displayed as color swatches)

## Risks

- **Link rot**: Links to Gentleman.Dots and ML4W repos must stay current
- **Version drift**: Screenshots become outdated as themes evolve — use generated previews instead
- **Translation**: Spanish README would be nice-to-have but out of scope for now

## References

- Current README: `README.md`
- Existing docs: `docs/README.md`, `docs/installation/macos.md`, `docs/installation/linux.md`
- Gentleman.Dots README: (bilingual EN+ES) — reference for format
- ML4W README: (professional, well-structured) — reference for professional tone
- Theme tokens: `DreamcoderThemes/dreamcoder/tokens.json`
- Theme preview: `docs/dreamcoder-theme-preview.md`
