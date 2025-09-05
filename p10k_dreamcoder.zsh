# =====================================================
# 🎨 POWERLEVEL10K DREAMCODER PREMIUM - LUXURY BACKGROUNDS
# =====================================================
# Diseño premium con backgrounds sofisticados y username elegante
# Estilo luxury con gradientes sutiles y separadores perfectos
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
  # 🎯 PREMIUM PROMPT ELEMENTS - LUXURY DESIGN
  # =====================================================
  
  # Left prompt - premium segments with beautiful backgrounds
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    user                    # Username with luxury styling
    dir                     # Directory with gradient background
    vcs                     # Git with premium contrast
  )

  # Right prompt - clean luxury
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

  # =====================================================
  # 🎨 LUXURY BACKGROUND SYSTEM - PREMIUM DESIGN
  # =====================================================

  # Perfect typography setup
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate

  # Elegant spacing with luxury feel
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
  
  # Premium prefix - sophisticated diamond
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{#7aa2f7}◆%f '    
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%F{#7aa2f7}◆%f '
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{#7aa2f7}◆%f '

# =====================================================
# 👤 USERNAME - PREMIUM LUXURY STYLING (Optimized)
# =====================================================

# --- 🎨 Background Styling ---
# Fondo con sensación elegante y moderna.
# Uso de colores inspirados en Catppuccin Mocha, con gradientes suaves.
typeset -g POWERLEVEL9K_USER_DEFAULT_BACKGROUND='#1e1e2e'   # Base oscura lujosa
typeset -g POWERLEVEL9K_USER_ROOT_BACKGROUND='#f38ba8'      # Rojo premium para root (alerta visual)

# --- ✨ Foreground Styling ---
# Colores del texto para contrastar perfectamente con los fondos.
typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND='#cdd6f4'   # Texto elegante en tonos claros
typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND='#1e1e2e'      # Texto oscuro sobre fondo rojo

# --- 🌐 Icon & Template ---
# Ícono distintivo + nombre, con espaciado elegante.
typeset -g POWERLEVEL9K_USER_ICON='󰀉 '                      # Ícono de usuario (Nerd Font)
typeset -g POWERLEVEL9K_USER_TEMPLATE='%B%n%b'               # Nombre en negrita para elegancia

# --- ⚙️ Behavior ---
# Mostrar siempre el usuario, incluso si es el actual.
typeset -g POWERLEVEL9K_ALWAYS_SHOW_USER=true

# --- 🧪 Extra Polish: Dynamic Gradient Effect ---
# Simula un degradado para el background usando diferentes colores
# cuando el prompt está en root vs usuario normal.
typeset -g POWERLEVEL9K_USER_BACKGROUND_COLOR=232            # Color base oscuro
typeset -g POWERLEVEL9K_USER_BACKGROUND_GRADIENT=true


  # =====================================================
  # 🏠 DIRECTORY - LUXURY GRADIENT BACKGROUND
  # =====================================================
  
  # Premium directory backgrounds - sophisticated gradients
  typeset -g POWERLEVEL9K_DIR_HOME_BACKGROUND='#181825'             # Deep charcoal - luxury
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='#181825'   # Consistent luxury
  typeset -g POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='#181825'          # Unified premium
  typeset -g POWERLEVEL9K_DIR_SHORTENED_BACKGROUND='#181825'        # Elegant consistency
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND='#181825'           # Premium dark
  
  # Your perfect colors maintained - maximum contrast on luxury background
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND='#7aa2f7'             # Vibrant blue - perfect contrast
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='#89b4fa'   # Lighter blue - hierarchy
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='#74c7ec'          # Cyan - beautiful
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#a6adc8'        # Light gray - subtle
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#b4befe'           # Purple accent - luxury
  
  # Special states with premium backgrounds
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_BACKGROUND='#181825'
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND='#f38ba8'     # Warning red
  typeset -g POWERLEVEL9K_DIR_WRITABLE_BACKGROUND='#181825'
  typeset -g POWERLEVEL9K_DIR_WRITABLE_FOREGROUND='#7aa2f7'         # Primary blue

  # Perfect truncation maintained
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_folder_marker
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|.svn|.hg|node_modules|.venv|venv)'
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=50
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'

  # Clean directory icons - typography luxury
  typeset -g POWERLEVEL9K_HOME_ICON=''                             
  typeset -g POWERLEVEL9K_HOME_SUB_ICON=''                         
  typeset -g POWERLEVEL9K_FOLDER_ICON=''                           
  typeset -g POWERLEVEL9K_ETC_ICON=''                              

  # =====================================================
  # 🌿 GIT - PREMIUM CONTRAST BACKGROUND
  # =====================================================
  
  # Git with premium darker background for perfect separation
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#0d1117'           # GitHub dark - premium
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#0d1117'        # Consistent premium
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#0d1117'       # Dark elegance
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND='#0d1117'      # Unified luxury
  
  # Your beautiful git colors - perfect on dark premium background
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#a6e3a1'          # Fresh green - premium contrast
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#f9e2af'       # Warm amber - luxury
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#fab387'      # Orange - attention
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND='#f38ba8'     # Soft red - elegant warning
  
  # Premium git styling
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''                          # Clean - no noise
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''                  # Minimal luxury
  typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''                  # Pure elegance
  
  # Beautiful branch styling maintained
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='󰘬 '                   # Subtle branch - premium
  typeset -g POWERLEVEL9K_VCS_TAG_ICON='󰓹 '                      # Elegant tag
  
  # Clean counters - luxury simplicity
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM=3
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM=3
  
  # Premium status indicators - perfect typography
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='●'                      # Solid dot - premium
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='○'                    # Hollow dot - contrast
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='◌'                   # Minimal circle - elegant
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='◆'                  # Diamond - luxury attention
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='⚹'                       # Elegant stash - premium
  
  # Beautiful prefix - luxury integration
  typeset -g POWERLEVEL9K_VCS_PREFIX='%F{#6c7086}on%f '           # Muted "on" - sophisticated

  # Ahead/behind with premium backgrounds
  typeset -g POWERLEVEL9K_VCS_COMMITS_AHEAD_FOREGROUND='#89b4fa'   # Blue - ahead
  typeset -g POWERLEVEL9K_VCS_COMMITS_BEHIND_FOREGROUND='#cba6f7'  # Purple - behind

  # =====================================================
  # 🎨 LUXURY SEPARATORS - PREMIUM POWERLINE
  # =====================================================
  
  # Premium powerline separators - luxury connections
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''               # Perfect powerline arrow
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''              # Elegant right arrow
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='│'           # Vertical line - premium
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='│'

  # Premium separator colors - beautiful luxury transitions
  # User to Directory transition
  typeset -g POWERLEVEL9K_USER_DEFAULT_SEGMENT_SEPARATOR_FOREGROUND='#181825'  # Dir bg color
  typeset -g POWERLEVEL9K_USER_ROOT_SEGMENT_SEPARATOR_FOREGROUND='#181825'
  
  # Directory to Git transition  
  typeset -g POWERLEVEL9K_DIR_HOME_SEGMENT_SEPARATOR_FOREGROUND='#0d1117'      # Git bg color
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_SEGMENT_SEPARATOR_FOREGROUND='#0d1117'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_SEGMENT_SEPARATOR_FOREGROUND='#0d1117'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_SEGMENT_SEPARATOR_FOREGROUND='#0d1117'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_SEGMENT_SEPARATOR_FOREGROUND='#0d1117'

  # Perfect spacing - luxury breathing room
  typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=''      # Separators handle spacing
  typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=''

  # =====================================================
  # ⚡ PREMIUM PERFORMANCE
  # =====================================================
  
  # Optimized for luxury smoothness
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096
  typeset -g POWERLEVEL9K_VCS_STAGED_MAX_NUM=3              
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM=3
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM=3
  
  # Premium performance
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=true              

  # =====================================================
  # ✨ LUXURY POLISH - PREMIUM ENDINGS  
  # =====================================================
  
  # Premium prompt ending - luxury finish
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=''
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=''
  
  # Luxury endings - perfect finish
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''
  
  # Premium prompt character (invisible for clean luxury)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='transparent'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='transparent'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR,VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION=''

}

# Restore previous options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'