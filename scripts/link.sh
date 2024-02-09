#!/bin/bash -u

HOME=${HOME:-~}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
DOTFILES_ROOT=${DOTFILES_ROOT:-$HOME/dotfiles}

linked_files=(
  .config/bash/bashrc
  .config/bundle/config
  .config/chrome-flags.conf
  .config/fish/{config.fish,fish_plugins}
  .config/git/{config,gitignore_global}
  .config/irb/irbrc
  .config/npm/npmrc
  .config/paru/paru.conf
  .config/python/startup.py
  .config/sway/{config,scripts/{clamshell.sh,ime-vim.sh,ime-vim-fast-paste.sh,recorder-{gif,mp4}.sh}}
  .config/tmux/tmux.conf
  .config/todo/config
  .config/vim/{vimrc,rc/dein{,_lazy}.toml}
  .config/vsnip/ruby.json
  .config/waybar/{config,style.css}
  .config/waybar/scripts/{vpn.sh,recorder-state.sh}
  .config/wezterm/wezterm.lua
  # .config/wget/wgetrc
  .config/X11/xinitrc
)

backup_path=$XDG_CACHE_HOME/dotfiles/$(date "+%Y%m%d-%H%M%S")

mkdir -p $backup_path

for file in "${linked_files[@]}"; do
  if [ -f $HOME/$file ]; then
    mkdir -p $backup_path/$(dirname $file)
    cp $HOME/$file $backup_path/$file ||
      echo "FAILURE 'cp $DOTFILES_ROOT/$file $backup_path/$file'"
  fi
  mkdir -p $HOME/$(dirname $file)
  ln -snf $DOTFILES_ROOT/$file $HOME/$file ||
    echo "FAILURE 'ln -snf $DOTFILES_ROOT/$file $HOME/$file'"
done

