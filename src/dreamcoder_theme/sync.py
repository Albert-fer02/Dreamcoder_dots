"""Orchestrate Dreamcoder theme generation."""

from __future__ import annotations

import subprocess
import sys
from collections.abc import Callable
from pathlib import Path
from typing import Any

from .herdr_contract import HERDR_073_PROFILE, HerdrProfile
from .palette import adaptive_palette, load_variants
from .palette_tokens import VARIANTS as DEFAULT_VARIANTS
from .renderers import (
    antigravity_content,
    bat_content,
    btop_content,
    cava_content,
    codex_tmtheme_content,
    delta_content,
    dunst_content,
    firefox_content,
    fzf_content,
    ghostty_content,
    herdr_content,
    hypr_colors_conf_content,
    hypr_colors_lua_content,
    hypr_content,
    kitty_content,
    kitty_ui_content,
    ls_colors_content,
    nvim_content,
    nvim_dispatcher_content,
    obsidian_content,
    opencode_content,
    pi_theme_content,
    readme_content,
    rofi_content,
    rofi_matugen_content,
    starship_content,
    tmux_content,
    warp_content,
    waybar_content,
    waybar_matugen_content,
    zsh_syntax_content,
)
from .settings import (
    ROOT,
    adaptive_enabled,
    theme_mode,
    theme_paths,
    write_repo_enabled,
)
from .writers import (
    cleanup_opencode_themes,
    ensure_codex_theme_config,
    ensure_kitty_ui_include,
    ensure_pi_theme_settings,
    update_ghostty_theme,
    update_warp_settings,
    update_zellij_config,
    valid_starship,
    write_if_changed,
    write_opencode_tui,
    write_variant_files,
)


def sync_active_targets(paths: Any, active: dict[str, str], mode: str) -> dict[str, bool]:
    return {
        "kitty": write_if_changed(paths.kitty, kitty_content(active)),
        "kitty_ui": write_if_changed(paths.kitty_ui, kitty_ui_content(active)),
        "kitty_config": ensure_kitty_ui_include(paths.kitty_config),
        "ghostty": write_if_changed(paths.ghostty, ghostty_content(active)),
        "ghostty_config": update_ghostty_theme(paths.ghostty_config, mode),
        "warp": write_if_changed(paths.warp, warp_content(active)),
        "warp_settings": update_warp_settings(paths.warp_settings, mode),
        "opencode": write_if_changed(
            paths.opencode, opencode_content(active, transparent_background=True)
        ),
        "opencode_tui": write_opencode_tui(paths.opencode_tui),
        "opencode_cleanup": cleanup_opencode_themes(paths.opencode),
        "codex_theme": write_if_changed(paths.codex_theme, codex_tmtheme_content(active)),
        "bat_theme": write_if_changed(
            paths.bat_theme_dir / "Dreamcoder.tmTheme", codex_tmtheme_content(active)
        ),
        "codex_config": ensure_codex_theme_config(paths.codex_config),
        "pi_theme": write_if_changed(paths.pi_theme, pi_theme_content(active)),
        "pi_settings": ensure_pi_theme_settings(paths.pi_settings),
        "starship": write_if_changed(paths.starship, starship_content(active)),
        "tmux": write_if_changed(paths.tmux, tmux_content(active)),
        "zellij": update_zellij_config(paths.zellij_config, mode),
        # New targets
        "nvim": write_if_changed(paths.nvim, nvim_dispatcher_content()),
        "zsh_syntax": write_if_changed(paths.zsh_syntax, zsh_syntax_content(active)),
        "ls_colors": write_if_changed(paths.ls_colors, ls_colors_content(active)),
        "bat": write_if_changed(paths.bat, bat_content(active)),
        "delta": write_if_changed(paths.delta, delta_content(active)),
        "fzf": write_if_changed(paths.fzf, fzf_content(active)),
        "btop": write_if_changed(paths.btop, btop_content(active)),
        "dunst": write_if_changed(paths.dunst, dunst_content(active)),
        "firefox": write_if_changed(paths.firefox, firefox_content(active)),
        "obsidian": write_if_changed(paths.obsidian, obsidian_content(active)),
        "cava": write_if_changed(paths.cava, cava_content(active)),
        # Desktop/WM targets
        "hyprland": write_if_changed(paths.hyprland, hypr_content(active)),
        "hypr_colors_lua": write_if_changed(paths.hypr_colors_lua, hypr_colors_lua_content(active)),
        "hypr_colors_conf": write_if_changed(
            paths.hypr_colors_conf, hypr_colors_conf_content(active)
        ),
        "waybar": write_if_changed(paths.waybar, waybar_content(active)),
        "waybar_matugen": write_if_changed(paths.waybar_matugen, waybar_matugen_content(active)),
        "rofi": write_if_changed(paths.rofi, rofi_content(active)),
        "rofi_matugen": write_if_changed(paths.rofi_matugen, rofi_matugen_content(active)),
    }


# ------------------------------------------------------------------
# Declarative variant registry — each entry produces write_variant_files
# (+ active-file write when active_path is set). Uniform entries only;
# hyprland, waybar, rofi, nvim, and opencode-transparent
# stay as explicit calls below the loop.
# ------------------------------------------------------------------
D = {"dark": "dark", "light": "light"}
VARIANT_REGISTRY: list[tuple[Path, dict[str, str], Callable[..., str], Path | None]] = [
    # -- Terminal targets --
    (
        ROOT / "DreamcoderKitty/.config/kitty",
        {k: f"colors-dreamcoder-{v}.conf" for k, v in D.items()},
        kitty_content,
        None,
    ),
    (
        ROOT / "DreamcoderKitty/.config/kitty",
        {k: f"dreamcoder-ui-{v}.conf" for k, v in D.items()},
        kitty_ui_content,
        None,
    ),
    (
        ROOT / "DreamcoderGhostty/.config/ghostty/themes",
        {k: f"dreamcoder-{v}" for k, v in D.items()},
        ghostty_content,
        None,
    ),
    (
        ROOT / "DreamcoderWarp/.local/share/warp-terminal/themes",
        {k: f"Dreamcoder-{v.title()}.yaml" for k, v in D.items()},
        warp_content,
        None,
    ),
    # -- Shell / prompt --
    (
        ROOT / "DreamcoderShell/.config",
        {k: f"starship-{v}.toml" for k, v in D.items()},
        starship_content,
        None,
    ),
    # -- TUI / editor themes --
    (
        ROOT / "DreamcoderCodexApp",
        {k: f"Dreamcoder-{v.title()}.codex-theme.json" for k, v in D.items()},
        opencode_content,
        ROOT / "DreamcoderCodexApp/Dreamcoder.codex-theme.json",
    ),
    (
        ROOT / "DreamcoderCodexCLI",
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in D.items()},
        codex_tmtheme_content,
        ROOT / "DreamcoderCodexCLI/Dreamcoder.tmTheme",
    ),
    (
        ROOT / "DreamcoderBat/.config/bat/themes",
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in D.items()},
        codex_tmtheme_content,
        ROOT / "DreamcoderBat/.config/bat/themes/Dreamcoder.tmTheme",
    ),
    # -- Pi CLI --
    (
        ROOT / "DreamcoderPi/.pi/agent/themes",
        {k: f"dreamcoder-{v}.json" for k, v in D.items()},
        pi_theme_content,
        ROOT / "DreamcoderPi/.pi/agent/themes/dreamcoder.json",
    ),
    # -- Antigravity --
    (
        ROOT / "DreamcoderAntigravity",
        {k: f"Dreamcoder-{v.title()}.json" for k, v in D.items()},
        antigravity_content,
        ROOT / "DreamcoderAntigravity/Dreamcoder.json",
    ),
    # -- theme_dir entries (DreamcoderThemes/dreamcoder) --
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"zsh-syntax-highlighting-dreamcoder-{v}.zsh" for k, v in D.items()},
        zsh_syntax_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"ls-colors-dreamcoder-{v}.sh" for k, v in D.items()},
        ls_colors_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"bat-dreamcoder-{v}.sh" for k, v in D.items()},
        bat_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"delta-dreamcoder-{v}.gitconfig" for k, v in D.items()},
        delta_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"fzf-dreamcoder-{v}.sh" for k, v in D.items()},
        fzf_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"btop-dreamcoder-{v}.theme" for k, v in D.items()},
        btop_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"dunst-dreamcoder-{v}.conf" for k, v in D.items()},
        dunst_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"firefox-dreamcoder-{v}.css" for k, v in D.items()},
        firefox_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"obsidian-dreamcoder-{v}.css" for k, v in D.items()},
        obsidian_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"cava-dreamcoder-{v}.config" for k, v in D.items()},
        cava_content,
        None,
    ),
    (
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"tmux-dreamcoder-{v}.conf" for k, v in D.items()},
        tmux_content,
        None,
    ),
]


def sync_herdr_repo_variants(
    variants: dict[str, dict[str, str]], profile: HerdrProfile | None = HERDR_073_PROFILE
) -> list[bool]:
    """Generate managed repository variants only; never select a live configuration."""
    if profile is None or not profile.is_complete:
        return []
    base = ROOT / "DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3"
    return [
        write_if_changed(
            base / "config.dark.toml", herdr_content(profile, "dark", variants["dark"])
        ),
        write_if_changed(
            base / "config.light.toml", herdr_content(profile, "light", variants["light"])
        ),
    ]


def sync_repo_snippets(variants: dict[str, dict[str, str]], active: dict[str, str]) -> list[bool]:
    repo_changes: list[bool] = []

    # ---- Declarative registry loop ----
    for base, names, builder, active_path in VARIANT_REGISTRY:
        repo_changes += write_variant_files(base, names, builder, variants)
        if active_path is not None:
            repo_changes.append(write_if_changed(active_path, builder(active)))

    # ---- Non-uniform entries (explicit calls) ----

    # Kitty UI active file (variants handled by VARIANT_REGISTRY above)
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderKitty/.config/kitty/dreamcoder-ui.conf", kitty_ui_content(active)
        )
    )

    # Opencode dotfile (transparent_background=True)
    repo_changes.append(
        write_if_changed(
            ROOT / ".opencode/themes/dreamcoder.json",
            opencode_content(active, transparent_background=True),
        )
    )

    # Hyprland — per-mode + active
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/hyprland-dark.conf",
            hypr_content(variants["dark"]),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/hyprland-light.conf",
            hypr_content(variants["light"]),
        )
    )
    repo_changes += write_variant_files(
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"hypr-colors-{v}.lua" for k, v in D.items()},
        hypr_colors_lua_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "DreamcoderThemes/dreamcoder",
        {k: f"hypr-colors-{v}.conf" for k, v in D.items()},
        hypr_colors_conf_content,
        variants,
    )

    # Waybar — per-mode + active
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/waybar-dark.css",
            waybar_content(variants["dark"]),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/waybar-light.css",
            waybar_content(variants["light"]),
        )
    )

    # Rofi — per-mode + active
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/rofi-dark.rasi",
            rofi_content(variants["dark"]),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "DreamcoderThemes/dreamcoder/rofi-light.rasi",
            rofi_content(variants["light"]),
        )
    )

    # Desktop/WM active files (no suffix — tracks current mode)
    repo_changes.append(
        write_if_changed(ROOT / "DreamcoderThemes/dreamcoder/hyprland.conf", hypr_content(active))
    )
    repo_changes.append(
        write_if_changed(ROOT / "DreamcoderThemes/dreamcoder/waybar.css", waybar_content(active))
    )
    repo_changes.append(
        write_if_changed(ROOT / "DreamcoderThemes/dreamcoder/rofi.rasi", rofi_content(active))
    )

    # Herdr repository variants are intentionally separate from live selection.
    repo_changes += sync_herdr_repo_variants(variants)

    # README
    repo_changes.append(
        write_if_changed(ROOT / "DreamcoderThemes/dreamcoder/README.md", readme_content())
    )

    # Nvim variant files
    nvim_dir = ROOT / "DreamcoderNvim/.config/nvim/colors"
    repo_changes += write_variant_files(
        nvim_dir,
        {k: f"dreamcoder-{v}.lua" for k, v in D.items()},
        nvim_content,
        variants,
    )

    return repo_changes


def sync_bat_theme_variants(paths: Any, variants: dict[str, dict[str, str]]) -> list[bool]:
    mode_names = {"dark": "dark", "light": "light"}
    return write_variant_files(
        paths.bat_theme_dir,
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in mode_names.items()},
        codex_tmtheme_content,
        variants,
    )


def print_summary(
    mode: str, paths: Any, changed: dict[str, bool], repo_changes: list[bool]
) -> None:
    print(f"Synced Dreamcoder {mode} identity")
    print(f"Kitty: {paths.kitty}")
    print(f"Kitty UI: {paths.kitty_ui}")
    print(f"Ghostty: {paths.ghostty}")
    print(f"Herdr repository variants: {paths.herdr_repo_variants}")
    print(f"Warp: {paths.warp}")
    print(f"opencode: {paths.opencode}")
    print(f"opencode tui: {paths.opencode_tui}")
    print(f"Codex CLI theme: {paths.codex_theme}")
    print(f"Bat theme dir: {paths.bat_theme_dir}")
    print(f"PI CLI theme: {paths.pi_theme}")
    print(f"PI CLI settings: {paths.pi_settings}")
    print(f"Starship: {paths.starship}")
    # New targets
    print(f"Neovim: {paths.nvim}")
    print(f"Zsh-syntax-highlighting: {paths.zsh_syntax}")
    print(f"LS_COLORS: {paths.ls_colors}")
    print(f"Bat: {paths.bat}")
    print(f"Delta: {paths.delta}")
    print(f"Fzf: {paths.fzf}")
    print(f"Btop: {paths.btop}")
    print(f"Dunst: {paths.dunst}")
    print(f"Firefox: {paths.firefox}")
    print(f"Obsidian: {paths.obsidian}")
    print(f"Cava: {paths.cava}")
    # Desktop/WM targets
    print(f"Hyprland: {paths.hyprland}")
    print(f"Hyprland colors.lua: {paths.hypr_colors_lua}")
    print(f"Hyprland colors.conf: {paths.hypr_colors_conf}")
    print(f"Waybar: {paths.waybar}")
    print(f"Waybar matugen: {paths.waybar_matugen}")
    print(f"Rofi: {paths.rofi}")
    print(f"Rofi matugen: {paths.rofi_matugen}")
    print("Changed: " + " ".join(f"{key}={value}" for key, value in changed.items()))
    print(f"Repo variant/snippet changes: {sum(repo_changes)}")


def main() -> None:
    gen = ROOT / "scripts" / "generate-palette-tokens.py"
    if gen.is_file():
        subprocess.run([sys.executable, str(gen)], check=True)
    paths = theme_paths()
    mode = theme_mode()
    variants = load_variants(DEFAULT_VARIANTS, paths.tokens_file)
    active = adaptive_palette(variants[mode], mode, paths.wallpaper, adaptive_enabled())
    changed = sync_active_targets(paths, active, mode)
    bat_variant_changes = sync_bat_theme_variants(paths, variants)
    repo_changes = sync_repo_snippets(variants, active) if write_repo_enabled() else []
    changed["bat_theme_variants"] = any(bat_variant_changes)

    if not valid_starship(paths.starship):
        raise SystemExit(f"Generated Starship config is invalid: {paths.starship}")
    print_summary(mode, paths, changed, repo_changes)
