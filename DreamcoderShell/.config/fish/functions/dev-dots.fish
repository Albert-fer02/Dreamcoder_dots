# Launch Dreamcoder-dots dev workspace with Herdr
function dev-dots
    set -l project_dir "$HOME/Documents/PROYECTOS/dreamcoder-dots"

    if not test -d "$project_dir"
        echo "❌ Project not found: $project_dir"
        return 1
    end

    # Start Herdr if not running
    if not set -q HERDR_SOCKET
        herdr --session dreamcoder-dots &
        sleep 0.5
    end

    cd "$project_dir"
    echo "🚀 Dreamcoder-dots workspace ready at $project_dir"

    # Open lazygit in current dir
    herdr tab open -- lazygit

    # Open nvim in project
    herdr tab open -- nvim

    # Status line
    echo "  📂 $(pwd)"
    echo "  🌿 $(git branch --show-current 2>/dev/null || echo 'no repo')"
    echo "  🎨 $DREAMCODER_THEME_MODE mode"
end
