# ========================================================
# Dreamcoder Light — Bat theme
# ========================================================
# Set the --theme to use the Dreamcoder tmTheme.
# Install: bat cache --build (after placing .tmTheme in Bat themes dir)
#
# Recommended approach:
#   1. Symlink or copy the Codex-CLI Dreamcoder.tmTheme to Bat themes:
#      ln -sf "$DREAMCODER_DOTS_DIR/Codex-CLI/Dreamcoder-Dark.tmTheme" \
#             "$(bat --config-dir)/themes/Dreamcoder-Dark.tmTheme"
#   2. Set this in your shell config:
#      export BAT_THEME="Dreamcoder-Dark"

export BAT_THEME="Dreamcoder-Light"

# Fallback: if no .tmTheme is installed, at least style the pager chrome
# with Dreamcoder colors via bat's --style and command-line flags.
export BAT_STYLE="header,numbers,changes,grid"
export BAT_TABS="4"

# Syntax theme can also be set via environment variable
# BAT_THEME="Dreamcoder-Dark"  # or -Light / -Dusk
