import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FISH_ICONS = ROOT / "DreamcoderShell/.config/fish/conf.d/16-dreamcoder-icons.fish"
SHELL_ALIASES = ROOT / "DreamcoderShell/.config/shell/aliases/dreamcoder-icons.sh"
KITTY_UI = ROOT / "DreamcoderKitty/.config/kitty/dreamcoder-ui.conf"
GHOSTTY = ROOT / "DreamcoderGhostty/.config/ghostty/config"


class TerminalIconContractTest(unittest.TestCase):
    def test_fish_uses_eza_icons_when_available(self):
        content = FISH_ICONS.read_text()
        self.assertIn("command -q eza", content)
        self.assertIn("alias ls='eza --icons=always --group-directories-first'", content)
        self.assertIn(
            "alias ll='eza --icons=always --group-directories-first --long --git'", content
        )
        self.assertIn("alias tree='eza --icons=always --group-directories-first --tree'", content)

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
