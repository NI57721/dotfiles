#!/bin/bash -u

FloatingVim=$(swaymsg -t get_tree | jq -c '.. | .floating_nodes? | arrays[] | select(.app_id == "FloatingVim")')

if [ -z $FloatingVim ]; then
  wezterm \
    --config initial_rows=18 \
    --config initial_cols=55 \
    --config enable_tab_bar=false \
    --config window_background_opacity=0.4 \
    --config text_background_opacity=0.7 \
    start --class FloatingVim vim -c ":IM" /var/tmp/ime-vim
else
  if [ "$(echo $FloatingVim | jq .focused)" = true ]; then
    wtype -k escape 0y$ -s 80
    swaymsg "move window to scratchpad"
    wtype -M shift -k insert
  else
    swaymsg '[app_id="FloatingVim"] focus'
  fi
fi

