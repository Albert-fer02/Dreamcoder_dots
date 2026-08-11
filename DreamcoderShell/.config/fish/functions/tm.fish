function tm --description "tmux smart attach — crea o adjunta a una sesión"
    # Uso: tm [nombre-sesion]
    # Si se omite el nombre, usa "mobile" por defecto (ideal para Termius)
    set -l session_name mobile
    if test (count $argv) -ge 1
        set session_name $argv[1]
    end

    if command -q tmux
        if set -q TMUX
            # Ya estamos dentro de tmux
            echo "Ya estás en una sesión tmux ($TMUX)"
            return 1
        end

        # Intenta attach, si no existe la sesión la crea
        tmux new-session -A -s "$session_name"
    else
        echo "❌ tmux no está instalado"
        return 1
    end
end
