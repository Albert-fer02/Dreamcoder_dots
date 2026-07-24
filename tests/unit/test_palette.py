"""Unit tests for domain/palette.py — pure color math functions."""

import pytest

from dreamcoder_theme.domain.palette import (
    compute_on_color,
    contrast,
    guard,
    hex_to_rgb,
    mix,
    rel_luminance,
    rgb_to_hex,
    surface_guard,
)


class TestHexConversion:
    def test_hex_to_rgb_white(self):
        assert hex_to_rgb("#ffffff") == (255, 255, 255)

    def test_hex_to_rgb_black(self):
        assert hex_to_rgb("#000000") == (0, 0, 0)

    def test_hex_to_rgb_without_hash(self):
        assert hex_to_rgb("ff0000") == (255, 0, 0)

    def test_rgb_to_hex_white(self):
        assert rgb_to_hex((255, 255, 255)) == "#ffffff"

    def test_roundtrip(self):
        original = "#a7471c"
        assert rgb_to_hex(hex_to_rgb(original)) == original


class TestMix:
    def test_mix_midpoint(self):
        result = mix("#000000", "#ffffff", 0.5)
        assert result == "#808080"

    def test_mix_toward_white(self):
        result = mix("#000000", "#ffffff", 0.25)
        assert result == "#404040"

    def test_mix_same_color(self):
        result = mix("#a7471c", "#a7471c", 0.5)
        assert result == "#a7471c"


class TestLuminance:
    def test_white_luminance(self):
        assert rel_luminance("#ffffff") == pytest.approx(1.0, abs=0.01)

    def test_black_luminance(self):
        assert rel_luminance("#000000") == pytest.approx(0.0, abs=0.01)

    def test_luminance_ordering(self):
        assert rel_luminance("#ffffff") > rel_luminance("#808080") > rel_luminance("#000000")


class TestContrast:
    def test_black_on_white(self):
        assert contrast("#000000", "#ffffff") == pytest.approx(21.0, abs=0.1)

    def test_white_on_black(self):
        assert contrast("#ffffff", "#000000") == pytest.approx(21.0, abs=0.1)

    def test_same_color(self):
        assert contrast("#808080", "#808080") == pytest.approx(1.0, abs=0.01)

    def test_wcag_aa_minimum(self):
        # #757575 on #ffffff is WCAG AA border (~4.5:1)
        ratio = contrast("#757575", "#ffffff")
        assert ratio == pytest.approx(4.6, abs=0.2)


class TestGuard:
    def test_already_sufficient(self):
        result = guard("#000000", "#ffffff", "light")
        assert result == "#000000"

    def test_adjusts_for_contrast(self):
        # Light gray on white needs adjustment
        result = guard("#e0e0e0", "#ffffff", "light")
        assert contrast(result, "#ffffff") >= 4.5

    def test_dark_mode_targets_white(self):
        result = guard("#222222", "#000000", "dark")
        assert contrast(result, "#000000") >= 4.5


class TestComputeOnColor:
    def test_dark_mode_prefers_dark_candidate(self):
        result = compute_on_color("#ffffff", "dark", dark_candidate="#000000")
        assert result == "#000000"

    def test_light_mode_prefers_light_candidate(self):
        result = compute_on_color("#000000", "light", light_candidate="#ffffff")
        assert result == "#ffffff"


class TestSurfaceGuard:
    def test_preserves_good_color(self):
        # These two dark mode colors have contrast ~1.5 (within 1.05-2.4 range)
        result = surface_guard("#201b16", "#000001", "dark")
        assert result == "#201b16"
