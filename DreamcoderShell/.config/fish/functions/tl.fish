function tl --description "Listar sesiones tmux"
    if command -q tmux
        tmux list-sessions 2>/dev/null
        if test $status -ne 0
            echo "No hay sesiones tmux activas"
        end
    else
        echo "❌ tmux no está instalado"
    end
end
