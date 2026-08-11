"""Cross-validation tests for the canonical package APCA implementation.

Imports ``apca_lc`` from ``dreamcoder_theme._math`` — the sole SAPC/APCA
implementation (ADR-001) — and validates it against known SAPC/APCA
0.0.98G-4g vectors, signed polarity, black soft clamp, low-contrast clamp,
and at-/just-below-floor boundaries.

Deliberately removed: AST-based source extraction and cross-script formula
comparison. The package implementation is the reference; this module is
cross-validation evidence, not a fourth production formula.
"""

from dreamcoder_theme._math import apca_lc

# Floor values used ONLY to classify synthetic pairs in boundary tests.
# They mirror the canonical tokens.json guardrails; runtime policy must
# always be read from the canonical token contract, never from tests.
QUIET_FLOOR = 44.0
DARK_BODY_FLOOR = 50.0


class TestKnownVectors:
    def test_dark_text_on_light_background_vector(self):
        # #222222 on #ffffff ≈ +102.9 Lc (normal polarity: dark text on light bg)
        lc = apca_lc("#222222", "#ffffff")
        assert 100.0 <= lc <= 106.0

    def test_white_text_on_near_black_vector(self):
        # #ffffff on #12100e ≈ -107.4 Lc (reverse polarity: light text on dark bg)
        lc = apca_lc("#ffffff", "#12100e")
        assert -112.0 <= lc <= -100.0

    def test_black_on_white_vector(self):
        lc = apca_lc("#000000", "#ffffff")
        assert 100.0 <= abs(lc) <= 112.0

    def test_white_on_black_vector(self):
        lc = apca_lc("#ffffff", "#000000")
        assert 100.0 <= abs(lc) <= 112.0


class TestSignedPolarity:
    def test_darker_foreground_on_lighter_background_is_positive(self):
        assert apca_lc("#222222", "#ffffff") > 0

    def test_lighter_foreground_on_darker_background_is_negative(self):
        assert apca_lc("#ffffff", "#15100d") < 0

    def test_magnitude_is_polarity_agnostic(self):
        # Same text/background roles mirrored: magnitudes are comparable.
        dark_on_light = abs(apca_lc("#222222", "#ffffff"))
        light_on_dark = abs(apca_lc("#ffffff", "#15100d"))
        assert 100.0 <= dark_on_light <= 112.0
        assert 100.0 <= light_on_dark <= 112.0


class TestBlackSoftClamp:
    def test_white_on_near_black_does_not_collapse(self):
        # #040404 is below the APCA black threshold; the soft clamp must keep
        # white-on-near-black at very high Lc instead of collapsing the signal.
        lc = abs(apca_lc("#ffffff", "#040404"))
        assert lc > 105.0

    def test_white_on_oled_black_is_maximum(self):
        lc = abs(apca_lc("#ffffff", "#000000"))
        assert lc > 105.0


class TestLowContrastClamp:
    def test_near_identical_pair_gets_hysteresis_boost(self):
        # #f1f1f1 on #eeeeee sits below the SAPC low-contrast threshold and is
        # boosted by the low-contrast factor rather than collapsing to zero.
        lc = abs(apca_lc("#f1f1f1", "#eeeeee"))
        assert 60.0 <= lc < 70.0

    def test_identical_pair_stays_small_and_non_negative(self):
        # Equal colors: polarity exponent difference yields a small positive
        # SAPC in the low-contrast branch (~20.6 Lc), never a negative Lc.
        lc = abs(apca_lc("#808080", "#808080"))
        assert 15.0 <= lc <= 25.0


class TestFloorBoundaries:
    def test_quiet_floor_just_above_passes(self):
        # #949494 on #070A13 ≈ 44.5 Lc — at/above the quiet floor.
        assert abs(apca_lc("#949494", "#070a13")) >= QUIET_FLOOR

    def test_quiet_floor_just_below_fails(self):
        # #939393 on #070A13 ≈ 43.9 Lc — just below the quiet floor.
        assert abs(apca_lc("#939393", "#070a13")) < QUIET_FLOOR

    def test_dark_body_floor_boundary_classification(self):
        # #A8B5C2 on #070A13 ≈ 61.2 Lc — at/above the dark body floor (50).
        assert abs(apca_lc("#A8B5C2", "#070a13")) >= DARK_BODY_FLOOR
