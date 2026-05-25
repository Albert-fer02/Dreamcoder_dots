"""Runtime configuration for Dreamcoder theme sync."""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PI_THEME_SCHEMA = (
    "https://raw.githubusercontent.com/earendil-works/pi/main/"
    "packages/coding-agent/src/modes/interactive/theme/theme-schema.json"
)


@dataclass(frozen=True)
class ThemePaths:
    kitty: Path
    kitty_config: Path
    kitty_ui: Path
    ghostty: Path
    starship: Path
    warp: Path
    opencode: Path
    opencode_tui: Path
    codex_theme: Path
    codex_config: Path
    pi_theme: Path
    pi_settings: Path
    wallpaper: Path
    tokens_file: Path


def theme_mode() -> str:
    mode = os.environ.get("DREAMCODER_THEME_MODE", "dark").lower()
    if mode not in {"dark", "light", "dusk"}:
        raise SystemExit("DREAMCODER_THEME_MODE must be 'dark', 'light', or 'dusk'")
    return mode


def theme_paths() -> ThemePaths:
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    pi_agent_home = Path(os.environ.get("PI_AGENT_DIR", Path.home() / ".pi/agent"))
    return ThemePaths(
        kitty=Path(os.environ.get("KITTY_COLORS", config_home / "kitty/colors-dreamcoder.conf")),
        kitty_config=Path(os.environ.get("KITTY_CONFIG", config_home / "kitty/kitty.conf")),
        kitty_ui=Path(os.environ.get("KITTY_DREAMCODER_UI", config_home / "kitty/dreamcoder-ui.conf")),
        ghostty=Path(os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder")),
        starship=Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml")),
        warp=Path(os.environ.get("WARP_THEME", data_home / "warp-terminal/themes/Dreamcoder.yaml")),
        opencode=Path(os.environ.get("OPENCODE_THEME", config_home / "opencode/themes/dreamcoder.json")),
        opencode_tui=Path(os.environ.get("OPENCODE_TUI", config_home / "opencode/tui.json")),
        codex_theme=Path(os.environ.get("CODEX_THEME", codex_home / "themes/Dreamcoder.tmTheme")),
        codex_config=Path(os.environ.get("CODEX_CONFIG", codex_home / "config.toml")),
        pi_theme=Path(os.environ.get("PI_THEME", pi_agent_home / "themes/dreamcoder.json")),
        pi_settings=Path(os.environ.get("PI_SETTINGS", pi_agent_home / "settings.json")),
        wallpaper=Path(os.environ.get("DREAMCODER_WALLPAPER", "")),
        tokens_file=Path(os.environ.get("DREAMCODER_TOKENS", ROOT / "themes/dreamcoder/tokens.json")),
    )


def adaptive_enabled() -> bool:
    return os.environ.get("DREAMCODER_ADAPTIVE", "1") != "0"


def write_repo_enabled() -> bool:
    return os.environ.get("DREAMCODER_WRITE_REPO", "1") != "0"
