"""CLI/editor theme renderers."""

from __future__ import annotations

import json

from .palette import guard, mix
from .settings import PI_THEME_SCHEMA

def pi_theme_content(c: dict[str, str]) -> str:
    t = opencode_tokens(c)
    mode_name = "dark" if c["details"] == "darker" else "light"
    user_bg = mix(c["accent"], c["bg"], 0.84)
    pending_bg = mix(c["surface0"], c["bg"], 0.55)
    success_bg = mix(c["sage"], c["bg"], 0.82)
    error_bg = mix(c["error"], c["bg"], 0.84)
    theme = {
        "$schema": PI_THEME_SCHEMA,
        "name": "dreamcoder",
        "vars": {
            "cocoa": c["accent_2"],
            "lucuma": c["accent"],
            "diagnostic": c["diagnostic"],
            "sage": c["sage"],
            "mauve": c["mauve"],
            "coral": c["error"],
            "warning": c["warning"],
            "muted": c["muted"],
            "subtle": c["subtle"],
            "comment": c["comment"],
            "borderUi": c["border_ui"],
            "borderMuted": c["border"],
        },
        "colors": {
            "accent": "lucuma",
            "border": "borderUi",
            "borderAccent": "diagnostic",
            "borderMuted": "borderMuted",
            "success": "sage",
            "error": "coral",
            "warning": "warning",
            "muted": "muted",
            "dim": "subtle",
            "text": "",
            "thinkingText": "muted",
            "selectedBg": c["selection"],
            "userMessageBg": user_bg,
            "userMessageText": "",
            "customMessageBg": c["surface0"],
            "customMessageText": "",
            "customMessageLabel": "lucuma",
            "toolPendingBg": pending_bg,
            "toolSuccessBg": success_bg,
            "toolErrorBg": error_bg,
            "toolTitle": "lucuma",
            "toolOutput": "",
            "mdHeading": "lucuma",
            "mdLink": "diagnostic",
            "mdLinkUrl": "muted",
            "mdCode": "sage",
            "mdCodeBlock": "",
            "mdCodeBlockBorder": "borderMuted",
            "mdQuote": "cocoa",
            "mdQuoteBorder": "borderMuted",
            "mdHr": "borderMuted",
            "mdListBullet": "lucuma",
            "toolDiffAdded": "sage",
            "toolDiffRemoved": "coral",
            "toolDiffContext": "muted",
            "syntaxComment": "comment",
            "syntaxKeyword": t["keyword"],
            "syntaxFunction": t["function"],
            "syntaxVariable": t["variable"],
            "syntaxString": t["string"],
            "syntaxNumber": t["number"],
            "syntaxType": t["type"],
            "syntaxOperator": t["operator"],
            "syntaxPunctuation": t["punctuation"],
            "thinkingOff": "comment",
            "thinkingMinimal": "borderUi",
            "thinkingLow": guard(mix(c["diagnostic"], c["text"], 0.12), c["bg"], mode_name),
            "thinkingMedium": "diagnostic",
            "thinkingHigh": "mauve",
            "thinkingXhigh": "coral",
            "bashMode": "lucuma",
        },
    }
    return json.dumps(theme, indent=2) + "\n"

def opencode_tokens(c: dict[str, str]) -> dict[str, str]:
    mode_name = "dark" if c["details"] == "darker" else "light"
    keyword = guard(mix(c["accent"], c["warning"], 0.22), c["bg"], mode_name)
    function = guard(c["diagnostic"], c["bg"], mode_name)
    type_color = guard(c["lavender"], c["bg"], mode_name)
    constant = guard(mix(c["accent_2"], c["mauve"], 0.24), c["bg"], mode_name)
    return {
        "keyword": keyword,
        "function": function,
        "method": guard(mix(function, c["lavender"], 0.16), c["bg"], mode_name),
        "variable": c["text"],
        "parameter": guard(mix(c["accent_2"], c["text"], 0.06), c["bg"], mode_name),
        "property": guard(mix(c["diagnostic"], c["text"], 0.04), c["bg"], mode_name),
        "field": guard(mix(c["sage"], c["text"], 0.05), c["bg"], mode_name),
        "string": guard(c["sage"], c["bg"], mode_name),
        "number": guard(c["accent_2"], c["bg"], mode_name),
        "constant": constant,
        "type": type_color,
        "constructor": guard(mix(type_color, c["accent"], 0.18), c["bg"], mode_name),
        "enum": guard(mix(type_color, c["sage"], 0.18), c["bg"], mode_name),
        "operator": guard(c["mauve"], c["bg"], mode_name),
        "punctuation": guard(c["muted"], c["bg"], mode_name),
        "comment": guard(c["comment"], c["bg"], mode_name),
        "todo": guard(mix(c["warning"], c["text"], 0.12), c["bg"], mode_name),
        "deprecated": guard(mix(c["error"], c["muted"], 0.28), c["bg"], mode_name),
        "code_bg": c["surface0"],
        "selection": c["selection"],
        "search": mix(c["warning"], c["bg"], 0.72),
    }

def opencode_content(c: dict[str, str], transparent_background: bool = False) -> str:
    t = opencode_tokens(c)
    mode_name = "dark" if c["details"] == "darker" else "light"
    added_bg = mix(c["sage"], c["bg"], 0.82)
    removed_bg = mix(c["error"], c["bg"], 0.84)
    hunk_bg = mix(c["lavender"], c["bg"], 0.84)
    line_bg = c["surface0"]
    assistant = guard(mix(c["diagnostic"], c["text"], 0.18), c["bg"], mode_name)
    user = guard(mix(c["accent"], c["text"], 0.15), c["bg"], mode_name)
    background = "none" if transparent_background else c["bg"]
    return f'''{{
  "$schema": "https://opencode.ai/theme.json",
  "defs": {{
    "dreamBackground": "{c['bg']}",
    "dreamPanel": "{c['surface0']}",
    "dreamElement": "{c['bg_soft']}",
    "dreamText": "{c['text']}",
    "dreamMuted": "{c['muted']}",
    "dreamCocoa": "{c['accent_2']}",
    "dreamLucuma": "{c['accent']}",
    "dreamDiagnostic": "{c['diagnostic']}",
    "dreamSage": "{c['sage']}",
    "dreamViolet": "{c['lavender']}",
    "dreamMauve": "{c['mauve']}",
    "dreamCoral": "{c['error']}",
    "dreamWarning": "{c['warning']}"
  }},
  "theme": {{
    "background": "{background}",
    "backgroundPanel": "{c['surface0']}",
    "backgroundElement": "{c['bg_soft']}",
    "backgroundHover": "{mix(c['surface1'], c['bg'], 0.45)}",
    "backgroundSelected": "{t['selection']}",
    "backgroundCode": "{t['code_bg']}",
    "backgroundSearch": "{t['search']}",
    "backgroundLine": "{line_bg}",
    "backgroundAssistant": "{mix(c['diagnostic'], c['bg'], 0.84)}",
    "backgroundUser": "{mix(c['accent'], c['bg'], 0.84)}",
    "backgroundTool": "{mix(c['lavender'], c['bg'], 0.86)}",
    "text": "{c['text']}",
    "textMuted": "{c['muted']}",
    "textSubtle": "{c['subtle']}",
    "textPlaceholder": "{c['comment']}",
    "textAssistant": "{assistant}",
    "textUser": "{user}",
    "textTool": "{t['type']}",
    "primary": "{c['accent']}",
    "secondary": "{c['accent_2']}",
    "accent": "{c['accent']}",
    "accentMuted": "{mix(c['accent'], c['bg'], 0.48)}",
    "error": "{c['error']}",
    "warning": "{c['warning']}",
    "success": "{c['sage']}",
    "info": "{c['diagnostic']}",
    "border": "{c['border_ui']}",
    "borderActive": "{c['accent']}",
    "borderSubtle": "{c['border']}",
    "borderFocus": "{c['diagnostic']}",
    "shadow": "{mix(c['bg'], '#000000', 0.25)}",
    "diffAdded": "{c['sage']}",
    "diffRemoved": "{c['error']}",
    "diffContext": "{c['muted']}",
    "diffHunkHeader": "{c['lavender']}",
    "diffHighlightAdded": "{c['sage']}",
    "diffHighlightRemoved": "{c['error']}",
    "diffAddedBg": "{added_bg}",
    "diffRemovedBg": "{removed_bg}",
    "diffContextBg": "{background}",
    "diffLineNumber": "{c['subtle']}",
    "diffAddedLineNumberBg": "{added_bg}",
    "diffRemovedLineNumberBg": "{removed_bg}",
    "diffHunkHeaderBg": "{hunk_bg}",
    "diffFold": "{c['comment']}",
    "diffFoldBg": "{mix(c['surface1'], c['bg'], 0.82)}",
    "markdownText": "{c['text']}",
    "markdownHeading": "{c['accent']}",
    "markdownLink": "{c['diagnostic']}",
    "markdownLinkText": "{c['accent']}",
    "markdownCode": "{c['sage']}",
    "markdownBlockQuote": "{c['accent_2']}",
    "markdownEmph": "{c['diagnostic']}",
    "markdownStrong": "{c['accent']}",
    "markdownHorizontalRule": "{c['border_ui']}",
    "markdownListItem": "{c['accent']}",
    "markdownListEnumeration": "{c['lavender']}",
    "markdownTableBorder": "{c['border_ui']}",
    "markdownTableHeader": "{c['accent_2']}",
    "markdownImage": "{c['mauve']}",
    "markdownImageText": "{c['text']}",
    "markdownCodeBlock": "{c['text']}",
    "markdownCodeBlockBg": "{t['code_bg']}",
    "markdownInlineCodeBg": "{mix(c['sage'], c['bg'], 0.84)}",
    "syntaxComment": "{t['comment']}",
    "syntaxKeyword": "{t['keyword']}",
    "syntaxFunction": "{t['function']}",
    "syntaxMethod": "{t['method']}",
    "syntaxVariable": "{t['variable']}",
    "syntaxParameter": "{t['parameter']}",
    "syntaxProperty": "{t['property']}",
    "syntaxField": "{t['field']}",
    "syntaxString": "{t['string']}",
    "syntaxNumber": "{t['number']}",
    "syntaxBoolean": "{t['constant']}",
    "syntaxConstant": "{t['constant']}",
    "syntaxType": "{t['type']}",
    "syntaxClass": "{t['constructor']}",
    "syntaxInterface": "{mix(t['type'], c['diagnostic'], 0.22)}",
    "syntaxEnum": "{t['enum']}",
    "syntaxOperator": "{t['operator']}",
    "syntaxPunctuation": "{t['punctuation']}",
    "syntaxTag": "{t['keyword']}",
    "syntaxAttribute": "{t['property']}",
    "syntaxRegexp": "{mix(c['mauve'], c['error'], 0.28)}",
    "syntaxEscape": "{c['warning']}",
    "syntaxNamespace": "{t['type']}",
    "syntaxModule": "{t['type']}",
    "syntaxDecorator": "{t['operator']}",
    "syntaxBuiltin": "{t['constant']}",
    "syntaxSpecial": "{c['warning']}",
    "syntaxTodo": "{t['todo']}",
    "syntaxDeprecated": "{t['deprecated']}",
    "terminalBlack": "{guard(c['surface0'], c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalRed": "{c['error']}",
    "terminalGreen": "{c['sage']}",
    "terminalYellow": "{c['warning']}",
    "terminalBlue": "{c['diagnostic']}",
    "terminalMagenta": "{c['mauve']}",
    "terminalCyan": "{guard(mix(c['diagnostic'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalWhite": "{c['text']}",
    "terminalBrightBlack": "{c['subtle']}",
    "terminalBrightRed": "{guard(mix(c['error'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightGreen": "{guard(mix(c['sage'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightYellow": "{guard(mix(c['warning'], c['text'], 0.16), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightBlue": "{guard(mix(c['diagnostic'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightMagenta": "{guard(mix(c['mauve'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightCyan": "{guard(mix(c['lavender'], c['text'], 0.18), c['bg'], 'dark' if c['details'] == 'darker' else 'light')}",
    "terminalBrightWhite": "{c['text']}"
  }}
}}
'''

def codex_tmtheme_content(c: dict[str, str]) -> str:
    t = opencode_tokens(c)
    invert = c.get("details") == "lighter"
    selection = c["text"] if invert else c["selection"]
    line_highlight = c["surface1"] if invert else c["surface0"]
    gutter = c["surface2"] if invert else c["surface1"]
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key><string>Dreamcoder</string>
  <key>settings</key>
  <array>
    <dict><key>settings</key><dict>
      <key>background</key><string>{c['bg']}</string>
      <key>foreground</key><string>{c['text']}</string>
      <key>caret</key><string>{c['accent']}</string>
      <key>selection</key><string>{selection}</string>
      <key>lineHighlight</key><string>{line_highlight}</string>
      <key>gutter</key><string>{gutter}</string>
      <key>gutterForeground</key><string>{c['muted']}</string>
      <key>invisibles</key><string>{c['comment']}</string>
    </dict></dict>
    <dict><key>scope</key><string>comment</string><key>settings</key><dict><key>foreground</key><string>{t['comment']}</string><key>fontStyle</key><string>italic</string></dict></dict>
    <dict><key>scope</key><string>keyword, storage</string><key>settings</key><dict><key>foreground</key><string>{t['keyword']}</string><key>fontStyle</key><string>bold</string></dict></dict>
    <dict><key>scope</key><string>entity.name.function, support.function</string><key>settings</key><dict><key>foreground</key><string>{t['function']}</string></dict></dict>
    <dict><key>scope</key><string>variable, meta.definition.variable</string><key>settings</key><dict><key>foreground</key><string>{t['variable']}</string></dict></dict>
    <dict><key>scope</key><string>string</string><key>settings</key><dict><key>foreground</key><string>{t['string']}</string></dict></dict>
    <dict><key>scope</key><string>constant.numeric, constant.language</string><key>settings</key><dict><key>foreground</key><string>{t['constant']}</string></dict></dict>
    <dict><key>scope</key><string>entity.name.type, support.type</string><key>settings</key><dict><key>foreground</key><string>{t['type']}</string></dict></dict>
    <dict><key>scope</key><string>punctuation, keyword.operator</string><key>settings</key><dict><key>foreground</key><string>{t['operator']}</string></dict></dict>
  </array>
</dict>
</plist>
'''
