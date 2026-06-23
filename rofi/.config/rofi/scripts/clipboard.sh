#!/usr/bin/env bash

CLEAR_ID="clear_history"
CLEAR_TEXT="󰃐  Clear History"
CLEAR_OPTION="$CLEAR_ID\t$CLEAR_TEXT"

# Fetch the current clipboard history
HISTORY=$(cliphist list)

# Check if the clipboard history is empty
if [ -z "$HISTORY" ]; then
    notify-send -t 2000 "Clipboard" "Clipboard history is already empty."
    exit 0
fi

# 1. Combine the custom clear option with the actual history
selected=$(printf "%b\n%s" "$CLEAR_OPTION" "$HISTORY" | rofi -dmenu -display-columns 2 -theme-str 'window {width : 350px;}' -p "󰅌 Copy")

# If the user selected nothing (pressed Escape), exit
if [ -z "$selected" ]; then
    exit 0
fi

# Check if the user selected the "Clear History" option
if echo "$selected" | grep -q "^$CLEAR_ID"; then
    cliphist wipe
    notify-send -t 1500 "Clipboard" "Clipboard history cleared!"
else
    echo "$selected" | cliphist decode | wl-copy
    notify-send -t 1500 "Clipboard" "Item copied and ready to paste!"
fi
