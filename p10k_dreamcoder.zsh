#!/bin/zsh
# =====================================================
# 🚀 POWERLEVEL10K DREAMCODER SENIOR - TOKYO NIGHT MASTERY
# =====================================================
# Diseño profesional senior-level con estructura correcta
# Elementos contextuales inteligentes + Performance extremo
# Compatible con instant prompt + Separadores avanzados
# =====================================================

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # =====================================================
  # 🌈 PALETA VIBRANTE - COLORES VIVOS Y BRILLANTES
  # =====================================================
  # Inspirada en: Dracula + Material Design + Neon themes
  # Colores saturados y vibrantes para máximo impacto visual
  # Perfecto para fondos transparentes y terminales oscuros
  
  # Colores principales ultra vibrantes
  local blue='#79a7ff'            # Azul eléctrico brillante
  local blue_silver='#87ceeb'     # Azul plata elegante para usuario
  local silver='#c0c0c0'          # Plata pura brillante
  local green='#a3d977'           # Verde lima vibrante
  local red='#ff5f87'             # Rojo coral intenso
  local yellow='#ffcb6b'          # Amarillo dorado brillante
  local purple='#d197ff'          # Púrpura neón intenso
  local cyan='#7fdbff'            # Cyan aqua brillante
  local orange='#ffb86c'          # Naranja mandarina vibrante
  
  # Texto con alta saturación
  local text_primary='#f8f8f2'    # Blanco puro para máximo contraste
  local text_secondary='#bd93f9'  # Púrpura claro vibrante
  local text_emphasis='#ffffff'   # Blanco absoluto
  local text_muted='#6272a4'     # Azul grisáceo pero vibrante
  
  local transparent=none

  # =====================================================
  # ⚡ INSTANT PROMPT & PERFORMANCE
  # =====================================================
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=false
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # =====================================================
  # 🎯 PROMPT STRUCTURE - SENIOR DESIGN
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    user
    dir
    vcs
    # Contextual elements (only when relevant)
    virtualenv
    pyenv
    nodeenv
    docker_context
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    background_jobs
    command_execution_time
  )

  # =====================================================
  # 🏗️ PROMPT FLOW & TYPOGRAPHY
  # =====================================================
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

  # Two-line design with contextual arrow
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$blue}❯%f "

  # =====================================================
  # 🔸 SEPARATORS - MINIMALISTA TRANSPARENTE
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

  # =====================================================
  # 💻 OS ICON - ARCH LINUX TRANSPARENTE
  # =====================================================
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="$blue"
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='󰣇'

  # =====================================================
  # 👤 USER - NOMBRE EN AZUL PLATA ELEGANTE
  # =====================================================
  typeset -g POWERLEVEL9K_USER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$blue_silver"
  typeset -g POWERLEVEL9K_USER_ROOT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND="$red"
  typeset -g POWERLEVEL9K_USER_SUDO_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_SUDO_FOREGROUND="$orange"
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_USER=true
  typeset -g POWERLEVEL9K_USER_TEMPLATE='%n'

  # =====================================================
  # 📁 DIRECTORY - TRANSPARENTE Y LEGIBLE
  # =====================================================
  typeset -g POWERLEVEL9K_DIR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$text_primary"
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND="$cyan"
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$text_primary"
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND="$red"

  # Smart truncation strategy
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=60
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'

  # Context-aware modern icons
  typeset -g POWERLEVEL9K_DIR_ETC_ICON=''
  typeset -g POWERLEVEL9K_DIR_HOME_ICON=''
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON=''
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ICON=''
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_ICON=''

  # =====================================================
  # 🌿 GIT - TRANSPARENTE CON COLORES CONTEXTUALES
  # =====================================================
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$green"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$yellow"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$blue"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND="$red"
  typeset -g POWERLEVEL9K_VCS_STAGED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_STAGED_FOREGROUND="$cyan"
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND="$text_secondary"

  # Professional Git icons
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='󰘬 '
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON=''
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=''
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON=''
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='󰏗'
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_ICON=''
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON=''

  # =====================================================
  # 🐍 DEVELOPMENT ENVIRONMENTS - CONTEXTUAL
  # =====================================================

  # Python - solo con archivos .py o venv
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND="$green"
  typeset -g POWERLEVEL9K_PYENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND="$yellow"
  typeset -g POWERLEVEL9K_PYENV_ICON=''

  # Node.js - solo con package.json
  typeset -g POWERLEVEL9K_NODEENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND="$green"
  typeset -g POWERLEVEL9K_NODEENV_ICON=''

  # Docker - solo con Dockerfile/docker-compose
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND="$blue"
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_ICON=''

  # =====================================================
  # ✔️ STATUS & SYSTEM INFO - RIGHT PROMPT
  # =====================================================

  # Status with contextual colors (only errors)
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="$green"
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$red"
  typeset -g POWERLEVEL9K_STATUS_OK_ICON=''
  typeset -g POWERLEVEL9K_STATUS_ERROR_ICON=''
  typeset -g POWERLEVEL9K_STATUS_OK=false  # Solo mostrar en errores

  # Background jobs (contextual)
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$orange"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON=''

  # Command execution time (>2s only)
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$purple"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='%d s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_ICON=''

  # =====================================================
  # ⚡ PERFORMANCE OPTIMIZATIONS
  # =====================================================

  # Git optimizations for large repos
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096
  typeset -g POWERLEVEL9K_VCS_STAGED_MAX_NUM=10
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM=10

  # Battery optimization (only show when critical)
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20

  # Disable time realtime updates
  typeset -g POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME=false

  # RPROMPT optimizations
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT_AFTER_COMMAND=true

}

# Restore previous options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'