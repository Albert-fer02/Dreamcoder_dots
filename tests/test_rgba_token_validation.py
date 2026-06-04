import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS_FILE = ROOT / "themes" / "dreamcoder" / "tokens.json"

_HEX = re.compile(r"^#[0-9a-fA-F]{6}$")
_RGBA = re.compile(
    r"^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(0|1|0?\.\d+)\s*\)$"
)
_RGBA_KEYS = {"panel_rgba", "module_rgba", "active_rgba", "inactive_border"}


def is_valid_rgba(value: str) -> bool:
    """Validate RGBA color string format and component ranges."""
    if not isinstance(value, str):
        return False
    match = _RGBA.match(value)
    if not match:
        return False
    r, g, b = int(match.group(1)), int(match.group(2)), int(match.group(3))
    if not (0 <= r <= 255 and 0 <= g <= 255 and 0 <= b <= 255):
        return False
    alpha = float(match.group(4))
    return 0.0 <= alpha <= 1.0


class RGBAValidationTest(unittest.TestCase):
    def setUp(self):
        self.tokens = json.loads(TOKENS_FILE.read_text())

    def test_all_rgba_fields_parse_correctly(self):
        """ALL rgba fields in tokens.json parse correctly."""
        for mode_name, mode_data in self.tokens["modes"].items():
            for key in _RGBA_KEYS:
                if key not in mode_data:
                    continue
                value = mode_data[key]
                self.assertTrue(
                    is_valid_rgba(value),
                    f"{mode_name}.{key} has invalid RGBA: {value}",
                )

    def test_is_valid_rgba_with_valid_inputs(self):
        """is_valid_rgba returns True for valid RGBA strings."""
        valid_cases = [
            "rgba(138, 115, 88, 0.93)",
            "rgba( 167 , 148 , 122 , 0.87 )",
            "rgba(0, 0, 0, 0)",
            "rgba(255, 255, 255, 1)",
            "rgba(255, 255, 255, 0.5)",
            "rgba(255, 255, 255, 0.0)",
        ]
        for case in valid_cases:
            with self.subTest(case=case):
                self.assertTrue(is_valid_rgba(case))

    def test_is_valid_rgba_with_invalid_inputs(self):
        """is_valid_rgba returns False for invalid RGBA strings."""
        invalid_cases = [
            "rgba(8a7358ee)",  # malformed - hex in rgba
            "rgba(a7947adf)",  # malformed - hex in rgba
            "rgba(256, 0, 0, 0.5)",  # R > 255
            "rgba(0, 256, 0, 0.5)",  # G > 255
            "rgba(0, 0, 256, 0.5)",  # B > 255
            "rgba(0, 0, 0, 1.5)",  # alpha > 1.0
            "rgba(0, 0, 0, -0.1)",  # negative alpha
            "#8a7358",  # hex not rgba
            "rgb(138, 115, 88)",  # missing alpha
            "rgba(138, 115, 88)",  # missing alpha
        ]
        for case in invalid_cases:
            with self.subTest(case=case):
                self.assertFalse(is_valid_rgba(case))

    def test_no_inactive_border_has_broken_format(self):
        """No inactive_border has the broken rgba(8a...) format."""
        for mode_name, mode_data in self.tokens["modes"].items():
            if "inactive_border" not in mode_data:
                continue
            value = mode_data["inactive_border"]
            self.assertFalse(
                "rgba(" in value and not _RGBA.match(value),
                f"{mode_name}.inactive_border has broken format: {value}",
            )

    def test_all_rgba_values_in_range_0_255(self):
        """All RGBA R, G, B component values are in range 0-255."""
        for mode_name, mode_data in self.tokens["modes"].items():
            for key in _RGBA_KEYS:
                if key not in mode_data:
                    continue
                value = mode_data[key]
                if not is_valid_rgba(value):
                    self.fail(f"{mode_name}.{key} is not valid RGBA: {value}")
                match = _RGBA.match(value)
                if match:
                    r, g, b = (
                        int(match.group(1)),
                        int(match.group(2)),
                        int(match.group(3)),
                    )
                    self.assertTrue(
                        0 <= r <= 255, f"{mode_name}.{key} R={r} out of range"
                    )
                    self.assertTrue(
                        0 <= g <= 255, f"{mode_name}.{key} G={g} out of range"
                    )
                    self.assertTrue(
                        0 <= b <= 255, f"{mode_name}.{key} B={b} out of range"
                    )

    def test_all_alpha_values_in_range_0_to_1(self):
        """All RGBA alpha values are in range 0.0-1.0."""
        for mode_name, mode_data in self.tokens["modes"].items():
            for key in _RGBA_KEYS:
                if key not in mode_data:
                    continue
                value = mode_data[key]
                match = _RGBA.match(value)
                if match:
                    alpha = float(match.group(4))
                    self.assertTrue(
                        0.0 <= alpha <= 1.0,
                        f"{mode_name}.{key} alpha={alpha} out of range",
                    )


if __name__ == "__main__":
    unittest.main()
