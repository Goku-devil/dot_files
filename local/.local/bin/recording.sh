#!/bin/bash

# Define the save directory based on XDG dirs, fallback to ~/Videos
VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}/Screencasts"
mkdir -p "$VIDEOS_DIR"

# Generate a filename with a timestamp
FILENAME="$VIDEOS_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

# Function to stop an active recording
stop_recording() {
    if pgrep wf-recorder > /dev/null; then
    
        killall -SIGINT wf-recorder
        notify-send -a "Screen Recording" -u normal "Recording Stopped" "Video saved to Screencasts folder."
    else
        notify-send -a "Screen Recording" -u low "No active recording found."
    fi
}

# Function to record the entire screen
record_fullscreen() {
    if pgrep -x "wf-recorder" > /dev/null; then
        stop_recording
    else
        notify-send -a "Screen Recording" -u normal "Recording Started" "Capturing the entire screen."
        nohup wf-recorder -c libx264 -f "$FILENAME" > /dev/null 2>&1 &
        disown
    fi
}

# Function to record a selected region
record_region() {
    if pgrep -x "wf-recorder" > /dev/null; then
        stop_recording
    else
        GEOMETRY=$(slurp)
        
        if [ -z "$GEOMETRY" ]; then
            exit 0
        fi

        notify-send -a "Screen Recording" -u normal "Recording Started" "Capturing selected region."
        nohup wf-recorder -c libx264 -g "$GEOMETRY" -f "$FILENAME" > /dev/null 2>&1 &
        disown
    fi
}

# Parse the arguments sent by SwayNC
case "$1" in
    toggle)
        case "$2" in
            fullscreen)
                record_fullscreen
                ;;
            region)
                record_region
                ;;
            *)
                echo "Usage: $0 toggle {fullscreen|region}"
                exit 1
                ;;
        esac
        ;;
    stop)
        stop_recording
        ;;
    *)
        echo "Usage: $0 {toggle fullscreen|toggle region|stop}"
        exit 1
        ;;
esac