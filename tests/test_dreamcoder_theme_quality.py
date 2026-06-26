import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "themes" / "dreamcoder" / "tokens.json"


def rel_luminance(value: str) -> float:
    """Calculate relative luminance for WCAG contrast."""

    def channel(part: int) -> float:
        scaled = part / 255
        return scaled / 12.92 if scaled <= 0.03928 else ((scaled + 0.055) / 1.055) ** 2.4

    value = value.lstrip("#")
    r, g, b = (channel(int(value[i : i + 2], 16)) for i in (0, 2, 4))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast(left: str, right: str) -> float:
    """Calculate WCAG 2 contrast ratio."""
    a, b = sorted((rel_luminance(left), rel_luminance(right)), reverse=True)
    return (a + 0.05) / (b + 0.05)


class DreamcoderThemeQualityTest(unittest.TestCase):
    def setUp(self):
        self.modes = json.loads(TOKENS.read_text())["modes"]

    def test_dark_uses_refined_ember_noir_scale(self):
        dark = self.modes["dark"]
        self.assertEqual(dark["name"], "Dreamcoder Ember Noir OLED")
        self.assertEqual(dark["surface0"], "#201b16")
        self.assertEqual(dark["surface1"], "#2b231b")
        self.assertEqual(dark["surface2"], "#392e21")
        self.assertEqual(dark["accent"], "#d99555")
        self.assertEqual(dark["accent_2"], "#c96a45")

    def test_light_has_stronger_editor_readability_tiers(self):
        light = self.modes["light"]
        self.assertEqual(light["surface0"], "#fff7ea")
        self.assertEqual(light["surface2"], "#c8ad89")
        # Verify subtle has sufficient contrast against background
        self.assertGreaterEqual(contrast(light["subtle"], light["bg"]), 4.5)
        self.assertGreaterEqual(contrast(light["comment"], light["bg"]), 4.5)

    def test_light_selection_uses_inverted_high_contrast_pair(self):
        light = self.modes["light"]
        self.assertEqual(light["selection"], light["text"])


if __name__ == "__main__":
    unittest.main()
