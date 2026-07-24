# Proposal: Hexagonal Architecture Refactor

## Current State — Critical Audit

### Shell Scripts (25+ files, 0 tests)

| Problem                                    | Severity | Impact                                                                             |
| ------------------------------------------ | -------- | ---------------------------------------------------------------------------------- |
| Zero test coverage                         | CRITICAL | Every shell change is blind                                                        |
| `apply-theme-mode.sh` is 200-line monolith | HIGH     | 6+ concerns in one file: env loading, mode detection, matugen, waybar, kitty, tmux |
| `doctor.sh` is 500+ line god-script        | HIGH     | Impossible to test individual checks                                               |
| 18x ENV_FILE boilerplate duplicated        | MEDIUM   | `DREAMCODER_DOTS_DIR` resolution copy-pasted across every script                   |
| No shared library                          | MEDIUM   | 25+ scripts with no reusable functions                                             |
| Missing `set -euo pipefail` in 8 scripts   | HIGH     | Silent failures in production                                                      |

### Python Theme Engine (src/dreamcoder_theme/)

| Problem                                                      | Severity | Impact                                                                                |
| ------------------------------------------------------------ | -------- | ------------------------------------------------------------------------------------- |
| `sync.py` requires 3-4 edits per new target                  | HIGH     | ThemePaths + sync_active_targets + print_summary + VARIANT_REGISTRY all need updating |
| `palette.py` mixes pure color math with subprocess (matugen) | MEDIUM   | Untestable in CI without matugen                                                      |
| Renderers have no formal interface                           | MEDIUM   | Ad-hoc duck typing — any renderer can break silently                                  |
| No dependency inversion                                      | MEDIUM   | Domain code imports infrastructure directly                                           |

### Profile System

| Problem                            | Severity | Impact                                |
| ---------------------------------- | -------- | ------------------------------------- |
| Generator is a single shell script | MEDIUM   | No tests, string manipulation fragile |
| Validator mixes I/O with logic     | LOW      | Tight coupling to file system         |

## Proposed Architecture

### Hexagonal Layers

```
┌──────────────────────────────────────────────────────┐
│                  CLI / Entry Points                    │
│  scripts/apply-theme, scripts/doctor, scripts/sync    │
├──────────────────────────────────────────────────────┤
│               Application Layer (Use Cases)            │
│  ThemeApplier, SystemDoctor, SyncOrchestrator,        │
│  ProfileManager, KeybindingGenerator                   │
├──────────────────────────────────────────────────────┤
│                  Domain Layer (Pure)                   │
│  Palette, ColorMath, ModeDetector, TokenSchema,       │
│  WCAGGuard, ProfileSchema, BindingSpec                 │
├──────────────────────────────────────────────────────┤
│               Infrastructure (Adapters)               │
│  FileSystem, ShellExecutor, SubprocessRunner,         │
│  WaybarAdapter, KittyAdapter, HyprlandAdapter...       │
└──────────────────────────────────────────────────────┘
```

### Directory Structure

```
src/dreamcoder_theme/
├── domain/                    # Pure — zero I/O
│   ├── palette.py             # Color math, contrast, blending
│   ├── mode_detector.py       # Light/dark detection from tokens
│   ├── token_schema.py        # Token structure validation
│   └── wcag_guard.py          # Accessibility thresholds
├── application/               # Use cases — orchestration
│   ├── theme_applier.py       # Apply theme to all targets
│   ├── theme_syncer.py        # Sync orchestrator (was sync.py)
│   ├── system_doctor.py       # Health checks (was doctor.sh)
│   └── keybinding_generator.py # Profile → Lua (was shell script)
├── ports/                     # Interfaces (ABCs)
│   ├── renderer.py            # Renderer protocol
│   ├── writer.py              # File writer protocol
│   └── validator.py           # Validation protocol
└── adapters/                  # I/O implementations
    ├── renderers/
    │   ├── kitty.py
    │   ├── ghostty.py
    │   ├── waybar.py
    │   └── ...
    ├── writers/
    │   └── file_writer.py
    └── shell/
        └── command_runner.py

lib/                           # Shared shell library (NEW)
├── core.sh                    # Logging, env, error handling
├── theme.sh                   # Theme detection, mode switching
├── hyprland.sh                # Hyprland/ML4W utilities
└── testing.sh                 # Test helpers

tests/
├── unit/                      # Domain + application unit tests
│   ├── test_palette.py
│   ├── test_mode_detector.py
│   └── ...
├── integration/               # Adapter + cross-layer tests
│   ├── test_theme_applier.py
│   └── ...
└── shell/                     # bats tests (NEW)
    ├── test_apply_theme.bats
    ├── test_doctor.bats
    └── ...
```

### Key Design Decisions

1. **Domain is pure Python** — zero file I/O, zero subprocess. Testable with `pytest` alone.
2. **Shell becomes thin** — scripts delegate to Python application layer or use shared `lib/` functions.
3. **Ports define contracts** — `Renderer.render(tokens) → str`, `Writer.write(path, content) → None`.
4. **Adapters implement ports** — each target (Kitty, Waybar, etc.) is an adapter, not a one-off function.
5. **Tests first** — bats for shell, pytest for Python. Zero untested surface policy.

### Migration Strategy

**Phase 1: Foundation (no behavior change)**

- Create `lib/` shell library, refactor scripts to use it
- Add bats tests for critical paths (apply-theme, doctor, generate-custom-lua)
- Extract `domain/` from `palette.py` and `core.py`

**Phase 2: Python Hexagonal**

- Ports + Adapters for renderers
- `ThemeApplier` use case
- `KeybindingGenerator` in Python (replace shell script)

**Phase 3: Shell Elimination**

- `doctor.sh` → `system_doctor.py`
- `apply-theme-mode.sh` → `theme_applier.py` orchestration
- Shell scripts become one-line Python invocations

**Phase 4: Polish**

- 80%+ test coverage
- Full documentation
- CI pipeline for shell + Python tests

### Risks

| Risk                           | Mitigation                                                              |
| ------------------------------ | ----------------------------------------------------------------------- |
| Breaking user's working config | Feature-flag old scripts during migration                               |
| Scope creep                    | Strict phase boundaries, each phase is independently shippable          |
| Shell → Python regression      | Bats tests validate old behavior before migration                       |
| Over-engineering               | Hexagonal fits naturally — we already have multiple targets (renderers) |
