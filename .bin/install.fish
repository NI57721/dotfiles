#!/usr/bin/env fish

set project_root (realpath (dirname (status dirname)))
set linked_files .vimrc .vim/rc/dein.toml .vim/rc/dein_lazy.toml .config/fish/config.fish .config/fish/config.fish.local .config/fish/fish_plugins .gitignore_global

function backup
  set dir (date "+%Y%m%d-%H%M%S")
  for f in $linked_files
    set dirpath $project_root/.backup/$dir/
    mkdir -p $dirpath
    and mv ~/$f $dirpath
    and echo mv ~/$f $dirpath
  end
end

function create_links
  for f in $linked_files
    set filepath $project_root/$f
    and ln -snf $filepath ~/$f
    and echo ln -snf $filepath ~/$f
  end
end

function install_packages
  sudo apt update
  sudo apt install git
end

function install_fisher
  curl -sL https://git.io/fisher | source; and fisher update
end

function install_rbenv
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  ~/.rbenv/bin/rbenv init
  mkdir -p "$(rbenv root)"/plugins
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
end

function init_git
  git config --global user.email "104410688+NI57721@users.noreply.github.com"
  git config --global user.name "NI57721"
end

backup
create_links
install_fisher
install_rbenv

