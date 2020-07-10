# autoload -U colors && colors
# PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b " 
[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx $HOME/.config/xinitrc dwm
