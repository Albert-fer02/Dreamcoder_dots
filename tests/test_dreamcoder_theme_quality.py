import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "themes" / "dreamcoder" / "tokens.json"


class DreamcoderThemeQualityTest(unittest.TestCase):
    def setUp(self):
        self.modes = json.loads(TOKENS.read_text())["modes"]

    def test_dark_uses_refined_ember_noir_scale(self):
        dark = self.modes["dark"]
        self.assertEqual(dark["name"], "Dreamcoder Ember Noir")
        self.assertEqual(dark["surface0"], "#241b16")
        self.assertEqual(dark["surface1"], "#30231c")
        self.assertEqual(dark["surface2"], "#3e2c22")
        self.assertEqual(dark["accent"], "#e6a15c")
        self.assertEqual(dark["accent_2"], "#d66f50")

    def test_light_has_stronger_editor_readability_tiers(self):
        light = self.modes["light"]
        self.assertEqual(light["surface0"], "#fff7ea")
        self.assertEqual(light["surface2"], "#c8ad89")
        self.assertEqual(light["subtle"], "#554635")
        self.assertEqual(light["comment"], "#66523f")
        self.assertEqual(light["accent"], "#824f16")

    def test_dusk_is_not_a_duplicate_light_palette(self):
        dusk = self.modes["dusk"]
        self.assertEqual(dusk["surface0"], "#f1eadf")
        self.assertEqual(dusk["surface2"], "#c6b6a0")
        self.assertEqual(dusk["muted"], "#4c443a")
        self.assertEqual(dusk["accent"], "#8a5520")

    def test_light_selection_uses_inverted_high_contrast_pair(self):
        light = self.modes["light"]
        self.assertEqual(light["selection"], light["text"])

    def test_dusk_selection_uses_inverted_high_contrast_pair(self):
        dusk = self.modes["dusk"]
        self.assertEqual(dusk["selection"], dusk["text"])


if __name__ == "__main__":
    unittest.main()
