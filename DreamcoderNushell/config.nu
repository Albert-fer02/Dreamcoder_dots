# Nushell Config File — Dreamcoder Dots
#
# version = "0.99.1"
#
# Dreamcoder Ember Noir OLED theme
# BG: #100f0d   Accent: #d99555   Text: #e8dfd0

$env.LS_COLORS = (
    # --- Directories and file types ---
    "di=38;2;217;149;85:" +         # Directories: accent (#d99555)
    "fi=38;2;232;223;208:" +        # Regular files: text (#e8dfd0)
    "ln=38;2;212;180;230:" +        # Symbolic links: lavender (#d4b4e6)
    "ex=38;2;77;179;95:" +          # Executable files: success (#4db35f)
    "or=38;2;237;138;122:" +        # Broken links: error (#ed8a7a)

    # --- Specific extensions ---
    "*.txt=38;2;199;185;170:" +     # .txt: muted (#c7b9aa)
    "*.md=38;2;199;185;170:" +      # .md: muted (#c7b9aa)
    "*.json=38;2;95;149;202:" +     # .json: info (#5f95ca)
    "*.yaml=38;2;95;149;202:" +     # .yaml: info (#5f95ca)
    "*.toml=38;2;95;149;202:" +     # .toml: info (#5f95ca)
    "*.js=38;2;232;184;102:" +      # .js: warning (#e8b866)
    "*.ts=38;2;232;184;102:" +      # .ts: warning (#e8b866)
    "*.tsx=38;2;232;184;102:" +     # .tsx: warning (#e8b866)
    "*.rs=38;2;201;106;69:" +       # .rs: accent_2 (#c96a45)
    "*.py=38;2;77;179;95:" +        # .py: success (#4db35f)
    "*.sh=38;2;77;179;95:" +        # .sh: success (#4db35f)
    "*.nu=38;2;217;149;85:" +       # .nu: accent (#d99555)
    "*.css=38;2;226;156;178:" +     # .css: mauve (#e29cb4)
    "*.html=38;2;226;156;178:" +    # .html: mauve (#e29cb4)
    "*.jpg=38;2;212;180;230:" +     # .jpg: lavender (#d4b4e6)
    "*.png=38;2;212;180;230:" +     # .png: lavender (#d4b4e6)
    "*.svg=38;2;212;180;230:" +     # .svg: lavender (#d4b4e6)
    "*.zip=38;2;147;130;116:" +     # .zip: subtle (#938274)
    "*.gz=38;2;147;130;116:" +      # .gz: subtle (#938274)

    # --- Default ---
    "*=38;2;232;223;208"            # text (#e8dfd0)
)

# Dreamcoder Ember Noir OLED theme for Nushell
let dreamcoder_dark = {
    separator: "#756052"                     # border
    leading_trailing_space_bg: { attr: "n" }
    header: "#d99555_bold"                   # accent + bold
    empty: "#d4b4e6"                         # lavender
    bool: "#5f8f8f"                          # focus
    int: "#c7b9aa"                           # muted
    filesize: "#4db35f"                      # success
    duration: "#e8b866"                      # warning
    date: "#e8dfd0"                          # text
    range: "#938274"                         # subtle
    float: "#c96a45"                         # accent_2
    string: "#c7b9aa"                        # muted
    nothing: "#5f95ca"                       # info
    binary: "#4db35f"                        # success
    cellpath: "#5f95ca"                      # info
    row_index: "#d99555_bold"                # accent + bold
    record: "#d4b4e6"                        # lavender
    list: "#c7b9aa"                          # muted
    block: "#d4b4e6_bold"                    # lavender + bold
    hints: "#4db35f"                         # success
    search_result: { fg: "#100f0d", bg: "#d99555" }

    shape_and: "#d4b4e6_bold"                # lavender + bold
    shape_binary: "#4db35f_bold"
    shape_block: "#d99555"
    shape_bool: "#5f8f8f"
    shape_closure: "#c96a45"
    shape_custom: "#4db35f"
    shape_datetime: "#e8dfd0_bold"
    shape_directory: "#d99555"
    shape_external: "#4db35f"
    shape_externalarg: "#d4b4e6_bold"
    shape_filepath: "#5f95ca"
    shape_flag: "#d99555_bold"
    shape_float: "#c96a45"
    shape_garbage: { fg: "#100f0d", bg: "#ed8a7a", attr: "b" }
    shape_globpattern: "#4db35f_bold"
    shape_int: "#d4b4e6"
    shape_internalcall: "#4db35f_bold"
    shape_keyword: "#d99555"
    shape_literal: "#e8dfd0"
    shape_operator: "#ed8a7a"
    shape_or: "#5f8f8f_bold"
    shape_pipe: "#4db35f"
    shape_string: "#4db35f"
    shape_variable: "#c96a45"
}

$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: false
    }

    table: {
        mode: rounded
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }

    error_style: "fancy"
    datetime_format: {}

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        sort: "smart"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
        use_ls_colors: true
    }

    filesize: {
        unit: "MB"
    }

    cursor_shape: {
        emacs: line
        vi_insert: block
        vi_normal: underscore
    }

    color_config: $dreamcoder_dark
    footer_mode: 25
    float_precision: 2
    buffer_editor: null
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: false
        osc633: true
        reset_application_mode: true
    }
    render_right_prompt_on_last_line: false
    use_kitty_protocol: false
    highlight_resolved_externals: false
    recursion_limit: 50
    plugins: {}

    plugin_gc: {
        default: {
            enabled: true
            stop_after: 10sec
        }
        plugins: {}
    }

    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
        env_change: {
            PWD: [{|before, after| null }]
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }"
        command_not_found: { null }
    }

    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: "#4db35f"
                selected_text: { attr: r }
                description_text: "#e8b866"
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: ide_completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: ide
                min_completion_width: 0
                max_completion_width: 50
                max_completion_height: 10
                padding: 0
                border: true
                cursor_offset: 0
                description_mode: "prefer_right"
                min_description_width: 0
                max_description_width: 50
                max_description_height: 10
                description_offset: 1
                correct_cursor_pos: false
            }
            style: {
                text: "#4db35f"
                selected_text: { attr: r }
                description_text: "#e8b866"
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: "#4db35f"
                selected_text: { fg: "#100f0d", bg: "#4db35f" }
                description_text: "#e8b866"
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: "#4db35f"
                selected_text: { fg: "#100f0d", bg: "#4db35f" }
                description_text: "#e8b866"
            }
        }
    ]

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: completion_previous_menu
            modifier: shift
            keycode: backtab
            mode: [emacs vi_normal vi_insert]
            event: { send: menuprevious }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs vi_insert vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: help_menu
            modifier: none
            keycode: f1
            mode: [emacs vi_insert vi_normal]
            event: { send: menu name: help_menu }
        }
        {
            name: escape
            modifier: none
            keycode: escape
            mode: [emacs vi_normal vi_insert]
            event: { send: esc }
        }
        {
            name: cancel_command
            modifier: control
            keycode: char_c
            mode: [emacs vi_normal vi_insert]
            event: { send: ctrlc }
        }
        {
            name: clear_screen
            modifier: control
            keycode: char_l
            mode: [emacs vi_normal vi_insert]
            event: { send: clearscreen }
        }
        {
            name: search_history
            modifier: control
            keycode: char_q
            mode: [emacs vi_normal vi_insert]
            event: { send: searchhistory }
        }
        {
            name: move_up
            modifier: none
            keycode: up
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menuup }
                    { send: up }
                ]
            }
        }
        {
            name: move_down
            modifier: none
            keycode: down
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menudown }
                    { send: down }
                ]
            }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menuleft }
                    { send: left }
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: none
            keycode: right
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: historyhintcomplete }
                    { send: menuright }
                    { send: right }
                ]
            }
        }
        {
            name: delete_one_character_backward
            modifier: none
            keycode: backspace
            mode: [emacs vi_insert]
            event: { edit: backspace }
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: backspace
            mode: [emacs vi_insert]
            event: { edit: backspaceword }
        }
        {
            name: delete_one_character_forward
            modifier: none
            keycode: delete
            mode: [emacs vi_insert]
            event: { edit: delete }
        }
        {
            name: move_to_line_start
            modifier: none
            keycode: home
            mode: [emacs vi_normal vi_insert]
            event: { edit: movetolinestart }
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: none
            keycode: end
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: historyhintcomplete }
                    { edit: movetolineend }
                ]
            }
        }
        {
            name: newline_or_run_command
            modifier: none
            keycode: enter
            mode: emacs
            event: { send: enter }
        }
        {
            name: copy_selection
            modifier: control_shift
            keycode: char_c
            mode: emacs
            event: { edit: copyselection }
        }
        {
            name: cut_selection
            modifier: control_shift
            keycode: char_x
            mode: emacs
            event: { edit: cutselection }
        }
        {
            name: select_all
            modifier: control_shift
            keycode: char_a
            mode: emacs
            event: { edit: selectall }
        }
    ]
}

# Useful aliases
alias ll = ls -la
alias la = ls -a
alias lt = ls -t
alias grep = rg
alias find = fd

# Source integrations
source ~/.zoxide.nu
source ~/.cache/carapace/init.nu
source ~/.local/share/atuin/init.nu
use ~/.cache/starship/init.nu
