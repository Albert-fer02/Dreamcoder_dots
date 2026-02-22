smart_cd() {
    builtin cd "$@" || return
    [[ -f "./venv/bin/activate" ]] && { echo "Activating venv"; source ./venv/bin/activate; }
    [[ -f "package.json" && ! -d "node_modules" ]] && echo "Run: npm install"
    [[ -d ".git" ]] && git status -s 2>/dev/null | head -3
}
