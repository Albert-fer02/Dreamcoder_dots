# ── Dreamcoder Fish Abbreviations ────────────────────────────────
# Faster than aliases — expand inline, show what you're running.

if status is-interactive
    # Git
    abbr -a g git
    abbr -a gco git checkout
    abbr -a gb git branch
    abbr -a gst git stash
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
    # (dots is a fish function in functions/dots.fish — no abbr, so the
    # function's DREAMCODER_DOTS_DIR-aware lookup is what runs)
    abbr -a gdots "cd $HOME/Gentleman.Dots"

    # Tools
    abbr -a lg lazygit
    abbr -a y yazi
        abbr -a cat bat

        # Listings — abbreviations shadow the icon aliases in
        # 16-dreamcoder-icons.fish, so they must carry --icons=always here.
        if command -q eza
            abbr -a ls "eza --icons=always --group-directories-first"
            abbr -a ll "eza --icons=always --group-directories-first --long --git"
            abbr -a la "eza --icons=always --group-directories-first --long --all --git"
            abbr -a tree "eza --icons=always --group-directories-first --tree"
        end
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
