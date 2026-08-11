"""Settings contract for ``theme.render_profile`` (Phase 4, tasks 4.1/4.2/4.3).

Covers R6 scenarios: schema entry with closed values, invalid-value rejection,
unknown-setting preservation, schema default, environment-override precedence
without mutation, persisted resolution, and the ``profile == night -> mode ==
dark`` effective-base conflict rule (design §3, ADR-003).
"""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from dreamcoder_theme import settings as settings_mod
from dreamcoder_theme import settings_store


@pytest.fixture
def settings_home(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """Isolate persisted settings under a temp config home."""
    monkeypatch.setenv("XDG_CONFIG_HOME", str(tmp_path / ".config"))
    monkeypatch.setenv("XDG_DATA_HOME", str(tmp_path / ".local" / "share"))
    monkeypatch.setenv("HOME", str(tmp_path))
    monkeypatch.delenv("DREAMCODER_THEME_PROFILE", raising=False)
    monkeypatch.delenv("DREAMCODER_THEME_MODE", raising=False)
    return tmp_path


def _persist(settings_home: Path, key: str, value: str) -> None:
    path = settings_home / ".config" / "dreamcoder" / "settings.json"
    data = json.loads(path.read_text()) if path.exists() else {}
    cursor = data
    parts = key.split(".")
    for part in parts[:-1]:
        cursor = cursor.setdefault(part, {})
    cursor[parts[-1]] = value
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")


# ---------------------------------------------------------------------------
# 4.1 RED — schema entry
# ---------------------------------------------------------------------------


def test_schema_declares_render_profile_with_standard_default(settings_home: Path) -> None:
    """``theme.render_profile`` is a typed schema entry defaulting to standard."""
    spec = settings_store.SETTINGS_SCHEMA["theme.render_profile"]
    assert spec["type"] == "string"
    assert spec["enum"] == ["standard", "night"]
    assert spec["default"] == "standard"


def test_render_profile_accepts_standard_and_night(settings_home: Path) -> None:
    """Both closed values validate and round-trip through settings_set/get."""
    for value in ("standard", "night"):
        assert settings_store.validate_setting_value("theme.render_profile", value) == []
        result = settings_store.settings_set("theme.render_profile", value)
        assert result["key"] == "theme.render_profile"
        assert settings_store.settings_get("theme.render_profile") == value


def test_render_profile_rejects_invalid_value(settings_home: Path) -> None:
    """An unknown profile value is rejected by settings_set (never persisted)."""
    with pytest.raises(ValueError, match=r"theme\.render_profile must be one of"):
        settings_store.settings_set("theme.render_profile", "neon")
    assert settings_store.settings_get("theme.render_profile") is None


def test_unknown_settings_preserved_with_warnings(settings_home: Path) -> None:
    """Unknown settings produce warnings and remain preserved (forward compat)."""
    path = settings_home / ".config" / "dreamcoder" / "settings.json"
    path.parent.mkdir(parents=True)
    path.write_text(json.dumps({"future": {"option": 42}}))
    report = settings_store.validate_settings()
    assert report["valid"] is True
    keys = [warning["key"] for warning in report["warnings"]]
    assert "future.option" in keys
    assert json.loads(path.read_text()) == {"future": {"option": 42}}


# ---------------------------------------------------------------------------
# 4.1/4.3 RED — resolver precedence
# ---------------------------------------------------------------------------


def test_default_profile_is_standard(settings_home: Path) -> None:
    """Absent env override and absent persisted setting resolve to standard."""
    assert settings_mod.render_profile() == "standard"


def test_persisted_profile_is_resolved(settings_home: Path) -> None:
    """Persisted ``theme.render_profile=night`` resolves absent an override."""
    _persist(settings_home, "theme.render_profile", "night")
    assert settings_mod.render_profile() == "night"


def test_env_override_wins_without_mutation(
    settings_home: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """Process-only env override wins and never mutates the persisted value."""
    _persist(settings_home, "theme.render_profile", "night")
    monkeypatch.setenv("DREAMCODER_THEME_PROFILE", "standard")
    assert settings_mod.render_profile() == "standard"
    # Persisted value untouched.
    assert settings_store.settings_get("theme.render_profile") == "night"


def test_env_profile_invalid_fails_closed(
    settings_home: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """An invalid env profile fails closed instead of being interpreted."""
    monkeypatch.setenv("DREAMCODER_THEME_PROFILE", "dusk")
    with pytest.raises(SystemExit, match=r"DREAMCODER_THEME_PROFILE must be 'standard' or 'night'"):
        settings_mod.render_profile()


def test_persisted_invalid_profile_fails_closed(settings_home: Path) -> None:
    """An invalid persisted value fails closed, never a runtime profile."""
    _persist(settings_home, "theme.render_profile", "dusk")
    with pytest.raises(SystemExit, match=r"theme\.render_profile"):
        settings_mod.render_profile()


# ---------------------------------------------------------------------------
# 4.3 RED — effective-base resolver (ADR-003 invariant)
# ---------------------------------------------------------------------------


def test_effective_base_mode_night_requires_dark(
    settings_home: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """profile=night + mode=dark resolves to dark base."""
    monkeypatch.setenv("DREAMCODER_THEME_MODE", "dark")
    monkeypatch.setenv("DREAMCODER_THEME_PROFILE", "night")
    assert settings_mod.effective_base_mode() == "dark"


def test_effective_base_mode_conflict_fails_actionably(
    settings_home: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """MODE=light + PROFILE=night fails with an actionable error (no Dusk, no coercion)."""
    monkeypatch.setenv("DREAMCODER_THEME_MODE", "light")
    monkeypatch.setenv("DREAMCODER_THEME_PROFILE", "night")
    with pytest.raises(SystemExit, match="requires base mode 'dark'"):
        settings_mod.effective_base_mode()


def test_effective_base_mode_standard_keeps_light(
    settings_home: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """Standard profile leaves the light/dark base untouched."""
    monkeypatch.setenv("DREAMCODER_THEME_MODE", "light")
    assert settings_mod.effective_base_mode() == "light"
