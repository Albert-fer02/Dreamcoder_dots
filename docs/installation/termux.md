# Installing Dreamcoder OS on Termux (Android)

## Prerequisites

- Termux app (from F-Droid, NOT Play Store)
- Android 7+

## Install

```bash
pkg update && pkg upgrade
pkg install stow git python nodejs

git clone https://github.com/dreamcoder08/dreamcoder-dots.git ~/dreamcoder-dots
cd ~/dreamcoder-dots
./scripts/dreamcoder install
```

## Limitations

- No systemd (day/night automation unavailable)
- No GUI apps (Kitty/Ghostty unavailable)
- Limited shader support
