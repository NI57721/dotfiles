#!/bin/bash -eu

wtype -M ctrl l -s 50 -k insert -k escape
swaymsg [app_id="^org\.wezfurlong\.wezterm$"] focus
wezterm cli spawn -- fish -c "cd ~/dev; git clone git@github.com:$(wl-paste | sed -r "s@https://github\.com/([^/]+/[^/]+).*@\1@")"

