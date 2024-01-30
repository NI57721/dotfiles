set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME  $HOME/.cache
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx DOTFILES_ROOT   $HOME/dotfiles

set -gx VIMRUNTIME $XDG_DATA_HOME/vim/runtime
set -gx MANPAGER "vim +MANPAGER -Rc 'set filetype=man nolist nonumber nomodifiable' -"
set -gx VISUAL vim --noplugin
set -gx THOR_DIFF /usr/local/bin/vimdiff
set -gx THOR_MERGE /usr/local/bin/vimdiff
set -gx FLYCTL_INSTALL $XDG_DATA_HOME/fly
set -gx RBENV_ROOT $XDG_DATA_HOME/rbenv
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx NVM_DIR $XDG_DATA_HOME/nvm
set -gx nvm_data $NVM_DIR/versions/node
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx VIMINIT 'let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
set -gx DVDCSS_CACHE $XDG_CACHE_HOME/dvdcss
set -gx HISTFILE $XDG_STATE_HOME/bash/history
set -gx GOPATH $XDG_DATA_HOME/go-workspace
set -gx NODE_REPL_HISTORY $XDG_DATA_HOME/node/repl_history
# set -gx WGETRC $XDG_CONFIG_HOME/wget/wgetrc
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/startup.py

nvm use (nvm list | sed "s/.*v\|[^0-9]\+\$//g" | sort | tail -1) > /dev/null

set -g theme_display_cmd_duration yes
set -g theme_display_hostname no
set -g theme_display_user no
set -g theme_display_vi yes
set -g theme_project_dir_length 1


fish_add_path $HOME/.local/bin
fish_add_path $RBENV_ROOT/bin
fish_add_path $XDG_DATA_HOME/cargo/bin
fish_add_path $FLYCTL_INSTALL/bin
fish_add_path $XDG_DATA_HOME/deno/bin
fish_add_path $XDG_DATA_HOME/go/bin
fish_add_path $GOPATH/bin
fish_add_path $XDG_DATA_HOME/vim/src
fish_add_path $XDG_DATA_HOME/dein/repos/github.com/thinca/vim-themis/bin

set -x less "-nm"

abbr -a lss ls -acf
abbr -a ll ls -al
abbr -a --set-cursor le % \| less
abbr -a kila kill -9
abbr -a psa ps aux \| grep -v grep \| grep
abbr -a virc  vim -p $XDG_CONFIG_HOME/{fish/config.fish,bash/bashrc}
abbr -a vircl vim    $XDG_CONFIG_HOME/fish/local.fish
abbr -a srrc  source $XDG_CONFIG_HOME/fish/config.fish
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a von sudo ipsec up interlink
abbr -a vof sudo ipsec down interlink
abbr -a om swaymsg output eDP-1 disable
abbr -a cdv cd $XDG_DATA_HOME/dein/repos/github.com/

# for TODO-TXT
abbr -a tt   todo.sh
abbr -a ttl  todo.sh ls
abbr -a ttla todo.sh lsa
abbr -a tta  todo.sh -t add
abbr -a --set-cursor tta todo.sh -t add \"\(B\) %\"
abbr -a ttd  todo.sh do

# for trash-cli
abbr -a rm   rm -i
abbr -a mv   mv -i
abbr -a cp   cp -i
abbr -a put  trash-put
abbr -a puts trash-put

# for Git
abbr -a cg   cd \(git rev-parse --show-toplevel 2\> /dev/null\; or pwd\)
abbr -a gist git switch
abbr -a girs git reset --soft HEAD~
abbr -a gia  git add
abbr -a giap git add -p
abbr -a gial git add -A
abbr -a gian git add -N
abbr -a --set-cursor gic  git commit -m \"%\"
abbr -a gis  git status
abbr -a gil  git log --reverse --decorate --color=always
abbr -a gilo git log --reverse --decorate --color=always origin -15
abbr -a gilg git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'"%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
abbr -a gilr git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'"@%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"' \| sed -E '\'s/^([^@]*)@|^([^-]*)$/\\1\\2@\\n/; 1!G; h; $!d;\'' \| sed -E '\'/^[^@]*@$/y!/\\\\\\\\!\\\\\\\\/!; N; s/@\\n//\''
abbr -a gib  git branch
abbr -a gif  git fetch --all --prune
abbr -a gim  git merge
abbr -a gid  git diff --color=always
abbr -a gidc git diff --cached --color=always
abbr -a --set-cursor gicl git clone git@github.com:%
abbr -a --set-cursor gira git remote add origin git@github.com:%
abbr -a gish  git stash
abbr -a gishp git stash pop
abbr -a gishd git stash drop
abbr -a gishl git stash list
abbr -a --set-cursor gishs git stash show -p stash@{%}
abbr -a gip  git push
abbr -a gipf git push --force-with-lease --force-if-includes
abbr -a gipu git push --set-upstream origin \(git branch --show-current\)
abbr -a girm git remind status --short \| grep -ve "-sandbox\\\$"

# for Docker
abbr docl docker container ls
abbr doil docker image ls
abbr dos  docker stop
abbr doe  docker exec -it {} /bin/bash

# for Bundler
abbr -a be   bundle exec
abbr -a ber  bundle exec rails
abbr -a bers bundle exec rails server -b 0.0.0.0
abbr -a berc bundle exec rails console --sandbox

# for clipboard
abbr -a ccp wl-copy
abbr -a cps wl-paste

# for Fly.io
abbr -a fly flyctl

# launcher
abbr chrome swaymsg exec "google-chrome-stable"
abbr vlc    swaymsg exec "vlc"

status --is-interactive; and rbenv init - fish | source

# Settings for WSL2
if grep -qie "microsoft-.*-WSL2" /proc/version
  abbr -e ccp
  function ccp
    if string match -q '*-WSL*' (uname -r)
      if count $argv > /dev/null
        echo $argv | /mnt/c/Windows/System32/clip.exe
      else
        cat | /mnt/c/Windows/System32/clip.exe
      end
    end
  end

  abbr -e cps
  function cps
    if string match -q '*-WSL*' (uname -r)
      /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
        -command Get-Clipboard
    end
  end
end

function mkcd
  mkdir -p $argv[1]
  and cd $argv[1]
  and pwd
end

function ppk2ssh
  set --local filename (path change-extension '' $argv[1])
  puttygen $argv[1] -O private-openssh -o $filename &&
    echo "Generate $filename"
  puttygen $argv[1] -O public-openssh -o $filename.pub &&
    echo "Generate $filename.pub"
end

function update
  echo -e "### Packages ###"
  update_packages
  echo -e "\n### Rbenv ###"
  update_rbenv
  echo -e "\n### Ruby Gems ###"
  update_gem
  echo -e "\n### NVM ###"
  update_nvm
  echo -e "\n### Deno ###"
  update_deno
  echo -e "\n### Go ###"
  update_go
  echo -e "\n### Rust ###"
  update_rust
  echo -e "\n### TPM ###"
  update_tpm
  echo -e "\n### Fisher ###"
  update_fisher
  echo -e "\n### Vim ###"
  update_vim
  echo -e "\n### Todo.txt list ###"
  todo.sh ls
  echo -e "\n### Git remind ###"
  git remind status --short | grep -ve "-sandbox\$"
end

function update_packages
  $DOTFILES_ROOT/scripts/update_packages.sh
end

function update_rbenv
  git -C (rbenv root) pull
  git -C (rbenv root)/plugins/ruby-build pull
end

function update_gem
  gem update --system
  gem update
end

function update_nvm
  $DOTFILES_ROOT/scripts/update_nvm.sh
end

function update_deno
  deno upgrade
end

function update_go
  $DOTFILES_ROOT/scripts/update_go.sh
end

function update_rust
  rustup update
end

function update_tpm
  $XDG_CONFIG_HOME/tmux/plugins/tpm/bin/update_plugins all
end

function update_fisher
  fisher update
end

function update_vim
  $DOTFILES_ROOT/scripts/update_vim.sh
end

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  for mode in insert default visual
    fish_default_key_bindings -M $mode
  end
  fish_vi_key_bindings --no-erase
  bind -M insert -m default jj backward-char force-repaint
  bind -M visual -m default jj end-selection force-repaint

  # settings below for CSI u mode
  # \cm(\e[109;5u) -> Enter, \ci(\e[105;5u) -> Tab, \c[ -> ESC
  # bind -M insert  \e\[32\;2u complete-and-search
  bind -M insert  \e\[109\;5u execute
  bind -M default \e\[109\;5u execute
  bind -M insert  \e\[105\;5u complete
  bind -M visual  \e\[105\;5u complete
  bind -M default \e\[105\;5u complete
  bind -M insert  -m default \e\[91\;5u backward-char force-repaint
  bind -M visual  -m default \e\[91\;5u end-selection force-repaint
  bind -M default            \e\[91\;5u ''
end

# Launch Sway when logging in with tty.
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  exec sway
end

if [ -f "$XDG_CONFIG_HOME/fish/local.fish" ]
  source "$XDG_CONFIG_HOME/fish/local.fish"
end

