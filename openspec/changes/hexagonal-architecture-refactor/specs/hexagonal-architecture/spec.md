# Spec: Hexagonal Architecture Refactor

## FR1: Domain Layer (Pure Python — Zero I/O)

### FR1.1 — Palette Module

- **Pure color math only**: contrast ratio (WCAG 2.1), luminance (APCA), blending, mixing
- **No subprocess calls**: `matugen` integration moved to adapter
- **Interface**: `Palette.contrast(fg, bg) → float`, `Palette.blend(c1, c2, ratio) → str`

### FR1.2 — Mode Detector

- **Theme mode detection**: given token data, return "light" | "dark" | "dusk"
- **Pure function**: no file I/O — accepts dict/str, returns str
- **Interface**: `ModeDetector.detect(tokens: dict) → str`

### FR1.3 — Token Schema

- **Token structure validation**: type checking, required fields, value ranges
- **Pure validation**: returns list of ValidationError, no side effects
- **Interface**: `TokenSchema.validate(tokens: dict) → list[ValidationError]`

### FR1.4 — WCAG Guard

- **Accessibility thresholds**: minimum contrast for text, UI elements
- **Configurable**: light/dark mode have different thresholds
- **Interface**: `WCAGGuard.check(fg, bg, context: str) → Pass | Fail`

## FR2: Application Layer (Use Cases)

### FR2.1 — Theme Applier

- **Orchestrate full theme application**: detect mode → load tokens → render all targets → write files → signal services
- **Depends on**: ports (Renderer, Writer, SignalSender)
- **No direct I/O**: delegates to injected adapters
- **Interface**: `ThemeApplier.apply(mode: str | None = None) → ApplyResult`

### FR2.2 — Theme Syncer

- **Replaces sync.py**: same functionality, hexagonal structure
- **Target registry**: single source of truth for theme targets
- **Interface**: `ThemeSyncer.sync() → SyncReport`

### FR2.3 — System Doctor

- **Replaces doctor.sh**: modular health checks
- **Check registry**: each check is a callable returning CheckResult
- **Interface**: `SystemDoctor.run(checks: list[str] | None = None) → DoctorReport`

### FR2.4 — Keybinding Generator

- **Replaces generate-custom-lua.sh**: Python-based profile → Lua
- **Schema-validated**: uses ProfileSchema from domain
- **Interface**: `KeybindingGenerator.generate(profile: dict) → str`

## FR3: Ports (Abstract Base Classes)

### FR3.1 — Renderer Port

```python
class Renderer(ABC):
    @abstractmethod
    def render(self, tokens: dict) -> str: ...
    @property
    @abstractmethod
    def target_name(self) -> str: ...
```

### FR3.2 — Writer Port

```python
class Writer(ABC):
    @abstractmethod
    def write(self, path: Path, content: str) -> None: ...
    @abstractmethod
    def ensure_dir(self, path: Path) -> None: ...
```

### FR3.3 — Validator Port

```python
class Validator(ABC):
    @abstractmethod
    def validate(self, content: str, schema: dict) -> list[ValidationError]: ...
```

## FR4: Adapters (Infrastructure)

### FR4.1 — Renderer Adapters

- KittyRenderer, GhosttyRenderer, WaybarRenderer, HyprlandRenderer, NvimRenderer, TmuxRenderer, ZellijRenderer, StarshipRenderer, FastfetchRenderer, RofiRenderer, BtopRenderer, BatRenderer, PiRenderer, CodexRenderer, OpenCodeRenderer, FirefoxRenderer, ObsidianRenderer, SystemdRenderer, NotificationRenderer

### FR4.2 — File Writer Adapter

- Atomic writes (write to temp, rename)
- Directory creation
- Permission handling

### FR4.3 — Shell Command Adapter

- Subprocess execution with timeout
- Signal sending (SIGUSR1 to kitty, pkill waybar)
- Command existence checking

## FR5: Shell Library (lib/)

### FR5.1 — Core Library

- `log_info`, `log_warn`, `log_error` with consistent formatting
- `ensure_dots_dir` — single source of DREAMCODER_DOTS_DIR resolution
- `require_command` — check + friendly error if missing
- `is_gui_session` — WAYLAND_DISPLAY/DISPLAY check

### FR5.2 — Theme Library

- `detect_theme_mode` — light/dark/dusk detection
- `load_theme_tokens` — JSON parsing with error handling

### FR5.3 — Hyprland Library

- `reload_hyprland` — hyprctl reload
- `restart_waybar` — safe waybar restart

## FR6: Testing (Zero Untested Surface)

### FR6.1 — Python Unit Tests

- Domain layer: 100% coverage target
- Application layer: 90%+ coverage
- Adapters: integration tests with temp directories

### FR6.2 — Shell Tests (bats)

- `test_apply_theme.bats`
- `test_doctor.bats`
- `test_generate_custom_lua.bats`
- `test_lib_core.bats`

## Acceptance Criteria

| ID  | Criterion                                                                                |
| --- | ---------------------------------------------------------------------------------------- |
| AC1 | All domain modules import zero I/O libraries (no `open`, `subprocess`, `pathlib`, `os`)  |
| AC2 | Every renderer implements `Renderer` ABC                                                 |
| AC3 | `ThemeApplier` works with mock adapters (no real file I/O in unit tests)                 |
| AC4 | Shell scripts use `lib/core.sh` — zero raw `DREAMCODER_DOTS_DIR` assignments outside lib |
| AC5 | `doctor.sh` checks are independently testable                                            |
| AC6 | bats tests pass for all critical shell paths                                             |
| AC7 | `KeybindingGenerator` produces identical Lua to `generate-custom-lua.sh`                 |
| AC8 | Existing `pytest` suite passes with zero regressions                                     |
