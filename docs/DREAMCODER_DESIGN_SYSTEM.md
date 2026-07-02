# Dreamcoder Design System

Dreamcoder is a personal developer-experience design system for Arch Linux workstations. It is not only a color theme: it is a token-governed visual operating layer for terminals, editors, shell tools, desktop chrome, notes, browser chrome, and AI coding CLIs.

## Product definition

Dreamcoder optimizes long coding sessions around three product principles:

1. **Readability before decoration**: text, selections, borders, and diagnostics must survive real terminal/editor use.
2. **Health-aware identity**: warm light mode, dusk transition, OLED-conscious Ember Noir dark mode, and no harsh pure black/white primary backgrounds.
3. **Operational resilience**: ML4W/Gentleman updates are expected; Dreamcoder must be repairable, auditable, and regenerable.

The system competes as a **developer OS design system**, not as a web component library. Its peers are theme ecosystems and workstation shells; its inspiration for rigor is Material, Carbon, Spectrum, and Fluent.

## Token contract

`DreamcoderThemes/dreamcoder/tokens.json` is the canonical token source. Generated files must not invent independent color decisions.

Required contract:

- **Versioned token schema**: `DreamcoderThemes/dreamcoder/tokens.schema.json` defines the public token shape.
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

Dreamcoder uses WCAG 2.1 contrast as the authoritative standard. APCA is evaluated as an advisory metric (it remains in public beta per Myndex/apca-w3, not yet approved for WCAG 3).

Minimums:

- WCAG AA (4.5:1) for semantic text tokens.
- WCAG AAA (7:1) target for main text where practical.
- Terminal ANSI colors must stay at WCAG AA against each mode background.
- Terminal cursor and selection pairs have explicit contrast floors in `tokens.json`.
- Meaningful borders use `border_ui` or `border_hi`; decorative borders may use `border`.

**APCA advisory thresholds (public beta, non-binding):**

- Body text: Lc 75 (matches WCAG AAA target)
- UI affordances: Lc 30 (matches WCAG any-text minimum)
- Quiet text: Lc 45 (matches WCAG large/heavy text tier)

Ve `DreamcoderThemes/dreamcoder/tokens.json` guardrails for current values.

## Governance

Dreamcoder changes follow this governance model:

1. **Token-first changes**: update `tokens.json` before renderer outputs. Token changes trigger preview regeneration.
2. **Dual-source warning**: `palette_tokens.py` exists as runtime fallback but `tokens.json` is canonical. Warnings are emitted at runtime if drift detected.
3. **Test-first regressions**: every readability bug gets a failing test before the fix.
4. **CI gate**: theme changes require `verify-theme-health.py` + pytest pass.
5. **Release notes**: user-visible theme, CLI, repair, or governance changes need a changelog entry.
6. **Compatibility check**: repair/install flows must remain safe after ML4W, Gentleman, Waypaper, or Hyprland updates.

⚠️ **Known token gaps (quedan pendientes):**

- Dark mode `diagnostic` color (#5f95ca) scores APCA Lc ~43 — below the Lc 75 advisory threshold. However WCAG 2.1 rates it at 6.00:1 (AA pass). This is a documented design tradeoff.

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
