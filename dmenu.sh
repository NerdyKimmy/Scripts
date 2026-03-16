#!/usr/bin/bash

export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Load pywal colors
[ -f "${HOME}/.cache/wal/colors.sh" ] && . "${HOME}/.cache/wal/colors.sh"

FONT="JetBrainsMono Nerd Font:size=12"
COLORS="-nb $color0 -nf $color7 -sb $color2 -sf $color0"
APP_DIR="${HOME}/.local/share/applications/selected"

# Styled menu function
menu() {
    dmenu -i -c -bw 3 -fn "$FONT" $COLORS "$@"
}

# 1. List .desktop files
# 2. Remove directory path and extension for display
# 3. Pipe to styled dmenu
choice=$(ls "$APP_DIR"/*.desktop | xargs -n 1 basename -s .desktop | menu -l 10)

if [ -n "$choice" ]; then
    # Construct path to selected desktop file
    desktop_file="$APP_DIR/$choice.desktop"
    
    # Extract Exec line, remove field codes (%u, %f, etc.), and run
    exec_cmd=$(grep '^Exec=' "$desktop_file" | head -1 | sed 's/^Exec=//;s/ %[a-zA-Z]//g')
    
    eval "$exec_cmd &"
fi
