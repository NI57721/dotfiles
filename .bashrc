# ~/.bashrc: executed by bash(1) for non-login shells.

case $- in
    *i*) ;;
      *) return;;
esac

export VISUAL='vim --noplugin'
export FLYCTL_INSTALL="~/.fly"
export DENO_INSTALL="/home/nishihama/.deno"
export LESS="-RNM"
export PATH="~/.local/bin:~/bin:~/.rbenv/bin:$PATH"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"

alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -al'
alias lss='ls -ACF'
alias srrc='source ~/.bashrc'
alias virc='vim ~/.bashrc'
alias lsag="!! | less -NM"
alias tt="todo-txt -t"
alias tp="trash-put"

eval "$(rbenv init -)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

shopt -s dotglob

set -o vi
bind '"jj": vi-movement-mode'
bind '"\C-p": previous-history'

mkcd() {
  mkdir $1 && cd $1 && pwd
}

rbenv_update() {
  (cd "$(rbenv root)" ; git pull ; cd "$(rbenv root)"/plugins/ruby-build ; git pull)
}

# https://qiita.com/xtetsuji/items/31bc53e92d94b1602b5d
function cdl {
  local -a dirlist opt_f=false
  local i d num=0 dirnum opt opt_f
  while getopts ":f" opt ; do
    case $opt in
      f ) opt_f=true ;;
    esac
  done
  shift $(( OPTIND -1 ))
  dirlist[0]=..
  # external pipe scope. array is established.
  for d in * ; do test -d "$d" && dirlist[$((++num))]="$d" ; done
  for i in $( seq 0 $num ) ; do printf "%3d %s%b\n" $i "$( $opt_f && echo -n "$PWD/" )${dirlist[$i]}" ; done
  read -p "select number: " dirnum
  if [ -z "$dirnum" ] ; then
    echo "$FUNCNAME: Abort." 1>&2
  elif ( echo $dirnum | egrep '^[[:digit:]]+$' > /dev/null ) ; then
    cd "${dirlist[$dirnum]}"
  else
    echo "$FUNCNAME: Something wrong." 1>&2
  fi
}

# cf. https://unix.stackexchange.com/questions/595574/how-to-configure-the-buffer-used-by-vi-mode-bash-for-yank-and-paste
# Macros to enable yanking, killing and putting to and from the system clipboard in vi-mode. Only supports yanking and killing the whole line.
# paste_from_clipboard () {
#   local shift=$1
# 
#   local head=${READLINE_LINE:0:READLINE_POINT+shift}
#   local tail=${READLINE_LINE:READLINE_POINT+shift}
# 
#   local paste=$(xclip -out -selection clipboard)
#   local paste_len=${#paste}
# 
#   READLINE_LINE=${head}${paste}${tail}
#   # Place caret before last char of paste (as in vi)
#   let READLINE_POINT+=$paste_len+$shift-1
# }
# 
# yank_line_to_clipboard () {
#   echo $READLINE_LINE | xclip -in -selection clipboard
# }
# 
# kill_line_to_clipboard () {
#   yank_line_to_clipboard
#   READLINE_LINE=""
# }
# 
# bind -m vi-command -x '"P": paste_from_clipboard 0'
# bind -m vi-command -x '"p": paste_from_clipboard 1'
# bind -m vi-command -x '"yy": yank_line_to_clipboard'
# bind -m vi-command -x '"dd": kill_line_to_clipboard'

