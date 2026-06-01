# Dreamcoder terminal editing ergonomics.
if status is-interactive
    bind \b backward-delete-char
    bind \x7f backward-delete-char
    bind \e\[3~ delete-char
    bind \e\[1\;5D backward-word
    bind \e\[1\;5C forward-word
    bind \e\x7f backward-kill-word
    bind \cw backward-kill-word
    bind \cu backward-kill-line
    bind \ck kill-line
    bind \e\[1\;5F end-of-line
    bind \e\[1\;5H beginning-of-line
    bind \e\[F end-of-line
    bind \e\[H beginning-of-line
    bind \cl clear-screen
end
