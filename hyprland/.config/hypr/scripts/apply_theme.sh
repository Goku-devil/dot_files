#!/bin/bash
theme=$1

if [[ -z "$theme" ]]; then
    exit 1
fi

# 1. Write the state so Lua knows what to load
echo "$theme" > ~/.config/hypr/.theme_state

# 2. Swap Symlinks
ln -sf ~/.config/waybar/${theme}.css ~/.config/waybar/style.css
ln -sf ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/colors.rasi
ln -sf ~/.config/kitty/themes/${theme}.conf ~/.config/kitty/theme.conf
ln -sf ~/.config/wlogout/themes/${theme}.css ~/.config/wlogout/style.css

# 3. Restart Daemons Safely
pkill -9 waybar
sleep 0.2
waybar > /dev/null 2>&1 &
awww img ~/Wallpapers/${theme}/${theme}.png --transition-type wipe

# 4. Tell Hyprland to reload (This triggers Lua to safely read the new state)
hyprctl reload
notify-send "Theme Switched" "${theme^}"