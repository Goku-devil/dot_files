#!/bin/bash
options="󰄛  Catppuccin Mocha\n󰐊  Evergreen (Everforest)\n󰏘  Tokyo Night"
choice=$(echo -e "$options" | rofi -dmenu -i -p "Select Theme" -theme ~/.config/rofi/config.rasi)

if [[ -z "$choice" ]]; then
    exit 0
fi

case "$choice" in
    *Catppuccin*) theme="catppuccin" ;;
    *Evergreen*)  theme="evergreen" ;;
    *Tokyo*)      theme="tokyonight" ;;
    *)            exit 0 ;;
esac

~/.config/hypr/scripts/apply_theme.sh "$theme" &
