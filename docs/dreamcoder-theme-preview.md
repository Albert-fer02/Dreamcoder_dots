# Dreamcoder Theme Preview

Generated from `themes/dreamcoder/tokens.json`.

## Design rationale

Dreamcoder light themes follow a **cocoa/lúcuma** identity: warm parchment backgrounds, graphite-brown text, and restrained accents. Unlike generic light themes that jump from white to mid-gray surfaces, Dreamcoder uses a **flat surface ladder** (~10 luminance points between steps) so panels feel layered without looking muddy.

Dreamcoder dark uses an **Ember Noir** identity: espresso/cacao glass surfaces, warm silver text, refined orange and maple red protagonists, and gold as the support accent. The opencode theme keeps the main background as `none` so the terminal's semi-transparent background remains visible while panels and selections carry the autumn glass color.

Semantic tokens are intentionally distinct:

- `comment` is softer and lower-chroma than `subtle` (syntax vs UI chrome).
- Dark `accent` (refined ember orange), `accent_2` (maple red), `error` (soft coral red), and `warning` (lúcuma gold) form the orange/red/gold signature.
- `accent` carries brand CTAs and active chrome; `focus` is teal for keyboard/input affordance (WCAG ring).
- `on_accent`, `on_error`, and `selection_bg`/`selection_fg` are explicit pairs validated in CI.
## Palette

### Dreamcoder Ember Noir OLED

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#100f0d'></span> `#100f0d` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#181512'></span> `#181512` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#201b16'></span> `#201b16` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#2b231b'></span> `#2b231b` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#392e21'></span> `#392e21` |
| `surface3` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4a3b2a'></span> `#4a3b2a` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e8dfd0'></span> `#e8dfd0` |
| `text_heading` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f4ecdd'></span> `#f4ecdd` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c7b9aa'></span> `#c7b9aa` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#938274'></span> `#938274` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b8a99a'></span> `#b8a99a` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d99555'></span> `#d99555` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c96a45'></span> `#c96a45` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5f95ca'></span> `#5f95ca` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4db35f'></span> `#4db35f` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4db35f'></span> `#4db35f` |
| `info` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5f95ca'></span> `#5f95ca` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d4b4e6'></span> `#d4b4e6` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e29cb4'></span> `#e29cb4` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#ed8a7a'></span> `#ed8a7a` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e8b866'></span> `#e8b866` |
| `on_accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#100f0d'></span> `#100f0d` |
| `on_error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#100f0d'></span> `#100f0d` |
| `link` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d99555'></span> `#d99555` |
| `link_hover` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c96a45'></span> `#c96a45` |
| `selection_bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#2b231b'></span> `#2b231b` |
| `selection_fg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e8dfd0'></span> `#e8dfd0` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#756052'></span> `#756052` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#968878'></span> `#968878` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c8b195'></span> `#c8b195` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5f8f8f'></span> `#5f8f8f` |

### Dreamcoder Light

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f3eadc'></span> `#f3eadc` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e6d7c4'></span> `#e6d7c4` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#fff7ea'></span> `#fff7ea` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#decbb1'></span> `#decbb1` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c8ad89'></span> `#c8ad89` |
| `surface3` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b89d7a'></span> `#b89d7a` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#17120d'></span> `#17120d` |
| `text_heading` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#100c07'></span> `#100c07` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#352e22'></span> `#352e22` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#554638'></span> `#554638` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#725e4c'></span> `#725e4c` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#824f16'></span> `#824f16` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a7471c'></span> `#a7471c` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#0d4a68'></span> `#0d4a68` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3d723d'></span> `#3d723d` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3d723d'></span> `#3d723d` |
| `info` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#0d4a68'></span> `#0d4a68` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#57478b'></span> `#57478b` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#7d3e64'></span> `#7d3e64` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#842f24'></span> `#842f24` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#654300'></span> `#654300` |
| `on_accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#fff7ea'></span> `#fff7ea` |
| `on_error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#fff7ea'></span> `#fff7ea` |
| `link` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#824f16'></span> `#824f16` |
| `link_hover` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a7471c'></span> `#a7471c` |
| `selection_bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#decbb1'></span> `#decbb1` |
| `selection_fg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#17120d'></span> `#17120d` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8a7358'></span> `#8a7358` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#66513b'></span> `#66513b` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3e2f20'></span> `#3e2f20` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#0f6570'></span> `#0f6570` |

### Dreamcoder Dusk

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#ebe4d6'></span> `#ebe4d6` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#dfd5c4'></span> `#dfd5c4` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f1eadf'></span> `#f1eadf` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d8cbb8'></span> `#d8cbb8` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c6b6a0'></span> `#c6b6a0` |
| `surface3` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b6a691'></span> `#b6a691` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1a1713'></span> `#1a1713` |
| `text_heading` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#13100c'></span> `#13100c` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4c443a'></span> `#4c443a` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5a4f43'></span> `#5a4f43` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#615548'></span> `#615548` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8a5520'></span> `#8a5520` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#96411e'></span> `#96411e` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#104b67'></span> `#104b67` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#466b41'></span> `#466b41` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#466b41'></span> `#466b41` |
| `info` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#104b67'></span> `#104b67` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5b4e86'></span> `#5b4e86` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#784762'></span> `#784762` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#773126'></span> `#773126` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#604000'></span> `#604000` |
| `on_accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f1eadf'></span> `#f1eadf` |
| `on_error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f1eadf'></span> `#f1eadf` |
| `link` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8a5520'></span> `#8a5520` |
| `link_hover` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#96411e'></span> `#96411e` |
| `selection_bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d8cbb8'></span> `#d8cbb8` |
| `selection_fg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1a1713'></span> `#1a1713` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a7947a'></span> `#a7947a` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#665845'></span> `#665845` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4a3f32'></span> `#4a3f32` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#216a73'></span> `#216a73` |

## Contrast audit

### Dreamcoder Ember Noir OLED contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 14.50:1 | AAA |
| `muted` | 9.99:1 | AA |
| `comment` | 8.37:1 | AA |
| `accent` | 7.65:1 | AA |
| `accent_2` | 5.14:1 | AA |
| `diagnostic` | 6.06:1 | AA |
| `sage` | 7.23:1 | AA |
| `error` | 7.77:1 | AA |
| `warning` | 10.47:1 | AA |

### Dreamcoder Ember Noir OLED APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 87.5 | ≥75 (body) |
| `muted` | 65.4 | ≥75 (FAIL) |
| `comment` | 56.6 | ≥75 (FAIL) |
| `accent` | 52.6 | ≥75 (FAIL) |
| `accent_2` | 36.9 | ≥75 (FAIL) |
| `diagnostic` | 42.7 | ≥75 (FAIL) |
| `sage` | 50.3 | ≥75 (FAIL) |
| `error` | 53.4 | ≥75 (FAIL) |
| `warning` | 68.1 | ≥75 (FAIL) |
| `border_ui` | 39.3 | ≥60 (FAIL) |
| `focus` | 37.6 | ≥60 (FAIL) |

### Dreamcoder Ember Noir OLED UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 5.56:1 | PASS |
| `border_hi` | 9.29:1 | PASS |
| `focus` | 5.30:1 | PASS |

### Dreamcoder Light contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 15.60:1 | AAA |
| `muted` | 11.25:1 | AA |
| `comment` | 5.15:1 | AA |
| `accent` | 5.72:1 | AA |
| `accent_2` | 4.95:1 | AA |
| `diagnostic` | 8.02:1 | AA |
| `sage` | 4.80:1 | AA |
| `error` | 7.30:1 | AA |
| `warning` | 7.48:1 | AA |

### Dreamcoder Light APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 93.3 | ≥75 (body) |
| `muted` | 88.0 | ≥75 (body) |
| `comment` | 68.8 | ≥75 (FAIL) |
| `accent` | 71.4 | ≥75 (FAIL) |
| `accent_2` | 66.9 | ≥75 (FAIL) |
| `diagnostic` | 79.9 | ≥75 (body) |
| `sage` | 66.6 | ≥75 (FAIL) |
| `error` | 77.2 | ≥75 (body) |
| `warning` | 78.3 | ≥75 (body) |
| `border_ui` | 74.1 | ≥60 (UI) |
| `focus` | 71.0 | ≥60 (UI) |

### Dreamcoder Light UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 6.28:1 | PASS |
| `border_hi` | 10.79:1 | PASS |
| `focus` | 5.65:1 | PASS |

### Dreamcoder Dusk contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 14.12:1 | AAA |
| `muted` | 7.56:1 | AA |
| `comment` | 5.72:1 | AA |
| `accent` | 4.88:1 | AA |
| `accent_2` | 5.40:1 | AA |
| `diagnostic` | 7.46:1 | AA |
| `sage` | 4.83:1 | AA |
| `error` | 7.37:1 | AA |
| `warning` | 7.44:1 | AA |

### Dreamcoder Dusk APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 89.0 | ≥75 (body) |
| `muted` | 76.6 | ≥75 (body) |
| `comment` | 69.5 | ≥75 (FAIL) |
| `accent` | 64.9 | ≥75 (FAIL) |
| `accent_2` | 67.4 | ≥75 (FAIL) |
| `diagnostic` | 75.9 | ≥75 (body) |
| `sage` | 64.8 | ≥75 (FAIL) |
| `error` | 75.4 | ≥75 (body) |
| `warning` | 75.9 | ≥75 (body) |
| `border_ui` | 68.2 | ≥60 (UI) |
| `focus` | 65.2 | ≥60 (UI) |

### Dreamcoder Dusk UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 5.45:1 | PASS |
| `border_hi` | 8.10:1 | PASS |
| `focus` | 4.92:1 | PASS |

## Usage

```bash
./scripts/dreamcoder auto
./scripts/dreamcoder light
./scripts/dreamcoder dark
./scripts/dreamcoder verify
./scripts/dreamcoder preview
```

## Design notes

- Main backgrounds avoid pure black and pure white.
- Main text targets AAA (WCAG 2) and APCA Lc ≥ 75 for long coding sessions.
- Cocoa/Lúcuma accents are identity colors in light; Ember Noir uses refined orange, maple red, soft coral, and gold for dark-mode personality.
- UI affordance tokens (`border_ui`, `border_hi`, `focus`) target at least 3:1 against the main background.
- opencode uses one canonical theme: `dreamcoder`; its main `background` is generated as `none` for terminal transparency.
