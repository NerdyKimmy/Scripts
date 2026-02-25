#!/usr/bin/bash

export LANG=C.UTF-8
export LC_ALL=C.UTF-8
. "${HOME}/.cache/wal/colors.sh"
FONT="JetBrainsMono Nerd Font:size=12"
COLORS="-nb $color0 -nf $color7 -sb $color2 -sf $color0"

menu() {
    dmenu -i -c -bw 3 -fn "$FONT" $COLORS "$@"
}

choice=$(printf "zzz\nreboot\nshutdown" | menu -l 4 )

case "$choice" in
    zzz)
    ${HOME}/.local/share/scripts/lockf.sh &
	sleep 1 
	doas /usr/bin/zzz 
        ;;
    reboot)
    doas /sbin/reboot
        ;;
    shutdown)
    doas /sbin/poweroff
        ;;
    *)
        exit 0
        ;;
esac
