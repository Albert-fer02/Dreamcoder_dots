#!/bin/zsh
# =====================================================
# 💎 DREAMCODER GENTLEMAN v7.0 - POWERLEVEL10K
# =====================================================
# Configuración premium inspirada en Gentleman.Dots
# Paleta de alto contraste + Estética minimalista
# Optimizado para máxima legibilidad y elegancia
# =====================================================

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # =====================================================
  # 🎨 PALETA GENTLEMAN MINIMALIST - INSPIRACIÓN PROMPT.JPG
  # =====================================================
  local gentleman_blue='#00BFFF'      # Azul Arch
  local gentleman_gold='#F0C674'      # Dorado Arena (User)
  local gentleman_green='#98C379'     # Verde Matcha (Git)
  local gentleman_white='#E6E6E6'     # Blanco Hueso (Path)
  local gentleman_gray='#444444'      # Gris Separadores
  local gentleman_red='#ff5f87'       # Rojo Alerta
  local gentleman_purple='#d197ff'    # Púrpura

  local transparent=none

  # =====================================================
  # ⚡ INSTANT PROMPT & PERFORMANCE
  # =====================================================
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=false
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # =====================================================
  # 🎯 PROMPT STRUCTURE
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
  # 🏗️ PROMPT FLOW & TYPOGRAPHY
  # =====================================================
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

  # Cursor line
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$gentleman_blue}>%f "

  # =====================================================
  # 🔹 SEPARATORS - GENTLEMAN STYLE
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$gentleman_gray} │ %f"
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$gentleman_gray} │ %f"

  # =====================================================
  # 💻 OS ICON - GENTLEMAN BLUE
  # =====================================================
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="$gentleman_blue"
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='󰣇'

  # =====================================================
  # 🏷️ CUSTOM DREAMCODER BADGE - HEXAGON & GOLD
  # =====================================================
  POWERLEVEL9K_CUSTOM_DREAMCODER='echo "⬢ dreamcoder08"'
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_FOREGROUND="$gentleman_gold"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_VISUAL_IDENTIFIER_EXPANSION=''

  # =====================================================
  # 📁 DIRECTORY - GENTLEMAN WHITE
  # =====================================================
  typeset -g POWERLEVEL9K_DIR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$gentleman_white"
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND="$gentleman_white"
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$gentleman_white"
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND="$gentleman_red"

  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'

  typeset -g POWERLEVEL9K_DIR_ETC_ICON='󰉋'
  typeset -g POWERLEVEL9K_DIR_HOME_ICON='󰋜'
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON='󰉖'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ICON='󰉋'

  # =====================================================
  # 🌿 GIT - GENTLEMAN MATCHA
  # =====================================================
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$gentleman_green"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$gentleman_gold"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$gentleman_blue"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND="$gentleman_red"
  typeset -g POWERLEVEL9K_VCS_STAGED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_STAGED_FOREGROUND="$gentleman_blue"

  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='󰊤 '
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='~'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_ICON='↑'
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON='↓'

  # =====================================================
  # ✔️ STATUS & SYSTEM INFO
  # =====================================================
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$gentleman_red"
  typeset -g POWERLEVEL9K_STATUS_ERROR_ICON='✗'

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$gentleman_purple"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$gentleman_gold"

  # Performance
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'