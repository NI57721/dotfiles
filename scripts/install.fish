#!/usr/bin/env fish

set project_root (realpath (dirname (status dirname)))
set linked_files .config/vim/{vimrc,rc/dein{,_lazy}.toml} .config/vsnip/ruby.json .config/fish/{config.fish,fish_plugins} .config/git/{config,gitignore_global} .config/tmux/tmux.conf .config/bash/bashrc .config/paru/paru.conf .config/waybar/{config,style.css,scripts/ppp.sh} .config/wezterm/wezterm.lua .config/sway/{config,scripts/{clamshell.sh,ime-vim.sh,recorder.sh}} .config/npm/npmrc .config/X11/xinitrc .config/irb/irbrc .config/todo/config .config/chrome-flags.conf


function success
  echo "Success: $argv"
end

function failure
  echo "Failure: $argv"
end

function install_packages
  sudo apt-get update
  and sudo apt-get install -y \
    git \
    todotxt-cli \
    vim-gtk3
  and success $history[1]
  or failure $history[1]
end

function backup
  set dir (date "+%Y%m%d-%H%M%S")
  for f in $linked_files
    set dirpath $project_root/.backup/$dir/(dirname $f)
    mkdir -p $dirpath
    and cp $project_root/$f $dirpath
    and success mv ~/$f $dirpath
    or failure mv ~/$f $dirpath
  end
end

function create_links
  for f in $linked_files
    set filepath $project_root/$f
    and mkdir -p ~/(dirname $f)
    and ln -snf $filepath ~/$f
    and success ln -snf $filepath ~/$f
    or failure ln -snf $filepath ~/$f
  end
end

