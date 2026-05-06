#!/usr/bin/env python3
import json
import os
import subprocess
from pathlib import Path


config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
cache_home = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
kitty = Path(os.environ.get("KITTY_COLORS", config_home / "kitty/colors-matugen.conf"))
ghostty = Path(os.environ.get("GHOSTTY_THEME", config_home / "ghostty/themes/dreamcoder"))
starship = Path(os.environ.get("STARSHIP_CONFIG", config_home / "starship.toml"))
wallpaper_file = Path(os.environ.get(
    "DREAMCODER_WALLPAPER_FILE",
    cache_home / "ml4w/hyprland-dotfiles/current_wallpaper",
))


def normalize_hex(value: str) -> str:
    value = value.strip()
    if not value.startswith("#"):
        value = f"#{value}"
    return value.lower()


def current_wallpaper() -> Path | None:
    explicit = os.environ.get("WALLPAPER") or os.environ.get("DREAMCODER_WALLPAPER")
    if explicit:
        path = Path(explicit).expanduser()
        return path if path.is_file() else None
    if wallpaper_file.is_file():
        path = Path(wallpaper_file.read_text().strip()).expanduser()
        return path if path.is_file() else None
    return None


def matugen_colors(wallpaper: Path) -> dict[str, str]:
    result = subprocess.run(
        ["matugen", "image", str(wallpaper), "-m", "dark", "--dry-run", "--json", "hex"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "matugen failed")
    raw = json.loads(result.stdout)
    dark = raw.get("colors", {}).get("dark", {})
    return {key: normalize_hex(value) for key, value in dark.items() if isinstance(value, str)}


def read_colors(path: Path) -> dict[str, str]:
    colors: dict[str, str] = {}
    for line in path.read_text().splitlines():
        clean = line.strip()
        if not clean or clean.startswith("#") or clean.startswith("/*"):
            continue
        parts = clean.split()
        if len(parts) >= 2:
            colors[parts[0]] = normalize_hex(parts[1])
    return colors


def require(label: str, colors: dict[str, str], *keys: str) -> None:
    missing = [key for key in keys if key not in colors]
    if missing:
        raise SystemExit(f"Missing {label} colors: {', '.join(missing)}")


def write_if_changed(path: Path, content: str) -> bool:
    old = path.read_text() if path.exists() else ""
    if old == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    return True


def valid_starship(path: Path) -> bool:
    return subprocess.run(
        ["starship", "explain"],
        env={**os.environ, "STARSHIP_CONFIG": str(path)},
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    ).returncode == 0


wallpaper = current_wallpaper()
if wallpaper:
    m = matugen_colors(wallpaper)
    require("Matugen", m, "surface", "on_surface", "on_surface_variant", "primary",
            "on_primary", "secondary", "secondary_container", "on_secondary_container",
            "tertiary", "tertiary_fixed_dim", "error", "outline", "inverse_surface",
            "surface_container", "surface_container_high", "surface_container_highest")
    c = {
        "background": m["surface"],
        "foreground": m["on_surface"],
        "cursor": m["primary"],
        "cursor_text_color": m["on_primary"],
        "selection_background": m["secondary_container"],
        "selection_foreground": m["on_secondary_container"],
        "color0": m["surface_container_high"],
        "color1": m["error"],
        "color2": m["secondary"],
        "color3": m["tertiary_fixed_dim"],
        "color4": m["primary"],
        "color5": m["tertiary"],
        "color6": m["secondary"],
        "color7": m["on_surface"],
        "color8": m["outline"],
        "color9": m["error"],
        "color10": m["secondary"],
        "color11": m["tertiary_fixed_dim"],
        "color12": m["primary"],
        "color13": m["tertiary"],
        "color14": m["secondary"],
        "color15": m["inverse_surface"],
        "surface0": m["surface_container_high"],
        "surface1": m["surface_container"],
        "muted": m["on_surface_variant"],
    }
    source = str(wallpaper)
else:
    c = read_colors(kitty)
    require("Kitty", c, "background", "foreground", "cursor", "cursor_text_color",
            "selection_background", "selection_foreground", *(f"color{i}" for i in range(16)))
    c["surface0"] = c["color0"]
    c["surface1"] = c["selection_foreground"]
    c["muted"] = c["cursor_text_color"]
    source = str(kitty)

ghostty_content = "\n".join([
    f"background = {c['background']}",
    f"foreground = {c['foreground']}",
    f"cursor-color = {c['cursor']}",
    f"cursor-text = {c['cursor_text_color']}",
    f"selection-background = {c['selection_background']}",
    f"selection-foreground = {c['selection_foreground']}",
    "",
    *[f"palette = {i}={c[f'color{i}']}" for i in range(16)],
    "",
])

def starship_palette(colors: dict[str, str]) -> str:
    return f'''[palettes.wallpaper]
bg = "{colors['background']}"
surface0 = "{colors['surface0']}"
surface1 = "{colors['surface1']}"
cream = "{colors['foreground']}"
muted = "{colors['muted']}"
beige = "{colors['selection_background']}"
lucuma = "{colors['color4']}"
sage = "{colors['color10']}"
cyan = "{colors['color14']}"
lavender = "{colors['color12']}"
mauve = "{colors['color13']}"
red = "{colors['color1']}"
'''


starship_modules = r'''
[username]
show_always = true
style_user = "bg:surface0 fg:cream bold"
style_root = "bg:surface0 fg:red bold"
format = "[  $user ]($style)"

[hostname]
ssh_only = true
style = "fg:muted bold"
format = "[ 󰣇 $hostname ]($style) "

[directory]
style = "bg:cream fg:bg bold"
format = "[  $path ]($style)"
truncation_length = 3
truncate_to_repo = false

[git_branch]
symbol = ""
style = "bg:lucuma fg:bg bold"
format = "[ $symbol $branch ]($style)"

[git_status]
style = "bg:lucuma fg:bg bold"
format = "[$all_status$ahead_behind ]($style)"
conflicted = "${count} "
ahead = "⇡${count} "
behind = "⇣${count} "
diverged = "⇕⇡${ahead_count}⇣${behind_count} "
untracked = "?${count} "
stashed = "󰏗${count} "
modified = "~${count} "
staged = "+${count} "
renamed = "»${count} "
deleted = "✘${count} "

[fill]
symbol = " "

[bun]
symbol = ""
style = "fg:lucuma bold"
format = "[ $symbol $version]($style)"

[nodejs]
symbol = ""
style = "fg:sage bold"
format = "[ $symbol $version]($style)"

[python]
symbol = ""
style = "fg:cyan bold"
format = "[ $symbol $version]($style)"

[golang]
symbol = ""
style = "fg:lavender bold"
format = "[ $symbol $version]($style)"

[rust]
symbol = ""
style = "fg:mauve bold"
format = "[ $symbol $version]($style)"

[docker_context]
symbol = ""
style = "fg:cyan bold"
format = "[ $symbol $context]($style)"
only_with_files = true

[cmd_duration]
min_time = 1000
style = "fg:muted"
format = "[  $duration ]($style) "

[time]
disabled = false
time_format = "%H:%M:%S"
style = "fg:muted"
format = "[ ✓ $time ]($style)"

[character]
success_symbol = "[❯](bold fg:lucuma)"
error_symbol = "[✗](bold fg:red)"
vimcmd_symbol = "[❮](bold fg:sage)"
'''


palette_content = starship_palette(c)
starship_content = f'''add_newline = true
palette = "wallpaper"

format = """
[](fg:surface0)\\
$username\\
[](bg:cream fg:surface0)\\
$directory\\
[](bg:lucuma fg:cream)\\
$git_branch\\
$git_status\\
[](fg:lucuma)\\
$fill\\
$hostname\\
$bun\\
$nodejs\\
$python\\
$golang\\
$rust\\
$docker_context\\
$cmd_duration\\
$time
$character"""

{palette_content}{starship_modules}
'''


changed_ghostty = write_if_changed(ghostty, ghostty_content)
changed_starship = write_if_changed(starship, starship_content)
if not valid_starship(starship):
    raise SystemExit(f"Generated Starship config is invalid: {starship}")

print(f"Synced Dreamcoder theme from {source}")
print(f"Ghostty: {ghostty}")
print(f"Starship: {starship}")
print(f"Changed: ghostty={changed_ghostty} starship={changed_starship}")
