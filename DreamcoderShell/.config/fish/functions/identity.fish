function identity --description "Switch to an identity workspace: personal, founder, dev, research"
    switch $argv[1]
        case personal
            set -l dir ~/Personal
            if test -d $dir
                cd $dir
            end
            zen-browser -P Personal &
            disown
            echo "🟢 Identity: Personal — ~/Personal/"

        case founder
            set -l dir ~/Founder
            if test -d $dir
                cd $dir
            end
            zen-browser -P Founder &
            disown
            echo "🚀 Identity: Founder — ~/Founder/"

        case dev
            set -l dir ~/Dev
            if test -d $dir
                cd $dir
            end
            zen-browser -P Dev &
            disown
            echo "💻 Identity: Dev — ~/Dev/"

        case research
            set -l dir ~/Research
            if test -d $dir
                cd $dir
            end
            zen-browser -P Research &
            disown
            echo "🔬 Identity: Research — ~/Research/"

        case '*'
            echo "Usage: identity <personal|founder|dev|research>"
            echo "Available identities:"
            echo "  personal  🟢  ~/Personal/   — Vida privada"
            echo "  founder   🚀  ~/Founder/    — Marca y presencia pública"
            echo "  dev       💻  ~/Dev/        — Infraestructura técnica"
            echo "  research  🔬  ~/Research/   — Exploración y experimental"
    end
end
