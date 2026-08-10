# Dreamcoder Workbench — Documentación

Bienvenido al hub de documentación de Dreamcoder Workbench. Este índice centraliza
toda la documentación técnica del proyecto.

## New here? Quick path

Nuevo en Dreamcoder Workbench? Este es el camino más corto:

1. Empezá por el [README principal](../README.md): overview, badges e instalación en 3 pasos.
2. Leé el [Source Manifest](sources.md) para entender qué es upstream y qué es propio del repo.
3. Profundizá en el [Theme System](configuration/theme-system.md) si trabajás con colores o tokens.
4. Revisá el [Design System](DREAMCODER_DESIGN_SYSTEM.md) para las guías de identidad y contraste.

---

## 🏗 Architecture

Documentación de alto nivel sobre cómo está construido y cómo funciona el sistema.

| Documento | Descripción |
|-----------|-------------|
| [Theme Pipeline](architecture/theme-pipeline.mmd) | Cómo los tokens de `tokens.json` fluyen por los renderers hasta los archivos de tema finales |
| [AI Integration](ai-integration.md) | Cómo dreamcoder se integra con Claude Code, OpenCode, Pi, y otras herramientas de IA |
| [Monorepo Structure](architecture/monorepo-structure.mmd) | Mapa visual del repositorio: `src/`, `scripts/`, `tests/`, y cada directorio top-level |
| [Data Flow](architecture/data-flow.mmd) | Flujo completo de `dreamcoder-theme sync`: palette → tokens → renderers → writers → disco |
| [Source Manifest](sources.md) | Upstream inputs (ML4W, Gentleman.Dots), ownership boundaries, y prohibiciones de secretos/estado en ejecución |
| [Herdr Integration](herdr.md) | Contratos Herdr 0.7.3/0.8.0, variantes versionadas generadas, y perfiles de despliegue |
| [Design System](DREAMCODER_DESIGN_SYSTEM.md) | Principios de diseño, filosofía de color, y guías de identidad visual |
| [Control Center](DREAMCODER_CONTROL_CENTER.md) | Dashboard de control central del ecosistema Dreamcoder |

### Architecture Decision Records (ADRs)

| ADR | Título | Estado |
|-----|--------|--------|
| [ADR-001](adr/0001-project-structure.md) | Monorepo Project Structure Layout | ✅ Accepted |
| [ADR-002](adr/0002-toolchain-selection.md) | Python and Shell Quality Toolchain | ✅ Accepted |
| [ADR-003](adr/0003-python-quality-strategy.md) | Python Quality Strategy | ✅ Accepted |
| [ADR-004](adr/0004-shell-test-strategy.md) | Shell Test Strategy | ✅ Accepted |
| [ADR-005](adr/0005-ci-cd-quality-gates.md) | CI/CD Quality Gates | ✅ Accepted |

---

## 🚀 Installation

Guías paso a paso para instalar Dreamcoder Workbench en diferentes plataformas.

| Guía | Plataforma |
|------|-----------|
| [Linux](installation/linux.md) | Arch Linux (recomendado), Fedora, Debian-based |
| [macOS](installation/macos.md) | macOS Sonoma+ |
| [WSL](installation/wsl.md) | Windows Subsystem for Linux |
| [Termux](installation/termux.md) | Android via Termux |

---

## ⚙️ Configuration

Guías de configuración de componentes individuales.

| Guía | Componente |
|------|-----------|
| [Terminal](configuration/terminal-config.md) | Kitty, Ghostty, WezTerm, Alacritty |
| [Editor](configuration/editor-config.md) | Neovim, VS Code / Antigravity |
| [Shell](configuration/shell-config.md) | Zsh, Bash, Starship, Fish, Nushell |
| [Multiplexer](configuration/multiplexer-config.md) | Tmux, Zellij |
| [ML4W Integration](configuration/ml4w.md) | Keybindings profile-driven, dispatchers nativos, layout de archivos |
| [Theme System](configuration/theme-system.md) | Arquitectura del theme engine, tokens, variantes |

---

## 🧑‍💻 Development

Guías para contributors y desarrolladores.

| Recurso | Descripción |
|---------|-------------|
| [CONTRIBUTING](../CONTRIBUTING.md) | Cómo contribuir: setup, tests, PR guidelines |
| [Design Docs](superpowers/specs/) | Especificaciones de diseño y planes de implementación (SDD) |
| [Theme Preview](generated/dreamcoder-theme-preview.md) | Preview generada automáticamente de todos los temas |
| [PyPI Publishing](pypi-publishing.md) | Publicar `dreamcoder-theme` en PyPI con Trusted Publisher |
| [Migration Guides](migration/) | Migración desde ML4W y Gentleman Dots |

---

## 🏠 Root Links

- [README principal](../README.md) — overview, badges, quick start
- [GitHub Repository](https://github.com/Dreamcoder08/Dreamcoder_dots)
- [PyPI Package](https://pypi.org/project/dreamcoder-theme/)
