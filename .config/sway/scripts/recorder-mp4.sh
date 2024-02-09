#!/bin/bash -u

if [ -z $(ps aux | grep -v grep | grep wf-recorder) ]; then
  notify-send -t 1000 "Start mp4 recording"
  wf-recorder -g "$(slurp)" -F fps=30 -f $HOME/$(date "+%Y%m%d-%H%M%S-%N").mp4
else
  killall -s SIGINT -e wf-recorder
  notify-send -t 1000 "Stop mp4 recording"
fi

