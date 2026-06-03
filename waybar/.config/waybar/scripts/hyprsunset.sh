#!/bin/bash

# Define your preferred color temperature (lower = warmer/more orange)
TEMP=4000 

# If the "toggle" argument is passed, turn it on/off
if [ "$1" == "toggle" ]; then
    if pgrep -x "hyprsunset" > /dev/null; then
        pkill -x hyprsunset
    else
        hyprsunset -t $TEMP &
    fi
    exit 0
fi

# Check status and output JSON for Waybar
if pgrep -x "hyprsunset" > /dev/null; then
    # Eye protection is ON
    echo '{"text": "", "tooltip": "Eye Protection: ON", "class": "on"}'
else
    # Eye protection is OFF
    echo '{"text": "", "tooltip": "Eye Protection: OFF", "class": "off"}'
fi
