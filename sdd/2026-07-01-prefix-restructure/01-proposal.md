# SDD Proposal: Dreamcoder Prefix Restructure

## Problem

El root del repo tiene ~38 directorios, mezclando configs de herramientas, configs de AI,
assets, e infraestructura del proyecto sin agrupación ni namespace. En GitHub se ve
desordenado vs referencias como Gentleman.Dots (~12 dirs) y ML4W dotfiles (~5 dirs).

## Solution

Aplicar prefix `Dreamcoder` a todos los directorios de config (tools, AI, assets),
siguiendo el patrón de Gentleman.Dots (`Gentleman*`). Infra del proyecto (src, tests, installer, etc.)
mantiene nombres estándar.

## Scope

### Renames (23 directorios)

#### Config tools (14)

| Actual       | Nuevo                  | Tracked files |
| ------------ | ---------------------- | ------------- |
| `Alacritty/` | `DreamcoderAlacritty/` | 3             |
| `Bat/`       | `DreamcoderBat/`       | 3             |
| `Fastfetch/` | `DreamcoderFastfetch/` | 3             |
| `Ghostty/`   | `DreamcoderGhostty/`   | 16            |
| `gitconfig/` | `DreamcoderGit/`       | 2             |
| `Kitty/`     | `DreamcoderKitty/`     | 7             |
| `Nushell/`   | `DreamcoderNushell/`   | 4             |
| `Nvim/`      | `DreamcoderNvim/`      | 18            |
| `Shell/`     | `DreamcoderShell/`     | 28            |
| `Systemd/`   | `DreamcoderSystemd/`   | 4             |
| `Tmux/`      | `DreamcoderTmux/`      | 4             |
| `Warp/`      | `DreamcoderWarp/`      | 5             |
| `WezTerm/`   | `DreamcoderWezTerm/`   | 4             |
| `Zellij/`    | `DreamcoderZellij/`    | 6             |

#### AI configs (5)

| Actual         | Nuevo                    | Tracked files |
| -------------- | ------------------------ | ------------- |
| `Antigravity/` | `DreamcoderAntigravity/` | 3             |
| `Codex-App/`   | `DreamcoderCodexApp/`    | 3             |
| `Codex-CLI/`   | `DreamcoderCodexCLI/`    | 3             |
| `OpenCode/`    | `DreamcoderOpenCode/`    | 1             |
| `Pi/`          | `DreamcoderPi/`          | 4             |

#### Assets (3)

| Actual        | Nuevo                   | Tracked files |
| ------------- | ----------------------- | ------------- |
| `themes/`     | `DreamcoderThemes/`     | 48            |
| `Wallpapers/` | `DreamcoderWallpapers/` | 4             |
| `profiles/`   | `DreamcoderProfiles/`   | 2             |

#### Symlink

- `unknown` → apunta a `Kitty/.config/kitty/colors-dreamcoder.conf`, actualizar a `DreamcoderKitty/...`

#### Infra que NO cambia (10)

`src/`, `tests/`, `installer/`, `scripts/`, `docs/`, `skills/`, `data/`, `homebrew-tap/`, `.github/`, `.atl/`

#### Ignorados/ocultos que NO cambian

`.venv/`, `info/` (virtualenv), `.git/`, `.mypy_cache/`, `.pytest_cache/`, `.ruff_cache/`, etc.

### Archivos a actualizar por área

| Área                      | Archivos                                                                                                                                                                                                                                                                                                                                                                                                                         | Tipo de cambio     |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| **Installer (Go)**        | `installer/internal/dotfiles/paths.go`, `installer/cmd/doctor.go`, `installer/main.go`, `installer/cmd/repair.go`, `installer/cmd/install.go`, `installer/internal/tui/non_interactive.go`, `installer/internal/installer/installer.go`, `installer/e2e/*.go`                                                                                                                                                                    | Path references    |
| **Scripts**               | `scripts/dreamcoder-lib.sh`, `scripts/verify.sh`, `scripts/apply-fastfetch-assets.sh`, `scripts/install-dreamcoder-hooks.sh`, `scripts/apply-theme-mode.sh`, `scripts/verify-theme-health.py`, `scripts/WALLPAPER_SETUP.md`                                                                                                                                                                                                      | Const string paths |
| **Theme engine (Python)** | `src/dreamcoder_theme/renderers_readme.py`, `src/dreamcoder_theme/installer.py`, `src/dreamcoder_theme/renderers_extra_nvim_lsp.py`, `src/dreamcoder_theme/writers.py`, `src/dreamcoder_theme/visual_regression.py`, `src/dreamcoder_theme/renderers_kitty.py`, `src/dreamcoder_theme/repair_engine.py`, `src/dreamcoder_theme/sync.py`, `src/dreamcoder_theme/renderers_extra_bat_delta.py`, `src/dreamcoder_theme/settings.py` | Const paths        |
| **Root docs**             | `README.md`, `INSTALL.md`, `CONTRIBUTING.md`, `COMPARISON.md`, `CHANGELOG.md`, `CLAUDE.md`, `AGENTS.md`, `SECURITY.md`                                                                                                                                                                                                                                                                                                           | Path references    |
| **`docs/`**               | Multiple `.md`, `.mmd` files                                                                                                                                                                                                                                                                                                                                                                                                     | Path references    |
| **CI/Meta**               | `.github/workflows/theme-validation.yml`, `.github/CODEOWNERS`, `.github/ISSUE_TEMPLATE/bug_report.yml`                                                                                                                                                                                                                                                                                                                          | Path references    |
| **`.gitignore`**          | `kitty/...` → `DreamcoderKitty/...` + new entries                                                                                                                                                                                                                                                                                                                                                                                | Path update        |
| **`homebrew-tap/`**       | Formula references                                                                                                                                                                                                                                                                                                                                                                                                               | Path update        |

## Execution Strategy

### Phase 1: Mechanical rename (git mv)

Los 23 `git mv` en un solo commit. No se pierde historial porque `git mv` preserva
el history tracking.

### Phase 2: Update source references

Actualizar paths en:

- `scripts/` (bash + python)
- `src/dreamcoder_theme/` (python)
- `installer/` (go)
- `.gitignore`
- Symlink `unknown`
- `homebrew-tap/`

### Phase 3: Update documentation

Actualizar paths en:

- Root `*.md` files
- `docs/`
- `.github/` (CI, issues, codeowners)
- `COMPARISON.md`, `CHANGELOG.md`

### Phase 4: Verify

- `git diff --stat` para verificar que no quedan refs viejas
- Correr tests de tema (si existen)
- Verificar que el installer compila
- Verificar que los scripts de theme engine siguen funcionando

## Risk Assessment

| Risk                                           | Mitigation                              |
| ---------------------------------------------- | --------------------------------------- |
| Symlink `unknown` rota                         | Actualizar target a DreamcoderKitty/... |
| Installer Go no compila por paths rotos        | Update + `go build` verify              |
| Theme engine writers.py escribe a paths viejos | Update const paths, probar con dry-run  |
| Scripts de shells referencian paths absolutos  | Grep + sed, verificar cada uno          |
| `.gitignore` paths hardcodeados                | Actualizar patrones                     |
| CI workflows fallan                            | Update paths + push a branch de prueba  |

## Non-Goals

- No cambiar estructura INTERNA de los directorios (`.config/` layout se mantiene)
- No cambiar contenido de archivos de config
- No refactorizar el theme engine
- No cambiar el installer Go semantics
- No mover infra (src, tests, etc.) a otros lados

## Acceptance Criteria

1. `git log --follow` preserva historial en cada archivo movido
2. Theme engine puede regenerar todas las themes sin error
3. Installer compila y sus paths internos son correctos
4. Scripts de shell (`scripts/dreamcoder.sh`, `scripts/verify.sh`, etc.) funcionan
5. No hay referencias a paths viejos (`rg '^[^D]' Alacritty/|Kitty/|Nvim/|...`) — solo deben aparecer en git history
6. README.md menciona los paths nuevos
7. Symlink `unknown` apunta al path correcto
8. CI pasa sin errores de path
