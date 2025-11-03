# DreamCoder Starship Prompt v2.0

## Cinematographic Design - Concept 2: Neon Cyber Aesthetic

### Visual Philosophy

The DreamCoder v2 prompt combines three aesthetic influences:
- **Comic Book Covers:** Bold symbols and clean separation of elements
- **Fashion Magazine:** Refined typography with precise spacing
- **Cinematic Epic:** Dramatic color accents and clear status indicators

### Color Palette

```bash
# Primary Colors
NEON_CYAN="#00e5ff"    # DreamCoder identity, primary accents
GOLD="#ffd166"         # Command duration, Python, highlights
PINK="#ff6b9f"         # Git changes, errors, warnings
GRAY="#cfd8dc"         # Paths, secondary text
BACKGROUND="#0b0f14"   # Deep slate terminal background
```

### Typography

- **Font Family:** Meslo Nerd Font (recommended) or any Nerd Font
- **Style:** Clean, bold, high contrast
- **Icons:** Nerd Font glyphs for maximum visual impact

## Prompt Layout

### Left Prompt Structure

```
 <OS> [user@host] <directory> <git_branch>[changes] <runtime> <duration> <status> <jobs>
❯
```

**Elements (left to right):**

1. **DreamCoder Symbol ()** - Neon cyan brand identity
2. **OS Icon** - System indicator (Arch/Ubuntu/etc)
3. **User@Host** - Context (shown on SSH only)
4. **Directory** - Current path with smart truncation
5. **Git Branch** - VCS repository info
6. **Git Status** - Changed files indicator [+~-?]
7. **Runtime** - Python/Node/Rust/Go/Java versions
8. **Docker** - Container context
9. **Command Duration** - Shows if >2s (gold highlight)
10. **Status** - Error/success indicator
11. **Jobs** - Background processes
12. **Character (❯)** - Input indicator (cyan=success, pink=error, gold=vi mode)

### Right Prompt Structure

```
󰥔 HH:MM  BATTERY%
```

**Elements:**
- **Time** - Current time (HH:MM format)
- **Battery** - Power status with dynamic icon

## Color Coding System

### Status Colors
- **Cyan (#00e5ff)** → Success, primary elements, navigation
- **Gold (#ffd166)** → Highlights, durations >2s, warnings
- **Pink (#ff6b9f)** → Errors, git changes, critical alerts
- **Gray (#cfd8dc)** → Standard text, paths, secondary info

### Runtime Languages
- **Python** → Gold (󰌠)
- **Node.js** → Cyan ()
- **Rust** → Pink ()
- **Go** → Cyan ()
- **Java** → Gold ()
- **Bun** → Gold (󰂫)

### Git Indicators
- `` → Branch (gray)
- `+N` → Staged files (pink)
- `!N` → Modified files (pink)
- `?N` → Untracked files (pink)
- `✘N` → Deleted files (pink)
- `⇡N / ⇣N` → Ahead/behind remote (pink)
- `⚡` → Merge conflict (pink)

## Features

### Smart Context Display
- **Local:** Shows only OS + directory
- **SSH:** Adds user@hostname automatically
- **Git:** Shows branch only when in repository
- **Runtime:** Appears only when project files detected

### Performance Optimized
- Custom modules disabled for speed
- Shell detection disabled
- Memory usage monitoring disabled
- 500ms command timeout

### Hardware Adaptive
- Battery indicator auto-disables on desktop
- Conditional display based on hardware presence

## Installation

The configuration is already integrated into the DreamCoder dotfiles system.

### Manual Application
```bash
# Copy configuration
cp starship.toml ~/.config/starship.toml

# Reload shell
exec $SHELL
```

### Verification
```bash
# Test prompt
starship prompt

# Check configuration
starship config

# Show version
starship --version
```

## Customization

### Adjust Command Duration Threshold
Edit `starship.toml:239`:
```toml
[cmd_duration]
min_time = 2000  # Change to desired milliseconds
```

### Change DreamCoder Symbol
Edit `starship.toml:15`:
```toml
format = """
[]  # Replace with your preferred symbol
```

### Enable/Disable Right Prompt
Edit `starship.toml:27`:
```toml
right_format = """$time$battery"""  # Remove elements or set to ""
```

### Add Cloud Context (AWS/GCP/K8s)
Add to format string in `starship.toml:15`:
```toml
$aws$gcloud$kubernetes\
```

## Troubleshooting

### Symbols Not Showing
**Problem:** Square boxes instead of icons
**Solution:** Install a Nerd Font:
```bash
# Arch Linux
sudo pacman -S ttf-meslo-nerd

# Or download from: https://www.nerdfonts.com/
```

### Colors Not Matching
**Problem:** Colors look different
**Solution:** Ensure terminal supports 24-bit color:
```bash
# Add to .zshrc or .bashrc
export COLORTERM=truecolor
```

### Slow Prompt
**Problem:** Lag when typing
**Solution:** Increase timeout in `starship.toml:29`:
```toml
command_timeout = 1000  # Reduce from 500ms
```

## Design Philosophy

### Why These Colors?

**Neon Cyan (#00e5ff)**
- High visibility on dark backgrounds
- Cyberpunk aesthetic that matches "DreamCoder"
- Represents clarity and navigation
- Less common than blue/purple (distinctive)

**Gold (#ffd166)**
- Warm accent that complements cyan
- Perfect for highlighting important info (durations)
- Conveys value and achievement
- Easy to distinguish from errors

**Pink (#ff6b9f)**
- Softer than red but still signals attention
- Modern, less aggressive error indicator
- Complements cyan without clashing
- Aesthetic balance with gold

### Layout Decisions

1. **Left-heavy:** Most important info near input position
2. **Right-minimal:** Time/battery don't distract from work
3. **No newline:** Maximizes screen space
4. **Smart truncation:** Directories shortened but readable
5. **Conditional display:** Only show what's relevant

## Version History

### v2.0 (Current) - Concept 2: Neon Cyber
- Switched from violet/magenta to neon cyan primary
- Added gold and pink accents
- Cinematographic typography
- Hardware-adaptive display
- Performance optimizations

### v1.0 - Original DreamCoder
- Basic configuration
- Standard colors
- Full module set

## Contributing

To modify this design:

1. Edit `starship.toml`
2. Test changes: `starship prompt`
3. Document in this file
4. Update version number

## References

- [Starship Documentation](https://starship.rs)
- [Nerd Fonts](https://www.nerdfonts.com)
- [Color Palette](https://coolors.co/0b0f14-00e5ff-ffd166-ff6b9f-cfd8dc)

---

**Created:** 2025-11-03
**Version:** 2.0
**Author:** DreamCoder Team
**License:** MIT
