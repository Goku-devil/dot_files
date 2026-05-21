#!/usr/bin/env bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/Wallpapers/walls-catppuccin-mocha"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Picker" "Error: Directory $WALLPAPER_DIR not found."
    exit 1
fi

# --- Generate Rofi Menu with Previews ---
get_wallpapers() {
    for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,webp}; do
        [ -e "$file" ] || continue
        basename=$(basename "$file")
        # Print format: "Filename\0icon\x1f/path/to/image.jpg\n"
        printf "%s\0icon\x1f%s\n" "$basename" "$file"
    done
}

# --- Rofi Grid Layout (Catppuccin Mocha - Blue Tone) ---
ROFI_THEME='
* {
    /* Core mocha colors */
    bg-base: #1e1e2e;
    bg-mantle: #181825;
    bg-surface: #313244;
    fg-text: #cdd6f4;
    
    /* BLUE ACCENT */
    accent-blue: #89b4fa;
    
    background-color: transparent;
    text-color: @fg-text;
    font: "JetBrainsMono Nerd Font 11";
}
window {
    width: 820px; 
    background-color: @bg-base;
    border: 2px solid;
    border-color: @accent-blue; /* Blue border */
    border-radius: 12px;
    padding: 15px;
}
inputbar {
    background-color: @bg-mantle;
    padding: 10px 15px;
    border-radius: 8px;
    margin: 0px 0px 15px 0px;
}
prompt {
    text-color: @accent-blue; /* Blue prompt icon/text */
    font: "JetBrainsMono Nerd Font Bold 12";
    margin: 0px 10px 0px 0px;
}
entry {
    placeholder: "Search Wallpapers...";
    placeholder-color: #a6adc8;
}
listview {
    columns: 3;
    lines: 2;
    spacing: 15px;
    fixed-columns: true;
}
element {
    orientation: vertical;
    padding: 10px;
    border-radius: 2px;
}
element selected {
    background-color: @bg-surface;
    border: 1px solid;
    border-color: @accent-blue; /* Blue highlight border */
}
element-icon {
    size: 200px;
    cursor: pointer;
    horizontal-align: 0.5;
}
element-text {
    horizontal-align: 0.5;
    margin: 5px 0px 0px 0px;
}'

# Pipe the formatted list into rofi
SELECTED=$(get_wallpapers | rofi -dmenu -i -p "󰸉 Wallpapers" -show-icons -theme-str "$ROFI_THEME")

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"

# --- Apply Wallpaper ---
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$WALLPAPER_PATH" \
    --transition-type grow \
    --transition-pos top-right \
    --transition-duration 1.5

notify-send "Wallpaper Applied" "Set to: $SELECTED"
