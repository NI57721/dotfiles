#!/bin/bash -eu

ActiveMonitors=($(swaymsg -t get_outputs | jq -r '.[] | select(.dpms and .active) | .name'))
CurrentMonitor=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).output')
CurrentWorkspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
MonitorCount=${#ActiveMonitors[@]}

for ((i=0; i<$MonitorCount; i++)); do
  if [ "${ActiveMonitors[i]}" = "$CurrentMonitor" ]; then
    swaymsg [workspace=$CurrentWorkspace] move workspace to output ${ActiveMonitors[$(((i + 1) % $MonitorCount))]}
    break
  fi
done

