# Dreamcoder Theme Preview

Generated from `DreamcoderThemes/dreamcoder/tokens.json`.

## Design rationale

Dreamcoder light themes follow a **cocoa/lúcuma** identity: warm parchment backgrounds, graphite-brown text, and restrained accents. Unlike generic light themes that jump from white to mid-gray surfaces, Dreamcoder uses a **flat surface ladder** (~10 luminance points between steps) so panels feel layered without looking muddy.

Dreamcoder dark uses an **Anthracite Steel** identity: near-black base (#070A13), cool steel-blue accents (#A5C7E8), icy diagnostics (#4DAED6), and muted sage strings (#55C080). Surfaces ladder from deep slate to lighter steel. The opencode theme keeps the main background as `none` so the terminal's semi-transparent background remains visible while panels and selections carry the steel glass color.

Semantic tokens are intentionally distinct:

- `comment` is softer and lower-chroma than `subtle` (syntax vs UI chrome).
- Dark `accent` (cool steel-blue), `accent_2` (muted slate-blue), `error` (soft rose), and `warning` (pale gold) form the cool steel signature.
- `accent` carries brand CTAs and active chrome; `focus` is teal for keyboard/input affordance (WCAG ring).
- `on_accent`, `on_error`, and `selection_bg`/`selection_fg` are explicit pairs validated in CI.
## Palette

### Dreamcoder Anthracite Steel

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#070A13'></span> `#070A13` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#0D121A'></span> `#0D121A` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#0D121A'></span> `#0D121A` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#151C25'></span> `#151C25` |
| `surface2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#202A35'></span> `#202A35` |
| `surface3` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#2B3846'></span> `#2B3846` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#E6EDF3'></span> `#E6EDF3` |
| `text_heading` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#F1F5F9'></span> `#F1F5F9` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#A8B5C2'></span> `#A8B5C2` |
| `subtle` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8795a2'></span> `#8795a2` |
| `comment` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#aab7c4'></span> `#aab7c4` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#A5C7E8'></span> `#A5C7E8` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8FAFCB'></span> `#8FAFCB` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4DAED6'></span> `#4DAED6` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#55C080'></span> `#55C080` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#55C080'></span> `#55C080` |
| `info` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4DAED6'></span> `#4DAED6` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#B6C5D4'></span> `#B6C5D4` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8FA9C0'></span> `#8FA9C0` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#E69AA4'></span> `#E69AA4` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#D9B36C'></span> `#D9B36C` |
| `on_accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#070A13'></span> `#070A13` |
| `on_error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#070A13'></span> `#070A13` |
| `link` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#A5C7E8'></span> `#A5C7E8` |
| `link_hover` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#8FAFCB'></span> `#8FAFCB` |
| `selection_bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#202A35'></span> `#202A35` |
| `selection_fg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#E6EDF3'></span> `#E6EDF3` |
| `border` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#17202B'></span> `#17202B` |
| `border_ui` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#647c8f'></span> `#647c8f` |
| `border_hi` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#758A9C'></span> `#758A9C` |
| `focus` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#A5C7E8'></span> `#A5C7E8` |

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
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#315b31'></span> `#315b31` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#315b31'></span> `#315b31` |
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
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#344f30'></span> `#344f30` |
| `success` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#344f30'></span> `#344f30` |
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

### Dreamcoder Anthracite Steel contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 16.74:1 | AAA |
| `muted` | 9.47:1 | AA |
| `comment` | 9.68:1 | AA |
| `accent` | 11.24:1 | AA |
| `accent_2` | 8.63:1 | AA |
| `diagnostic` | 7.86:1 | AA |
| `sage` | 8.70:1 | AA |
| `error` | 8.97:1 | AA |
| `warning` | 10.00:1 | AA |

### Dreamcoder Anthracite Steel APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 95.3 | ≥75 (body) |
| `muted` | 61.2 | ≥75 (FAIL) |
| `comment` | 62.4 | ≥75 (FAIL) |
| `accent` | 70.3 | ≥75 (FAIL) |
| `accent_2` | 56.8 | ≥75 (FAIL) |
| `diagnostic` | 52.7 | ≥75 (FAIL) |
| `sage` | 57.4 | ≥75 (FAIL) |
| `error` | 58.7 | ≥75 (FAIL) |
| `warning` | 64.1 | ≥75 (FAIL) |
| `border_ui` | 31.3 | ≥60 (FAIL) |
| `focus` | 70.3 | ≥60 (UI) |

### Dreamcoder Anthracite Steel UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 4.54:1 | PASS |
| `border_hi` | 5.53:1 | PASS |
| `focus` | 11.24:1 | PASS |

### Dreamcoder Light contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 15.60:1 | AAA |
| `muted` | 11.25:1 | AA |
| `comment` | 5.15:1 | AA |
| `accent` | 5.72:1 | AA |
| `accent_2` | 4.95:1 | AA |
| `diagnostic` | 8.02:1 | AA |
| `sage` | 6.59:1 | AA |
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
| `sage` | 75.3 | ≥75 (body) |
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
| `sage` | 7.20:1 | AA |
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
| `sage` | 75.3 | ≥75 (body) |
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

### Night (derived from Anthracite Steel) contrast (WCAG 2)

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 12.15:1 | AAA |
| `muted` | 7.10:1 | AA |
| `comment` | 7.21:1 | AA |
| `accent` | 9.33:1 | AA |
| `accent_2` | 6.52:1 | AA |
| `diagnostic` | 7.71:1 | AA |
| `sage` | 7.74:1 | AA |
| `error` | 7.52:1 | AA |
| `warning` | 7.59:1 | AA |

### Night (derived from Anthracite Steel) APCA

| Token | Lc vs bg | Target |
| --- | ---: | --- |
| `text` | 74.4 | ≥75 (FAIL) |
| `muted` | 47.7 | ≥75 (FAIL) |
| `comment` | 48.4 | ≥75 (FAIL) |
| `accent` | 60.3 | ≥75 (FAIL) |
| `accent_2` | 44.3 | ≥75 (FAIL) |
| `diagnostic` | 51.4 | ≥75 (FAIL) |
| `sage` | 51.7 | ≥75 (FAIL) |
| `error` | 50.4 | ≥75 (FAIL) |
| `warning` | 50.7 | ≥75 (FAIL) |
| `border_ui` | 32.6 | ≥60 (FAIL) |
| `focus` | 60.3 | ≥60 (UI) |

### Night (derived from Anthracite Steel) UI affordance contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `border_ui` | 4.74:1 | PASS |
| `border_hi` | 4.57:1 | PASS |
| `focus` | 9.33:1 | PASS |

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
- Cocoa/Lúcuma accents are identity colors in light; Anthracite Steel uses cool steel-blue, muted slate, soft rose, and pale gold for dark-mode personality.
- UI affordance tokens (`border_ui`, `border_hi`, `focus`) target at least 3:1 against the main background.
- opencode uses one canonical theme: `dreamcoder`; its main `background` is generated as `none` for terminal transparency.
