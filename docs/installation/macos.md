# Installing Dreamcoder Workbench on macOS

## Prerequisites

- macOS 12+
- Homebrew
- Git

## Install

Dreamcoder Workbench is distributed as a git repository, not a Homebrew formula.

```bash
# Install base dependencies
brew install stow git python

# Clone and install
git clone https://github.com/Dreamcoder08/Dreamcoder-Workbench.git ~/Dreamcoder-Workbench
cd ~/Dreamcoder-Workbench

# Install the Python theme engine
pip install -e .
# or, with uv:
uv sync

# Run the installer
./scripts/dreamcoder install
```

## Verify

```bash
./scripts/dreamcoder doctor    # Health check
./scripts/dreamcoder status    # System status
```

If the installer was skipped, you can still use the theme engine directly:

```bash
dreamcoder-theme sync
```

## Rollback

- The installer writes a backup manifest under `~/.local/share/dreamcoder/backups/` before changing configs. To restore, run `./scripts/dreamcoder backup restore <backup_id> --json` with the backup id shown during install.
- To remove the environment entirely, delete the symlinks the installer created (listed in the backup manifest) and remove the `~/Dreamcoder-Workbench` directory.

> **Note**: terminal, shell, and multiplexer overlays assume a Linux-style environment; GUI and systemd-timer features are limited on macOS.
