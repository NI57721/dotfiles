#!/bin/bash -u

linked_files=()
linked_files+=(.config/bash/bashrc)
linked_files+=(.config/chrome-flags.conf)
linked_files+=(.config/fish/{config.fish,fish_plugins})
linked_files+=(.config/git/{config,gitignore_global})
linked_files+=(.config/irb/irbrc)
linked_files+=(.config/npm/npmrc)
linked_files+=(.config/paru/paru.conf)
linked_files+=(.config/sway/{config,scripts/{clamshell.sh,ime-vim.sh,recorder.sh}})
linked_files+=(.config/tmux/tmux.conf)
linked_files+=(.config/todo/config)
linked_files+=(.config/vim/{vimrc,rc/dein{,_lazy}.toml})
linked_files+=(.config/vsnip/ruby.json)
linked_files+=(.config/waybar/{config,style.css,scripts/ppp.sh})
linked_files+=(.config/wezterm/wezterm.lua)
linked_files+=(.config/X11/xinitrc)

backup_path=$XDG_CACHE_HOME/dotfiles/$(date "+%Y%m%d-%H%M%S")

mkdir -p $backup_path

for file in "${linked_files[@]}"; do
  mkdir -p $backup_path/$(dirname $file)
  cp $HOME/$file $backup_path/$file &&
    echo "SUCCESS 'cp $DOTFILES_ROOT/$file $backup_path/$file'" ||
    echo "FAILURE 'cp $DOTFILES_ROOT/$file $backup_path/$file'" && continue
  mkdir -p $HOME/$(dirname $file)
  ln -snf $DOTFILES_ROOT/$file $HOME/$file &&
    echo "SUCCESS 'ln -snf $DOTFILES_ROOT/$file $HOME/$file'" ||
    echo "FAILURE 'ln -snf $DOTFILES_ROOT/$file $HOME/$file'"
done

