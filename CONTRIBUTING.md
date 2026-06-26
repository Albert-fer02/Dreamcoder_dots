# Contributing

Thanks for your interest in Dreamcoder OS! This project is a personal dotfiles
repository with an open-source theme engine. Contributions, ideas, and bug
reports are welcome.

## Project Structure

```
src/dreamcoder_theme/     # Python theme engine (pip-installable package)
  ├── palette.py              # Color math, adaptive palette derivation
  ├── palette_tokens.py       # Static design tokens (dark/light/dusk)
  ├── renderers_*.py          # Per-target format renderers
  ├── sync.py                 # Theme file orchestration
  ├── control.py              # CLI entry point
  └── ...
tests/                        # pytest test suite
themes/dreamcoder/            # Generated theme files (output)
```

Each terminal/shell/editor lives in its own top-level directory
(`Kitty/`, `Ghostty/`, `Nvim/`, etc.) and is installed via GNU Stow.

## Development Setup

```bash
# Clone and enter
git clone git@github.com:Gentleman-Programming/dreamcoder-dots.git
cd dreamcoder-dots

# Install with dev dependencies (using pip)
pip install -e ".[dev]"

# Or using uv (recommended)
uv pip install -e ".[dev]"
```

## Running Tests

```bash
# Full test suite
pytest

# With coverage
pytest --cov=dreamcoder_theme --cov-report=term-missing

# Specific test file
pytest tests/test_palette.py -v
```

## Linting

```bash
# ruff for Python
ruff check src/dreamcoder_theme/
```

## Building

```bash
# Build wheel + source tarball
python -m build

# Or via Makefile
make build
```

## Pull Request Guidelines

- Keep changes focused — one feature/fix per PR.
- Add tests for new functionality.
- Ensure `pytest` passes before opening the PR.
- Follow existing code style (the project uses ruff defaults).
- Keep the CHANGELOG updated under `## Unreleased`.

## Design Principles

- **Health first**: colors must pass WCAG AA contrast ratios.
- **Single source of truth**: edit tokens in `palette_tokens.py`, not in
  individual theme files.
- **Renderers are pure**: each renderer takes a color dict and returns a
  string — no side effects.
- **Stow-compatible**: file paths in the repo mirror `$HOME` layout so GNU
  Stow can link them directly.
