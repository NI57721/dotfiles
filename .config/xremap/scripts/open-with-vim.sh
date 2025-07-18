#!/bin/bash -eu

wtype -M ctrl l -s 50 -k insert -k escape
swaymsg [app_id="^org\.wezfurlong\.wezterm$"] focus
wezterm cli spawn -- vim $(wl-paste)

