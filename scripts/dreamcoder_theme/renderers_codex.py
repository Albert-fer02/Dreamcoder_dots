"""Focused CLI/editor theme renderers."""

from __future__ import annotations

import json

from .palette import guard, mix
from .settings import PI_THEME_SCHEMA
from .renderers_opencode import opencode_tokens


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
