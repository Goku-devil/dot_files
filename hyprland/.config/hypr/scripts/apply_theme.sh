#!/bin/bash

# Default to "nord" if no argument is passed to prevent empty variables
theme="${1:-nord}"

# 1. Write the state so Lua and Bash know what to load
echo "$theme" > ~/.config/hypr/.theme_state
echo "$theme" > ~/.config/nvim/theme.txt

# 2. Swap Symlinks (Use full paths or $HOME to be completely safe)
ln -sf "$HOME/.config/waybar/themes/${theme}.css" "$HOME/.config/waybar/style.css"
ln -sf "$HOME/.config/rofi/themes/${theme}.rasi" "$HOME/.config/rofi/colors.rasi"
ln -sf "$HOME/.config/swaync/themes/${theme}.css" "$HOME/.config/swaync/theme.css"
ln -sf "$HOME/.config/kitty/themes/${theme}.conf" "$HOME/.config/kitty/theme.conf"
ln -sf "$HOME/.config/wlogout/themes/${theme}.css" "$HOME/.config/wlogout/style.css"

# Concatenate SwayNC CSS
cat "$HOME/.config/swaync/themes/${theme}.css" "$HOME/.config/swaync/base.css" > "$HOME/.config/swaync/style.css"

# 3. Restart Daemons Safely
# Waybar
killall waybar
waybar > /dev/null 2>&1 &

# Kitty hot-reload (updates open terminals)
killall -SIGUSR1 kitty

# SwayNC (Just kill and restart, letting it load the newly generated style.css)
killall swaync
sleep 0.2
swaync > /dev/null 2>&1 &

# Apply Wallpaper (Fixed awww typo)
# Ensure the daemon is running first, then apply image
if command -v awww >/dev/null 2>&1; then
    awww query || awww-daemon &
    sleep 0.2
    awww img "$HOME/Wallpapers/${theme}/${theme}.png" --transition-type wipe
fi

# Give SwayNC a half-second to fully render its invisible layers
sleep 0.5 

# 5. Tell Hyprland to reload config files
hyprctl reload

notify-send "Theme Switched" "${theme^}"