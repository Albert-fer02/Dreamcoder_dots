# Dreamcoder visual theme contract for Fish shells.
set -q DREAMCODER_THEME_MODE; or set -gx DREAMCODER_THEME_MODE light
set -q COLORTERM; or set -gx COLORTERM truecolor
set -gx FORCE_COLOR 3
set -gx CLICOLOR_FORCE 1
set -e NO_COLOR

switch "$DREAMCODER_THEME_MODE"
    case dark
        set -gx BAT_THEME Dreamcoder-Dark
    case '*'
        set -gx BAT_THEME Dreamcoder-Light
end

set -gx BAT_STYLE header,numbers,changes,grid
set -gx BAT_TABS 4
