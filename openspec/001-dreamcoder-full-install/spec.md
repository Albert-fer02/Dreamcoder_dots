# Spec: Full Installation Integration

> **SDD Change:** `001-dreamcoder-full-install`

## Target T1: Clean Baseline

### Requirement

El working tree debe estar limpio antes de empezar cualquier cambio. Los cambios del SDD anterior (000-dreamcoder-theme-unification) deben ser evaluados y commiteados, descartados, o stasheados.

### Files

- Working tree completo

### Scenario: Clean tree with existing changes

```
Given there are uncommitted changes from a previous SDD
When we start the apply phase
Then the working tree must be clean
And the user must decide: commit the previous changes as-is, or discard them
```

### Acceptance

- `git status --short` output is empty after cleanup
- No data loss from the previous SDD changes (they are either committed or stashed)

---

## Target T2: Hyprland dreamcoder-colors Import

### Requirement

El archivo `dreamcoder-colors.conf` generado por dreamcoder debe ser importado por Hyprland. Actualmente existe en `~/.config/hypr/dreamcoder-colors.conf` pero `hyprland.lua` usa `require("colors")` que carga las variantes de ML4W.

### Files

- `~/.config/hypr/hyprland.lua` — agregar source/require
- `DreamcoderThemes/dreamcoder/hypr-colors-{mode}.conf` — archivos ya generados

### Scenario: Hyprland loads dreamcoder colors

```
Given dreamcoder-colors.conf exists in ~/.config/hypr/
When hyprland.lua loads
Then it must import dreamcoder-colors.conf after ML4W colors
And the import must be conditional (file exists check)
```

### Scenario: Mode switching reflects in Hyprland

```
Given the theme mode changes from light to dark
When apply-theme-mode.sh runs
Then colors.lua symlink points to colors-dark.lua
And dreamcoder-colors.conf must be regenerated with dark values
And hyprctl reload must be called
```

### Acceptance

- `grep "dreamcoder" ~/.config/hypr/hyprland.lua` returns a valid import
- `hyprctl getoption general:col.active_border` shows dreamcoder colors after mode switch
- Import is conditional — no error if file is missing

---

## Target T3: Btop Dreamcoder Theme

### Requirement

Btop debe usar un theme dreamcoder en lugar del matugen default de ML4W. El archivo `btop-dreamcoder.theme` ya existe en `DreamcoderThemes/` pero no está deployado.

### Files

- `DreamcoderThemes/btop-dreamcoder.theme` — source theme (already exists)
- `~/.config/btop/themes/dreamcoder.theme` — deploy target (symlink or copy)
- `~/.config/btop/btop.conf` — `color_theme = "dreamcoder"`

### Scenario: Btop theme installed

```
Given dreamcoder-dots is installed
When btop loads
Then the theme must be available as "dreamcoder"
And color_theme in btop.conf must be set to "dreamcoder"
```

### Scenario: Btop theme switches with mode

```
Given mode changes from light to dark
When btop is restarted
Then the theme must reflect dark mode colors
```

### Acceptance

- `btop` loads without "theme not found" error
- `grep color_theme ~/.config/btop/btop.conf` → `color_theme = "dreamcoder"`
- Doctor detects if btop theme is missing and suggests repair

---

## Target T4: Auto-Theme Timer Active

### Requirement

Systemd timer `dreamcoder-theme-auto.timer` debe estar enabled y active después de la instalación. Los units ya existen en `~/.config/systemd/user/` pero nunca se habilitaron.

### Files

- `~/.config/systemd/user/dreamcoder-theme-auto.timer` — exists
- `~/.config/systemd/user/dreamcoder-theme-auto.service` — exists
- `scripts/install.sh` — agregar `systemctl --user enable --now`
- `scripts/doctor.sh` — check timer status

### Scenario: Timer enabled after install

```
Given dreamcoder-dots is being installed
After install completes
Then systemctl --user is-enabled dreamcoder-theme-auto.timer must return "enabled"
And systemctl --user is-active dreamcoder-theme-auto.timer must return "active"
```

### Scenario: Doctor detects inactive timer

```
Given the timer is disabled or inactive
When doctor runs
Then it must report "auto-theme timer is inactive"
And suggest: "systemctl --user enable --now dreamcoder-theme-auto.timer"
```

### Acceptance

- Timer is active after `./scripts/install.sh`
- Doctor warns if timer is inactive
- Timer triggers service at configured schedule (e.g., 6:00 AM light, 18:00 PM dark)

---

## Target T5: Doctor Mejorado

### Requirement

`dreamcoder doctor` debe verificar todos los componentes del stack, no solo los actuales. Debe detectar:

- Todos los paths de ghostty, kitty, starship, tmux, fish (ya existe)
- Nvim colorscheme loading
- Btop theme presence
- Bat theme presence
- Hypr dreamcoder-colors import
- GTK color scheme
- Firefox theme (if exists)
- Obsidian theme (if exists)
- Cava config (if exists)
- Auto-theme timer status
- Waybar/Rofi/Dunst symlinks actualizados
- Backup manifest freshness

### Files

- `scripts/doctor.sh` — extender
- `src/dreamcoder_theme/doctor.py` — extender (structured health)

### Scenario: Doctor comprehensive check

```
Given dreamcoder-dots is installed
When doctor runs
Then it checks ALL 15+ components
And each check returns {name, status, detail, repair}
And the output is both human-readable and machine-parseable (JSON)
```

### Scenario: Doctor suggests repair

```
Given a component is missing or misconfigured
When doctor runs
Then it suggests a repair command for each issue
And the repair command is safe (dry-run capable)
```

### Acceptance

- `dreamcoder doctor` exits 0 when all components are healthy
- `dreamcoder doctor` exits non-zero and lists all issues when components are missing
- All repairs suggested are actionable shell commands
- JSON output validates against the contract schema

---

## Target T6: Instalador Idempotente

### Requirement

`./scripts/install.sh` debe ser seguro de ejecutar múltiples veces. Debe:

1. Crear backup manifest de los archivos que va a tocar
2. Verificar que no hay conflictos con configs existentes no-managed
3. Aplicar symlinks solo si no existen o están rotos
4. Proveer comando de rollback
5. Reportar qué cambió y qué no

### Files

- `scripts/install.sh` — modificar
- `src/dreamcoder_theme/installer.py` — ya existe en control center

### Scenario: First install

```
Given a clean system
When install.sh runs
Then it creates a backup manifest
And installs all symlinks
And enables the auto-theme timer
And reports success
```

### Scenario: Re-install (idempotent)

```
Given dreamcoder-dots is already installed
When install.sh runs again
Then it detects existing symlinks
And skips already-correct symlinks
And updates broken or outdated symlinks
And does NOT create duplicate backup manifests
And exits 0
```

### Scenario: Rollback

```
Given install.sh just ran
When user runs the suggested rollback command
Then all symlinks are removed
And original files are restored from backup
And timer is disabled
```

### Acceptance

- `./scripts/install.sh` can be run 3 times in a row without errors
- Running install.sh twice produces the same result
- `install.sh` creates a timestamped backup manifest
- Rollback command is printed at the end of install
- Timer is enabled only once (no duplicate systemd calls)

---

## Target T7: Repair Catalog Extendido

### Requirement

El repair catalog debe incluir acciones para restaurar los targets faltantes: Btop theme, Hypr dreamcoder import, Bat theme deploy, Firefox/Obsidian/Cava theme deploy.

### Files

- `src/dreamcoder_theme/repair_engine.py` — extender catalog

### Scenario: Repair missing Btop theme

```
Given btop theme is missing
When repair plan --json runs
Then it includes "deploy btop dreamcoder theme" as a safe action
And repair apply --dry-run shows what would be done
```

### Acceptance

- `repair catalog --json` lists all deployable components
- Each repair action has: `{name, description, safe, dry_run_command, apply_command}`
- Safe repairs can run without sudo
- Repair updates the doctor state after applying

---

## Target T8: CI Integration Test

### Requirement

GitHub Action que verifique que dreamcoder-dots se integra correctamente con Gentleman.Dots + ML4W. El workflow debe:

1. Clonar Gentleman.Dots en un path conocido
2. Clonar ML4W dotfiles (release estable)
3. Ejecutar `dreamcoder-theme sync` para generar themes
4. Verificar que todos los paths de hook existen
5. Verificar que mode switching genera archivos correctos
6. Correr `dreamcoder doctor` en modo dry-run

### Files

- `.github/workflows/integration-test.yml` — crear
- `scripts/integration-test.sh` — helper script (opcional)

### Scenario: CI integration passes

```
Given a fresh checkout
When CI runs the integration workflow
Then it installs Gentleman.Dots base structure
And installs ML4W base structure
And runs dreamcoder sync
And all hook files are present at expected paths
And doctor reports all green
```

### Acceptance

- Workflow runs on PRs to main
- Workflow runs on push to main
- Fails if any hook file is missing
- Takes under 5 minutes

---

## Target T9: Waybar @import Verification

### Requirement

Verificar que Waybar's style.css (ML4W) importa correctamente los colores dreamcoder. Actualmente ML4W tiene `colors.css` que apunta a `colors-light.css` vía symlink.

### Files

- `~/.config/waybar/style.css` — ML4W's style file
- `~/.config/waybar/colors.css` — symlink to colors-{mode}.css

### Scenario: Waybar imports dreamcoder colors

```
Given waybar colors.css symlink points to colors-light.css
When waybar starts
Then style.css must @import or otherwise reference colors.css
And the colors must render without errors
```

### Acceptance

- No "file not found" errors in waybar logs
- `@import "colors.css";` exists in style.css or equivalent
- Doctor verifies this

---

## Target T10: Installation Docs Update

### Requirement

Actualizar `docs/installation/linux.md` con:

- Prerrequisitos exactos
- Pasos precisos: Gentleman.Dots → ML4W → dreamcoder
- Troubleshooting para cada capa
- Verify checklist post-instalación
- Comando de rollback

### Files

- `docs/installation/linux.md` — modificar
- `docs/installation/README.md` — posible update

### Acceptance

- Pasos reproducibles de principio a fin
- Un usuario nuevo puede seguir los pasos sin ambigüedad
- Incluye verify checklist que cubre todos los componentes
- Incluye rollback instructions
