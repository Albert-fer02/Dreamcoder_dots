# Dreamcoder Workbench Theme System

## Architecture

Three-layer design system:

```txt
primitives (OKLCH ramps) → semantic tokens (tokens.json) → component themes (renderers)
```

Pipeline:

```txt
tokens.json → generate-palette-tokens.py → palette_tokens.py
           → dreamcoder sync → generated theme files for every configured renderer
```

## Canonical tokens

Single source of truth: [`DreamcoderThemes/dreamcoder/tokens.json`](../../DreamcoderThemes/dreamcoder/tokens.json)

Dark (**Dark Black OLED**), light (**Cocoa/Lúcuma**), and the derived night
variant share the same semantic key set. Dark uses pure black only for the root
canvas; scrollable workspaces and editors use `surface0` (`#060608`) to reduce
OLED smear, panels use `surface1`, cards use `surface2`, and modals use
`surface3`.

| Layer       | Examples                                                       |
| ----------- | -------------------------------------------------------------- |
| Surfaces    | `bg`, `bg_soft`, `surface0`–`surface3`                         |
| Text        | `text`, `text_heading`, `muted`, `subtle`, `comment`           |
| Brand       | `accent`, `accent_2`, `link`, `link_hover`                     |
| Feedback    | `error`, `warning`, `success`, `info`, `diagnostic`            |
| On-colors   | `on_surface`, `on_accent`, `on_error`, `on_focus`              |
| Interaction | `selection_bg`, `selection_fg`, `hover`, `pressed`, `disabled` |
| Chrome      | `border`, `border_ui`, `border_hi`, `focus`, `panel_rgba`      |

## Regenerating themes

After editing `tokens.json`:

```bash
./scripts/generate-palette-tokens.py       # sync palette_tokens.py + derived tokens
python scripts/generate-dark-oled-css.py   # sync dark-black-oled.css variables
./scripts/dreamcoder sync                  # propagate to all targets
./scripts/verify-theme-health.py           # WCAG + APCA gates (light and dark)
```

CI or local drift checks can use:

```bash
python scripts/generate-palette-tokens.py --check
python scripts/generate-dark-oled-css.py --check
```

## Quality gates

- WCAG 2.2: body text ≥ 4.5:1 (main text ≥ 7:1)
- APCA: body Lc ≥ 75 light / ≥ 50 dark; `on_accent` Lc ≥ 54 on filled accent
- CI validates **both** light and dark Kitty, Starship, Ghostty, Waybar, Hypr, Rofi, Btop, Dunst, Fzf

## Design decisions

- **brand alias** = indigo `#6366F1`; the runtime `accent` is a lighter accessible role where filled controls must pass the existing WCAG/APCA gates
- **focus** = blue `#3B82F6`, kept distinct from brand and diagnostic colors
- **border aliases** = `#12121A` (subtle) and `#1F1F2B` (medium); significant runtime borders remain brighter because the non-text contrast gate is not weakened
- **generated CSS** = [`dark-black-oled.css`](../../DreamcoderThemes/dreamcoder/dark-black-oled.css), sourced only from `tokens.json`
- **adaptive/matugen** may tint surfaces but identity tokens win per `CLAUDE.md`

## Adding new targets

1. Create renderer in `src/dreamcoder_theme/renderers_<target>.py`
2. Map semantic tokens (never raw hex in renderers)
3. Register in `src/dreamcoder_theme/sync.py`
4. Run `./scripts/dreamcoder sync`
