"""Tests for the dreamcoder_theme.writers module."""

from __future__ import annotations

import json
import shutil
import subprocess
from pathlib import Path

import pytest

from dreamcoder_theme.writers import (
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


class TestWriteIfChanged:
    def test_creates_new_file(self, tmp_path: Path) -> None:
        path = tmp_path / "new.txt"
        assert write_if_changed(path, "hello") is True
        assert path.read_text() == "hello\n"

    def test_skips_identical_content(self, tmp_path: Path) -> None:
        path = tmp_path / "same.txt"
        path.write_text("hello\n")
        assert write_if_changed(path, "hello") is False
        assert path.read_text() == "hello\n"

    def test_updates_different_content(self, tmp_path: Path) -> None:
        path = tmp_path / "diff.txt"
        path.write_text("old\n")
        assert write_if_changed(path, "new") is True
        assert path.read_text() == "new\n"

    def test_creates_parent_directories(self, tmp_path: Path) -> None:
        path = tmp_path / "a" / "b" / "deep.txt"
        assert write_if_changed(path, "deep") is True
        assert path.read_text() == "deep\n"

    def test_rewrites_file_without_trailing_newline(self, tmp_path: Path) -> None:
        """Files missing the final newline are normalized on the next write."""
        path = tmp_path / "legacy.txt"
        path.write_text("hello")
        assert write_if_changed(path, "hello") is True
        assert path.read_text() == "hello\n"

    def test_collapses_multiple_trailing_newlines(self, tmp_path: Path) -> None:
        path = tmp_path / "spaces.txt"
        assert write_if_changed(path, "a\n\n\n") is True
        assert path.read_text() == "a\n"

    def test_strips_trailing_whitespace_on_last_line(self, tmp_path: Path) -> None:
        path = tmp_path / "trail.txt"
        assert write_if_changed(path, "a\n  ") is True
        assert path.read_text() == "a\n"

    def test_empty_content_skipped(self, tmp_path: Path) -> None:
        path = tmp_path / "empty.txt"
        assert write_if_changed(path, "") is False
        assert not path.exists()


class TestValidStarship:
    def test_returns_true_when_starship_not_installed(self, tmp_path: Path) -> None:
        path = tmp_path / "starship.toml"
        path.write_text("[gcloud]\nformat = '☁️ '")
        with pytest.MonkeyPatch.context() as mp:
            mp.setattr(shutil, "which", lambda _: None)
            assert valid_starship(path) is True

    def test_valid_config_returns_true(self, tmp_path: Path) -> None:
        path = tmp_path / "starship.toml"
        path.write_text("[gcloud]\nformat = '☁️ '")
        with pytest.MonkeyPatch.context() as mp:
            mp.setattr(shutil, "which", lambda cmd: "/usr/bin/starship")

            def fake_run(*args, **kwargs):
                class Result:
                    returncode = 0

                return Result()

            mp.setattr(subprocess, "run", fake_run)
            assert valid_starship(path) is True

    def test_invalid_config_returns_false(self, tmp_path: Path) -> None:
        path = tmp_path / "starship.toml"
        path.write_text("invalid[[[\n")
        with pytest.MonkeyPatch.context() as mp:
            mp.setattr(shutil, "which", lambda cmd: "/usr/bin/starship")

            def fake_run(*args, **kwargs):
                class Result:
                    returncode = 1

                return Result()

            mp.setattr(subprocess, "run", fake_run)
            assert valid_starship(path) is False


class TestWriteVariantFiles:
    def test_writes_all_variants(self, tmp_path: Path) -> None:
        def builder(variant: dict[str, str]) -> str:
            return f"bg={variant['bg']}\nfg={variant['fg']}\n"

        base = tmp_path / "themes"
        results = write_variant_files(
            base,
            {"dark": "dark.theme", "light": "light.theme"},
            builder,
            {"dark": {"bg": "black", "fg": "white"}, "light": {"bg": "white", "fg": "black"}},
        )
        assert results == [True, True]
        assert (base / "dark.theme").read_text() == "bg=black\nfg=white\n"
        assert (base / "light.theme").read_text() == "bg=white\nfg=black\n"

    def test_skips_unchanged(self, tmp_path: Path) -> None:
        def builder(variant: dict[str, str]) -> str:
            return f"x={variant['x']}\n"

        base = tmp_path / "themes"
        (base / "dark.theme").parent.mkdir(parents=True, exist_ok=True)
        (base / "dark.theme").write_text("x=1\n")
        results = write_variant_files(
            base,
            {"dark": "dark.theme", "light": "light.theme"},
            builder,
            {"dark": {"x": "1"}, "light": {"x": "2"}},
        )
        assert results == [False, True]


class TestWriteOpencodeTui:
    def test_creates_new_file(self, tmp_path: Path) -> None:
        path = tmp_path / "tui.json"
        assert write_opencode_tui(path) is True
        data = json.loads(path.read_text())
        assert data["$schema"] == "https://opencode.ai/tui.json"
        assert data["theme"] == "dreamcoder"

    def test_preserves_existing_schema(self, tmp_path: Path) -> None:
        path = tmp_path / "tui.json"
        path.write_text(json.dumps({"$schema": "https://custom.ai/tui.json"}))
        assert write_opencode_tui(path) is True
        data = json.loads(path.read_text())
        assert data["$schema"] == "https://custom.ai/tui.json"
        assert data["theme"] == "dreamcoder"

    def test_no_change_when_already_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "tui.json"
        path.write_text(
            json.dumps({"$schema": "https://opencode.ai/tui.json", "theme": "dreamcoder"}, indent=2)
            + "\n"
        )
        assert write_opencode_tui(path) is False

    def test_handles_corrupted_json(self, tmp_path: Path) -> None:
        path = tmp_path / "tui.json"
        path.write_text("{bad json}")
        assert write_opencode_tui(path) is True
        data = json.loads(path.read_text())
        assert data["theme"] == "dreamcoder"


class TestCleanupOpencodeThemes:
    def test_removes_other_json_files(self, tmp_path: Path) -> None:
        target = tmp_path / "keep.json"
        target.write_text("{}")
        other = tmp_path / "other.json"
        other.write_text("{}")
        assert cleanup_opencode_themes(target) is True
        assert target.exists()
        assert not other.exists()

    def test_noop_when_only_target(self, tmp_path: Path) -> None:
        target = tmp_path / "only.json"
        target.write_text("{}")
        assert cleanup_opencode_themes(target) is False

    def test_honors_env_var(self, tmp_path: Path) -> None:
        target = tmp_path / "keep.json"
        target.write_text("{}")
        other = tmp_path / "other.json"
        other.write_text("{}")
        with pytest.MonkeyPatch.context() as mp:
            mp.setenv("DREAMCODER_CLEAN_OPENCODE_THEMES", "0")
            assert cleanup_opencode_themes(target) is False
        assert other.exists()

    def test_handles_nonexistent_parent(self, tmp_path: Path) -> None:
        target = tmp_path / "solo.json"
        target.write_text("{}")
        assert cleanup_opencode_themes(target) is False


class TestEnsureCodexThemeConfig:
    def test_creates_new_file(self, tmp_path: Path) -> None:
        path = tmp_path / "config.toml"
        assert ensure_codex_theme_config(path) is True
        content = path.read_text()
        assert "[tui]" in content
        assert 'theme = "Dreamcoder"' in content

    def test_no_change_when_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "config.toml"
        path.write_text('[tui]\ntheme = "Dreamcoder"\n')
        assert ensure_codex_theme_config(path) is False

    def test_adds_theme_to_existing_tui_section(self, tmp_path: Path) -> None:
        path = tmp_path / "config.toml"
        path.write_text("[tui]\nfont_size = 14\n")
        assert ensure_codex_theme_config(path) is True
        content = path.read_text()
        assert 'theme = "Dreamcoder"' in content
        assert "font_size = 14" in content

    def test_adds_tui_section_when_missing(self, tmp_path: Path) -> None:
        path = tmp_path / "config.toml"
        path.write_text('[general]\nkey = "val"\n')
        assert ensure_codex_theme_config(path) is True
        content = path.read_text()
        assert "[tui]" in content
        assert 'theme = "Dreamcoder"' in content

    def test_noop_when_theme_in_tui_section(self, tmp_path: Path) -> None:
        path = tmp_path / "config.toml"
        path.write_text('[tui]\ntheme = "Other"\n')
        assert ensure_codex_theme_config(path) is False


class TestEnsurePiThemeSettings:
    def test_creates_new_file(self, tmp_path: Path) -> None:
        path = tmp_path / "pi.json"
        assert ensure_pi_theme_settings(path) is True
        data = json.loads(path.read_text())
        assert data["theme"] == "dreamcoder"

    def test_no_change_when_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "pi.json"
        path.write_text(json.dumps({"theme": "dreamcoder"}, indent=2) + "\n")
        assert ensure_pi_theme_settings(path) is False

    def test_overwrites_different_theme(self, tmp_path: Path) -> None:
        path = tmp_path / "pi.json"
        path.write_text(json.dumps({"theme": "other"}))
        assert ensure_pi_theme_settings(path) is True
        data = json.loads(path.read_text())
        assert data["theme"] == "dreamcoder"

    def test_handles_corrupted_json(self, tmp_path: Path) -> None:
        path = tmp_path / "pi.json"
        path.write_text("{corrupt}")
        assert ensure_pi_theme_settings(path) is True
        data = json.loads(path.read_text())
        assert data["theme"] == "dreamcoder"


class TestEnsureKittyUiInclude:
    def test_noop_when_file_missing(self, tmp_path: Path) -> None:
        path = tmp_path / "nonexistent.conf"
        assert ensure_kitty_ui_include(path) is False

    def test_appends_include_line(self, tmp_path: Path) -> None:
        path = tmp_path / "kitty.conf"
        path.write_text("font_size 14\n")
        assert ensure_kitty_ui_include(path) is True
        content = path.read_text()
        assert "include dreamcoder-ui.conf" in content

    def test_no_change_when_already_present(self, tmp_path: Path) -> None:
        path = tmp_path / "kitty.conf"
        path.write_text("include dreamcoder-ui.conf\n")
        assert ensure_kitty_ui_include(path) is False


class TestUpdateGhosttyTheme:
    def test_noop_when_file_missing(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        assert update_ghostty_theme(path, "dark") is False

    def test_sets_dark_theme(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text("[theme]\n")
        assert update_ghostty_theme(path, "dark") is True
        content = path.read_text()
        assert "theme = dreamcoder-dark" in content

    def test_sets_light_theme(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text("[theme]\n")
        assert update_ghostty_theme(path, "light") is True
        content = path.read_text()
        assert "theme = dreamcoder" in content

    def test_no_change_when_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text("theme = dreamcoder-dark\n")
        assert update_ghostty_theme(path, "dark") is False

    def test_updates_existing_theme_line(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text("theme = old-theme\n")
        assert update_ghostty_theme(path, "dark") is True
        assert "theme = dreamcoder-dark" in path.read_text()

    def test_replaces_different_opacity(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text(
            "theme = dreamcoder-dark\nbackground-opacity = 1.00\nbackground-blur = 30\n"
        )
        # Theme line matches: no change needed (opacity/blur come from theme file)
        assert update_ghostty_theme(path, "dark") is False

    def test_replaces_different_opacity_light(self, tmp_path: Path) -> None:
        path = tmp_path / "ghostty.conf"
        path.write_text("theme = dreamcoder\nbackground-opacity = 0.50\nbackground-blur = false\n")
        # Theme line matches: no change needed
        assert update_ghostty_theme(path, "light") is False


class TestUpdateZellijConfig:
    def test_noop_when_file_missing(self, tmp_path: Path) -> None:
        path = tmp_path / "config.kdl"
        assert update_zellij_config(path, "dark") is False

    def test_sets_dark_theme(self, tmp_path: Path) -> None:
        path = tmp_path / "config.kdl"
        path.write_text("some_setting true\n")
        assert update_zellij_config(path, "dark") is True
        content = path.read_text()
        assert 'theme "dreamcoder-dark"' in content

    def test_no_change_when_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "config.kdl"
        path.write_text('theme "dreamcoder-dark"\n')
        assert update_zellij_config(path, "dark") is False

    def test_replaces_existing_theme(self, tmp_path: Path) -> None:
        path = tmp_path / "config.kdl"
        path.write_text('theme "old-theme"\n')
        assert update_zellij_config(path, "dark") is True
        content = path.read_text()
        assert 'theme "dreamcoder-dark"' in content
        assert 'theme "old-theme"' not in content

    def test_appends_theme_when_missing(self, tmp_path: Path) -> None:
        path = tmp_path / "config.kdl"
        path.write_text("some_setting true\n")
        assert update_zellij_config(path, "light") is True
        assert 'theme "dreamcoder-light"' in path.read_text()


class TestUpdateWarpSettings:
    def test_creates_new_file(self, tmp_path: Path) -> None:
        path = tmp_path / "settings.toml"
        assert update_warp_settings(path, "dark") is True
        content = path.read_text()
        assert "[appearance.window]" in content
        assert "override_opacity = 76" in content
        assert "override_blur = 20" in content
        assert "override_blur_texture = true" in content

    def test_sets_light_mode(self, tmp_path: Path) -> None:
        path = tmp_path / "settings.toml"
        assert update_warp_settings(path, "light") is True
        content = path.read_text()
        assert "override_opacity = 96" in content
        assert "override_blur = 1" in content
        assert "override_blur_texture = false" in content

    def test_no_change_when_correct(self, tmp_path: Path) -> None:
        path = tmp_path / "settings.toml"
        content = (
            "[appearance.window]\n"
            "override_opacity = 76\n"
            "override_blur = 20\n"
            "override_blur_texture = true\n"
        )
        path.write_text(content)
        assert update_warp_settings(path, "dark") is False

    def test_replaces_existing_section(self, tmp_path: Path) -> None:
        path = tmp_path / "settings.toml"
        path.write_text(
            "[appearance.window]\n"
            "override_opacity = 50\n"
            "override_blur = 5\n"
            "override_blur_texture = false\n"
        )
        assert update_warp_settings(path, "dark") is True
        content = path.read_text()
        assert "override_opacity = 76" in content

    def test_preserves_other_sections(self, tmp_path: Path) -> None:
        path = tmp_path / "settings.toml"
        path.write_text("[other]\nkey = true\n")
        assert update_warp_settings(path, "dark") is True
        content = path.read_text()
        assert "[other]" in content
        assert "[appearance.window]" in content


# ---------------------------------------------------------------------------
# write_variant_files_and_active delegation tests (T3.3)
# ---------------------------------------------------------------------------

from unittest import mock

from dreamcoder_theme.writers import write_variant_files_and_active


def test_write_variant_files_and_active_delegates(tmp_path: Path) -> None:
    """Helper delegates to write_variant_files then write_if_changed, in order."""
    base = tmp_path / "out"
    names = {"dark": "dark.txt", "light": "light.txt"}
    active = {"bg": "#111"}
    variants = {"dark": {"bg": "#000"}, "light": {"bg": "#fff"}}
    active_path = base / "active.txt"

    def builder(c: dict[str, str]) -> str:
        return f"bg={c['bg']}"

    with (
        mock.patch(
            "dreamcoder_theme.writers.write_variant_files", return_value=[True, False]
        ) as m_wvf,
        mock.patch("dreamcoder_theme.writers.write_if_changed", return_value=True) as m_wic,
    ):
        result = write_variant_files_and_active(base, names, builder, variants, active, active_path)

    m_wvf.assert_called_once_with(base, names, builder, variants)
    m_wic.assert_called_once_with(active_path, builder(active))
    assert result == [True, False, True]


def test_write_variant_files_and_active_returns_false_when_unchanged(
    tmp_path: Path,
) -> None:
    """Active file write returns False when unchanged."""
    base = tmp_path / "out"
    names = {"dark": "dark.txt", "light": "light.txt"}
    active = {"bg": "#111"}
    variants = {"dark": {"bg": "#000"}, "light": {"bg": "#fff"}}
    active_path = base / "active.txt"

    def builder(c: dict[str, str]) -> str:
        return f"bg={c['bg']}"

    with (
        mock.patch("dreamcoder_theme.writers.write_variant_files", return_value=[False, False]),
        mock.patch("dreamcoder_theme.writers.write_if_changed", return_value=False) as m_wic,
    ):
        result = write_variant_files_and_active(base, names, builder, variants, active, active_path)

    m_wic.assert_called_once()
    assert result == [False, False, False]
