#!/bin/sh

doas /usr/bin/btmon | stdbuf -oL awk '
  /HCI Event: Connect Complete/ { event="c" }
  /HCI Event: Disconnect Complete/ { event="d" }
  /Address:/ { 
    if (event != "") { 
      print event, $2
      fflush() # Ensure the loop gets the data immediately
      event="" 
    } 
  }
' | while read -r type mac; do
    if [ "$type" = "c" ]; then
        (
            sleep 2
            NAME=$(bluetoothctl info "$mac" | sed -n 's/^[[:space:]]*Name: //p')
            
            [ -z "$NAME" ] && NAME="Device"
            MSG="Connected: $NAME"
            
            notify-send -u low "Bluetooth" "$MSG" -i bluetooth-active
        ) &
    else
        notify-send -u low "Bluetooth" "Device disconnected" -i bluetooth-disabled
    fi
done
