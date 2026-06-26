import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "themes" / "dreamcoder" / "tokens.json"


class DreamcoderEmberNoirTest(unittest.TestCase):
    def setUp(self):
        self.dark = json.loads(TOKENS.read_text())["modes"]["dark"]

    def test_dark_mode_uses_ember_noir_identity(self):
        self.assertEqual(self.dark["name"], "Dreamcoder Ember Noir OLED")
        self.assertEqual(self.dark["bg"], "#100f0d")
        self.assertEqual(self.dark["surface0"], "#201b16")
        self.assertEqual(self.dark["surface1"], "#2b231b")
        self.assertEqual(self.dark["surface2"], "#392e21")

    def test_dark_mode_has_red_orange_gold_signature(self):
        self.assertEqual(self.dark["accent"], "#d99555")
        self.assertEqual(self.dark["accent_2"], "#c96a45")
        self.assertEqual(self.dark["error"], "#ed8a7a")
        self.assertEqual(self.dark["warning"], "#e8b866")

    def test_dark_mode_keeps_warm_silver_text_and_ember_focus(self):
        self.assertEqual(self.dark["text"], "#e8dfd0")
        self.assertEqual(self.dark["muted"], "#c7b9aa")
        self.assertEqual(self.dark["focus"], "#5f8f8f")
        self.assertEqual(self.dark["diagnostic"], "#5f95ca")


if __name__ == "__main__":
    unittest.main()
