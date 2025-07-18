#!/bin/bash -eu

wtype -M ctrl l -s 50 -k insert -k escape
swaymsg [app_id="^MainTerminal$"] focus
wtype -M alt o -m alt -s 100 vim\  -M shift -k insert -m shift -s 50 -k return

