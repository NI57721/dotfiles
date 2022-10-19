# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Read .bashrc.local, if any, which may contain credentials or specific
# options
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

################################################################################
#                                                                              #
#                                   templates                                  #
#                                                                              #
################################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


################################################################################
#                                                                              #
#                                my own settings                               #
#                                                                              #
################################################################################

export VISUAL='vim --noplugin'
export LESS="-RNM"

export PATH="~/bin:$PATH"
export PATH="~/.local/bin:$PATH"
export PATH="~/.yarn/bin:$PATH"
export PATH="~/.config/yarn/global/node_modules/.bin:$PATH"

export FLYCTL_INSTALL=~/.fly
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export DENO_INSTALL=~/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="~/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. ~/.cargo/env

[ -f ~/.fzf.bash ] && . ~/.fzf.bash

alias ..='cd ..'
alias ...='cd ../..'

alias ll='ls -al'
alias lss='ls -ACF'

alias virc='vim ~/.bashrc'
alias srrc='. ~/.bashrc'

alias gico="git checkout"
alias gia="git add"
alias giap="git add -p"
alias gial="git add -A"
alias gic="git commit -m"
alias gis="git status"
alias gil="git log --reverse --decorate --color=always"
alias giln="git log --reverse --decorate -n 10 --color=always"
alias gilg="git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'\"%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\"'"
alias gib="git branch"
alias gif="git fetch"
alias gim="git merge"
alias gid="git diff --color=always"
alias gidc="git diff --cached --color=always"
alias gicl="git clone git@github.com:"
alias gira="git remote add origin git@github.com:"

alias tt="todo-txt -t"
alias ttl="todo-txt ls"
alias ttla="todo-txt lsa"
alias tta="todo-txt -t add"
alias ttd="todo-txt do"

alias rm="rm -i"
alias put="trash-put"

shopt -s dotglob

set -o vi
bind '"jj": vi-movement-mode'
bind '"\C-p": previous-history'

mkcd() {
  mkdir $1 && cd $1 && pwd
}

update() {
  echo -e "### APT ###"
  apt_update
  echo -e "\n### RBENV ###"
  rbenv_update
  echo -e "\n### GEM ###"
  gem_update
  echo -e "\n### NVM ###"
  nvm_update
  echo -e "\n### PIP ###"
  pip_update
}

apt_update() {
  sudo apt-get update -q
  sudo apt-get upgrade -q
  sudo apt-get autoclean
  sudo apt-get autoremove
}

rbenv_update() {
  (cd "$(rbenv root)"; git pull; cd "$(rbenv root)"/plugins/ruby-build; git pull)
}

gem_update() {
  gem update --system
  gem update
}

nvm_update() {
  cd $NVM_DIR
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  $NVM_DIR/nvm.sh
  nvm install stable --latest-npm
  nvm install-latest-npm
  npm update
  cd -
}

pip_update() {
  pip install -U pip
  pip list -o | tail -n +3 | sed -e "s/ .*//g" | xargs -t -I{} pip install -U {}
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

# Settings for WSL2
if grep -qie "microsoft-.*-WSL2" /proc/version; then
  WIN_HOME='/mnt/c/Users/$USER'

  alias cddt='cd $WIN_HOME/desktop/'
  alias cdstu='cd $WIN_HOME/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup/'

  alias ste='explorer.exe .'

  alias pnet=$'open "/mnt/c/PROGRA~1/paint.net/PaintDotNet.exe"'
  alias zoom=$'open "$WIN_HOME/AppData/Roaming/Zoom/bin/Zoom.exe"'
  alias chrome='/mnt/c/PROGRA~2/Google/Chrome/Application/chrome.exe'
  alias word='powershell.exe -command "start WINWORD"'
  alias excel='powershell.exe -command "start EXCEL"'

  alias goodbye='shutdown.exe /p; exit'
  alias terminate='wsl.exe -t Ubuntu'

  function open() {
    if [ $# -eq 0 ]; then
      explorer.exe .
    else
      if [ -e $1 ]; then
        cmd.exe /c start $(wslpath -w $1) 2> /dev/null
      else
        # echo "open: $1 : No such file or directory"
        chrome $* 2> /dev/null
      fi
    fi
  }

  wincmd() {
    local CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f cp932 -t utf-8
  }

  ccp() {
    if [[ $# -eq 0 ]] ; then
      cat | clip.exe
    else
      echo $1 | clip.exe
    fi
  }

  alias cps='powershell.exe -command Get-Clipboard'
fi

