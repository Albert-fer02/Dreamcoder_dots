function tmux-kill-all --description "Mata TODAS las sesiones tmux (cuidado)"
    if command -q tmux
        set -l sessions (tmux list-sessions -F '#{session_name}' 2>/dev/null)
        if test (count $sessions) -eq 0
            echo "No hay sesiones tmux activas"
            return 0
        end

        echo "Sesiones activas:"
        for s in $sessions
            echo "  • $s"
        end
        echo ""
        read -l -p 'echo "¿Matar TODAS? (s/N): "' confirm
        if test "$confirm" = "s"
            tmux kill-server
            echo "✅ Todas las sesiones tmux fueron terminadas"
        else
            echo "Cancelado"
        end
    end
end
