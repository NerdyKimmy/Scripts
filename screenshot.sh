#!/bin/sh

SCREENSHOTS_DIR="$HOME/Images/Screenshots"
FILENAME="$(date +%Y-%m-%d--%H-%M-%S).png"
FILE_PATH="$SCREENSHOTS_DIR/$FILENAME"

mkdir -p "$SCREENSHOTS_DIR"


if scrot -s "$FILE_PATH"; then
    xclip -selection clipboard -t image/png -i "$FILE_PATH"
    notify-send "Screenshot Captured" "Saved to $FILE_PATH and copied to clipboard."
else
	notify-send "Screenshot Capturing Canceled" "Nothing was'nt saved."
fi

