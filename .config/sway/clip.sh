#!/bin/bash -u

unix_time=$(date +%s%N)
ime_tmp=/tmp/ime/$unix_time
mkdir -p /tmp/ime
touch $ime_tmp
# Vimが正しく終了しなかった時はコピーしない
wezterm --config initial_rows=10 --config initial_cols=70 --config enable_tab_bar=false --config window_background_opacity=0.4 --config text_background_opacity=0.4 start --class Floaterm vim -N -u ~/.vimrc.ime -c start $ime_tmp | exit 1
# wezterm --config initial_rows=10 --config initial_cols=70 --config enable_tab_bar=false --config command_palette_bg_color="#ff0000" start --class Floaterm vim -N -u ~/.vimrc.ime -c start $ime_tmp | exit 1
# head -c -1は末尾の改行を削ぎ落とすやつ
head -c -1 $ime_tmp | xclip -selection clipboard -i
notify-send -t 1000 copied

