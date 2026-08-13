package styles

import (
	"math"
	"strings"
	"testing"
)

// TestCanonicalDarkPaletteMapping locks every exported TUI semantic color to
// the exact canonical Anthracite Steel dark token value from
// DreamcoderThemes/dreamcoder/tokens.json (mirrored by
// src/dreamcoder_theme/palette_tokens.py). Any drift from the canonical
// palette fails here on purpose.
func TestCanonicalDarkPaletteMapping(t *testing.T) {
	cases := []struct {
		name string
		got  string
		want string
	}{
		{"Primary (bg)", string(Primary), "#070A13"},
		{"Secondary (bg_soft/surface0)", string(Secondary), "#0D121A"},
		{"Surface (surface1)", string(Surface), "#151C25"},
		{"Text", string(Text), "#E6EDF3"},
		{"Muted", string(Muted), "#A8B5C2"},
		{"Subtle", string(Subtle), "#8795a2"},
		{"Comment", string(Comment), "#aab7c4"},
		{"Accent", string(Accent), "#A5C7E8"},
		{"Accent2", string(Accent2), "#8FAFCB"},
		{"Focus", string(Focus), "#A5C7E8"},
		{"Diagnostic", string(Diagnostic), "#4DAED6"},
		{"Sage", string(Sage), "#55C080"},
		{"Success (sage role)", string(Success), "#55C080"},
		{"Lavender", string(Lavender), "#B6C5D4"},
		{"Mauve", string(Mauve), "#B48EAD"},
		{"Error", string(Error), "#E38989"},
		{"Warning", string(Warning), "#E1C16D"},
		{"BorderUI (border_ui, visible border role)", string(BorderUI), "#6A8497"},
		{"BorderHi (border_hi)", string(BorderHi), "#758A9C"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if tc.got != tc.want {
				t.Fatalf("palette divergence: got %s, want canonical %s", tc.got, tc.want)
			}
		})
	}
}

// TestWCAGContrastAgainstPrimaryBackground enforces the TUI's WCAG 2.x
// contrast floors against the primary background (#070A13): text and accent
// colors must reach 4.5:1, and the visible border (BorderUI) and border
// highlight must reach 3:1. The canonical "border" token (#17202B, ~1.2:1)
// intentionally fails the border floor, which is why BorderUI fills the
// visible border role.
func TestWCAGContrastAgainstPrimaryBackground(t *testing.T) {
	bg := string(Primary)
	cases := []struct {
		name  string
		color string
		floor float64
	}{
		{"Text", string(Text), 4.5},
		{"Muted", string(Muted), 4.5},
		{"Subtle", string(Subtle), 4.5},
		{"Comment", string(Comment), 4.5},
		{"Accent", string(Accent), 4.5},
		{"Accent2", string(Accent2), 4.5},
		{"Focus", string(Focus), 4.5},
		{"Diagnostic", string(Diagnostic), 4.5},
		{"Sage", string(Sage), 4.5},
		{"Success", string(Success), 4.5},
		{"Lavender", string(Lavender), 4.5},
		{"Mauve", string(Mauve), 4.5},
		{"Error", string(Error), 4.5},
		{"Warning", string(Warning), 4.5},
		{"BorderHi (border_hi)", string(BorderHi), 3.0},
		{"BorderUI (visible border)", string(BorderUI), 3.0},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			ratio := contrastRatio(tc.color, bg)
			if ratio < tc.floor {
				t.Fatalf("contrast %s on %s = %.2f:1, below floor %.1f:1", tc.color, bg, ratio, tc.floor)
			}
		})
	}
}

// contrastRatio returns the WCAG 2.x contrast ratio between two #RRGGBB
// colors. Deterministic and dependency-free so the floors above are enforced
// without pulling an external color library into the installer.
func contrastRatio(a, b string) float64 {
	la := relativeLuminance(a)
	lb := relativeLuminance(b)
	if la < lb {
		la, lb = lb, la
	}
	return (la + 0.05) / (lb + 0.05)
}

func relativeLuminance(hex string) float64 {
	r, g, b := parseHex(hex)
	return 0.2126*linearChannel(r) + 0.7152*linearChannel(g) + 0.0722*linearChannel(b)
}

func linearChannel(v int) float64 {
	c := float64(v) / 255
	if c <= 0.03928 {
		return c / 12.92
	}
	return math.Pow((c+0.055)/1.055, 2.4)
}

func parseHex(hex string) (r, g, b int) {
	hex = strings.TrimPrefix(hex, "#")
	if len(hex) != 6 {
		panic("parseHex: expected #RRGGBB, got " + hex)
	}
	r = hexPair(hex[0:2])
	g = hexPair(hex[2:4])
	b = hexPair(hex[4:6])
	return r, g, b
}

func hexPair(s string) int {
	v := 0
	for _, ch := range s {
		v *= 16
		switch {
		case ch >= '0' && ch <= '9':
			v += int(ch - '0')
		case ch >= 'a' && ch <= 'f':
			v += int(ch-'a') + 10
		case ch >= 'A' && ch <= 'F':
			v += int(ch-'A') + 10
		default:
			panic("parseHex: invalid hex digit " + string(ch))
		}
	}
	return v
}
