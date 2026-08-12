# Installing Dreamcoder Workbench on Windows WSL

## Prerequisites

- Windows 10/11 with WSL2 enabled
- Ubuntu or Debian on WSL
- GNU Stow

## Install

```bash
# Install dependencies
sudo apt update && sudo apt install -y stow git python3 python3-venv

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

## Using Windows Terminal

After install, configure Windows Terminal to use:

- Shell: `wsl -d Ubuntu`
- Font: JetBrainsMono Nerd Font
- Theme: use the Dreamcoder theme in Windows Terminal settings

## Rollback

The installer writes a backup manifest under `~/.local/share/dreamcoder/backups/` before changing configs. To restore, run `./scripts/dreamcoder backup restore <backup_id> --json` with the backup id shown during install. Remove the `~/Dreamcoder-Workbench` directory to uninstall the environment.

> **Note**: WSL has no systemd by default, so the auto-theme timer is unavailable unless systemd is enabled in WSL (systemd-enabled WSL distros support `systemctl --user`).
