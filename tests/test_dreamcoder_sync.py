"""Tests for the sync orchestrator module."""

from __future__ import annotations

from pathlib import Path
from typing import Any
from unittest import mock

import pytest

from dreamcoder_theme import sync
from dreamcoder_theme.palette import load_variants
from dreamcoder_theme.palette_tokens import VARIANTS as V
from dreamcoder_theme.settings import ThemePaths

_CONTENT_FUNCS = [
    "kitty_content",
    "kitty_ui_content",
    "ghostty_content",
    "warp_content",
    "opencode_content",
    "codex_tmtheme_content",
    "pi_theme_content",
    "starship_content",
    "tmux_content",
    "nvim_dispatcher_content",
    "zsh_syntax_content",
    "ls_colors_content",
    "bat_content",
    "delta_content",
    "fzf_content",
    "btop_content",
    "dunst_content",
    "firefox_content",
    "obsidian_content",
    "cava_content",
    "hypr_content",
    "hypr_colors_lua_content",
    "hypr_colors_conf_content",
    "waybar_content",
    "waybar_matugen_content",
    "rofi_content",
    "rofi_matugen_content",
    "readme_content",
    "antigravity_content",
]


def _patch_renderers(return_value: str = "") -> list[mock._patch]:
    return [
        mock.patch(f"dreamcoder_theme.sync.{name}", return_value=return_value)
        for name in _CONTENT_FUNCS
    ]


_WRITER_DEFAULTS: dict[str, Any] = {
    "write_if_changed": False,
    "ensure_kitty_ui_include": False,
    "update_ghostty_theme": False,
    "update_warp_settings": False,
    "write_opencode_tui": False,
    "cleanup_opencode_themes": False,
    "ensure_codex_theme_config": False,
    "ensure_pi_theme_settings": False,
    "update_zellij_config": False,
    "write_variant_files": [False],
}


def _writer_patches(**overrides: Any) -> list[mock._patch]:
    vals = {**_WRITER_DEFAULTS, **overrides}
    return [
        mock.patch(f"dreamcoder_theme.sync.{name}", return_value=vals[name])
        for name in _WRITER_DEFAULTS
    ]


@pytest.fixture
def mock_paths() -> Any:
    return ThemePaths(
        kitty=Path("/fake/kitty/colors.conf"),
        kitty_config=Path("/fake/kitty/kitty.conf"),
        kitty_ui=Path("/fake/kitty/ui.conf"),
        ghostty=Path("/fake/ghostty/theme"),
        ghostty_config=Path("/fake/ghostty/config"),
        starship=Path("/fake/starship.toml"),
        tmux=Path("/fake/tmux/tmux.conf"),
        zellij_config=Path("/fake/zellij/config.kdl"),
        warp=Path("/fake/warp/theme.yaml"),
        warp_settings=Path("/fake/warp/settings.toml"),
        opencode=Path("/fake/opencode/theme.json"),
        opencode_tui=Path("/fake/opencode/tui.json"),
        codex_theme=Path("/fake/codex/themes/Dreamcoder.tmTheme"),
        codex_config=Path("/fake/codex/config.toml"),
        pi_theme=Path("/fake/pi/themes/dreamcoder.json"),
        pi_settings=Path("/fake/pi/settings.json"),
        wallpaper=Path("/fake/wallpaper.jpg"),
        tokens_file=Path("/fake/tokens.json"),
        bat_theme_dir=Path("/fake/bat/themes"),
        nvim=Path("/fake/nvim/colors/dreamcoder.lua"),
        zsh_syntax=Path("/fake/themes/zsh-syntax.zsh"),
        ls_colors=Path("/fake/themes/ls-colors.sh"),
        bat=Path("/fake/themes/bat.sh"),
        delta=Path("/fake/themes/delta.gitconfig"),
        fzf=Path("/fake/themes/fzf.sh"),
        btop=Path("/fake/themes/btop.theme"),
        dunst=Path("/fake/themes/dunst.conf"),
        firefox=Path("/fake/themes/firefox.css"),
        obsidian=Path("/fake/themes/obsidian.css"),
        cava=Path("/fake/themes/cava.config"),
        hyprland=Path("/fake/themes/hyprland.conf"),
        hypr_colors_lua=Path("/fake/hypr/colors.lua"),
        hypr_colors_conf=Path("/fake/hypr/colors.conf"),
        waybar=Path("/fake/themes/waybar.css"),
        waybar_matugen=Path("/fake/waybar/colors.css"),
        rofi=Path("/fake/themes/rofi.rasi"),
        rofi_matugen=Path("/fake/rofi/colors.rasi"),
    )


@pytest.fixture
def active() -> dict[str, str]:
    return dict(V["dark"])


@pytest.fixture
def variants() -> dict[str, dict[str, str]]:
    return {"dark": dict(V["dark"]), "light": dict(V["light"])}


def test_sync_active_targets_returns_dict(mock_paths, active):
    patches = [*_writer_patches(), *_patch_renderers()]
    for p in patches:
        p.start()
    try:
        result = sync.sync_active_targets(mock_paths, active, "dark")
    finally:
        for p in patches:
            p.stop()
    assert isinstance(result, dict)
    assert result["kitty"] is False
    assert "hyprland" in result
    assert result["bat_theme"] is False


def test_sync_active_targets_detects_changes(mock_paths, active):
    def side_effect(path, content):
        return path.name in ("colors.conf", "starship.toml", "tmux.conf")

    patches = [
        mock.patch("dreamcoder_theme.sync.write_if_changed", side_effect=side_effect),
        *(
            mock.patch(f"dreamcoder_theme.sync.{name}", return_value=val)
            for name, val in _WRITER_DEFAULTS.items()
            if name != "write_if_changed"
        ),
        *_patch_renderers(),
    ]
    for p in patches:
        p.start()
    try:
        result = sync.sync_active_targets(mock_paths, active, "dark")
    finally:
        for p in patches:
            p.stop()
    assert result["kitty"] is True
    assert result["starship"] is True
    assert result["tmux"] is True
    assert result["ghostty"] is False


def test_sync_bat_theme_variants_delegates(mock_paths):
    v = {"dark": {"bg": "#111"}, "light": {"bg": "#fff"}}
    with mock.patch(
        "dreamcoder_theme.sync.write_variant_files", return_value=[True, False]
    ) as mock_wvf:
        result = sync.sync_bat_theme_variants(mock_paths, v)
    mock_wvf.assert_called_once()
    assert result == [True, False]


def test_print_summary_output(mock_paths, capsys):
    changed = {"kitty": True, "starship": False}
    sync.print_summary("dark", mock_paths, changed, [True, False])
    captured = capsys.readouterr()
    assert "Synced Dreamcoder dark identity" in captured.out
    assert "kitty=True" in captured.out
    assert "Repo variant/snippet changes: 1" in captured.out


def _main_patches(mock_paths, active, variants, **overrides):
    vals = dict(
        theme_paths=mock_paths,
        theme_mode="dark",
        load_variants=variants,
        adaptive_palette=active,
        adaptive_enabled=False,
        write_repo_enabled=True,
        valid_starship=True,
        batch_theme_variants=[False],
    )
    vals.update(overrides)
    result = []
    for name in (
        "theme_paths",
        "theme_mode",
        "load_variants",
        "adaptive_palette",
        "adaptive_enabled",
        "write_repo_enabled",
        "valid_starship",
    ):
        if name in vals:
            result.append(mock.patch(f"dreamcoder_theme.sync.{name}", return_value=vals[name]))
    result += [*_writer_patches(), *_patch_renderers()]
    return result


def test_main_happy_path(mock_paths, active, variants):
    patches = _main_patches(mock_paths, active, variants)
    for p in patches:
        p.start()
    try:
        sync.main()
    finally:
        for p in patches:
            p.stop()


def test_main_fails_on_invalid_starship(mock_paths, active, variants):
    patches = _main_patches(mock_paths, active, variants, valid_starship=False)
    for p in patches:
        p.start()
    try:
        with pytest.raises(SystemExit) as exc:
            sync.main()
    finally:
        for p in patches:
            p.stop()
    assert "Starship" in str(exc.value)


def test_main_skips_sync_repo_when_disabled(mock_paths, active, variants):
    patches = _main_patches(mock_paths, active, variants, write_repo_enabled=False)
    patches.append(
        mock.patch(
            "dreamcoder_theme.sync.sync_repo_snippets",
            side_effect=RuntimeError("should not be called"),
        )
    )
    for p in patches:
        p.start()
    try:
        sync.main()
    finally:
        for p in patches:
            p.stop()


def test_main_calls_sync_repo_when_enabled(mock_paths, active, variants):
    patches = _main_patches(mock_paths, active, variants)
    patches.append(mock.patch("dreamcoder_theme.sync.sync_repo_snippets", return_value=[True]))
    for p in patches:
        p.start()
    try:
        sync.main()
    finally:
        for p in patches:
            p.stop()


def test_main_light_mode(mock_paths):
    active_light = dict(V["light"])
    v = {"dark": dict(V["dark"]), "light": active_light}
    patches = _main_patches(mock_paths, active_light, v, theme_mode="light")
    for p in patches:
        p.start()
    try:
        sync.main()
    finally:
        for p in patches:
            p.stop()


def test_load_variants_fallback_when_missing(tmp_path):
    tokens_file = tmp_path / "nonexistent.json"
    result = load_variants(V, tokens_file)
    assert result == V
    assert "dark" in result


def test_load_variants_merges_tokens(tmp_path):
    tokens = {"modes": {"dark": {"bg": "#000001"}}}
    tokens_file = tmp_path / "tokens.json"
    tokens_file.write_text(__import__("json").dumps(tokens))

    result = load_variants(V, tokens_file)
    assert result["dark"]["bg"] == "#000001"
    assert result["light"]["bg"] == V["light"]["bg"]
    assert "prompt_bg" in result["dark"]
