# Enable colors and change prompt:
autoload -U colors && colors
PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b " 
# RPROMPT="$(git_super_status)"

# export HISTFILE="$XDG_CONFIG_HOME/zsh/zsh_history"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in vim with ctrl-e:
# autoload edit-command-line; zle -N edit-command-line
# bindkey '^e' edit-command-line

# source alias file
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Load zsh-history
source /usr/share/zsh/plugins/zsh-history/history.zsh 2>/dev/null

# [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx $HOME/.config/xinitrc
