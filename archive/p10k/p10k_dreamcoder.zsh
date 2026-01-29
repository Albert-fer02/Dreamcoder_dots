#!/bin/zsh
# =====================================================
# 💎 DREAMCODER CRYSTAL GLASS v6.0 - POWERLEVEL10K
# =====================================================
# Configuración premium cristalina con estética refinada
# Paleta cristal transparente + Optimizaciones extremo
# Información contextual extendida + Legibilidad máxima
# Compatible con instant prompt + Performance cristalino
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
  # 💎 PALETA CRISTAL GLASS - COLORES TRANSPARENTES Y REFINADOS
  # =====================================================
  # Inspirada en cristales puros + vidrio transparente + neones suaves
  # Colores cristalinos con máxima legibilidad y elegancia refinada
  # Perfecto para fondos transparentes y terminales modernas

  # Colores principales cristalinos
  local crystal_blue='#87ceeb'        # Azul cristalino brillante
  local crystal_cyan='#7fdbff'        # Cyan cristalino puro
  local crystal_green='#a3d977'       # Verde cristalino suave
  local crystal_purple='#d197ff'      # Púrpura cristalino elegante
  local crystal_pink='#ff6b9f'        # Rosa cristalino refinado
  local crystal_gold='#ffd166'        # Oro cristalino luminoso
  local crystal_silver='#c0c0c0'      # Plata cristalina brillante
  local crystal_red='#ff5f87'         # Rojo cristalino intenso

  # Textos con máxima legibilidad cristalina
  local text_crystal='#f8f8f2'        # Blanco cristalino puro
  local text_crystal_secondary='#bd93f9' # Púrpura cristalino claro
  local text_crystal_emphasis='#ffffff' # Blanco cristalino absoluto
  local text_crystal_muted='#6272a4'  # Azul cristalino grisáceo
  local text_crystal_dim='#4a5568'    # Gris cristalino suave

  local transparent=none

  # =====================================================
  # ⚡ INSTANT PROMPT & PERFORMANCE CRISTALINO
  # =====================================================
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=false
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # =====================================================
  # 🎯 PROMPT STRUCTURE - CRYSTAL DESIGN EXTENDED
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    custom_dreamcoder
    dir
    vcs
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
  )

  # =====================================================
  # 🏗️ PROMPT FLOW & TYPOGRAPHY CRISTALINA
  # =====================================================
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

  # Three-line crystal design with contextual arrows
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$crystal_cyan}❯%f "

  # =====================================================
  # 🔹 SEPARATORS - CRYSTAL GLASS MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='│'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='│'

  # =====================================================
  # 💻 OS ICON - CRYSTAL GLASS ARCH LINUX
  # =====================================================
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="$crystal_blue"
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='󰣇'

  # =====================================================
  # 🏷️ CUSTOM DREAMCODER BADGE - CRYSTAL GLASS INTEGRATION
  # =====================================================
  POWERLEVEL9K_CUSTOM_DREAMCODER='echo "⬢ dreamcoder08"'
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_VISUAL_IDENTIFIER_EXPANSION=''

  # =====================================================
  # 👤 USER - CRYSTAL SILVER ELEGANT
  # =====================================================
  typeset -g POWERLEVEL9K_USER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_USER_ROOT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND="$crystal_red"
  typeset -g POWERLEVEL9K_USER_SUDO_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_SUDO_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_USER=true
  typeset -g POWERLEVEL9K_USER_TEMPLATE='%n'

  # =====================================================
  # 📁 DIRECTORY - CRYSTAL TRANSPARENT & LEGIBLE
  # =====================================================
  typeset -g POWERLEVEL9K_DIR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$text_crystal"
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND="#FAFAFF"
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$text_crystal"
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND="$crystal_red"

  # Smart truncation strategy with crystal clarity
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'

  # Context-aware crystal modern icons
  typeset -g POWERLEVEL9K_DIR_ETC_ICON='󰉋'
  typeset -g POWERLEVEL9K_DIR_HOME_ICON='󰋜'
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON='󰉖'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ICON='󰉋'
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_ICON='󰀪'

  # =====================================================
  # 🌿 GIT - CRYSTAL TRANSPARENT CON CONTEXTUAL COLORS
  # =====================================================
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$crystal_green"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$crystal_blue"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND="$crystal_red"
  typeset -g POWERLEVEL9K_VCS_STAGED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_STAGED_FOREGROUND="$crystal_cyan"
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND="$text_crystal_secondary"

  # Professional crystal Git icons
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='󰘬 '
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='●'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='●'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='󰏗'
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_ICON='↑'
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON='↓'

  # =====================================================
  # 🐍 DEVELOPMENT ENVIRONMENTS - CRYSTAL CONTEXTUAL
  # =====================================================

  # Python - solo con archivos .py o venv
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND="$crystal_green"
  typeset -g POWERLEVEL9K_PYENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_PYENV_ICON=''

  # Node.js - solo con package.json
  typeset -g POWERLEVEL9K_NODEENV_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND="$crystal_green"
  typeset -g POWERLEVEL9K_NODEENV_ICON='󰎙'

  # Docker - solo con Dockerfile/docker-compose
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND="$crystal_blue"
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_ICON='󰡨'

  # Kubernetes - contextual
  typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND="$crystal_purple"
  typeset -g POWERLEVEL9K_KUBECONTEXT_ICON='󱃾'

  # AWS - contextual
  typeset -g POWERLEVEL9K_AWS_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_AWS_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_AWS_ICON='󰸏'

  # Terraform - contextual
  typeset -g POWERLEVEL9K_TERRAFORM_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND="$crystal_purple"
  typeset -g POWERLEVEL9K_TERRAFORM_ICON='󱁢'

  # =====================================================
  # 🔋 BATTERY - CRYSTAL GLASS EXTENDED
  # =====================================================
  typeset -g POWERLEVEL9K_BATTERY_SHOW=false
  typeset -g POWERLEVEL9K_BATTERY_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_BATTERY_FOREGROUND="$crystal_cyan"
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND="$crystal_red"
  typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="$crystal_green"
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=25
  typeset -g POWERLEVEL9K_BATTERY_ICON='󰁹'

  # =====================================================
  # 🕐 TIME - CRYSTAL GLASS ELEGANT
  # =====================================================
  typeset -g POWERLEVEL9K_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_TIME_FOREGROUND="$text_crystal_muted"
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_ICON='󰅐'

  # =====================================================
  # 💾 RAM & LOAD - CRYSTAL SYSTEM INFO
  # =====================================================
  typeset -g POWERLEVEL9K_RAM_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_RAM_FOREGROUND="$crystal_pink"
  typeset -g POWERLEVEL9K_LOAD_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_LOAD_FOREGROUND="$crystal_purple"

  # =====================================================
  # ✔️ STATUS & SYSTEM INFO - CRYSTAL RIGHT PROMPT
  # =====================================================

  # Status with crystal contextual colors (only errors)
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="$crystal_green"
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$crystal_red"
  typeset -g POWERLEVEL9K_STATUS_OK_ICON='✓'
  typeset -g POWERLEVEL9K_STATUS_ERROR_ICON='✗'
  typeset -g POWERLEVEL9K_STATUS_OK=false  # Solo mostrar en errores

  # Background jobs (crystal contextual)
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$crystal_gold"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON='󰏪'

  # Command execution time (>3s only)
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$crystal_purple"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='%d s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_ICON='󰔟'

  # =====================================================
  # ⚡ PERFORMANCE OPTIMIZATIONS CRISTALINAS
  # =====================================================

  # Git optimizations for large repos with crystal performance
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=8192
  typeset -g POWERLEVEL9K_VCS_STAGED_MAX_NUM=15
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM=15

  # Battery optimization (only show when critical)
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=25

  # Disable time realtime updates for crystal performance
  typeset -g POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME=false

  # RPROMPT optimizations with crystal smoothness
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT_AFTER_COMMAND=true

  # Additional crystal performance settings
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_VCS_HYPERLINK=false

}

# Restore previous options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
