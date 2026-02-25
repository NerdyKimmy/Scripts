#!/bin/sh
playerctl pause
if pgrep -x "i3lock" > /dev/null; then
    exit 0
fi

(
    sleep 120
    if pgrep -x "i3lock" > /dev/null; then
        xset dpms force off
        doas /usr/bin/zzz
    fi
) &

IMAGE="/home/aliisa/Images/lockcat.jpg"
#IMAGE="/home/allie/Images/lock.jpg"
#IMAGE="/home/allie/Images/mizu2d.png"
BLANK='#00000000'
TEXT='#ffffffff' 

i3lock \
--image=$IMAGE \
--fill \
--clock \
--time-str="%H:%M" \
--date-str="%A, %d %B" \
--time-color=$TEXT \
--date-color=$TEXT \
--time-size=72 \
--date-size=20 \
--time-font="Ubuntu" \
--date-font="Ubuntu" \
--inside-color=$BLANK \
--ring-color=$BLANK \
--line-color=$BLANK \
--separator-color=$BLANK \
--insidever-color=$BLANK \
--insidewrong-color=$BLANK \
--ringver-color=$BLANK \
--ringwrong-color=$BLANK \
--verif-color=$BLANK \
--wrong-color=$BLANK \
--keyhl-color=$TEXT \
--bshl-color=$TEXT \
--no-modkey-text \
--verif-text="Verifying..." \
--wrong-text="Wrong!" \
--verif-color=$TEXT \
--wrong-color=$TEXT \
--noinput-text="" \
--radius=120 \
--ring-width=4 \
--nofork

