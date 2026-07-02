#!/bin/zsh
# =====================================================
# 💎 DREAMCODER MINIMALIST v1.0 - POWERLEVEL10K
# =====================================================
# Configuración minimalista DreamCoder con paleta específica
# Elementos esenciales: os_icon, custom_dreamcoder, user, dir, vcs (izq)
# status, command_execution_time, background_jobs, time (der)
# Iconos Nerd Font + Badge DreamCoder personalizado
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
  # 💎 PALETA DREAMCODER MINIMALIST - COLORES ESPECÍFICOS
  # =====================================================
  # Paleta DreamCoder: fondo oscuro, acentos épicos, legibilidad máxima

  # Colores principales DreamCoder
  local dream_bg='#0b0f14'          # Fondo base terminal
  local dream_primary='#00e5ff'     # Primario / acento épico
  local dream_gold='#ffd166'        # Dorado / highlight
  local dream_pink='#ff6b9f'        # Rosa / detalle
  local dream_gray='#cfd8dc'        # Gris claro (texto)
  local crystal_silver='#c0c0c0'    # Plata cristalina brillante

  # Fondos transparentes para diseño minimalista
  local transparent=none

  # =====================================================
  # ⚡ INSTANT PROMPT & PERFORMANCE MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=false
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # =====================================================
  # 🎯 PROMPT STRUCTURE - DREAMCODER MINIMALIST
  # =====================================================
  # Elementos esenciales en izquierda y derecha
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
  # 🏗️ PROMPT FLOW & TYPOGRAPHY MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

  # Minimalist prompt prefix
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$dream_primary}❯%f "

  # =====================================================
  # 🔹 SEPARATORS - MINIMALIST POWERLINE
  # =====================================================
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='│'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='│'

  # =====================================================
  # 💻 OS ICON - DREAMCODER MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="$dream_primary"
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='󰣇'

  # =====================================================
  # 🏷️ CUSTOM DREAMCODER BADGE - MINIMALIST INTEGRATION
  # =====================================================
  POWERLEVEL9K_CUSTOM_DREAMCODER='echo "⬢ dreamcoder08"'
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_CUSTOM_DREAMCODER_VISUAL_IDENTIFIER_EXPANSION=''

  # =====================================================
  # 👤 USER - DREAMCODER MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_USER_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_USER_ROOT_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND="$dream_pink"
  typeset -g POWERLEVEL9K_USER_SUDO_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_USER_SUDO_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_USER=true
  typeset -g POWERLEVEL9K_USER_TEMPLATE='%n'

  # =====================================================
  # 📁 DIRECTORY - DREAMCODER MINIMALIST & LEGIBLE
  # =====================================================
  typeset -g POWERLEVEL9K_DIR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$dream_gray"
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND="#FAFAFF"
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$dream_gray"
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND="$dream_pink"

  # Smart truncation strategy with DreamCoder clarity
  typeset -g POWERLEVEL9K_DIR_SHORTEN_STRATEGY="truncate_to_unique"
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_FROM="left"

  # Context-aware minimalist icons
  typeset -g POWERLEVEL9K_DIR_ETC_ICON='󰉋'
  typeset -g POWERLEVEL9K_DIR_HOME_ICON='󰋜'
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON='󰉖'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ICON='󰉋'
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_ICON='󰀪'

  # =====================================================
  # 🌿 VCS - DREAMCODER MINIMALIST CON CONTEXTUAL COLORS
  # =====================================================
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$dream_primary"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$dream_gray"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND="$dream_pink"
  typeset -g POWERLEVEL9K_VCS_STAGED_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_STAGED_FOREGROUND="$dream_primary"
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND="$dream_gray"

  # Professional DreamCoder Git icons
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='󰘬 '
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='●'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='●'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='󰏗'
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_ICON='↑'
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_ICON='↓'

  # Enable ahead/behind information
  typeset -g POWERLEVEL9K_VCS_SHOW_AHEAD_BEHIND=true
  typeset -g POWERLEVEL9K_VCS_SHOW_CHANGED_STATES=true
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_AGE=1800

  # =====================================================
  # ✔️ STATUS - DREAMCODER RIGHT PROMPT MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="$dream_primary"
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$dream_pink"
  typeset -g POWERLEVEL9K_STATUS_OK_ICON='✓'
  typeset -g POWERLEVEL9K_STATUS_ERROR_ICON='✗'
  typeset -g POWERLEVEL9K_STATUS_OK=false

  # =====================================================
  # ⏱️ COMMAND EXECUTION TIME - DREAMCODER MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='⏱ %d s'

  # =====================================================
  # 🔄 BACKGROUND JOBS - DREAMCODER MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$dream_gold"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON='󰏪'

  # =====================================================
  # 🕐 TIME - DREAMCODER MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_TIME_BACKGROUND="$transparent"
  typeset -g POWERLEVEL9K_TIME_FOREGROUND="$dream_gray"
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
  typeset -g POWERLEVEL9K_TIME_ICON='󰅐'

  # =====================================================
  # ⚡ PERFORMANCE OPTIMIZATIONS MINIMALIST
  # =====================================================
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=8192
  typeset -g POWERLEVEL9K_VCS_STAGED_MAX_NUM=15
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM=15
  typeset -g POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME=false
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT_AFTER_COMMAND=true
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_VCS_HYPERLINK=false

}

# Restore previous options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
