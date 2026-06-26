# Phase 1 — Foundation: Monorepo Restructure & Quality Tooling

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure the dreamcoder-dots monorepo layout, configure quality tooling (Ruff, Mypy, shellcheck), set up EditorConfig, ADRs, pre-commit, and Makefile targets.

**Architecture:** Move `dreamcoder_theme` from `scripts/` to `src/` to follow Python packaging conventions, separate shell scripts in `scripts/`, configure quality tooling in `pyproject.toml`, and wire everything through pre-commit and Makefile.

**Tech Stack:** Python 3.11+, Ruff, Mypy, shellcheck, pre-commit, adr-tools, EditorConfig, Make, pytest

## Global Constraints

- Ruff target-version = "py311", line-length = 100
- Mypy strict = true, python_version = "3.11", ignore-missing-imports for PyQt6
- shellcheck level = style, disable SC3043
- EditorConfig: *.py indent 4, *.sh indent 2, *.yml indent 2, Makefile tabs
- No code changes to dreamcoder_theme internals — pure structural move
- No shell script rewrites — only add `.sh` extension where missing
- All paths in pyproject.toml must reference `src/` after the move
- Pre-commit hooks: ruff check, ruff format --check, mypy, shellcheck, check-yaml, end-of-file-fixer, trailing-whitespace
- ADRs at `docs/adr/`, format: 0001-title-with-dashes.md
- Makefile targets: lint, python-lint, shell-lint, type-check, format, adr

---

### Task 1: EditorConfig + .gitignore updates

**Files:**
- Create: `.editorconfig`
- Modify: `.gitignore`
- Verify: no runtime tests needed

**Interfaces:**
- Consumes: nothing
- Produces: `.editorconfig` root config, updated `.gitignore`

- [ ] **Step 1: Create `.editorconfig`**

```ini
# .editorconfig — dreamcoder-dots
root = true

[*]
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.py]
indent_style = space
indent_size = 4

[*.sh]
indent_style = space
indent_size = 2

[*.{yml,yaml}]
indent_style = space
indent_size = 2

[Makefile]
indent_style = tab
```

- [ ] **Step 2: Update `.gitignore`**

Add these lines before the `# Python cache` section:

```gitignore
# Editor
.editorconfig-unreal  # not used, just a marker
```

Actually add these to the Editor section:

```gitignore
# Python packaging
src/dreamcoder_theme.egg-info/
```

After the existing `*.egg-info/` line, add:

```gitignore
# Python packaging
src/dreamcoder_theme.egg-info/
```

- [ ] **Step 3: Commit**

```bash
git add .editorconfig .gitignore
git commit -m "chore: add EditorConfig and update gitignore for new layout"
```

---

### Task 2: Move dreamcoder_theme to src/ + update pyproject.toml

**Files:**
- Move: `scripts/dreamcoder_theme/` → `src/dreamcoder_theme/`
- Modify: `pyproject.toml` — update package find paths, pytest pythonpath
- Delete: no forced delete, but ensure old path isn't referenced
- Verify: `python -c "from dreamcoder_theme.control import main; print('OK')"`

**Interfaces:**
- Consumes: nothing
- Produces: `src/dreamcoder_theme/` with all files, updated `pyproject.toml`

- [ ] **Step 1: Create `src/` directory and move the package**

```bash
mkdir -p src
mv scripts/dreamcoder_theme/ src/dreamcoder_theme/
```

- [ ] **Step 2: Update `pyproject.toml`**

Change `[tool.setuptools.packages.find]` section:

```toml
[tool.setuptools.packages.find]
where = ["src"]
include = ["dreamcoder_theme*"]
```

Change `[tool.pytest.ini_options]`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-q"
pythonpath = ["src"]
```

- [ ] **Step 3: Verify the package imports correctly**

```bash
pip install -e ".[dev]"
python -c "from dreamcoder_theme.control import main; print('Package OK')"
```

Expected output: `Package OK`

- [ ] **Step 4: Commit**

```bash
git add src/ pyproject.toml
git rm -r scripts/dreamcoder_theme/
git commit -m "refactor: move dreamcoder_theme from scripts/ to src/"
```

---

### Task 3: Configure Ruff in pyproject.toml

**Files:**
- Modify: `pyproject.toml` — add `[tool.ruff]` sections
- Verify: `ruff check src/ tests/` and `ruff format --check src/ tests/`

**Interfaces:**
- Consumes: `pyproject.toml` (updated in Task 2)
- Produces: Ruff linter + formatter config

- [ ] **Step 1: Add Ruff config to `pyproject.toml`**

Add after the `[tool.pytest.ini_options]` section:

```toml
[tool.ruff]
target-version = "py311"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP", "YTT", "ASYNC", "SIM", "PL", "RUF"]
ignore = ["E501"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "lf"
```

- [ ] **Step 2: Run Ruff check and fix issues**

```bash
ruff check src/ tests/ --fix
```

If auto-fixable issues remain, they'll be fixed. Any remaining issues need manual review — the goal is a clean run.

```bash
ruff check src/ tests/
```

Expected output: no errors/warnings (or minimal known issues documented)

- [ ] **Step 3: Run Ruff format check**

```bash
ruff format --check src/ tests/
```

If there are formatting issues:
```bash
ruff format src/ tests/
```

Then re-check:
```bash
ruff format --check src/ tests/
```

Expected: Clean output with no changes needed.

- [ ] **Step 4: Commit**

```bash
git add pyproject.toml
git commit -m "chore: configure Ruff linter and formatter"
```

---

### Task 4: Configure Mypy with strict mode

**Files:**
- Modify: `pyproject.toml` — add `[tool.mypy]` section
- Verify: `mypy src/`

**Interfaces:**
- Consumes: `pyproject.toml` (updated in Task 2)
- Produces: Mypy strict mode config

- [ ] **Step 1: Add Mypy config to `pyproject.toml`**

Add after the `[tool.ruff]` section:

```toml
[tool.mypy]
python_version = "3.11"
strict = true
show_error_codes = true
warn_unreachable = true
ignore_missing_imports = false

[[tool.mypy.overrides]]
module = "PyQt6.*"
ignore_missing_imports = true

[[tool.mypy.overrides]]
module = "matugen.*"
ignore_missing_imports = true
```

- [ ] **Step 2: Run Mypy to see current state**

```bash
mypy src/ 2>&1 | head -60
```

Document the number of errors. The key is that the config works and errors are expected (pure structural change, no code fixes in Phase 1).

Expected: Mypy will report type errors — this is fine, Phase 2 will fix them. The plan is to have the config in place.

- [ ] **Step 3: Add a `mypy.ini` fallback override comment** (optional, but good practice)

Add this comment right before `[tool.mypy]`:

```toml
# Mypy strict mode — Phase 2 will address all type errors
```

- [ ] **Step 4: Commit**

```bash
git add pyproject.toml
git commit -m "chore: configure Mypy strict mode"
```

---

### Task 5: Configure shellcheck

**Files:**
- Create: `.shellcheckrc`
- Verify: `find scripts/ -name '*.sh' -exec shellcheck --shell=bash {} +` (once scripts are identified)

**Interfaces:**
- Consumes: nothing
- Produces: `.shellcheckrc`

- [ ] **Step 1: Create `.shellcheckrc`**

```
# shellcheck config for dreamcoder-dots
# SC3043: 'local' is not POSIX — we target bash, not sh
disable=SC3043
```

- [ ] **Step 2: Rename shell scripts that lack `.sh` extension**

Some scripts in `scripts/` might not have `.sh` extension (e.g., `dreamcoder`, `dreamcoder.sh`). Check:

```bash
cd scripts
for f in *; do
  if [[ -f "$f" && ! "$f" =~ \.py$ && ! "$f" =~ \.sh$ && ! "$f" =~ \.md$ && "$(head -1 "$f" 2>/dev/null)" =~ ^#! ]]; then
    echo "Would rename: $f → $f.sh"
  fi
done
```

If any are missing the extension and have a shebang, rename them:

```bash
# Only if the above shows candidates:
# mv scripts/dreamcoder scripts/dreamcoder.sh
```

- [ ] **Step 3: Run shellcheck on all shell scripts**

```bash
find scripts/ -name "*.sh" -exec shellcheck -s bash {} +
```

Expected: Warnings may appear. SC3043 should not appear (it's disabled). Note any real issues found.

- [ ] **Step 4: Commit**

```bash
git add .shellcheckrc
git commit -m "chore: configure shellcheck"
```

---

### Task 6: Full pre-commit configuration

**Files:**
- Modify: `.pre-commit-config.yaml`
- Verify: `pre-commit run --all-files`

**Interfaces:**
- Consumes: Ruff (Task 3), Mypy (Task 4), shellcheck (Task 5) — configurations exist in pyproject.toml and .shellcheckrc
- Produces: Complete `.pre-commit-config.yaml`

- [ ] **Step 1: Write `.pre-commit-config.yaml`**

Replace the current file:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.7.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.11.0
    hooks:
      - id: mypy
        args: [--config-file=pyproject.toml]
        additional_dependencies: [PyQt6-stubs]
        pass_filenames: false

  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.10.0.1
    hooks:
      - id: shellcheck
        args: ["--shell=bash"]
        files: ^scripts/.*\.sh$

  - repo: local
    hooks:
      - id: dreamcoder-theme-validate
        name: Validate Dreamcoder theme tokens
        entry: python scripts/verify-theme-health.py
        language: system
        files: ^(themes/dreamcoder/.*\.json|scripts/verify-theme-health\.py)$
        pass_filenames: false
      - id: dreamcoder-preview-regenerate
        name: Regenerate theme preview
        entry: python scripts/generate-theme-preview.py && git diff --quiet --exit-code docs/dreamcoder-theme-preview.md
        language: system
        files: ^themes/dreamcoder/.*\.json$
        pass_filenames: false
```

Wait — the local hooks reference `scripts/verify-theme-health.py` and `scripts/generate-theme-preview.py`. These are Python files that stayed in `scripts/` (they're tools, not part of the dreamcoder_theme package). Let me verify they're still there.

- [ ] **Step 2: Verify local hook paths are correct**

```bash
ls -la scripts/verify-theme-health.py scripts/generate-theme-preview.py
```

If these exist, the local hooks are correct. If not, remove those hooks.

- [ ] **Step 3: Run pre-commit on all files**

```bash
pre-commit run --all-files 2>&1 | tail -60
```

Expected: All hooks pass or only expected failures (e.g., Mypy errors are known). The structural hooks (trailing-whitespace, end-of-file-fixer, YAML validation) should pass cleanly.

- [ ] **Step 4: Commit**

```bash
git add .pre-commit-config.yaml
git commit -m "chore: update pre-commit config with Ruff, Mypy, shellcheck"
```

---

### Task 7: tests/ + shell-tests/ scaffolding

**Files:**
- Modify: `tests/conftest.py` — update to work with `src/` layout
- Create: `shell-tests/` directory
- Create: `shell-tests/test_helper.bash`
- Verify: `python -m pytest tests/ -q` (should still pass all 17 tests)

**Interfaces:**
- Consumes: `pyproject.toml` (Task 2 — pythonpath points to `src/`)
- Produces: Working test scaffolding for both Python and shell

- [ ] **Step 1: Update `tests/conftest.py` for the new src layout**

Read current conftest if it exists:

```bash
cat tests/conftest.py 2>/dev/null || echo "No conftest.py yet"
```

If it exists and has path manipulation like `sys.path.insert(0, "scripts")`, update to `sys.path.insert(0, "src")`:

```python
# conftest.py — updated for new src/ layout
import sys
from pathlib import Path

SRC_DIR = Path(__file__).resolve().parent.parent / "src"
if str(SRC_DIR) not in sys.path:
    sys.path.insert(0, str(SRC_DIR))
```

If it doesn't exist, create it with the above content.

- [ ] **Step 2: Run existing tests to verify they still pass**

```bash
python -m pytest tests/ -v 2>&1 | tail -30
```

Expected: All 17 tests pass after the move. If any fail due to import paths, fix the conftest.py to include both `src/` and the old `scripts/` path as fallback.

- [ ] **Step 3: Create `shell-tests/` directory and helper**

```bash
mkdir -p shell-tests
```

Create `shell-tests/test_helper.bash`:

```bash
# test_helper.bash — common setup for bats tests
# Source this in each test file: setup() { load test_helper; }

setup_file() {
    export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    export SCRIPTS_DIR="${PROJECT_ROOT}/scripts"
}

setup() {
    if [[ ! -d "$SCRIPTS_DIR" ]]; then
        echo "ERROR: scripts directory not found at $SCRIPTS_DIR" >&2
        return 1
    fi
}
```

- [ ] **Step 4: Commit**

```bash
git add tests/conftest.py shell-tests/
git commit -m "chore: update test scaffolding for new layout"
```

---

### Task 8: ADR-001 and ADR-002

**Files:**
- Create: `docs/adr/0001-project-structure.md`
- Create: `docs/adr/0002-toolchain-selection.md`
- Verify: `cat docs/adr/0001-project-structure.md` — reads correctly

**Interfaces:**
- Consumes: nothing
- Produces: Two ADRs documenting key decisions

- [ ] **Step 1: Install `adr-tools`**

```bash
sudo pacman -S adr-tools
```

If not available:
```bash
yay -S adr-tools
```

- [ ] **Step 2: Initialize ADR directory**

```bash
mkdir -p docs/adr
```

- [ ] **Step 3: Create ADR-001 — Project Structure Layout**

```bash
cat > docs/adr/0001-project-structure.md << 'ADREOF'
# ADR-001: Monorepo Project Structure Layout

## Status

Accepted

## Context

The dreamcoder-dots repository started as a personal dotfiles collection and
grew organically. The main Python package `dreamcoder_theme` lived inside
`scripts/`, which doesn't follow standard Python packaging conventions. Shell
scripts were mixed with Python code, and there was no clear separation between
source code, tests, and tooling.

## Decision

We restructure the repository to follow a standard monorepo layout:

```
src/                    # Python source packages
  dreamcoder_theme/     # Main theme engine package
scripts/                # Shell scripts only
tests/                  # Python tests
shell-tests/            # bats tests for shell scripts
docs/                   # Documentation
  adr/                  # Architecture Decision Records
  superpowers/          # Design docs and implementation plans
```

Key decisions:
- Python package moves from `scripts/` to `src/` following PEP 517/518
- All shell scripts use `.sh` extension for consistent tooling
- `pyproject.toml` is the single source of truth for Python config
- Tool config (Ruff, Mypy, shellcheck) lives in `pyproject.toml` or root dotfiles

## Consequences

Positive:
- Standard Python packaging layout (pip, build, setuptools all work correctly)
- Clear separation of concerns at the directory level
- Tooling can target specific directories without exclusion lists

Negative:
- Existing imports or scripts that reference `scripts/dreamcoder_theme/` will
  break until updated (none should, since it's installed as a package)
- Any hardcoded paths in CI/CD need updating

## Compliance

- `pyproject.toml` must point `[tool.setuptools.packages.find]` to `src/`
- All new Python packages must live under `src/`
- Shell scripts must live under `scripts/` with `.sh` extension
ADREOF
```

- [ ] **Step 4: Create ADR-002 — Toolchain Selection**

```bash
cat > docs/adr/0002-toolchain-selection.md << 'ADREOF'
# ADR-002: Python and Shell Quality Toolchain

## Status

Accepted

## Context

The project had no standardized linting, formatting, or type checking. Shell
scripts had no static analysis. This led to inconsistent code style and
preventable bugs.

## Decision

### Python — Ruff (linter + formatter)

We replace the implicit flake8/isort/pyupgrade combination with Ruff:
- **Why**: Ruff is 10-100x faster, replaces multiple tools, has built-in
  formatter compatible with Black, and is configured entirely in
  `pyproject.toml`
- **Level**: E, F, I, N, W, UP, YTT, ASYNC, SIM, PL, RUF
- **Line length**: 100
- **Formatter**: Built-in `ruff format` (compatible with Black)

### Python — Mypy (type checker)

We adopt Mypy in strict mode:
- **Why**: Catches type errors before runtime, documents interfaces,
  enables safer refactoring
- **Level**: Strict (`strict = true`)
- **Overrides**: PyQt6 gets `ignore_missing_imports = true` (no stubs available)

### Shell — shellcheck

We adopt shellcheck for all shell scripts:
- **Why**: Industry standard, catches common shell scripting bugs
- **Level**: `style` (most thorough)
- **Disabled**: SC3043 (`local` — we target bash, not POSIX sh)

### Pre-commit integration

All tools run as pre-commit hooks on every commit, providing fast feedback.

## Consequences

Positive:
- Consistent code style enforced automatically
- Type errors caught in CI instead of production
- Shell scripts get the same quality bar as Python code

Negative:
- Initial migration: Ruff may flag existing code (fixed automatically where possible)
- Mypy strict mode will report errors in existing code (addressed in Phase 2)
- All contributors must have these tools installed (pre-commit handles this)

## Compliance

- `ruff check` must pass before merge
- `ruff format --check` must pass before merge
- `mypy` must pass before merge (Phase 2 target — currently advisory)
- `shellcheck --shell=bash` must pass for all `.sh` files in `scripts/`

## Alternatives Considered

- **Black** as formatter: Rejected in favor of Ruff's built-in formatter
  (compatible, fewer dependencies)
- **Pyright/Pylance**: Rejected in favor of Mypy (more widely adopted community
  standard for open-source Python)
- **Flake8 + isort**: Rejected in favor of Ruff (single tool, faster)
ADREOF
```

- [ ] **Step 5: Commit**

```bash
git add docs/adr/
git commit -m "docs: add ADR-001 (project structure) and ADR-002 (toolchain)"
```

---

### Task 9: Makefile updates

**Files:**
- Modify: `Makefile`
- Verify: `make lint` (should run all checks)

**Interfaces:**
- Consumes: All toolchain configs from Tasks 2-5
- Produces: Updated Makefile with lint, python-lint, shell-lint, type-check, format, adr targets

- [ ] **Step 1: Update `Makefile`**

Replace the current content:

```makefile
.PHONY: install test coverage build clean lint python-lint shell-lint type-check format adr

install:
	pip install -e ".[dev]"

test:
	python -m pytest tests/ -v

coverage:
	python -m pytest tests/ --cov=dreamcoder_theme --cov-report=term-missing

build:
	python -m build

clean:
	rm -rf dist/ build/ *.egg-info/ src/*.egg-info/

lint: python-lint shell-lint type-check

python-lint:
	ruff check src/ tests/
	ruff format --check src/ tests/

shell-lint:
	find scripts/ -name '*.sh' -exec shellcheck --shell=bash {} +

type-check:
	mypy src/

format:
	ruff format src/ tests/

adr:
	@echo "=== Architecture Decision Records ==="
	@ls docs/adr/*.md | while read f; do \
		echo "  $$(basename $$f) — $$(head -3 "$$f" | tail -1)"; \
	done
	@echo "Total: $$(ls docs/adr/*.md 2>/dev/null | wc -l) ADRs"
```

- [ ] **Step 2: Verify Makefile targets**

```bash
make lint 2>&1 | head -30
```

Expected output: Runs ruff check, ruff format --check, shellcheck, and mypy. May have warnings but no fatal errors.

- [ ] **Step 3: Commit**

```bash
git add Makefile
git commit -m "chore: update Makefile with lint, type-check, format, adr targets"
```

---

### Task 10: Final verification

**Files:** None
**Verify:** All tools pass on the new structure

- [ ] **Step 1: Run full lint suite**

```bash
make lint 2>&1
```

Document any remaining issues (expected: Mypy strict errors — Phase 2 scope).

- [ ] **Step 2: Run pre-commit on all files**

```bash
pre-commit run --all-files 2>&1
```

- [ ] **Step 3: Run tests**

```bash
make test 2>&1 | tail -20
```

Expected: All 17 tests pass.

- [ ] **Step 4: Run coverage**

```bash
make coverage 2>&1 | tail -10
```

Expected: ~60% coverage (same as before, no new code added).

- [ ] **Step 5: Verify ADRs render**

```bash
make adr
```

Expected:
```
=== Architecture Decision Records ===
  0001-project-structure.md — ## Status
  0002-toolchain-selection.md — ## Status
Total: 2 ADRs
```

- [ ] **Step 6: Install pre-commit hooks**

```bash
pre-commit install
```

- [ ] **Step 7: Final commit with any remaining changes**

```bash
git add -A
git status
```

If there are uncommitted changes, commit them:

```bash
git commit -m "chore: finalize Phase 1 foundation setup"
```
