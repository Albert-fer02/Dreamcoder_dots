# Project directory
if [[ -d "$HOME/Documents" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documents/Projects}"
elif [[ -d "$HOME/Documentos" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documentos/PROYECTOS}"
else
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
fi
