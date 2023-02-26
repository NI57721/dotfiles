# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

mkcd() {
  mkdir -p $1 && cd $1 && pwd
}

update() {
  echo -e "### packages ###"
  update_packages
  echo -e "\n### RBENV ###"
  update_rbenv
  echo -e "\n### GEM ###"
  update_gem
  echo -e "\n### NVM ###"
  update_nvm
  echo -e "\n### PIP ###"
  update_pip
  echo -e "\n### DENO ###"
  update_deno
  echo -e "\n### GO ###"
  update_go
  echo -e "\n### RUST ###"
  update_rust
  echo -e "\n### TPM ###"
  update_tpm
  echo -e "\n### FISHER ###"
  update_fisher
}

update_packages() {
  if [[ ! -f /etc/os-release ]]; then
    echo "/etc/os-release does not exist."
    return 1
  fi

  . /usr/lib/os-release
  case $ID in
    debian | ubuntu )
      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt-get autoclean -y
      sudo apt-get autoremove -y;;
    arch )
      sudo pacman -Syu
      pacman -Qdtq || sudo pacman -Rs
      paccache -ruk0;;
    rhel ) echo "Red Hat";;
    centos ) echo "CentOS";;
    fedora ) echo "Fedora";;
    opensuse ) echo "OpenSUSE";;
    * )
      echo "Unknown distribution"
      return 1;;
  esac
}

update_rbenv() {
  git -C $(rbenv root) pull
  git -C $(rbenv root)/plugins/ruby-build pull
}

update_gem() {
  gem update --system
  gem update
}

update_nvm() {
  git -C $NVM_DIR fetch --tags origin
  local latest_commit=$(git -C $NVM_DIR rev-list --tags --max-count=1)
  local latest_tag=$(git -C $NVM_DIR describe --abbrev=0 --tags --match \
    "v[0-9]*" $latest_commit)
  git -C $NVM_DIR checkout $latest_tag
  . $NVM_DIR/nvm.sh
  nvm install stable --latest-npm
  nvm install-latest-npm
  npm update
}

update_pip() {
  pip install -U pip
  pip list -o | tail -n +3 | sed -e "s/ .*//g" | xargs -t -I{} pip install -U {}
}

update_deno() {
  deno upgrade
}

update_go() {
  echo Looking up latest version
  local path=$HOME/src
  local go_path=$path/go
  local version=$(go version | sed -e "s/^.*\(go[0-9.]\+\).*/\1/g")
  local latest_version=$(curl --silent https://go.dev/VERSION?m=text)
  if [[ "$version" == "$latest_version" ]]; then
    echo "Local go version $version is the most recent release"
    return 0
  fi
  local archive_uri=https://go.dev/dl/$latest_version.linux-amd64.tar.gz
  local archive=$path/$latest_version.tar.gz
  curl -L $archive_uri > "$archive"
  [[ -d "$go_path" ]] && rm -rf $go_path
  mkdir -p $go_path
  tar -C $path -xzf $archive && rm $archive
}

update_rust() {
  rustup update
}

update_tpm() {
  ~/.tmux/plugins/tpm/bin/update_plugins all
}

update_fisher() {
  fish -c "fisher update"
}

update_vim() {
  mkdir -p $HOME/src
  if [ ! -e $HOME/src/vim ]; then git clone https://github.com/vim/vim.git $HOME/src/vim; fi
  git -C $HOME/src/vim pull
  cd $HOME/src/vim/src
  ./configure \
    --with-features=huge --enable-gui=gtk3 --enable-perlinterp \
    --enable-python3interp --enable-rubyinterp --enable-luainterp \
    --with-luajit --enable-fail-if-missing
  make
  cd -
}

# If not running interactively, don't do anything below
case $- in
  *i*) ;;
    *) return;;
esac

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
  test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
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
export MANPAGER="/bin/sh -c \"col -bx|vim -Rc 'set ft=man nolist nonu noma' -\""
export LESS="-RNM"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/src/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

export VIMRUNTIME=$HOME/src/vim/runtime
export PATH="$HOME/src/vim/src:$PATH"
export PATH="$HOME/.vim/dein/repos/github.com/thinca/vim-themis/bin:$PATH"

export FLYCTL_INSTALL=$HOME/.fly
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export DENO_INSTALL=$HOME/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state


. $HOME/.cargo/env

[ -f "$HOME/.fzf.bash" ] && . ~/.fzf.bash

alias ..='cd ..'
alias ...='cd ../..'

alias ll='ls -al'
alias lss='ls -ACF'

alias virc='vim $HOME/.bashrc'
alias srrc='. $HOME/.bashrc'

alias gist="git switch"
alias girs="git restore"
alias gia="git add"
alias giap="git add -p"
alias gial="git add -A"
alias gic="git commit -m"
alias gis="git status"
alias gil="git log --reverse --decorate --color=always"
alias gilo="git log --reverse --decorate --color=always origin -15"
alias gilg="git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'\"%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\"'"
alias gib="git branch"
alias gif="git fetch"
alias gim="git merge"
alias gid="git diff --color=always"
alias gidc="git diff --cached --color=always"
alias gicl="git clone git@github.com:"
alias gira="git remote add origin git@github.com:"
alias gish="git stash"
alias giss="git stash show -p"
alias gipf="git push --force-with-lease --force-if-includes"

alias docl="docker container ls"
alias doil="docker image ls"
alias dos="docker stop"
alias doe="docker exec -it"

alias tt="todo.sh -t"
alias ttl="todo.sh ls"
alias ttla="todo.sh lsa"
alias tta="todo.sh -t add"
alias ttd="todo.sh do"

alias rm="rm -i"
alias put="trash-put"
alias puts="trash-put"

alias ccp="xclip -selection clipboard -i"
alias cps="xclip -selection clipboard -o"

alias chrome="swaymsg exec \"google-chrome-stable\""
alias thunar="swaymsg exec \"thunar\""
alias vlc="swaymsg exec \"vlc\""

shopt -s dotglob

set -o vi
bind '"jj": vi-movement-mode'
bind '"\C-p": previous-history'

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
  WIN_HOME="/mnt/c/Users/$USER"

  alias cddt="cd $WIN_HOME/desktop/"
  alias cdstu="cd $WIN_HOME/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup/"

  alias ste="explorer.exe ."

  alias pnet=$'open "/mnt/c/PROGRA~1/paint.net/PaintDotNet.exe"'
  alias zoom=$'open "$WIN_HOME/AppData/Roaming/Zoom/bin/Zoom.exe"'
  alias chrome="/mnt/c/PROGRA~2/Google/Chrome/Application/chrome.exe"
  alias word='powershell.exe -command "start WINWORD"'
  alias excel='powershell.exe -command "start EXCEL"'

  alias goodbye="shutdown.exe /p; exit"
  alias terminate="wsl.exe -t Ubuntu"

  open() {
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

  # Override existing alias for ccp
  alias ccp=_ccp
  _ccp() {
    if [[ $# -eq 0 ]] ; then
      cat | clip.exe
    else
      echo $1 | clip.exe
    fi
  }
  alias cps="powershell.exe -command Get-Clipboard"
fi

# Launch Sway when logging in with tty.
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  exec sway
fi

# Read .bashrc.local, if any, which may contain credentials or specific
# options
if [ -f "$HOME/.bashrc.local" ]; then
  . $HOME/.bashrc.local
fi

