set VIMRUNTIME ~/src/vim/runtime
set MANPAGER "/bin/sh -c \"col -b -x|vim -R -c 'set ft=man nolist nonu noma' -\""
set VISUAL vim --noplugin
set THOR_DIFF /usr/local/bin/vimdiff
set THOR_MERGE /usr/local/bin/vimdiff
set FLYCTL_INSTALL ~/.fly
set DENO_INSTALL ~/.deno
set NVM_DIR ~/.nvm

set XDG_CONFIG_HOME ~/.config
set XDG_CACHE_HOME  ~/.cache
set XDG_DATA_HOME   ~/.local/share
set XDG_STATE_HOME  ~/.local/state

set -g theme_display_user no
set -g theme_display_hostname no


fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path ~/.rbenv/bin
fish_add_path $FLYCTL_INSTALL/bin
fish_add_path $DENO_INSTALL/bin
fish_add_path ~/src/go/bin
fish_add_path ~/go/bin
fish_add_path ~/src/vim/src
fish_add_path ~/.vim/dein/repos/github.com/thinca/vim-themis/bin


set -x less "-nm"

abbr -a lss ls -acf
abbr -a ll ls -al
abbr -a virc  vim    ~/.config/fish/config.fish
abbr -a vircl vim    ~/.config/fish/config.fish.local
abbr -a srrc  source ~/.config/fish/config.fish
abbr -a .. cd ..
abbr -a ... cd ../..

# for TODO-TXT
abbr -a tt   todo.sh
abbr -a ttl  todo.sh ls
abbr -a ttla todo.sh lsa
abbr -a tta  todo.sh -t add
abbr -a ttd  todo.sh do

# for trash-cli
abbr -a rm   rm -i
abbr -a put  trash-put
abbr -a puts trash-put

# for Git
abbr -a gist git switch
abbr -a girs git restore
abbr -a gia  git add
abbr -a giap git add -p
abbr -a gial git add -A
abbr -a gian git add -N
abbr -a gic  git commit -m
abbr -a gis  git status
abbr -a gil  git log --reverse --decorate --color=always
abbr -a gilo git log --reverse --decorate --color=always origin -15
abbr -a gilg git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'"%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
abbr -a gilr git log --graph --all --abbrev-commit --date=relative --color=always --pretty=format:'"%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"' \| tac \| ruby -pe '\'$_.sub!(/.+?(?=\\h{7}|$)/){ _1.tr("\\\\/\\\\\\\\", "\\\\\\\\\\\\\\\\\\\\/") }\''
abbr -a gib  git branch
abbr -a gif  git fetch --all --prune
abbr -a gim  git merge
abbr -a gid  git diff --color=always
abbr -a gidc git diff --cached --color=always
abbr -a gicl git clone git@github.com:
abbr -a gira git remote add origin git@github.com:
abbr -a giss git stash show -p
abbr -a gipf git push --force-with-lease --force-if-includes

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
abbr -a ccp  xclip -selection clipboard -i
abbr -a cps  xclip -selection clipboard -o

# for Fly.io
abbr -a fly flyctl

# for Rust
sh ~/.cargo/env

# substitute for eval (rbenv init -)
status --is-interactive; and source (rbenv init -|psub)

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

function update
  bash -c ". ~/.bashrc && update"
end

function update_packages
  bash -c ". ~/.bashrc && update_packages"
end

function update_rbenv
  bash -c ". ~/.bashrc && update_rbenv"
end

function update_gem
  bash -c ". ~/.bashrc && update_gem"
end

function update_nvm
  bash -c ". ~/.bashrc && update_nvm"
end

function update_pip
  bash -c ". ~/.bashrc && update_pip"
end

function update_deno
  bash -c ". ~/.bashrc && update_deno"
end

function update_go
  bash -c ". ~/.bashrc && update_go"
end

function update_rust
  bash -c ". ~/.bashrc && update_rust"
end

function update_tpm
  bash -c ". ~/.bashrc && update_tpm"
end

function update_fisher
  bash -c ". ~/.bashrc && update_fisher"
end

function update_vim
  bash -c ". ~/.bashrc && update_vim"
end


function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  for mode in insert default visual
    fish_default_key_bindings -M $mode
  end
  fish_vi_key_bindings --no-erase
  bind -M insert -m default jj backward-char force-repaint
end

if test -e (status dirname)'/config.fish.local'
  source (status dirname)'/config.fish.local'
end

