#!/bin/bash -u

FloatingVim=$(swaymsg -t get_tree | jq -c '.. | .floating_nodes? | arrays[] | select(.app_id=="FloatingVim")')

if [ -z $FloatingVim ]; then
  wezterm \
    --config initial_rows=20 \
    --config initial_cols=60 \
    --config enable_tab_bar=false \
    --config window_background_opacity=0.4 \
    --config text_background_opacity=0.7 \
    start --class FloatingVim fish
else
  if [ "$(echo $FloatingVim | jq .focused)" = true ]; then
    swaymsg "move window to scratchpad"
  else
    swaymsg "[app_id=\"FloatingVim\"] focus"
  fi
fi

