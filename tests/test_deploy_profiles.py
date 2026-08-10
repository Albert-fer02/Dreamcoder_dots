"""Tests for repository-safe Dreamcoder deployment profiles."""

from __future__ import annotations

import json
from pathlib import Path

import jsonschema
import pytest

ROOT = Path(__file__).resolve().parents[1]
DEPLOY_DIR = ROOT / "DreamcoderProfiles/deploy"
PROFILE_NAMES = ("desktop-arch.json", "mobile-termux.json")
FORBIDDEN_KEYS = {
    "address",
    "user",
    "host",
    "key",
    "token",
    "secret",
    "password",
    "private_key",
}


def _load(name: str) -> dict:
    return json.loads((DEPLOY_DIR / name).read_text())


def _walk_keys(payload: object, prefix: str = "") -> list[str]:
    keys: list[str] = []
    if isinstance(payload, dict):
        for name, child in payload.items():
            path = f"{prefix}.{name}" if prefix else name
            keys.append(path)
            keys.extend(_walk_keys(child, path))
    elif isinstance(payload, list):
        for child in payload:
            keys.extend(_walk_keys(child, prefix))
    return keys


def test_deploy_schema_validates_desktop_and_mobile_profiles() -> None:
    schema = _load("deploy.schema.json")
    for name in PROFILE_NAMES:
        jsonschema.validate(_load(name), schema)


def test_mobile_profile_selects_dreamcoder_light() -> None:
    mobile = _load("mobile-termux.json")
    assert mobile["terminal_default_mode"] == "light"


def test_mobile_profile_disables_herdr_pane_scrollbars() -> None:
    mobile = _load("mobile-termux.json")
    assert mobile["herdr"]["ui"]["pane_scrollbars"] is False


def test_desktop_profile_does_not_pin_mobile_settings() -> None:
    desktop = _load("desktop-arch.json")
    assert desktop["platform"] == "arch-desktop"
    assert "herdr" not in desktop


def test_deploy_profiles_contain_no_sensitive_fields() -> None:
    for name in PROFILE_NAMES:
        assert not FORBIDDEN_KEYS.intersection(_walk_keys(_load(name)))


def test_deploy_schema_rejects_unknown_sensitive_keys() -> None:
    schema = _load("deploy.schema.json")
    invalid = {
        "kind": "deployment",
        "name": "bad",
        "description": "invalid",
        "platform": "arch-desktop",
        "address": "127.0.0.1",
    }
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(invalid, schema)
