# Dreamcoder Theme Preview

Generated from `themes/dreamcoder/tokens.json`.

## Design rationale

Dreamcoder light themes follow a **cocoa/lúcuma** identity: warm parchment backgrounds, graphite-brown text, and restrained accents. Unlike generic light themes that jump from white to mid-gray surfaces, Dreamcoder uses a **flat surface ladder** (~10 luminance points between steps) so panels feel layered without looking muddy.

Dreamcoder dark uses an **Ember Noir** identity: espresso/cacao glass surfaces, warm silver text, refined orange and maple red protagonists, and gold as the support accent. The opencode theme keeps the main background as `none` so the terminal's semi-transparent background remains visible while panels and selections carry the autumn glass color.

Semantic tokens are intentionally distinct:

- `comment` is softer and lower-chroma than `subtle` (syntax vs UI chrome).
- Dark `accent` (refined ember orange), `accent_2` (maple red), `error` (soft coral red), and `warning` (lúcuma gold) form the orange/red/gold signature.
- `focus` follows the orange protagonist instead of a separate cyan ring; `diagnostic` stays warm amber so the palette remains autumnal.
- **Dusk** bridges daytime light and night dark for late-afternoon sessions on Arch.

## Palette

### Dreamcoder Ember Noir

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#15100d'></span> `#15100d` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1d1613'></span> `#1d1613` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#241b16'></span> `#241b16` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#30231c'></span> `#30231c` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3e2c22'></span> `#3e2c22` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f0e7dc'></span> `#f0e7dc` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c7b9aa'></span> `#c7b9aa` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#aa927c'></span> `#aa927c` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#9c826d'></span> `#9c826d` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e6a15c'></span> `#e6a15c` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d66f50'></span> `#d66f50` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d2a268'></span> `#d2a268` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b8bf84'></span> `#b8bf84` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c9a8dc'></span> `#c9a8dc` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d98aa9'></span> `#d98aa9` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e98272'></span> `#e98272` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e8b866'></span> `#e8b866` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#49362c'></span> `#49362c` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#806754'></span> `#806754` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d8c1a5'></span> `#d8c1a5` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e6a15c'></span> `#e6a15c` |

### Dreamcoder Light

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f3eadc'></span> `#f3eadc` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e6d7c4'></span> `#e6d7c4` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#fff7ea'></span> `#fff7ea` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#decbb1'></span> `#decbb1` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c8ad89'></span> `#c8ad89` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#17120d'></span> `#17120d` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3d3228'></span> `#3d3228` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#554635'></span> `#554635` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#66523f'></span> `#66523f` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#824f16'></span> `#824f16` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a7471c'></span> `#a7471c` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#15516e'></span> `#15516e` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#3f6b35'></span> `#3f6b35` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#57478b'></span> `#57478b` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#7d3e64'></span> `#7d3e64` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#842f24'></span> `#842f24` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#654300'></span> `#654300` |
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
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1a1713'></span> `#1a1713` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4c443a'></span> `#4c443a` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5a4f43'></span> `#5a4f43` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#615548'></span> `#615548` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8a5520'></span> `#8a5520` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#96411e'></span> `#96411e` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#104b67'></span> `#104b67` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#466b41'></span> `#466b41` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#5b4e86'></span> `#5b4e86` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#784762'></span> `#784762` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#773126'></span> `#773126` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#604000'></span> `#604000` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a7947a'></span> `#a7947a` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#665845'></span> `#665845` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4a3f32'></span> `#4a3f32` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#216a73'></span> `#216a73` |

## Contrast audit

### Dreamcoder Ember Noir contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 15.44:1 | AAA |
| `muted` | 9.85:1 | AA |
| `comment` | 5.24:1 | AA |
| `accent` | 8.65:1 | AA |
| `accent_2` | 5.62:1 | AA |
| `diagnostic` | 8.19:1 | AA |
| `sage` | 9.74:1 | AA |
| `error` | 7.11:1 | AA |
| `warning` | 10.32:1 | AA |

### Dreamcoder Ember Noir APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 95.0 | ≥75 (body) |
| `muted` | 70.9 | ≥75 (FAIL) |
| `comment` | 45.2 | ≥75 (FAIL) |
| `accent` | 64.9 | ≥75 (FAIL) |
| `accent_2` | 47.7 | ≥75 (FAIL) |
| `diagnostic` | 62.5 | ≥75 (FAIL) |
| `sage` | 70.3 | ≥75 (FAIL) |
| `error` | 56.6 | ≥75 (FAIL) |
| `warning` | 73.1 | ≥75 (FAIL) |
| `border_ui` | 33.1 | ≥60 (FAIL) |
| `focus` | 64.9 | ≥60 (UI) |

### Dreamcoder Ember Noir UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 3.59:1 | PASS |
| `border_hi` | 10.88:1 | PASS |
| `focus` | 8.65:1 | PASS |

### Dreamcoder Light contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 15.60:1 | AAA |
| `muted` | 10.45:1 | AA |
| `comment` | 6.19:1 | AA |
| `accent` | 5.72:1 | AA |
| `accent_2` | 4.95:1 | AA |
| `diagnostic` | 7.24:1 | AA |
| `sage` | 5.23:1 | AA |
| `error` | 7.30:1 | AA |
| `warning` | 7.48:1 | AA |

### Dreamcoder Light APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 96.0 | ≥75 (body) |
| `muted` | 85.5 | ≥75 (body) |
| `comment` | 72.8 | ≥75 (FAIL) |
| `accent` | 70.7 | ≥75 (FAIL) |
| `accent_2` | 66.7 | ≥75 (FAIL) |
| `diagnostic` | 76.7 | ≥75 (body) |
| `sage` | 68.3 | ≥75 (FAIL) |
| `error` | 76.9 | ≥75 (body) |
| `warning` | 77.5 | ≥75 (body) |
| `border_ui` | 73.1 | ≥60 (UI) |
| `focus` | 70.4 | ≥60 (UI) |

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
| `text` | 91.1 | ≥75 (body) |
| `muted` | 75.7 | ≥75 (body) |
| `comment` | 68.7 | ≥75 (FAIL) |
| `accent` | 64.4 | ≥75 (FAIL) |
| `accent_2` | 67.2 | ≥75 (FAIL) |
| `diagnostic` | 75.3 | ≥75 (body) |
| `sage` | 64.1 | ≥75 (FAIL) |
| `error` | 75.0 | ≥75 (body) |
| `warning` | 75.3 | ≥75 (body) |
| `border_ui` | 67.4 | ≥60 (UI) |
| `focus` | 64.6 | ≥60 (UI) |

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
./scripts/dreamcoder dusk
./scripts/dreamcoder dark
./scripts/dreamcoder verify
./scripts/dreamcoder preview
```

## Design notes

- Main backgrounds avoid pure black and pure white.
- Main text targets AAA (WCAG 2) and APCA Lc ≥ 75 for long coding sessions.
- Cocoa/Lúcuma accents are identity colors in light/dusk; Ember Noir uses refined orange, maple red, soft coral, and gold for dark-mode personality.
- UI affordance tokens (`border_ui`, `border_hi`, `focus`) target at least 3:1 against the main background.
- opencode uses one canonical theme: `dreamcoder`; its main `background` is generated as `none` for terminal transparency.
