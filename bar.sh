#!/bin/dash

fifo="/tmp/dwmbar.fifo"
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"
exec 3<>"$fifo"

trap 'pkill -P $$ 2>/dev/null; rm "$fifo" 2>/dev/null; exit' EXIT TERM INT
trap 'pkill -P $$' EXIT


pkill -f "pactl subscribe" 2>/dev/null
pkill -f "playerctl status" 2>/dev/null


# --- 1. МИТТЄВА РОЗКЛАДКА (Fast Polling) ---
# Окремий процес, який стежить ТІЛЬКИ за мовою кожні 0.1 сек.
# Він пише у FIFO лише тоді, коли мова реально змінилася.
(
    last_key=""
    while :; do
        curr_key=$(xset -q | awk '/LED/{print ($10=="00000000"?"En":"Ua")}')
        if [ "$curr_key" != "$last_key" ]; then
            echo "KEY$curr_key" >&3
            last_key="$curr_key"
        fi
        sleep 0.1
    done
) &

# --- 2. МИТТЄВИЙ ГУЧНОМОВЕЦЬ (Event-based) ---
# Використовує підписку на події PulseAudio/Pipewire.
(
    get_vol() {
        if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then
            echo "VOL♬˖.✦M" >&3
        else
            vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
            echo "VOL♬˖°$vol" >&3
        fi
    }
    get_vol
    pactl subscribe | while read -r event; do
        case "$event" in *'sink'*) get_vol ;; esac
    done
) &

# --- 3. ЕКОНОМНИЙ ТАЙМЕР (Battery & Date) ---
# Оновлюється раз на хвилину для ThinkPad E14.
(
    while :; do
        if [ -d /sys/class/power_supply/BAT0 ]; then
            read -r cap < /sys/class/power_supply/BAT0/capacity
            read -r stat < /sys/class/power_supply/BAT0/status
            if [ "$stat" = "Charging" ]; then bat="BAT✿✦${cap}%"
            elif [ "$cap" -eq 100 ]; then bat="BAT˚✿˖°"
            else bat="BAT✿ ${cap}%"; fi
            echo "$bat" >&3
        fi
        echo "DAT$(date +'%m.%d %H:%M')" >&3
        sleep 60
    done
) &

(
    echo "✿ Enjoying the Silence ✿" > /tmp/dwm_music
    echo "MUS✿ Enjoying the Silence ✿" >&3

    playerctl metadata --format '{{ artist }} - {{ title }}' --follow 2>/dev/null | while read -r line; do
        if [ -z "$line" ]; then
            msg="✿ Enjoying the Silence ✿"
        else
            msg=$(echo "$line" | cut -c1-128)
        fi
        
        echo "$msg" > /tmp/dwm_music
        echo "MUS$msg" >&3
    done
) &

# --- 4. ЗБІРКА СТАТУСУ ---
while read -r line <&3; do
    case "$line" in
        DAT*) date="${line#???}" ;;
        VOL*) volume="${line#???}" ;;
        BAT*) battery="${line#???}" ;;
        KEY*) key="${line#???}" ;;
        MUS*) music="${line#???}" ;;
    esac
    # Пишемо результат у файл для OXWM
    echo " $music | $key | $volume | $battery | $date " > /tmp/oxwm_status
done
