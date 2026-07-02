import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from dreamcoder_theme.palette import ansi, contrast

TOKENS = ROOT / "DreamcoderThemes" / "dreamcoder" / "tokens.json"


class TerminalReadabilityTest(unittest.TestCase):
    def setUp(self):
        self.tokens = json.loads(TOKENS.read_text())
        self.modes = self.tokens["modes"]
        self.guardrails = self.tokens["guardrails"]

    def test_terminal_guardrails_are_explicit(self):
        self.assertEqual(self.guardrails["minimum_terminal_ansi_contrast"], 4.5)
        self.assertEqual(self.guardrails["minimum_terminal_cursor_contrast"], 4.5)
        self.assertEqual(self.guardrails["minimum_terminal_selection_contrast"], 7.0)

    def test_all_ansi_colors_are_readable_on_terminal_background(self):
        minimum = self.guardrails["minimum_terminal_ansi_contrast"]
        for mode, palette in self.modes.items():
            with self.subTest(mode=mode):
                ratios = [contrast(color, palette["bg"]) for color in ansi(palette)]
                self.assertGreaterEqual(min(ratios), minimum)

    def test_cursor_and_selection_pairs_are_terminal_readable(self):
        cursor_min = self.guardrails["minimum_terminal_cursor_contrast"]
        selection_min = self.guardrails["minimum_terminal_selection_contrast"]
        for mode, palette in self.modes.items():
            with self.subTest(mode=mode):
                self.assertGreaterEqual(contrast(palette["accent"], palette["bg"]), cursor_min)
                self.assertGreaterEqual(
                    contrast(palette["selection_fg"], palette["selection_bg"]),
                    selection_min,
                )


if __name__ == "__main__":
    unittest.main()
