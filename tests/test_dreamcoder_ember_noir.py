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
        self.assertEqual(self.dark["bg"], "#12100e")
        self.assertEqual(self.dark["surface0"], "#211c18")
        self.assertEqual(self.dark["surface1"], "#2e241f")
        self.assertEqual(self.dark["surface2"], "#3e3129")

    def test_dark_mode_has_red_orange_gold_signature(self):
        self.assertEqual(self.dark["accent"], "#d99555")
        self.assertEqual(self.dark["accent_2"], "#c96a45")
        self.assertEqual(self.dark["error"], "#e98272")
        self.assertEqual(self.dark["warning"], "#e8b866")

    def test_dark_mode_keeps_warm_silver_text_and_ember_focus(self):
        self.assertEqual(self.dark["text"], "#e8dfd0")
        self.assertEqual(self.dark["muted"], "#c7b9aa")
        self.assertEqual(self.dark["focus"], "#d99555")
        self.assertEqual(self.dark["diagnostic"], "#5f95ca")


if __name__ == "__main__":
    unittest.main()
