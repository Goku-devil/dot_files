#!/bin/bash

# Initialize the starting state
MENU_STATE="main"

# Helper to open a URL in app mode when possible to avoid duplicate windows.
open_webapp() {
    local url="$1"
    if command -v firefox >/dev/null 2>&1; then
        # Creates/Runs a separate lightweight UI profile completely independent of your primary browser tabs
        firefox -P webapp --new-window "$url" >/dev/null 2>&1 &
    else
        xdg-open "$url" >/dev/null 2>&1 &
    fi
}
# Dynamic string to force a clean vertical list layout over the global grid theme
VERTICAL_THEME_STR='window {width: 330px;} listview {columns: 1; lines: 9;} element {orientation: horizontal; spacing: 12px; padding: 8px 12px;} element-text {enabled: true; horizontal-align: 0;}'
while true; do

    # ==========================================
    # 1. MAIN MENU
    # ==========================================
    if [[ "$MENU_STATE" == "main" ]]; then
        MENU_APPS="  Applications"
        MENU_WEB="󰖟  Web Apps"
        MENU_KEYS="  Keybinds"
        MENU_TERM="  Terminal"
        MENU_CODE="󰨞  VS Code"
        MENU_UTILS="  Config"
        MENU_POWER="⏻  Power Options"
        MENU_WALLPAPER="󰸉  Wallpaper" 
        MENU_THEME="󰔎  Themes"

        MAIN_OPTIONS="$MENU_APPS\n$MENU_WEB\n$MENU_UTILS\n$MENU_KEYS\n$MENU_WALLPAPER\n$MENU_THEME\n$MENU_TERM\n$MENU_CODE\n$MENU_POWER"
        
        # Enforced vertical layout overrides
        CHOICE=$(echo -e "$MAIN_OPTIONS" | rofi -dmenu -i -p "Dashboard:" -theme-str "$VERTICAL_THEME_STR")
        
        ROFI_EXIT=$?
        if [[ $ROFI_EXIT -eq 1 ]]; then
            exit 0
        fi

        case "$CHOICE" in
            "$MENU_APPS") rofi -show drun; exit 0 ;;
            "$MENU_TERM") kitty & exit 0 ;;
            "$MENU_CODE") code & exit 0 ;;
            "$MENU_WEB")  MENU_STATE="web" ;;
            "$MENU_UTILS") MENU_STATE="utils" ;;
            "$MENU_KEYS") MENU_STATE="keys" ;;
            "$MENU_POWER") MENU_STATE="power" ;;
            "$MENU_WALLPAPER") MENU_STATE="wallpaper";;
            "$MENU_THEME") MENU_STATE="theme";;
            *) exit 0 ;;
        esac

    # ==========================================
    # 2. WEB APPS SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "web" ]]; then
        WEB_OPTIONS="󰧑  Gemini\n  YouTube\n󰊫  Gmail\n  WhatsApp\n  GitHub\n  LinkedIn\n󰿎  Crunchyroll"
        
        CHOICE=$(echo -e "$WEB_OPTIONS" | rofi -dmenu -i -p "Web Apps:" -theme-str "${VERTICAL_THEME_STR//lines: 9;/lines: 7;}")
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        case "$CHOICE" in
            *YouTube*) open_webapp "https://youtube.com" ; exit 0 ;;
            *Gemini*) open_webapp "https://gemini.google.com" ; exit 0 ;;
            *Gmail*) open_webapp "https://mail.google.com" ; exit 0 ;;
            *WhatsApp*) open_webapp "https://web.whatsapp.com" ; exit 0 ;;
            *GitHub*) open_webapp "https://github.com" ; exit 0 ;;
            *LinkedIn*) open_webapp "https://linkedin.com" ; exit 0 ;;
            *Crunchyroll*) open_webapp "https://crunchyroll.com" ; exit 0 ;;
            *) MENU_STATE="main" ;;
        esac

    # ==========================================
    # 2.5 CONFIG SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "utils" ]]; then
        CFGS="  Hyprland\n  Rofi\n  Neovim\n  Waybar\n  Network Manager"
        CFG_CHOICE=$(echo -e "$CFGS" | rofi -dmenu -i -p "Edit Config:" -theme-str "${VERTICAL_THEME_STR//lines: 9;/lines: 5;}")
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        case "$CFG_CHOICE" in
            *Hyprland*) kitty nvim ~/.dotfiles/hyprland/.config/hypr/modules/keybinds.lua ; exit 0 ;;
            *Rofi*) kitty nvim ~/.config/rofi/config.rasi ; exit 0 ;;
            *Neovim*) kitty nvim ~/.config/nvim/init.lua ; exit 0 ;;
            *Waybar*) kitty nvim ~/.config/waybar/config ; exit 0 ;;
            *Network*) kitty nvim ~/.config/rofi/scripts/network_manager.sh ; exit 0 ;;
            *) MENU_STATE="main" ;;
        esac

    # ==========================================
    # 3. KEYBINDS SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "keys" ]]; then
        KEY_OPTIONS=" Open Config\n + 󰌑 : Terminal\n + Space : Menu\n + B : Browser\n + F : Files\n + C : Close Window\n + V : Toggle Floating\n + 󰘶 + S : Screenshot"
        
        CHOICE=$(echo -e "$KEY_OPTIONS" | rofi -dmenu -i -p "Shortcuts:" -theme-str "${VERTICAL_THEME_STR//lines: 9;/lines: 8;}")
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi
        
        case "$CHOICE" in
            " Open Config")
                kitty nvim ~/.config/hypr/modules/keybinds.lua 
                exit 0;
                ;;
            *) 
                exit 0 
                ;;
        esac

    # ==========================================
    # 4. POWER SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "power" ]]; then
        PWR_OPTIONS="  Lock\n󰍃  Logout\n  Reboot\n  Shutdown"
        
        CHOICE=$(echo -e "$PWR_OPTIONS" | rofi -dmenu -i -p "System:" -theme-str "${VERTICAL_THEME_STR//lines: 9;/lines: 4;}")
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        case "$CHOICE" in
            "  Lock") hyprlock; exit 0 ;; 
            "󰍃  Logout") hyprctl dispatch 'hl.dsp.exit()'; exit 0 ;; 
            "  Reboot") systemctl reboot; exit 0 ;;
            "  Shutdown") systemctl poweroff; exit 0 ;;
            *) exit 0 ;;
        esac

    # ==========================================
    # 5. WALLPAPER PICKER
    # ==========================================
    elif [[ "$MENU_STATE" == "wallpaper" ]]; then
        ~/.config/rofi/scripts/wallpaper.sh
        exit 0

    # ==========================================
    # 6. THEMES SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "theme" ]]; then
        ~/.config/rofi/scripts/theme_switcher.sh
        exit 0
    fi

done
