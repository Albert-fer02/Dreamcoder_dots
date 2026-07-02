import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from dreamcoder_theme.palette import contrast
from dreamcoder_theme.palette_tokens import ANSI_KEY_NAMES

TOKENS = ROOT / "DreamcoderThemes" / "dreamcoder" / "tokens.json"


class TokenParityTest(unittest.TestCase):
    def setUp(self):
        self.modes = json.loads(TOKENS.read_text())["modes"]

    def test_dark_and_light_share_semantic_keys(self):
        dark_keys = {k for k in self.modes["dark"] if k not in {"name", "details"}}
        light_keys = {k for k in self.modes["light"] if k not in {"name", "details"}}
        self.assertEqual(dark_keys, light_keys)

    def test_surface_ladder_increases_contrast_from_bg(self):
        for mode in ("dark", "light"):
            palette = self.modes[mode]
            bg = palette["bg"]
            steps = [
                palette[k] for k in ("bg_soft", "surface0", "surface1", "surface2", "surface3")
            ]
            ratios = [contrast(step, bg) for step in steps]
            with self.subTest(mode=mode):
                self.assertTrue(all(r >= 1.02 for r in ratios))

    def test_text_hierarchy_is_ordered(self):
        for mode in ("dark", "light"):
            palette = self.modes[mode]
            bg = palette["bg"]
            text_ratio = contrast(palette["text"], bg)
            muted_ratio = contrast(palette["muted"], bg)
            subtle_ratio = contrast(palette["subtle"], bg)
            with self.subTest(mode=mode):
                self.assertGreater(text_ratio, muted_ratio)
                self.assertGreater(muted_ratio, subtle_ratio)

    def test_ansi_keys_are_token_names_only(self):
        for key in ANSI_KEY_NAMES:
            self.assertFalse(key.startswith("#"), f"literal hex in ANSI_KEY_NAMES: {key}")


if __name__ == "__main__":
    unittest.main()
