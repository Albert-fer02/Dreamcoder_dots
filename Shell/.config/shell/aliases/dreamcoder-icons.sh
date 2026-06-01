#!/usr/bin/env bash
set -euo pipefail
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons=always --group-directories-first'
    alias ll='eza --icons=always --group-directories-first --long --git'
    alias la='eza --icons=always --group-directories-first --long --all --git'
    alias tree='eza --icons=always --group-directories-first --tree'
else
    alias ll='ls -lah'
    alias la='ls -lahA'
fi
