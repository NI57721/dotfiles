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

