# Codex App — Dreamcoder Theme

Módulo visual para mantener el theme **Dreamcoder** de Codex App dentro de
`dreamcoder-dots`.

Este directorio es solo para identidad visual:

- paleta Dreamcoder
- archivos de theme
- script de instalación/symlink

No debe contener runtime de Codex CLI:

- `~/.codex/`
- `auth.json`
- `history.jsonl`
- `sessions/`
- `plugins/cache/`
- `memories/`
- logs o bases SQLite

## Install

```bash
./Codex-App/install.sh
```

Por defecto instala enlaces en:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/codex-app/themes
```

Para otra ruta:

```bash
CODEX_APP_THEME_DIR="$HOME/.config/codex/themes" ./Codex-App/install.sh
```

