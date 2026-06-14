#!/bin/bash

# 1. Read the current theme from your Hyprland engine
current_theme=$(cat ~/.config/hypr/.theme_state 2>/dev/null || echo "nord")

# 2. Define the dynamic Active color based on the current theme
# This maps the tag to the specific accent color of the running theme
case "$current_theme" in
    "catppuccin") active_color="#cba6f7" ;; # Mauve
    "evergreen")  active_color="#a7c080" ;; # Green
    "tokyonight") active_color="#7aa2f7" ;; # Blue
    "rosepine")   active_color="#c4a7e7" ;; # Iris
    "nord")       active_color="#88c0d0" ;; # Frost Blue
    *)            active_color="#cdd6f4" ;; # Default Text
esac

# 3. Create the badge with the dynamic color
active_badge="<span size='small' style='italic' color='$active_color'>[Active]</span>"

# 4. Define the base options
opt1="󰄛  Catppuccin Mocha"
opt2="󰐊  Evergreen"
opt3="󰏘  Tokyo Night"
opt4="󰀱  Rosé Pine"
opt5="  Nord"

# 5. Inject the [Active] tag
if [[ "$current_theme" == "catppuccin" ]]; then opt1="󰄛  Catppuccin Mocha   $active_badge"; fi
if [[ "$current_theme" == "evergreen" ]]; then opt2="󰐊  Evergreen (Everforest)   $active_badge"; fi
if [[ "$current_theme" == "tokyonight" ]]; then opt3="󰏘  Tokyo Night   $active_badge"; fi
if [[ "$current_theme" == "rosepine" ]]; then opt4="󰀱  Rosé Pine   $active_badge"; fi
if [[ "$current_theme" == "nord" ]]; then opt5="  Nord   $active_badge"; fi

# 6. Build the final menu
options="$opt1\n$opt2\n$opt3\n$opt4\n$opt5"

# 7. Launch Rofi with layout overrides to restore text display and alignment
choice=$(echo -e "$options" | rofi -dmenu -i -markup-rows -p "Select Theme" \
-theme-str 'window {width: 350px;} listview {columns: 1; lines: 5;} element {orientation: horizontal; spacing: 12px; padding: 8px 12px;} element-text {enabled: true; horizontal-align: 0;}' \
-theme ~/.config/rofi/config.rasi)
if [[ -z "$choice" ]]; then
    exit 0
fi

# 8. Process the choice
case "$choice" in
    *Catppuccin*)  theme="catppuccin" ;;
    *Evergreen*)   theme="evergreen" ;;
    *Tokyo*)       theme="tokyonight" ;;
    *Rosé*|*Rose*) theme="rosepine" ;;
    *Nord*)        theme="nord" ;;
    *)             exit 0 ;;
esac

~/.config/hypr/scripts/apply_theme.sh "$theme" &
