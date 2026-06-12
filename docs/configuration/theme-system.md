# Dreamcoder Theme System

## Architecture

```
tokens.json → Theme Engine (Python) → 48 config files → 22 targets
```

## Token Schema

All colors are defined in `themes/dreamcoder/tokens.json`:

```json
{
  "dark": {
    "background": "#100f0d",
    "text": "#e8dfd0",
    "accent": "#d99555",
    "accent_2": "#c96a45",
    "diagnostic": "#5f95ca"
  },
  "light": {
    "background": "#f3eadc",
    "text": "#17120d",
    "accent": "#824f16",
    "accent_2": "#b85c2a",
    "diagnostic": "#3a7bc8"
  }
}
```

## Regenerating Themes

After editing `tokens.json`:

```bash
./scripts/dreamcoder sync
```

## Adding New Targets

1. Create renderer in `scripts/dreamcoder_theme/renderers_<target>.py`
2. Add token mapping
3. Run `./scripts/dreamcoder sync`
4. Files appear in `themes/dreamcoder/`
