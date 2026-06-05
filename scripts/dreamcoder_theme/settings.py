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
    ghostty_config: Path
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
    # New targets
    bat_theme_dir: Path
    nvim: Path
    zsh_syntax: Path
    ls_colors: Path
    bat: Path
    delta: Path
    fzf: Path
    btop: Path
    dunst: Path
    firefox: Path
    obsidian: Path
    cava: Path
    # Desktop/WM targets
    hyprland: Path
    hypr_colors_lua: Path
    hypr_colors_conf: Path
    waybar: Path
    waybar_matugen: Path
    rofi: Path
    rofi_matugen: Path


def theme_mode() -> str:
    mode = os.environ.get("DREAMCODER_THEME_MODE", "light").lower()
    if mode not in {"dark", "light", "dusk"}:
        raise SystemExit("DREAMCODER_THEME_MODE must be 'dark', 'light', or 'dusk'")
    return mode


def theme_paths() -> ThemePaths:
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    pi_agent_home = Path(os.environ.get("PI_AGENT_DIR", Path.home() / ".pi/agent"))
    dreamcoder_theme = ROOT / "themes/dreamcoder"
    return ThemePaths(
        kitty=Path(
            os.environ.get("KITTY_COLORS", config_home / "kitty/colors-dreamcoder.conf")
        ),
        kitty_config=Path(
            os.environ.get("KITTY_CONFIG", config_home / "kitty/kitty.conf")
        ),
        kitty_ui=Path(
            os.environ.get(
                "KITTY_DREAMCODER_UI", config_home / "kitty/dreamcoder-ui.conf"
            )
        ),
        ghostty=Path(
            os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder")
        ),
        ghostty_config=Path(
            os.environ.get("GHOSTTY_CONFIG", config_home / "ghostty/config")
        ),
        starship=Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml")),
        warp=Path(
            os.environ.get(
                "WARP_THEME", data_home / "warp-terminal/themes/Dreamcoder.yaml"
            )
        ),
        opencode=Path(
            os.environ.get(
                "OPENCODE_THEME", config_home / "opencode/themes/dreamcoder.json"
            )
        ),
        opencode_tui=Path(
            os.environ.get("OPENCODE_TUI", config_home / "opencode/tui.json")
        ),
        codex_theme=Path(
            os.environ.get("CODEX_THEME", codex_home / "themes/Dreamcoder.tmTheme")
        ),
        codex_config=Path(os.environ.get("CODEX_CONFIG", codex_home / "config.toml")),
        pi_theme=Path(
            os.environ.get("PI_THEME", pi_agent_home / "themes/dreamcoder.json")
        ),
        pi_settings=Path(
            os.environ.get("PI_SETTINGS", pi_agent_home / "settings.json")
        ),
        wallpaper=Path(os.environ.get("DREAMCODER_WALLPAPER", "")),
        tokens_file=Path(
            os.environ.get("DREAMCODER_TOKENS", ROOT / "themes/dreamcoder/tokens.json")
        ),
        # New targets — all stored in themes/dreamcoder/ by default
        bat_theme_dir=Path(os.environ.get("BAT_THEME_DIR", config_home / "bat/themes")),
        nvim=Path(
            os.environ.get(
                "DREAMCODER_NVIM_THEME",
                dreamcoder_theme.parent.parent / "Nvim/.config/nvim/colors/dreamcoder.lua",
            )
        ),
        zsh_syntax=Path(
            os.environ.get(
                "DREAMCODER_ZSH_SYNTAX_THEME",
                dreamcoder_theme / "zsh-syntax-highlighting-dreamcoder.zsh",
            )
        ),
        ls_colors=Path(
            os.environ.get(
                "DREAMCODER_LS_COLORS_THEME",
                dreamcoder_theme / "ls-colors-dreamcoder.sh",
            )
        ),
        bat=Path(
            os.environ.get(
                "DREAMCODER_BAT_THEME", dreamcoder_theme / "bat-dreamcoder.sh"
            )
        ),
        delta=Path(
            os.environ.get(
                "DREAMCODER_DELTA_THEME",
                dreamcoder_theme / "delta-dreamcoder.gitconfig",
            )
        ),
        fzf=Path(
            os.environ.get(
                "DREAMCODER_FZF_THEME", dreamcoder_theme / "fzf-dreamcoder.sh"
            )
        ),
        btop=Path(
            os.environ.get(
                "DREAMCODER_BTOP_THEME", dreamcoder_theme / "btop-dreamcoder.theme"
            )
        ),
        dunst=Path(
            os.environ.get(
                "DREAMCODER_DUNST_THEME", dreamcoder_theme / "dunst-dreamcoder.conf"
            )
        ),
        firefox=Path(
            os.environ.get(
                "DREAMCODER_FIREFOX_THEME", dreamcoder_theme / "firefox-dreamcoder.css"
            )
        ),
        obsidian=Path(
            os.environ.get(
                "DREAMCODER_OBSIDIAN_THEME",
                dreamcoder_theme / "obsidian-dreamcoder.css",
            )
        ),
        cava=Path(
            os.environ.get(
                "DREAMCODER_CAVA_THEME", dreamcoder_theme / "cava-dreamcoder.config"
            )
        ),
        # Desktop/WM targets
        hyprland=Path(
            os.environ.get(
                "DREAMCODER_HYPRLAND_THEME",
                dreamcoder_theme / "hyprland.conf",
            )
        ),
        hypr_colors_lua=Path(
            os.environ.get(
                "DREAMCODER_HYPR_COLORS_LUA",
                config_home / "hypr/colors.lua",
            )
        ),
        hypr_colors_conf=Path(
            os.environ.get(
                "DREAMCODER_HYPR_COLORS_CONF",
                config_home / "hypr/colors.conf",
            )
        ),
        waybar=Path(
            os.environ.get(
                "DREAMCODER_WAYBAR_THEME",
                dreamcoder_theme / "waybar.css",
            )
        ),
        waybar_matugen=Path(
            os.environ.get(
                "DREAMCODER_WAYBAR_MATUGEN",
                config_home / "waybar/colors.css",
            )
        ),
        rofi=Path(
            os.environ.get(
                "DREAMCODER_ROFI_THEME",
                dreamcoder_theme / "rofi.rasi",
            )
        ),
        rofi_matugen=Path(
            os.environ.get(
                "DREAMCODER_ROFI_MATUGEN",
                config_home / "rofi/colors.rasi",
            )
        ),
    )


def adaptive_enabled() -> bool:
    return os.environ.get("DREAMCODER_ADAPTIVE", "1") != "0"


def write_repo_enabled() -> bool:
    return os.environ.get("DREAMCODER_WRITE_REPO", "1") != "0"
