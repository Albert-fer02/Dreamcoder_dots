# Pi agent bin directory — gentle-pi tools like sdd-swap
if not contains "$HOME/.pi/agent/bin" $PATH
    set -gx PATH "$HOME/.pi/agent/bin" $PATH
end
