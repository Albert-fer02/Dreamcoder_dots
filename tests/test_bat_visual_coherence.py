import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FISH_THEME = ROOT / "Shell/.config/fish/conf.d/05-dreamcoder-theme.fish"
BAT_THEMES = ROOT / "Bat/.config/bat/themes"
CODEX_THEMES = ROOT / "Codex-CLI"


class BatVisualCoherenceTest(unittest.TestCase):
    def test_fish_exports_same_bat_contract_as_zsh(self):
        content = FISH_THEME.read_text()
        self.assertIn("set -gx BAT_THEME Dreamcoder-Dark", content)
        self.assertIn("set -gx BAT_THEME Dreamcoder-Light", content)
        self.assertIn("set -gx BAT_STYLE auto,changes,header,grid", content)
        self.assertIn("set -gx BAT_TABS 4", content)
        self.assertIn("set -e NO_COLOR", content)

    def test_bat_tmthemes_mirror_dreamcoder_cli_themes(self):
        mapping = {
            "Dreamcoder.tmTheme": "Dreamcoder.tmTheme",
            "Dreamcoder-Light.tmTheme": "Dreamcoder-Light.tmTheme",
            "Dreamcoder-Dark.tmTheme": "Dreamcoder-Dark.tmTheme",
        }
        for bat_name, codex_name in mapping.items():
            with self.subTest(theme=bat_name):
                self.assertEqual((BAT_THEMES / bat_name).read_text(), (CODEX_THEMES / codex_name).read_text())


if __name__ == "__main__":
    unittest.main()
