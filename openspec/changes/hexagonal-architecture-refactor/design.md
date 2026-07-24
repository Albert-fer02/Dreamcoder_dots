# Design: Hexagonal Architecture Refactor

## Layer Dependency Rules

```
CLI/Scripts ──→ Application ──→ Ports (ABCs)
                     │                ↑
                     ↓                │
                  Domain (pure)  Adapters (impl)
```

**Iron rule**: Domain imports NOTHING from Application, Infrastructure, or Adapters. Application imports only Domain + Ports. Adapters import only Ports + Domain.

## Key Interfaces

### Renderer Protocol

```python
# src/dreamcoder_theme/ports/renderer.py
from abc import ABC, abstractmethod
from dataclasses import dataclass

@dataclass
class RenderResult:
    target_name: str
    output_path: str
    content: str
    mode: str  # "light" | "dark" | "dusk"

class Renderer(ABC):
    """Contract: every theme target implements this."""

    @abstractmethod
    def render(self, tokens: dict[str, str]) -> RenderResult:
        """Transform Dreamcoder tokens into target-specific output."""
        ...

    @property
    @abstractmethod
    def target_name(self) -> str:
        """Unique identifier (e.g., 'kitty', 'waybar-light')."""
        ...
```

### Writer Protocol

```python
# src/dreamcoder_theme/ports/writer.py
class Writer(ABC):
    @abstractmethod
    def write(self, path: Path, content: str, *, atomic: bool = True) -> None: ...
    @abstractmethod
    def symlink(self, source: Path, target: Path) -> None: ...
```

### SystemDoctor Check Protocol

```python
# src/dreamcoder_theme/application/system_doctor.py
@dataclass
class CheckResult:
    name: str
    status: str  # "pass" | "warn" | "fail"
    message: str
    fix_hint: str | None = None

CheckFn = Callable[[], CheckResult]  # Each check is a zero-arg callable
```

## Domain Module Design

### palette.py (refactored)

```python
# Pure — only stdlib math, no subprocess
class Palette:
    @staticmethod
    def contrast_ratio(fg: str, bg: str) -> float: ...
    @staticmethod
    def relative_luminance(hex_color: str) -> float: ...
    @staticmethod
    def blend(c1: str, c2: str, ratio: float = 0.5) -> str: ...
    @staticmethod
    def ensure_contrast(fg: str, bg: str, min_ratio: float) -> str: ...

# Matugen-specific logic moves to:
# src/dreamcoder_theme/adapters/matugen_adapter.py
```

### mode_detector.py (extracted from core.py)

```python
class ModeDetector:
    DARK_MARKERS = ("dreamcoder dark", "ember noir", "anthracite steel")
    LIGHT_MARKERS = ("dreamcoder light", "cocoa cream")

    @staticmethod
    def from_tokens(tokens: dict) -> str: ...
    @staticmethod
    def from_file_content(text: str) -> str: ...
```

## Application Layer Design

### ThemeApplier

```python
class ThemeApplier:
    def __init__(
        self,
        renderers: list[Renderer],
        writer: Writer,
        signaler: SignalSender,
        mode_detector: ModeDetector,
    ): ...

    def apply(self, mode: str | None = None) -> ApplyResult:
        """1. Detect mode  2. Load tokens  3. Render all  4. Write files  5. Signal"""
```

### KeybindingGenerator (replaces shell script)

```python
class KeybindingGenerator:
    def generate(self, profile: dict) -> str:
        """Profile JSON → Hyprland Lua string.
        Uses Jinja2 template internally (adapter injection point)."""
```

## Shell Library Design

### lib/core.sh

```bash
# Single source of truth for project root
ensure_dots_dir() {
    if [[ -z "${DREAMCODER_DOTS_DIR:-}" ]]; then
        export DREAMCODER_DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    fi
}

# Consistent logging
log_info()  { echo "ℹ️  $*"; }
log_warn()  { echo "⚠️  $*" >&2; }
log_error() { echo "❌ $*" >&2; }

# Safe command checking
require_command() {
    command -v "$1" >/dev/null || {
        log_error "$1 is required but not installed"
        return 1
    }
}

# GUI session detection (single source)
is_gui_session() {
    [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]]
}
```

## Migration: Phase 1 Details

### Step 1: Create lib/ directory

```
lib/
├── core.sh          # logging, env, error handling
├── theme.sh         # mode detection, token loading
└── hyprland.sh      # reload, waybar restart
```

### Step 2: Refactor scripts to use lib/

Each script becomes a thin orchestration layer:

```bash
#!/usr/bin/env bash
set -euo pipefail
source "${DREAMCODER_DOTS_DIR}/lib/core.sh"
source "${DREAMCODER_DOTS_DIR}/lib/theme.sh"

main() {
    local mode="${1:-$(detect_theme_mode)}"
    log_info "Applying ${mode} theme..."
    # ... orchestration only
}
main "$@"
```

### Step 3: Add bats tests

```bash
# tests/shell/test_apply_theme.bats
@test "apply-theme-mode.sh --help exits 0" {
  run bash scripts/apply-theme-mode.sh --help
  [ "$status" -eq 0 ]
}
```

### Step 4: Extract domain layer

- Move color math from `palette.py` to `domain/palette.py`
- Move mode detection from `core.py` to `domain/mode_detector.py`
- Keep old imports as aliases during migration

## File Structure After Phase 1

```
src/dreamcoder_theme/
├── domain/                    # NEW
│   ├── __init__.py
│   ├── palette.py             # Pure color math
│   └── mode_detector.py       # Theme detection
├── ports/                     # NEW
│   ├── __init__.py
│   ├── renderer.py            # ABC
│   └── writer.py              # ABC
├── application/               # NEW (empty in Phase 1)
├── adapters/                  # NEW (empty in Phase 1)
├── palette.py                 # → re-exports from domain.palette
├── core.py                    # → re-exports ModeDetector
├── renderers_kitty.py         # unchanged
├── renderers_ghostty.py       # unchanged
├── ...                        # other renderers unchanged
├── sync.py                    # unchanged
└── ...
lib/                           # NEW
├── core.sh
├── theme.sh
└── hyprland.sh
tests/
├── unit/                      # NEW
│   ├── test_palette.py        # Domain unit tests
│   └── test_mode_detector.py
├── shell/                     # NEW
│   ├── test_apply_theme.bats
│   └── test_doctor.bats
├── test_renderer_output.py    # existing
└── ...
```
