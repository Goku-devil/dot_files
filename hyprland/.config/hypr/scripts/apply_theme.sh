#!/bin/bash
theme=$1

if [[ -z "$theme" ]]; then
    exit 1
fi

# 1. Write the state so Lua and Bash know what to load
echo "$theme" > ~/.config/hypr/.theme_state

# 2. Swap Symlinks
ln -sf ~/.config/waybar/${theme}.css ~/.config/waybar/style.css
ln -sf ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/colors.rasi
ln -sf ~/.config/swaync/themes/${theme}.css ~/.config/swaync/theme.css
ln -sf ~/.config/kitty/themes/${theme}.conf ~/.config/kitty/theme.conf
ln -sf ~/.config/wlogout/themes/${theme}.css ~/.config/wlogout/style.css

cat ~/.config/swaync/themes/${theme}.css ~/.config/swaync/base.css > ~/.config/swaync/style.css

# 3. Restart Daemons Safely
pkill -9 waybar
sleep 0.2
waybar > /dev/null 2>&1 &

# Kitty hot-reload (updates open terminals)
killall -SIGUSR1 kitty

# Hard restart SwayNC so Hyprland catches the transparent layers
killall swaync
swaync-client -rs
sleep 0.2
swaync > /dev/null 2>&1 &

# Apply Wallpaper
awww img ~/Wallpapers/${theme}/${theme}.png --transition-type wipe

# Give SwayNC a half-second to fully render its invisible layers
sleep 0.5 

# 5. Tell Hyprland to reload config files
hyprctl reload

notify-send "Theme Switched" "${theme^}"
