#!/usr/bin/bash
playerctl previous
sleep 1
artist=$(playerctl metadata artist)
title=$(playerctl metadata title)
stat=$(playerctl status)
notify-send "$stat previous" "$title"
