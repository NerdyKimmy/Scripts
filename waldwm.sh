#!/bin/yash

DWM_DIR="$HOME/dwm"
ST_DIR="$HOME/st"

ln -sf "$HOME/.cache/wal/colors-wal-dwm.h" "$DWM_DIR/colors-wal-dwm.h"
ln -sf "$HOME/.cache/wal/colors-wal-st.h" "$ST_DIR/colors-wal-st.h"

cd "$DWM_DIR" && make clean install
cd "$ST_DIR" && make clean install

pkill bar.sh
pkill dunst
pkill dwm
