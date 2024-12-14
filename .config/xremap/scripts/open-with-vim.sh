#!/bin/bash -eu

wtype -M ctrl l -s 50 -P insert -p insert -P escape -p escape
swaymsg [app_id="^org\.wezfurlong\.wezterm$"] focus
wezterm cli spawn -- vim $(wl-paste)

