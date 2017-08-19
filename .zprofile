[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
# eval $(ssh-agent) >/dev/null
eval "$(hub alias -s)"

export PATH="$HOME/.cargo/bin:$PATH"
