"""Orchestrate Dreamcoder theme generation."""

from __future__ import annotations

from .palette import VARIANTS as DEFAULT_VARIANTS, adaptive_palette, load_variants
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
    update_zellij_config,
    valid_starship,
    update_warp_settings,
    write_if_changed,
    write_opencode_tui,
    write_variant_files,
)


def sync_active_targets(paths, active: dict[str, str], mode: str) -> dict[str, bool]:
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
        "codex_theme": write_if_changed(
            paths.codex_theme, codex_tmtheme_content(active)
        ),
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
        "hypr_colors_lua": write_if_changed(
            paths.hypr_colors_lua, hypr_colors_lua_content(active)
        ),
        "hypr_colors_conf": write_if_changed(
            paths.hypr_colors_conf, hypr_colors_conf_content(active)
        ),
        "waybar": write_if_changed(paths.waybar, waybar_content(active)),
        "waybar_matugen": write_if_changed(
            paths.waybar_matugen, waybar_matugen_content(active)
        ),
        "rofi": write_if_changed(paths.rofi, rofi_content(active)),
        "rofi_matugen": write_if_changed(
            paths.rofi_matugen, rofi_matugen_content(active)
        ),
    }


def sync_repo_snippets(
    variants: dict[str, dict[str, str]], active: dict[str, str]
) -> list[bool]:
    mode_names = {"dark": "dark", "light": "light"}
    repo_changes: list[bool] = []
    repo_changes += write_variant_files(
        ROOT / "Kitty/.config/kitty",
        {k: f"colors-dreamcoder-{v}.conf" for k, v in mode_names.items()},
        kitty_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Kitty/.config/kitty/dreamcoder-ui.conf", kitty_ui_content(active)
        )
    )
    repo_changes += write_variant_files(
        ROOT / "Ghostty/.config/ghostty/themes",
        {k: f"dreamcoder-{v}" for k, v in mode_names.items()},
        ghostty_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "Warp/.local/share/warp-terminal/themes",
        {k: f"Dreamcoder-{v.title()}.yaml" for k, v in mode_names.items()},
        warp_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "Shell/.config",
        {k: f"starship-{v}.toml" for k, v in mode_names.items()},
        starship_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "Codex-App",
        {k: f"Dreamcoder-{v.title()}.codex-theme.json" for k, v in mode_names.items()},
        opencode_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "Codex-CLI",
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in mode_names.items()},
        codex_tmtheme_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Codex-CLI/Dreamcoder.tmTheme", codex_tmtheme_content(active)
        )
    )
    repo_changes += write_variant_files(
        ROOT / "Bat/.config/bat/themes",
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in mode_names.items()},
        codex_tmtheme_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Bat/.config/bat/themes/Dreamcoder.tmTheme",
            codex_tmtheme_content(active),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Codex-App/Dreamcoder.codex-theme.json", opencode_content(active)
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / ".opencode/themes/dreamcoder.json",
            opencode_content(active, transparent_background=True),
        )
    )
    repo_changes += write_variant_files(
        ROOT / "Pi/.pi/agent/themes",
        {k: f"dreamcoder-{v}.json" for k, v in mode_names.items()},
        pi_theme_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Pi/.pi/agent/themes/dreamcoder.json", pi_theme_content(active)
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/hyprland-dark.conf",
            hypr_content(variants["dark"]),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/hyprland-light.conf",
            hypr_content(variants["light"]),
        )
    )
    repo_changes += write_variant_files(
        ROOT / "themes/dreamcoder",
        {k: f"hypr-colors-{v}.lua" for k, v in mode_names.items()},
        hypr_colors_lua_content,
        variants,
    )
    repo_changes += write_variant_files(
        ROOT / "themes/dreamcoder",
        {k: f"hypr-colors-{v}.conf" for k, v in mode_names.items()},
        hypr_colors_conf_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/waybar-dark.css", waybar_content(variants["dark"])
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/waybar-light.css",
            waybar_content(variants["light"]),
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/rofi-dark.rasi", rofi_content(variants["dark"])
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/rofi-light.rasi", rofi_content(variants["light"])
        )
    )
    # Desktop/WM active files (no suffix — tracks current mode)
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/hyprland.conf", hypr_content(active)
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/waybar.css", waybar_content(active)
        )
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "themes/dreamcoder/rofi.rasi", rofi_content(active)
        )
    )
    repo_changes.append(
        write_if_changed(ROOT / "themes/dreamcoder/README.md", readme_content())
    )
    repo_changes += write_variant_files(
        ROOT / "Antigravity",
        {k: f"Dreamcoder-{v.title()}.json" for k, v in mode_names.items()},
        antigravity_content,
        variants,
    )
    repo_changes.append(
        write_if_changed(
            ROOT / "Antigravity/Dreamcoder.json", antigravity_content(active)
        )
    )
    # Nvim variant files go in Nvim/.config/nvim/colors/
    nvim_dir = ROOT / "Nvim/.config/nvim/colors"
    repo_changes += write_variant_files(
        nvim_dir,
        {k: f"dreamcoder-{v}.lua" for k, v in mode_names.items()},
        nvim_content,
        variants,
    )
    # Other variant files stay in themes/dreamcoder/
    theme_dir = ROOT / "themes/dreamcoder"
    repo_changes += write_variant_files(
        theme_dir,
        {
            k: f"zsh-syntax-highlighting-dreamcoder-{v}.zsh"
            for k, v in mode_names.items()
        },
        zsh_syntax_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"ls-colors-dreamcoder-{v}.sh" for k, v in mode_names.items()},
        ls_colors_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"bat-dreamcoder-{v}.sh" for k, v in mode_names.items()},
        bat_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"delta-dreamcoder-{v}.gitconfig" for k, v in mode_names.items()},
        delta_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"fzf-dreamcoder-{v}.sh" for k, v in mode_names.items()},
        fzf_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"btop-dreamcoder-{v}.theme" for k, v in mode_names.items()},
        btop_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"dunst-dreamcoder-{v}.conf" for k, v in mode_names.items()},
        dunst_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"firefox-dreamcoder-{v}.css" for k, v in mode_names.items()},
        firefox_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"obsidian-dreamcoder-{v}.css" for k, v in mode_names.items()},
        obsidian_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"cava-dreamcoder-{v}.config" for k, v in mode_names.items()},
        cava_content,
        variants,
    )
    repo_changes += write_variant_files(
        theme_dir,
        {k: f"tmux-dreamcoder-{v}.conf" for k, v in mode_names.items()},
        tmux_content,
        variants,
    )
    return repo_changes


def sync_bat_theme_variants(paths, variants: dict[str, dict[str, str]]) -> list[bool]:
    mode_names = {"dark": "dark", "light": "light"}
    return write_variant_files(
        paths.bat_theme_dir,
        {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in mode_names.items()},
        codex_tmtheme_content,
        variants,
    )


def print_summary(
    mode: str, paths, changed: dict[str, bool], repo_changes: list[bool]
) -> None:
    print(f"Synced Dreamcoder {mode} identity")
    print(f"Kitty: {paths.kitty}")
    print(f"Kitty UI: {paths.kitty_ui}")
    print(f"Ghostty: {paths.ghostty}")
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
