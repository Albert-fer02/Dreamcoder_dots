"""Unit tests for domain/mode_detector.py — pure theme detection."""

from dreamcoder_theme.domain.mode_detector import (
    DARK_MARKERS,
    LIGHT_MARKERS,
    from_file_content,
    from_tokens,
)


class TestFromTokens:
    def test_active_mode_light(self):
        assert from_tokens({"active_mode": "light"}) == "light"

    def test_active_mode_dark(self):
        assert from_tokens({"active_mode": "dark"}) == "dark"

    def test_active_mode_dusk(self):
        assert from_tokens({"active_mode": "dusk"}) == "dusk"

    def test_missing_key_defaults_light(self):
        assert from_tokens({}) == "light"

    def test_unknown_mode_defaults_light(self):
        assert from_tokens({"active_mode": "unknown"}) == "light"


class TestFromFileContent:
    def test_detects_dark_by_marker(self):
        for marker in DARK_MARKERS:
            assert from_file_content(marker) == "dark", f"Failed for marker: {marker}"

    def test_detects_light_by_marker(self):
        for marker in LIGHT_MARKERS:
            assert from_file_content(marker) == "light", f"Failed for marker: {marker}"

    def test_case_insensitive(self):
        assert from_file_content("DREAMCODER DARK") == "dark"
        assert from_file_content("Dreamcoder Light") == "light"

    def test_unknown_content(self):
        assert from_file_content("random text") == "unknown"

    def test_dark_wins_over_light(self):
        content = "dreamcoder dark and dreamcoder light"
        assert from_file_content(content) == "dark"
