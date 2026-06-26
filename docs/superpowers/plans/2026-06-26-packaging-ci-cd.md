# Packaging & CI/CD Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add modern Python packaging (pyproject.toml) and a comprehensive CI/CD pipeline for dreamcoder-dots.

**Architecture:** Single package `dreamcoder_theme` with CLI entry points. No namespace packages. Version sourced from `__version__` in `__init__.py`. CI runs full test suite on every push/PR, publishes to PyPI on tags.

**Tech Stack:** pyproject.toml (PEP 621), setuptools, pytest, coverage, GitHub Actions, PyPI (Trusted Publisher).

## Global Constraints

- Python 3.11+ minimum (matches existing codebase patterns — `from __future__ import annotations` everywhere)
- All existing tests must pass after packaging
- No breaking changes to existing CLI usage (`./scripts/dreamcoder`, `python3 -m dreamcoder_theme.control`)
- Jinja2 is the only third-party runtime dependency
- Version string in `scripts/dreamcoder_theme/__init__.py` matches git tag on release

---

### Task 1: `__version__` and `pyproject.toml`

**Files:**
- Modify: `scripts/dreamcoder_theme/__init__.py`
- Create: `pyproject.toml`

**Interfaces:**
- Consumes: existing package structure under `scripts/dreamcoder_theme/`
- Produces: `dreamcoder_theme.__version__` string, `pyproject.toml` with all metadata and tool configs

- [ ] **Step 1: Add `__version__` to `__init__.py`**

```python
"""Dreamcoder theme generation package."""

__version__ = "0.1.0"
```

- [ ] **Step 2: Create `pyproject.toml`**

```toml
[build-system]
requires = ["setuptools>=69.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "dreamcoder-theme"
dynamic = ["version"]
description = "Dreamcoder OS — personal Arch Linux dotfiles with a premium color theme engine"
readme = "README.md"
requires-python = ">=3.11"
license = { text = "MIT" }
authors = [
  { name = "Dreamcoder" },
]
keywords = ["dotfiles", "theme", "arch-linux", "colorscheme", "hyprland"]
classifiers = [
  "Development Status :: 4 - Beta",
  "Environment :: Console",
  "Intended Audience :: End Users/Desktop",
  "License :: OSI Approved :: MIT License",
  "Operating System :: POSIX :: Linux",
  "Programming Language :: Python :: 3",
  "Programming Language :: Python :: 3.11",
  "Programming Language :: Python :: 3.12",
  "Topic :: Desktop Environment",
]
dependencies = [
  "jinja2>=3.0",
]
optional-dependencies = { dev = ["pytest>=7", "pytest-cov>=4"] }

[project.urls]
Homepage = "https://github.com/Gentleman-Programming/dreamcoder-dots"
Repository = "https://github.com/Gentleman-Programming/dreamcoder-dots"
Changelog = "https://github.com/Gentleman-Programming/dreamcoder-dots/blob/main/CHANGELOG.md"

[project.scripts]
dreamcoder-theme = "dreamcoder_theme.control:main"

[tool.setuptools.dynamic]
version = { file = "scripts/dreamcoder_theme/__init__.py" }

[tool.setuptools.packages.find]
where = ["scripts"]
include = ["dreamcoder_theme*"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-q"
pythonpath = ["scripts"]

[tool.coverage.run]
source = ["dreamcoder_theme"]
source_pkgs = ["dreamcoder_theme"]
relative_files = true

[tool.coverage.report]
show_missing = true
fail_under = 80
```

Wait — setuptools doesn't support `file =` for version in `[tool.setuptools.dynamic]` with a regex on a Python file easily. Let me use a simpler approach: read version from a `VERSION` file or set it statically.

Actually, the simplest reliable approach: static version in pyproject.toml, and a single source of truth. Let me do it right:

```toml
[build-system]
requires = ["setuptools>=69.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "dreamcoder-theme"
version = "0.1.0"
description = "Dreamcoder OS — personal Arch Linux dotfiles with a premium color theme engine"
readme = "README.md"
requires-python = ">=3.11"
license = { text = "MIT" }
authors = [
  { name = "Dreamcoder" },
]
keywords = ["dotfiles", "theme", "arch-linux", "colorscheme", "hyprland"]
classifiers = [
  "Development Status :: 4 - Beta",
  "Environment :: Console",
  "Intended Audience :: End Users/Desktop",
  "License :: OSI Approved :: MIT License",
  "Operating System :: POSIX :: Linux",
  "Programming Language :: Python :: 3",
  "Programming Language :: Python :: 3.11",
  "Programming Language :: Python :: 3.12",
  "Topic :: Desktop Environment",
]
dependencies = [
  "jinja2>=3.0",
]
optional-dependencies = { dev = ["pytest>=7", "pytest-cov>=4"] }

[project.urls]
Homepage = "https://github.com/Gentleman-Programming/dreamcoder-dots"
Repository = "https://github.com/Gentleman-Programming/dreamcoder-dots"
Changelog = "https://github.com/Gentleman-Programming/dreamcoder-dots/blob/main/CHANGELOG.md"

[project.scripts]
dreamcoder-theme = "dreamcoder_theme.control:main"

[tool.setuptools.packages.find]
where = ["scripts"]
include = ["dreamcoder_theme*"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-q"
pythonpath = ["scripts"]

[tool.coverage.run]
source = ["dreamcoder_theme"]
relative_files = true

[tool.coverage.report]
show_missing = true
fail_under = 80
```

- [ ] **Step 3: Verify packaging works**

Run: `pip install -e . 2>&1 | tail -5`
Expected: `Successfully installed dreamcoder-theme-0.1.0`

Run: `python -c "import dreamcoder_theme; print(dreamcoder_theme.__version__)"`
Expected: `0.1.0`

- [ ] **Step 4: Verify tests still pass with installed package**

Run: `python -m pytest tests/ -q`
Expected: `487 passed`

- [ ] **Step 5: Commit**

```bash
git add pyproject.toml scripts/dreamcoder_theme/__init__.py
git commit -m "build: add pyproject.toml and package version

- PEP 621 pyproject.toml with setuptools backend
- Single third-party dep: jinja2>=3.0
- CLI entry point: dreamcoder-theme
- pytest/coverage tool configs included"
```

---

### Task 2: Update .gitignore for packaging artifacts

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: Add packaging artifacts to .gitignore**

Append to `.gitignore`:

```gitignore
# Python packaging
*.egg-info/
dist/
build/
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: add packaging artifacts to .gitignore"
```

---

### Task 3: Expand CI workflow

**Files:**
- Modify: `.github/workflows/theme-validation.yml`

**Interfaces:**
- Consumes: pyproject.toml from Task 1
- Produces: CI that runs on all pushes/PRs with matrix testing, coverage, and PyPI publish

- [ ] **Step 1: Rewrite CI workflow for full push/PR coverage**

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install package
        run: |
          pip install --upgrade pip
          pip install -e ".[dev]"

      - name: Run tests with coverage
        run: python -m pytest tests/ --cov=dreamcoder_theme --cov-report=term-missing

      - name: Run theme health check
        run: python scripts/verify-theme-health.py

      - name: Generate theme preview
        run: python scripts/generate-theme-preview.py

      - name: Check for uncommitted changes
        run: |
          git diff --exit-code docs/dreamcoder-theme-preview.md || (echo "::error::Theme preview not regenerated" && exit 1)

  publish:
    needs: [test]
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/v')
    permissions:
      id-token: write

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install build tools
        run: pip install build

      - name: Build package
        run: python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

- [ ] **Step 2: Verify workflow syntax is valid**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/theme-validation.yml'))" 2>&1 || echo "No pyyaml, manually checking"`

Manually verify indentation is correct — YAML is whitespace-sensitive.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/theme-validation.yml
git commit -m "ci: expand CI to full test matrix + PyPI publishing

- Run on all push/PR to main (not just theme file changes)
- Python 3.11 + 3.12 matrix
- Coverage reporting with pytest-cov
- Theme health check and preview regeneration
- PyPI trusted publisher (publish on git tag v*)"
```

---

### Task 4: Add a Makefile for common commands

**Files:**
- Create: `Makefile`

- [ ] **Step 1: Create Makefile**

```makefile
.PHONY: install test coverage build clean lint

install:
	pip install -e ".[dev]"

test:
	python -m pytest tests/ -v

coverage:
	python -m pytest tests/ --cov=dreamcoder_theme --cov-report=term-missing

build:
	python -m build

clean:
	rm -rf dist/ build/ *.egg-info/

lint:
	ruff check scripts/dreamcoder_theme/ tests/
```

- [ ] **Step 2: Commit**

```bash
git add Makefile
git commit -m "chore: add Makefile for common dev commands"
```

---

### Task 5: Final verification — full suite passes

- [ ] **Step 1: Run full test suite one final time**

Run: `python -m pytest tests/ -q`
Expected: `487 passed`

- [ ] **Step 2: Verify package builds cleanly**

Run: `python -m build 2>&1 | tail -5`
Expected: `Successfully built dreamcoder-theme-0.1.0.tar.gz and dreamcoder-theme-0.1.0-py3-none-any.whl`

- [ ] **Step 3: Verify import works from wheel**

```bash
pip install dist/dreamcoder_theme-0.1.0-py3-none-any.whl
python -c "from dreamcoder_theme.control import main; print('OK:', main)" 2>&1 | grep -v RuntimeWarning | grep -v UserWarning
```

- [ ] **Step 4: Clean up test install**

```bash
pip uninstall -y dreamcoder-theme
pip install -e ".[dev]"
```

