# USE NVIDIA DRI_PRIME=1

[[ $DISPLAY && $XDG_VTNR -eq 1 ]] || startx $HOME/.config/xinitrc dwm
