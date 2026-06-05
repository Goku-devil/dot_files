#!/usr/bin/env bash

# --- 1. Read Current Theme State ---
THEME=$(cat ~/.config/hypr/.theme_state 2>/dev/null || echo "catppuccin")

# --- 2. Dynamic Directory ---
WALLPAPER_DIR="$HOME/Wallpapers/$THEME"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Picker" "Error: Directory $WALLPAPER_DIR not found."
    exit 1
fi

# --- 3. Generate Rofi Menu with Previews ---
get_wallpapers() {
    for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif,webp}; do
        [ -e "$file" ] || continue
        basename=$(basename "$file")
        # Print format: "Filename\0icon\x1f/path/to/image.jpg\n"
        printf "%s\0icon\x1f%s\n" "$basename" "$file"
    done
}

# --- 4. Rofi Horizontal Gallery Layout ---
# --- 4. Rofi Grid Gallery Layout ---
ROFI_THEME='
@import "~/.config/rofi/colors.rasi"

* {
    background-color: transparent;
    text-color: @fg-base;
    font: "JetBrainsMono Nerd Font 10"; /* Slightly smaller font to help long names */
}
window {
    width: 1000px; 
    background-color: @bg-base;
    border: 2px solid;
    border-color: @accent-lavender; 
    border-radius: 16px;
    padding: 20px;
}
inputbar {
    background-color: @bg-alt;
    padding: 12px 20px;
    border-radius: 12px;
    margin: 0px 0px 20px 0px;
}
prompt {
    text-color: @accent-lavender;
    font: "JetBrainsMono Nerd Font Bold 12";
    margin: 0px 15px 0px 0px;
}
entry {
    placeholder: "Search Wallpapers...";
    placeholder-color: @fg-muted;
    text-color: @fg-base;
}
listview {
    columns: 4;          /* Force exactly 4 columns across */
    lines: 1;            /* Force 1 row down */
    spacing: 20px;
    fixed-columns: true; /* STRICT RULE: Do not let long text stretch the box */
    fixed-height: true;
}
element {
    orientation: vertical;
    padding: 15px;
    border-radius: 12px;
}
element selected {
    background-color: @bg-surface;
    border: 2px solid;
    border-color: @accent-lavender;
}
element-icon {
    size: 180px;         /* Scaled down slightly to fit the strict columns */
    cursor: pointer;
    horizontal-align: 0.5;
}
element-text {
    horizontal-align: 0.5;
    margin: 10px 0px 0px 0px;
}'
# --- 5. Launch Rofi ---
SELECTED=$(get_wallpapers | rofi -dmenu -i -p "󰸉 Wallpapers" -show-icons -theme-str "$ROFI_THEME")

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"

# --- 6. Apply Wallpaper ---
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$WALLPAPER_PATH" \
    --transition-type grow \
    --transition-pos top-right \
    --transition-duration 1.5

notify-send "Wallpaper Applied" "Set to: $SELECTED"
