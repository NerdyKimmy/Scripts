#!/usr/bin/bash
playerctl play-pause
artist=$(playerctl metadata artist)
title=$(playerctl metadata title)
stat=$(playerctl status)
notify-send "$stat" "$title"
