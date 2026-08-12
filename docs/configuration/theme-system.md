# Dreamcoder Theme System

## Architecture

Three-layer design system:

```txt
primitives (OKLCH ramps) → semantic tokens (tokens.json) → component themes (renderers)
```

Pipeline:

```txt
tokens.json → generate-palette-tokens.py → palette_tokens.py
           → dreamcoder sync → 48+ config files → 22+ targets
```

## Canonical tokens

Single source of truth: [`DreamcoderThemes/dreamcoder/tokens.json`](../../DreamcoderThemes/dreamcoder/tokens.json)

Dark (**Anthracite Steel OLED**) and light (**Cocoa/Lúcuma**) share the same semantic key set:

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
./scripts/generate-palette-tokens.py   # sync palette_tokens.py + derived tokens
./scripts/dreamcoder sync              # propagate to all targets
./scripts/verify-theme-health.py       # WCAG + APCA gates (light and dark)
```

## Quality gates

- WCAG 2.2: body text ≥ 4.5:1 (main text ≥ 7:1)
- APCA: body Lc ≥ 75 light / ≥ 50 dark; `on_accent` Lc ≥ 54 on filled accent
- CI validates **both** light and dark Kitty, Starship, Ghostty, Waybar, Hypr, Rofi, Btop, Dunst, Fzf

## Design decisions

- **accent** = lúcuma `#A5C7E8` (identity, tabs, CTAs) — Anthracite Steel dark palette
- **focus** = accent (lúcuma) — same token by design; no separate focus hue in the current palette
- **adaptive/matugen** may tint surfaces but identity tokens win per `CLAUDE.md`

## Adding new targets

1. Create renderer in `src/dreamcoder_theme/renderers_<target>.py`
2. Map semantic tokens (never raw hex in renderers)
3. Register in `src/dreamcoder_theme/sync.py`
4. Run `./scripts/dreamcoder sync`
