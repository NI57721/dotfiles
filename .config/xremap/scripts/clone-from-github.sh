#!/bin/bash -eu

MAIN_WEZTERM_PID=$(swaymsg -t get_tree | jq '.. | objects | select(.app_id? == "MainTerminal") | .pid')
export WEZTERM_UNIX_SOCKET=/run/user/$(id -u)/wezterm/gui-sock-$MAIN_WEZTERM_PID

wtype -M ctrl l -s 50 -k insert -k escape
user=$(wl-paste | sed -r "s@https://github\.com/([^/?]+).*@\1@")
repository=$(wl-paste | sed -r "s@https://github\.com/[^/]+/([^/?]+).*@\1@")

if [ -z "$user" ] || [ -z "$repository" ]; then
  exit
fi

git clone git@github.com:$user/$repository ~/dev/$repository &
wezterm cli spawn --cwd ~/dev/$repository -- fish
swaymsg [app_id="^MainTerminal$"] focus

