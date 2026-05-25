"""Orchestrate Dreamcoder theme generation."""

from __future__ import annotations

from .palette import VARIANTS as DEFAULT_VARIANTS, adaptive_palette, load_variants
from .renderers import (
    antigravity_content,
    codex_tmtheme_content,
    ghostty_content,
    hypr_content,
    kitty_content,
    kitty_ui_content,
    opencode_content,
    pi_theme_content,
    readme_content,
    rofi_content,
    starship_content,
    warp_content,
    waybar_content,
)
from .settings import ROOT, adaptive_enabled, theme_mode, theme_paths, write_repo_enabled
from .writers import (
    cleanup_opencode_themes,
    ensure_codex_theme_config,
    ensure_kitty_ui_include,
    ensure_pi_theme_settings,
    valid_starship,
    write_if_changed,
    write_opencode_tui,
    write_variant_files,
)


def sync_active_targets(paths, active: dict[str, str]) -> dict[str, bool]:
    return {
        "kitty": write_if_changed(paths.kitty, kitty_content(active)),
        "kitty_ui": write_if_changed(paths.kitty_ui, kitty_ui_content(active)),
        "kitty_config": ensure_kitty_ui_include(paths.kitty_config),
        "ghostty": write_if_changed(paths.ghostty, ghostty_content(active)),
        "warp": write_if_changed(paths.warp, warp_content(active)),
        "opencode": write_if_changed(paths.opencode, opencode_content(active, transparent_background=True)),
        "opencode_tui": write_opencode_tui(paths.opencode_tui),
        "opencode_cleanup": cleanup_opencode_themes(paths.opencode),
        "codex_theme": write_if_changed(paths.codex_theme, codex_tmtheme_content(active)),
        "codex_config": ensure_codex_theme_config(paths.codex_config),
        "pi_theme": write_if_changed(paths.pi_theme, pi_theme_content(active)),
        "pi_settings": ensure_pi_theme_settings(paths.pi_settings),
        "starship": write_if_changed(paths.starship, starship_content(active)),
    }


def sync_repo_snippets(variants: dict[str, dict[str, str]], active: dict[str, str]) -> list[bool]:
    mode_names = {"dark": "dark", "light": "light", "dusk": "dusk"}
    repo_changes: list[bool] = []
    repo_changes += write_variant_files(ROOT / "Kitty/.config/kitty", {k: f"colors-dreamcoder-{v}.conf" for k, v in mode_names.items()}, kitty_content, variants)
    repo_changes.append(write_if_changed(ROOT / "Kitty/.config/kitty/dreamcoder-ui.conf", kitty_ui_content(active)))
    repo_changes += write_variant_files(ROOT / "Ghostty/.config/ghostty/themes", {k: f"dreamcoder-{v}" for k, v in mode_names.items()}, ghostty_content, variants)
    repo_changes += write_variant_files(ROOT / "Warp/.local/share/warp-terminal/themes", {k: f"Dreamcoder-{v.title()}.yaml" for k, v in mode_names.items()}, warp_content, variants)
    repo_changes += write_variant_files(ROOT / "Shell/.config", {k: f"starship-{v}.toml" for k, v in mode_names.items()}, starship_content, variants)
    repo_changes += write_variant_files(ROOT / "Codex-App", {k: f"Dreamcoder-{v.title()}.codex-theme.json" for k, v in mode_names.items()}, opencode_content, variants)
    repo_changes += write_variant_files(ROOT / "Codex-CLI", {k: f"Dreamcoder-{v.title()}.tmTheme" for k, v in mode_names.items()}, codex_tmtheme_content, variants)
    repo_changes.append(write_if_changed(ROOT / "Codex-CLI/Dreamcoder.tmTheme", codex_tmtheme_content(active)))
    repo_changes.append(write_if_changed(ROOT / "Codex-App/Dreamcoder.codex-theme.json", opencode_content(active)))
    repo_changes.append(write_if_changed(ROOT / ".opencode/themes/dreamcoder.json", opencode_content(active, transparent_background=True)))
    repo_changes += write_variant_files(ROOT / "Pi/.pi/agent/themes", {k: f"dreamcoder-{v}.json" for k, v in mode_names.items()}, pi_theme_content, variants)
    repo_changes.append(write_if_changed(ROOT / "Pi/.pi/agent/themes/dreamcoder.json", pi_theme_content(active)))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/hyprland-dark.conf", hypr_content(variants["dark"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/hyprland-light.conf", hypr_content(variants["light"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/waybar-dark.css", waybar_content(variants["dark"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/waybar-light.css", waybar_content(variants["light"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/rofi-dark.rasi", rofi_content(variants["dark"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/rofi-light.rasi", rofi_content(variants["light"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/hyprland-dusk.conf", hypr_content(variants["dusk"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/waybar-dusk.css", waybar_content(variants["dusk"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/rofi-dusk.rasi", rofi_content(variants["dusk"])))
    repo_changes.append(write_if_changed(ROOT / "themes/dreamcoder/README.md", readme_content()))
    repo_changes += write_variant_files(ROOT / "Antigravity", {k: f"Dreamcoder-{v.title()}.json" for k, v in mode_names.items()}, antigravity_content, variants)
    return repo_changes


def print_summary(mode: str, paths, changed: dict[str, bool], repo_changes: list[bool]) -> None:
    print(f"Synced Dreamcoder {mode} identity")
    print(f"Kitty: {paths.kitty}")
    print(f"Kitty UI: {paths.kitty_ui}")
    print(f"Ghostty: {paths.ghostty}")
    print(f"Warp: {paths.warp}")
    print(f"opencode: {paths.opencode}")
    print(f"opencode tui: {paths.opencode_tui}")
    print(f"Codex CLI theme: {paths.codex_theme}")
    print(f"PI CLI theme: {paths.pi_theme}")
    print(f"PI CLI settings: {paths.pi_settings}")
    print(f"Starship: {paths.starship}")
    print("Changed: " + " ".join(f"{key}={value}" for key, value in changed.items()))
    print(f"Repo variant/snippet changes: {sum(repo_changes)}")


def main() -> None:
    paths = theme_paths()
    mode = theme_mode()
    variants = load_variants(DEFAULT_VARIANTS, paths.tokens_file)
    active = adaptive_palette(variants[mode], mode, paths.wallpaper, adaptive_enabled())
    changed = sync_active_targets(paths, active)
    repo_changes = sync_repo_snippets(variants, active) if write_repo_enabled() else []

    if not valid_starship(paths.starship):
        raise SystemExit(f"Generated Starship config is invalid: {paths.starship}")
    print_summary(mode, paths, changed, repo_changes)
