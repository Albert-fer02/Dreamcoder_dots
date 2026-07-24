# ── Dreamcoder Fish Abbreviations ────────────────────────────────
# Faster than aliases — expand inline, show what you're running.

if status is-interactive
    # Git
    abbr -a g git
    abbr -a gco git checkout
    abbr -a gb git branch
    abbr -a gst git status
    abbr -a gd git diff
    abbr -a gdt git difftool
    abbr -a gcm git commit -m
    abbr -a gca git commit --amend
    abbr -a gl git log --oneline -20
    abbr -a gp git push
    abbr -a gpl git pull
    abbr -a grb git rebase -i

    # Navigation
    abbr -a .. cd ..
    abbr -a ... cd ../..
    abbr -a .... cd ../../..

    # Project quick-jump
    abbr -a dots "cd $HOME/Documents/PROYECTOS/dreamcoder-dots"
    abbr -a gdots "cd $HOME/Gentleman.Dots"

    # Tools
    abbr -a lg lazygit
    abbr -a y yazi
    abbr -a cat bat
    abbr -a ls eza
    abbr -a ll "eza -la --icons --group-directories-first"
    abbr -a tree "eza --tree --icons"
    abbr -a grep rg
    abbr -a find fd

    # AI
    abbr -a cx codex
    abbr -a cc claude

    # Docker (if installed)
    if command -q docker
        abbr -a d docker
        abbr -a dc docker compose
        abbr -a dps docker ps
    end
end
