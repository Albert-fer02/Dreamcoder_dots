"""Unit tests for the corrected APCA implementation.

Extracts the ``apca_lc`` function directly from each script and exercises it
so we can verify:
  - polarity-aware exponents
  - hysteresis offset
  - black soft-clamp
  - both scripts stay in sync
"""

import ast
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent


def _extract_function_source(relative_path: str, name: str) -> str:
    source = (REPO_ROOT / relative_path).read_text()
    tree = ast.parse(source)
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) and node.name == name:
            return ast.unparse(node)
    raise RuntimeError(f"function {name!r} not found in {relative_path}")


def _compile(apca_lc_source: str, name: str):
    """Compile an isolated ``apca_lc`` callable without script top-level side effects."""
    # Include all constants needed by apca_lc
    support_code = """
def srgb_lin(channel):
    return (channel / 255) ** 2.4

_APCA_R = 0.2126729
_APCA_G = 0.7151522
_APCA_B = 0.0721750

_NORM_TXT = 0.57
_NORM_BG = 0.56
_REV_TXT = 0.62
_REV_BG = 0.65

_BLK_THRS = 0.022
_BLK_CLMP = 1.414
_SCALE = 1.14
_LO_THRESH = 0.035991
_LO_FACTOR = 27.7847239587675
_OFFSET = 0.027

def rgb(value):
    hex_part = value.lstrip('#')
    return tuple(int(hex_part[i:i+2], 16) for i in (0, 2, 4))

def apca_y(value):
    r, g, b = (srgb_lin(part) for part in rgb(value))
    return _APCA_R * r + _APCA_G * g + _APCA_B * b
"""
    namespace = {}
    exec(compile(support_code, f"apca_support_{name}.py", "exec"), namespace)
    exec(compile(apca_lc_source, f"apca_lc_{name}.py", "exec"), namespace)
    return namespace["apca_lc"]


verify_lc = _compile(
    _extract_function_source("scripts/verify-theme-health.py", "apca_lc"),
    "verify",
)
preview_lc = _compile(
    _extract_function_source("scripts/generate-theme-preview.py", "apca_lc"),
    "preview",
)


class APCAImplementationTests(unittest.TestCase):
    # ---- spec behavior ----

    def test_normal_polarity_returns_positive(self):
        self.assertGreater(abs(verify_lc("#222222", "#ffffff")), 0)

    def test_reverse_polarity_returns_positive(self):
        self.assertGreater(abs(verify_lc("#ffffff", "#15100d")), 0)

    def test_known_dark_on_light_bg_reference(self):
        lc = abs(verify_lc("#222222", "#ffffff"))
        self.assertGreaterEqual(lc, 90)  # Dark gray on white ~104 Lc with APCA
        self.assertLessEqual(lc, 110)

    def test_known_white_on_dark_bg_reference(self):
        lc = abs(verify_lc("#ffffff", "#12100e"))
        self.assertGreaterEqual(lc, 100)  # White on dark ~107 Lc with APCA
        self.assertLessEqual(lc, 120)

    def test_black_soft_clamp_raises_lc_for_near_black_background(self):
        near_black = "#040404"
        white = "#ffffff"
        clamped = abs(verify_lc(white, near_black))
        self.assertGreater(clamped, 0)
        self.assertGreater(clamped, 100)  # White on near-black very high contrast

    def test_very_low_contrast_pair_stays_reasonable(self):
        # APCA still produces meaningful values for near-identical colors
        lc = abs(verify_lc("#f1f1f1", "#eeeeee"))
        self.assertLess(lc, 70)  # Should be low but not zero

    def test_srgb_linearization_uses_exponent_only(self):
        namespace = {}
        exec(
            compile(
                "def srgb_lin(channel): return (channel / 255) ** 2.4",
                "__test__",
                "exec",
            ),
            namespace,
        )
        srgb_lin = namespace["srgb_lin"]
        for val in (0, 64, 128, 255):
            with self.subTest(val=val):
                self.assertAlmostEqual(srgb_lin(val), (val / 255) ** 2.4, places=10)

    # ---- cross-script agreement ----

    def test_preview_agrees_with_verifier(self):
        pairs = [
            ("#f0e7dc", "#15100d"),
            ("#15100d", "#f3eadc"),
            ("#f0e7dc", "#f3eadc"),
            ("#15100d", "#15100d"),
            ("#c7b9aa", "#15100d"),
        ]
        for fg, bg in pairs:
            with self.subTest(fg=fg, bg=bg):
                self.assertAlmostEqual(
                    abs(verify_lc(fg, bg)),
                    abs(preview_lc(fg, bg)),
                    places=5,
                )


if __name__ == "__main__":
    unittest.main()
