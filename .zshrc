[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && DRI_PRIME=1 startx $HOME/.config/xinitrc dwm
