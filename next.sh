#!/usr/bin/bash
playerctl next
sleep 1
artist=$(playerctl metadata artist)
title=$(playerctl metadata title)
stat=$(playerctl status)
notify-send "$stat next" "$title"
