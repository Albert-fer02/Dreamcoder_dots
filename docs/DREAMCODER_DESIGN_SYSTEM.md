# Dreamcoder Design System

Dreamcoder is a personal developer-experience design system for Arch Linux workstations. It is not only a color theme: it is a token-governed visual operating layer for terminals, editors, shell tools, desktop chrome, notes, browser chrome, and AI coding CLIs.

## Product definition

Dreamcoder optimizes long coding sessions around three product principles:

1. **Readability before decoration**: text, selections, borders, and diagnostics must survive real terminal/editor use.
2. **Health-aware identity**: warm light mode, dusk transition, OLED-conscious Ember Noir dark mode, and no harsh pure black/white primary backgrounds.
3. **Operational resilience**: ML4W/Gentleman updates are expected; Dreamcoder must be repairable, auditable, and regenerable.

The system competes as a **developer OS design system**, not as a web component library. Its peers are theme ecosystems and workstation shells; its inspiration for rigor is Material, Carbon, Spectrum, and Fluent.

## Token contract

`themes/dreamcoder/tokens.json` is the canonical token source. Generated files must not invent independent color decisions.

Required contract:

- **Versioned token schema**: `themes/dreamcoder/tokens.schema.json` defines the public token shape.
- **Mode parity**: `light`, `dusk`, and `dark` must expose equivalent semantic roles.
- **Semantic separation**: `accent`, `accent_2`, `diagnostic`, `warning`, `error`, `comment`, `subtle`, `focus`, `border_ui`, and `border_hi` must remain distinct.
- **Generator ownership**: app-specific files are outputs; renderer modules own translation from tokens to target syntax.
- **No silent drift**: regenerated artifacts must be checked into the repo or intentionally ignored.

## Component model

Dreamcoder components are cross-application interaction primitives rather than React-style widgets.

| Component | Token roles | Applies to |
| --- | --- | --- |
| Workspace background | `bg`, `bg_soft`, `panel_rgba` | Kitty, Ghostty, Warp, opencode, Codex, Neovim |
| Raised surface | `surface0`, `surface1`, `surface2`, `module_rgba` | panels, prompts, popups, Waybar, Rofi |
| Primary text | `text`, `muted`, `subtle`, `comment` | editors, prompts, CLIs, docs |
| Selection | `selection`, `text`, `bg` | terminals, Codex CLI, Neovim visual mode |
| Focus affordance | `focus`, `border_ui`, `border_hi` | active panes, Rofi, Waybar, Neovim floating windows |
| Diagnostics | `diagnostic`, `error`, `warning`, `sage` | LSP, diffs, shell syntax, status modules |
| Motion profile | profile and motion settings | terminal cursor, Hyprland animation intent |

Every new target must map these primitives explicitly. If a target lacks one primitive, document the fallback.

## Accessibility policy

Dreamcoder uses both WCAG contrast and APCA because terminal/editor themes fail in ways that pure ratio checks miss.

Minimums:

- WCAG AA for semantic text tokens.
- WCAG AAA target for main text where practical.
- APCA body floors from `tokens.json` guardrails.
- APCA UI floors for borders/focus affordances.
- Selection must be visibly stronger than passive surfaces.
- Meaningful borders use `border_ui` or `border_hi`; decorative borders may use `border`.

Verification commands:

```bash
./scripts/verify-theme-health.py
pytest -q tests/test_dreamcoder_theme_quality.py tests/test_nvim_readability.py tests/test_dreamcoder_global_design_system.py
```

Visual regression is mandatory for top-tier maturity. Run `./scripts/dreamcoder visual plan --json` to list required screenshot baselines, then capture representative screenshots for Neovim, Kitty/Ghostty, Waybar, Rofi, Codex CLI, and opencode before accepting palette changes.

## Governance

Dreamcoder changes follow this governance model:

1. **Token-first changes**: update `tokens.json` before renderer outputs.
2. **Test-first regressions**: every readability bug gets a failing test before the fix.
3. **Generated-output discipline**: run the generator after token or renderer changes.
4. **Release notes**: user-visible theme, CLI, repair, or governance changes need a changelog entry.
5. **Compatibility check**: repair/install flows must remain safe after ML4W, Gentleman, Waypaper, or Hyprland updates.

Review questions before merge:

- Does this preserve light/dusk/dark parity?
- Did any renderer hardcode a color that should be a token?
- Did APCA/WCAG checks run after generation?
- Is there a rollback path if the change affects user machine state?

## Release readiness checklist

A Dreamcoder release is ready only when all items are true:

- `./scripts/dreamcoder verify` passes.
- `./scripts/verify-theme-health.py` passes.
- Full pytest suite passes.
- Theme preview has been regenerated when tokens changed.
- Operator report has been regenerated when CLI/control behavior changed.
- Token schema remains valid and documented.
- New app targets include install, repair, and fallback notes.
- Risky machine changes create or document backups.

## Maturity gap to global top systems

Current strength: Dreamcoder has a strong token engine, broad target coverage, health checks, and a control-center direction.

Remaining gap: global design systems also ship component APIs, formal contribution governance, public examples, adoption guides, visual regression infrastructure, and long-term versioning guarantees. Dreamcoder should grow in that order: **accessibility gates -> visual regression -> component docs -> release governance -> public examples**.
