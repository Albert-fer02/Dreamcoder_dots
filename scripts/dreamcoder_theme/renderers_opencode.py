"""Focused CLI/editor theme renderers."""

from __future__ import annotations

import json

from .palette import guard, mix
from .settings import PI_THEME_SCHEMA


def opencode_tokens(c: dict[str, str]) -> dict[str, str]:
    mode_name = "dark" if c["details"] == "darker" else "light"
    # Use lower contrast minimum for syntax colors so they stay vibrant.
    # 4.5 is for body text; syntax highlighting is decorative/auxiliary.
    syntax_min = 3.0
    keyword = guard(mix(c["accent"], c["warning"], 0.22), c["bg"], mode_name, minimum=syntax_min)
    function = guard(c["diagnostic"], c["bg"], mode_name, minimum=syntax_min)
    type_color = guard(c["lavender"], c["bg"], mode_name, minimum=syntax_min)
    constant = guard(mix(c["accent_2"], c["mauve"], 0.24), c["bg"], mode_name, minimum=syntax_min)
    # Selection: inverted accent block for high visibility in all modes.
    # surface2 blends into the warm palette — use accent for visible contrast.
    sel_bg = c["accent"]
    sel_fg = c["bg"]
    return {
        "keyword": keyword,
        "function": function,
        "method": guard(mix(function, c["lavender"], 0.16), c["bg"], mode_name, minimum=syntax_min),
        # Variables must be distinguishable from normal text — use muted tone
        "variable": c["muted"],
        "parameter": guard(mix(c["accent_2"], c["text"], 0.06), c["bg"], mode_name, minimum=syntax_min),
        "property": guard(mix(c["diagnostic"], c["text"], 0.04), c["bg"], mode_name, minimum=syntax_min),
        "field": guard(mix(c["sage"], c["text"], 0.05), c["bg"], mode_name, minimum=syntax_min),
        "string": guard(c["sage"], c["bg"], mode_name, minimum=syntax_min),
        "number": guard(c["accent_2"], c["bg"], mode_name, minimum=syntax_min),
        "constant": constant,
        "type": type_color,
        "constructor": guard(mix(type_color, c["accent"], 0.18), c["bg"], mode_name, minimum=syntax_min),
        "enum": guard(mix(type_color, c["sage"], 0.18), c["bg"], mode_name, minimum=syntax_min),
        "operator": guard(c["mauve"], c["bg"], mode_name, minimum=syntax_min),
        "punctuation": guard(c["muted"], c["bg"], mode_name, minimum=syntax_min),
        "comment": guard(c["comment"], c["bg"], mode_name, minimum=syntax_min),
        "todo": guard(mix(c["warning"], c["text"], 0.12), c["bg"], mode_name, minimum=syntax_min),
        "deprecated": guard(mix(c["error"], c["muted"], 0.28), c["bg"], mode_name, minimum=syntax_min),
        "code_bg": mix(c["border_ui"], c["bg"], 0.15),
        "selection": sel_bg,
        "selection_fg": sel_fg,  # text color on selection
        "search": mix(c["warning"], c["bg"], 0.42),
    }


def opencode_content(c: dict[str, str], transparent_background: bool = False) -> str:
    t = opencode_tokens(c)
    mode_name = "dark" if c["details"] == "darker" else "light"

    # Mode-aware surface formulas
    if mode_name == "dark":
        element_bg = mix(c["border_ui"], c["bg"], 0.20)
        hover_bg = mix(c["border_ui"], c["bg"], 0.12)
        line_bg = mix(c["border_ui"], c["bg"], 0.12)
        code_bg = mix(c["border_ui"], c["bg"], 0.18)
        assistant_bg = mix(c["diagnostic"], c["bg"], 0.18)
        user_bg = mix(c["accent"], c["bg"], 0.18)
        tool_bg = mix(c["lavender"], c["bg"], 0.18)
        accent_muted = mix(c["accent"], c["bg"], 0.25)
        inline_code_bg = mix(c["sage"], c["border_ui"], 0.45)
        mix_base = c["border_ui"]
    else:
        element_bg = mix(c["bg_soft"], c["surface1"], 0.4)
        hover_bg = c["surface2"]
        line_bg = c["bg_soft"]
        code_bg = mix(c["surface1"], c["border_ui"], 0.12)
        assistant_bg = mix(c["diagnostic"], c["bg"], 0.12)
        user_bg = mix(c["accent"], c["bg"], 0.15)
        tool_bg = mix(c["lavender"], c["bg"], 0.12)
        accent_muted = mix(c["accent"], c["bg"], 0.4)
        inline_code_bg = mix(c["sage"], c["bg"], 0.18)
        mix_base = c["bg"]

    added_bg = mix(c["sage"], mix_base, 0.35)
    removed_bg = mix(c["error"], mix_base, 0.35)
    hunk_bg = mix(c["lavender"], mix_base, 0.45)
    assistant = guard(mix(c["diagnostic"], c["text"], 0.18), c["bg"], mode_name)
    user = guard(mix(c["accent"], c["text"], 0.15), c["bg"], mode_name)
    background = "none" if transparent_background else c["bg"]
    return f'''{{
  "$schema": "https://opencode.ai/theme.json",
  "defs": {{
    "dreamBackground": "{c["bg"]}",
    "dreamPanel": "{c["surface0"]}",
    "dreamElement": "{c["bg_soft"]}",
    "dreamText": "{c["text"]}",
    "dreamMuted": "{c["muted"]}",
    "dreamCocoa": "{c["accent_2"]}",
    "dreamLucuma": "{c["accent"]}",
    "dreamDiagnostic": "{c["diagnostic"]}",
    "dreamSage": "{c["sage"]}",
    "dreamViolet": "{c["lavender"]}",
    "dreamMauve": "{c["mauve"]}",
    "dreamCoral": "{c["error"]}",
    "dreamWarning": "{c["warning"]}"
  }},
  "theme": {{
    "background": "{background}",
    "backgroundPanel": "{c["surface0"]}",
    "backgroundElement": "{element_bg}",
    "backgroundHover": "{hover_bg}",
    "backgroundSelected": "{t["selection"]}",
    "textSelected": "{t["selection_fg"]}",
    "backgroundCode": "{code_bg}",
    "backgroundSearch": "{t["search"]}",
    "backgroundLine": "{line_bg}",
    "backgroundAssistant": "{assistant_bg}",
    "backgroundUser": "{user_bg}",
    "backgroundTool": "{tool_bg}",
    "text": "{c["text"]}",
    "textMuted": "{c["muted"]}",
    "textSubtle": "{guard(c["subtle"], c["bg"], mode_name, minimum=5.5)}",
    "textPlaceholder": "{c["comment"]}",
    "textAssistant": "{assistant}",
    "textUser": "{user}",
    "textTool": "{t["type"]}",
    "primary": "{c["accent"]}",
    "secondary": "{c["accent_2"]}",
    "accent": "{c["accent"]}",
    "accentMuted": "{accent_muted}",
    "error": "{c["error"]}",
    "warning": "{c["warning"]}",
    "success": "{c["sage"]}",
    "info": "{c["diagnostic"]}",
    "border": "{c["border_ui"]}",
    "borderActive": "{c["accent"]}",
    "borderSubtle": "{c["border"]}",
    "borderFocus": "{c["diagnostic"]}",
    "shadow": "{mix(c["bg"], "#000000", 0.25)}",
    "diffAdded": "{c["sage"]}",
    "diffRemoved": "{c["error"]}",
    "diffContext": "{c["muted"]}",
    "diffHunkHeader": "{c["lavender"]}",
    "diffHighlightAdded": "{c["sage"]}",
    "diffHighlightRemoved": "{c["error"]}",
    "diffAddedBg": "{added_bg}",
    "diffRemovedBg": "{removed_bg}",
    "diffContextBg": "{background}",
    "diffLineNumber": "{c["subtle"]}",
    "diffAddedLineNumberBg": "{added_bg}",
    "diffRemovedLineNumberBg": "{removed_bg}",
    "diffHunkHeaderBg": "{hunk_bg}",
    "diffFold": "{c["comment"]}",
    "diffFoldBg": "{line_bg}",
    "markdownText": "{c["text"]}",
    "markdownHeading": "{c["accent"]}",
    "markdownLink": "{c["diagnostic"]}",
    "markdownLinkText": "{c["accent"]}",
    "markdownCode": "{c["sage"]}",
    "markdownBlockQuote": "{c["accent_2"]}",
    "markdownEmph": "{c["diagnostic"]}",
    "markdownStrong": "{c["accent"]}",
    "markdownHorizontalRule": "{c["border_ui"]}",
    "markdownListItem": "{c["accent"]}",
    "markdownListEnumeration": "{c["lavender"]}",
    "markdownTableBorder": "{c["border_ui"]}",
    "markdownTableHeader": "{c["accent_2"]}",
    "markdownImage": "{c["mauve"]}",
    "markdownImageText": "{c["text"]}",
    "markdownCodeBlock": "{c["text"]}",
    "markdownCodeBlockBg": "{code_bg}",
    "markdownInlineCodeBg": "{inline_code_bg}",
    "syntaxComment": "{t["comment"]}",
    "syntaxKeyword": "{t["keyword"]}",
    "syntaxFunction": "{t["function"]}",
    "syntaxMethod": "{t["method"]}",
    "syntaxVariable": "{t["variable"]}",
    "syntaxParameter": "{t["parameter"]}",
    "syntaxProperty": "{t["property"]}",
    "syntaxField": "{t["field"]}",
    "syntaxString": "{t["string"]}",
    "syntaxNumber": "{t["number"]}",
    "syntaxBoolean": "{t["constant"]}",
    "syntaxConstant": "{t["constant"]}",
    "syntaxType": "{t["type"]}",
    "syntaxClass": "{t["constructor"]}",
    "syntaxInterface": "{mix(t["type"], c["diagnostic"], 0.22)}",
    "syntaxEnum": "{t["enum"]}",
    "syntaxOperator": "{t["operator"]}",
    "syntaxPunctuation": "{t["punctuation"]}",
    "syntaxTag": "{t["keyword"]}",
    "syntaxAttribute": "{t["property"]}",
    "syntaxRegexp": "{mix(c["mauve"], c["error"], 0.28)}",
    "syntaxEscape": "{c["warning"]}",
    "syntaxNamespace": "{t["type"]}",
    "syntaxModule": "{t["type"]}",
    "syntaxDecorator": "{t["operator"]}",
    "syntaxBuiltin": "{t["constant"]}",
    "syntaxSpecial": "{c["warning"]}",
    "syntaxTodo": "{t["todo"]}",
    "syntaxDeprecated": "{t["deprecated"]}",
    "terminalBlack": "{guard(c["surface0"], c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalRed": "{c["error"]}",
    "terminalGreen": "{c["sage"]}",
    "terminalYellow": "{c["warning"]}",
    "terminalBlue": "{c["diagnostic"]}",
    "terminalMagenta": "{c["mauve"]}",
    "terminalCyan": "{guard(mix(c["diagnostic"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalWhite": "{c["text"]}",
    "terminalBrightBlack": "{c["subtle"]}",
    "terminalBrightRed": "{guard(mix(c["error"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightGreen": "{guard(mix(c["sage"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightYellow": "{guard(mix(c["warning"], c["text"], 0.16), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightBlue": "{guard(mix(c["diagnostic"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightMagenta": "{guard(mix(c["mauve"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightCyan": "{guard(mix(c["lavender"], c["text"], 0.18), c["bg"], "dark" if c["details"] == "darker" else "light")}",
    "terminalBrightWhite": "{c["text"]}"
  }}
}}
'''
