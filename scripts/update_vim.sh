#!/bin/bash -u

vim_root=$VIMRUNTIME/..
mkdir -p $vim_root
if [ -d $vim_root/.git ]; then
  git -C $vim_root pull
else
  git clone https://github.com/vim/vim.git $vim_root
fi

cd $vim_root
./configure \
  --with-features=huge --enable-gui=gtk3 --enable-perlinterp \
  --enable-python3interp --enable-rubyinterp --enable-luainterp \
  --with-luajit --enable-fail-if-missing
make

