import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "DreamcoderThemes" / "dreamcoder" / "tokens.json"


class DreamcoderDarkIdentityTest(unittest.TestCase):
    """Verify Anthracite Steel dark theme identity and key token values."""

    def setUp(self):
        self.dark = json.loads(TOKENS.read_text())["modes"]["dark"]

    def test_dark_mode_uses_anthracite_steel_identity(self):
        self.assertEqual(self.dark["name"], "Dreamcoder Anthracite Steel")
        self.assertEqual(self.dark["bg"], "#070A13")
        self.assertEqual(self.dark["surface0"], "#0D121A")
        self.assertEqual(self.dark["surface1"], "#151C25")
        self.assertEqual(self.dark["surface2"], "#202A35")

    def test_dark_mode_has_cool_steel_blue_signature(self):
        self.assertEqual(self.dark["accent"], "#A5C7E8")
        self.assertEqual(self.dark["accent_2"], "#8FAFCB")
        self.assertEqual(self.dark["error"], "#E69AA4")
        self.assertEqual(self.dark["warning"], "#D9B36C")

    def test_dark_mode_keeps_cool_text_and_steel_focus(self):
        self.assertEqual(self.dark["text"], "#E6EDF3")
        self.assertEqual(self.dark["muted"], "#A8B5C2")
        self.assertEqual(self.dark["focus"], "#A5C7E8")
        self.assertEqual(self.dark["diagnostic"], "#4DAED6")


if __name__ == "__main__":
    unittest.main()
