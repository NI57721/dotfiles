#!/bin/bash -eu

MAIN_WEZTERM_PID=$(swaymsg -t get_tree | jq '.. | objects | select(.app_id? == "MainTerminal") | .pid')
export WEZTERM_UNIX_SOCKET=/run/user/$(id -u)/wezterm/gui-sock-$MAIN_WEZTERM_PID

wtype -M ctrl l -s 50 -k insert -k escape
wezterm cli spawn -- vim $(wl-paste)
swaymsg [app_id="^MainTerminal$"] focus

