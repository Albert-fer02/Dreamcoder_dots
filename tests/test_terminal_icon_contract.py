import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FISH_ICONS = ROOT / "DreamcoderShell/.config/fish/conf.d/16-dreamcoder-icons.fish"
FISH_ABBR = ROOT / "DreamcoderShell/.config/fish/conf.d/60-abbreviations.fish"
SHELL_ALIASES = ROOT / "DreamcoderShell/.config/shell/aliases/dreamcoder-icons.sh"
KITTY_UI = ROOT / "DreamcoderKitty/.config/kitty/dreamcoder-ui.conf"
GHOSTTY = ROOT / "DreamcoderGhostty/.config/ghostty/config"


class TerminalIconContractTest(unittest.TestCase):
    def test_fish_uses_eza_icons_when_available(self):
        # Abbreviations shadow aliases in fish, so the icon contract lives in
        # 60-abbreviations.fish (the listings abbreviations must carry
        # --icons=always); 16-dreamcoder-icons.fish is the no-eza fallback only.
        abbr = FISH_ABBR.read_text()
        self.assertIn("command -q eza", abbr)
        self.assertIn('abbr -a ls "eza --icons=always --group-directories-first"', abbr)
        self.assertIn(
            'abbr -a ll "eza --icons=always --group-directories-first --long --git"', abbr
        )
        self.assertIn('abbr -a tree "eza --icons=always --group-directories-first --tree"', abbr)

        fallback = FISH_ICONS.read_text()
        self.assertNotIn("eza --icons=always", fallback)
        self.assertNotIn("alias ls='eza", fallback)
        self.assertIn("alias ll='ls -lah'", fallback)
        self.assertIn("if not command -q eza", fallback)

    def test_posix_shells_use_eza_icons_when_available(self):
        content = SHELL_ALIASES.read_text()
        self.assertIn("command -v eza", content)
        self.assertIn("alias ls='eza --icons=always --group-directories-first'", content)
        self.assertIn(
            "alias ll='eza --icons=always --group-directories-first --long --git'", content
        )
        self.assertIn("alias tree='eza --icons=always --group-directories-first --tree'", content)

    def test_terminals_have_nerd_symbol_fallback(self):
        kitty = KITTY_UI.read_text()
        ghostty = GHOSTTY.read_text()
        self.assertIn("symbol_map", kitty)
        self.assertIn("Symbols Nerd Font", kitty)
        self.assertRegex(ghostty, r'font-family\s*=\s*"Symbols Nerd Font"')


if __name__ == "__main__":
    unittest.main()
