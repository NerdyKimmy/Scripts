#!/usr/bin/env yash

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
    	${HOME}/.local/share/scripts/lock.sh &
	sleep 1 &
	doas /usr/bin/zzz 
        ;;
    reboot)
        dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" \
            /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart
        ;;
    shutdown)
        dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" \
            /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
        ;;
    *)
        exit 0
        ;;
esac
