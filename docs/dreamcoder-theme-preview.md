# Dreamcoder Theme Preview

Generated from `themes/dreamcoder/tokens.json`.

## Palette

### Dreamcoder Dark

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#101216'></span> `#101216` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#161922'></span> `#161922` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1c222b'></span> `#1c222b` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#282e38'></span> `#282e38` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#e8e1d7'></span> `#e8e1d7` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b8b0a5'></span> `#b8b0a5` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d9ad67'></span> `#d9ad67` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#b87a48'></span> `#b87a48` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#92c7cd'></span> `#92c7cd` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#a5b89c'></span> `#a5b89c` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#c4b3df'></span> `#c4b3df` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d2a3c3'></span> `#d2a3c3` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#d78373'></span> `#d78373` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#ddb36b'></span> `#ddb36b` |

### Dreamcoder Light

| Role | Color |
| --- | --- |
| `bg` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#f6f1e8'></span> `#f6f1e8` |
| `bg_soft` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#ece4d8'></span> `#ece4d8` |
| `surface0` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#fbf8f1'></span> `#fbf8f1` |
| `surface1` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#ded3c4'></span> `#ded3c4` |
| `text` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#15130f'></span> `#15130f` |
| `muted` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#4a463f'></span> `#4a463f` |
| `accent` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#855719'></span> `#855719` |
| `accent_2` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#7f4a27'></span> `#7f4a27` |
| `diagnostic` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#1e6871'></span> `#1e6871` |
| `sage` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#496f45'></span> `#496f45` |
| `lavender` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#665593'></span> `#665593` |
| `mauve` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#844c71'></span> `#844c71` |
| `error` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#9b4b40'></span> `#9b4b40` |
| `warning` | <span style='display:inline-block;width:0.9em;height:0.9em;border:1px solid #888;background:#765019'></span> `#765019` |

## Contrast audit

### Dreamcoder Dark contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 14.45:1 | AAA |
| `muted` | 8.74:1 | AA |
| `comment` | 5.14:1 | AA |
| `accent` | 9.04:1 | AA |
| `accent_2` | 5.28:1 | AA |
| `diagnostic` | 10.06:1 | AA |
| `sage` | 8.87:1 | AA |
| `error` | 6.59:1 | AA |
| `warning` | 9.58:1 | AA |

### Dreamcoder Light contrast

| Token | Ratio vs bg | Target |
| --- | ---: | --- |
| `text` | 16.49:1 | AAA |
| `muted` | 8.34:1 | AA |
| `comment` | 5.33:1 | AA |
| `accent` | 5.53:1 | AA |
| `accent_2` | 6.41:1 | AA |
| `diagnostic` | 5.70:1 | AA |
| `sage` | 5.12:1 | AA |
| `error` | 5.37:1 | AA |
| `warning` | 6.37:1 | AA |

## Usage

```bash
./scripts/dreamcoder auto
./scripts/dreamcoder light
./scripts/dreamcoder dark
./scripts/dreamcoder verify
```

## Design notes

- Main backgrounds avoid pure black and pure white.
- Main text targets AAA contrast for long coding sessions.
- Cocoa/Lúcuma accents are identity colors; cyan is diagnostic, not decoration.
- opencode uses one canonical theme: `dreamcoder`.
