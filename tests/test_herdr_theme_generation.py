"""Regression tests for repository-only Herdr variant generation."""

from __future__ import annotations

import tomllib
from pathlib import Path

import pytest

from dreamcoder_theme import sync
from dreamcoder_theme.herdr_contract import HERDR_073_PROFILE
from dreamcoder_theme.palette_tokens import VARIANTS
from dreamcoder_theme.renderers_herdr import (
    HerdrContractUnavailableError,
    herdr_content,
    herdr_token_mapping,
)

EXPECTED_CUSTOM_FIELDS = {
    "accent",
    "panel_bg",
    "surface0",
    "surface1",
    "surface_dim",
    "overlay0",
    "overlay1",
    "text",
    "subtext0",
    "mauve",
    "green",
    "yellow",
    "red",
    "blue",
    "teal",
    "peach",
}


@pytest.mark.parametrize("mode", ("dark", "light"))
def test_herdr_output_uses_exact_allow_list_and_canonical_tokens(mode: str) -> None:
    content = herdr_content(HERDR_073_PROFILE, mode, VARIANTS[mode])
    parsed = tomllib.loads(content)

    assert parsed["theme"]["name"] == "catppuccin"
    assert set(parsed["theme"]) == {"name", "custom"}
    assert set(parsed["theme"]["custom"]) == EXPECTED_CUSTOM_FIELDS
    for field, token in herdr_token_mapping():
        assert parsed["theme"]["custom"][field] == VARIANTS[mode][token]
    assert parsed["ui"] == {"accent": "#6FA0AF"}
    assert parsed["keys"] == {
        "prefix": "ctrl+a",
        "previous_agent": "prefix+alt+k",
        "next_agent": "prefix+alt+j",
        "focus_agent": "prefix+ctrl+1..9",
    }
    assert "window-title" not in content
    assert "tab-title" not in content
    assert content.endswith("\n") and not content.endswith("\n\n")
    assert "\r" not in content


def test_herdr_variants_are_byte_stable_and_have_matching_structure() -> None:
    dark = herdr_content(HERDR_073_PROFILE, "dark", VARIANTS["dark"])
    light = herdr_content(HERDR_073_PROFILE, "light", VARIANTS["light"])

    assert dark == herdr_content(HERDR_073_PROFILE, "dark", VARIANTS["dark"])
    assert light == herdr_content(HERDR_073_PROFILE, "light", VARIANTS["light"])
    dark_toml, light_toml = tomllib.loads(dark), tomllib.loads(light)
    assert set(dark_toml["theme"]["custom"]) == set(light_toml["theme"]["custom"])
    assert dark_toml["ui"] == light_toml["ui"]
    assert dark_toml["keys"] == light_toml["keys"]
    assert dark != light


@pytest.mark.parametrize("mode", ("dusk", "invalid"))
def test_herdr_rejects_non_static_modes(mode: str) -> None:
    with pytest.raises(ValueError, match="only dark and light"):
        herdr_content(HERDR_073_PROFILE, mode, VARIANTS["dark"])


def test_repository_sync_writes_only_versioned_variants(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    selector = tmp_path / "user-herdr" / "config.toml"
    selector.parent.mkdir()
    selector.write_text("onboarding = false\n")
    monkeypatch.setattr(sync, "ROOT", tmp_path)

    changes = sync.sync_herdr_repo_variants({"dark": VARIANTS["dark"], "light": VARIANTS["light"]})
    base = tmp_path / "DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3"

    assert changes == [True, True]
    assert (base / "config.dark.toml").is_file()
    assert (base / "config.light.toml").is_file()
    assert selector.read_text() == "onboarding = false\n"
    assert sync.sync_herdr_repo_variants(
        {"dark": VARIANTS["dark"], "light": VARIANTS["light"]}
    ) == [
        False,
        False,
    ]


def test_checked_in_repository_variants_match_the_renderer() -> None:
    base = Path(__file__).parents[1] / "DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3"

    assert (base / "config.dark.toml").read_text() == herdr_content(
        HERDR_073_PROFILE, "dark", VARIANTS["dark"]
    )
    assert (base / "config.light.toml").read_text() == herdr_content(
        HERDR_073_PROFILE, "light", VARIANTS["light"]
    )


def test_unsupported_profile_produces_no_repository_files(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(sync, "ROOT", tmp_path)

    assert sync.sync_herdr_repo_variants(VARIANTS, profile=None) == []
    assert not (tmp_path / "DreamcoderHerdr").exists()


def test_incomplete_profile_cannot_generate_output() -> None:
    incomplete = HERDR_073_PROFILE.__class__(
        evidence=HERDR_073_PROFILE.evidence.__class__(
            **{**HERDR_073_PROFILE.evidence.__dict__, "base_theme_name": ""}
        )
    )

    with pytest.raises(HerdrContractUnavailableError):
        herdr_content(incomplete, "dark", VARIANTS["dark"])
