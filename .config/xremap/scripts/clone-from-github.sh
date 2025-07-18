#!/bin/bash -eu

wtype -M ctrl l -s 50 -k insert -k escape
swaymsg [app_id="^MainTerminal$"] focus
user=$(wl-paste | sed -r "s@https://github\.com/([^/]+).*@\1@")
repository=$(wl-paste | sed -r "s@https://github\.com/[^/]+/([^/]+).*@\1@")
wtype -M alt o -m alt -s 100 cd \~/dev\; git clone git@github.com:$user/$repository\; \~/dev/$repository -k return

