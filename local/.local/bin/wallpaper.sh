#!/usr/bin/env bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/Wallpaper/walls-catppuccin-mocha"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Picker" "Error: Directory $WALLPAPER_DIR not found."
    exit 1
fi

# --- Generate Rofi Menu with Previews ---
# We use a function to print the filename and the hidden icon path
get_wallpapers() {
    for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,webp}; do
        # Skip if no files match
        [ -e "$file" ] || continue
        
        # Get just the file name
        basename=$(basename "$file")
        
        # Print format: "Filename\0icon\x1f/path/to/image.jpg\n"
        printf "%s\0icon\x1f%s\n" "$basename" "$file"
    done
}

# --- Rofi Grid Layout ---
ROFI_THEME='
window {
    width: 800px; /* FIX: Widened to prevent 3rd column truncation */
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
}
element-icon {
    size: 180px;
    cursor: pointer;
    horizontal-align: 0.5; /* Centers the image inside the column */
}
element-text {
    horizontal-align: 0.5; /* Centers the text below the image */
}'

# Pipe the formatted list into rofi
SELECTED=$(get_wallpapers | rofi -dmenu -i -p "󰸉 Wallpapers" -show-icons -theme-str "$ROFI_THEME")

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"

# --- Apply Wallpaper ---
# Using awww (or swww depending on what you installed)
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$WALLPAPER_PATH" \
    --transition-type grow \
    --transition-pos top-right \
    --transition-duration 1.5

notify-send "Wallpaper Applied" "Set to: $SELECTED"

