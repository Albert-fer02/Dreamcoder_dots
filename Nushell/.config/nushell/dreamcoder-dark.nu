# Dreamcoder Dark Theme for Nushell
# Auto-generated from tokens.json — do not edit manually

$env.config = {
    color_config: {
        separator: "#6b5f52"
        leading_trailing_space_bg: "#1a1714"
        header: "#d99555"
        date: "#e8dfd0"
        filesize: "#5f95ca"
        row_index: "#6b5f52"
        bool: "#d99555"
        nothing: "#6b5f52"
        binary: "#e8dfd0"
        cellpath: "#e8dfd0"
        int: "#e8dfd0"
        duration: "#e8dfd0"
        range: "#e8dfd0"
        float: "#e8dfd0"
        string: "#e8dfd0"
        record: "#e8dfd0"
        list: "#e8dfd0"
        closure: "#e8dfd0"
        custom: "#e8dfd0"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    history: {
        max_size: 50000
        sync_on_enter: true
    }
   .rm: { always_interactive: true }
   .cd: { with_ls: true }
   .ls: { use_ls_colors: true }
}
