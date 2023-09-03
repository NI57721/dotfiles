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

for file in "${linked_files[@]}"; do
  mkdir -p $HOME/$(dirname $file)
  ln -snf $DOTFILES_ROOT/$file $HOME/$file &&
    echo "SUCCESS 'ln -snf $DOTFILES_ROOT/$file $HOME/$file'" ||
    echo "FAILURE 'ln -snf $DOTFILES_ROOT/$file $HOME/$file'"
done

