
#!/bin/bash

# Initialize the starting state
MENU_STATE="main"

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
        MENU_POWER="⏻  Power Options"
        MENU_WALLPAPER="󰸉  Wallpaper" 
        MENU_THEME="󰔎  Themes"

        # Added MENU_THEME to the list
        MAIN_OPTIONS="$MENU_APPS\n$MENU_WEB\n$MENU_KEYS\n$MENU_WALLPAPER\n$MENU_THEME\n$MENU_TERM\n$MENU_CODE\n$MENU_POWER"
        
        # Width shrunk to 350px
        CHOICE=$(echo -e "$MAIN_OPTIONS" | rofi -dmenu -i -p "Dashboard:" -theme-str 'window {width: 350px;}')
        
        # Capture the exit code (1 means user pressed Escape)
        ROFI_EXIT=$?
        if [[ $ROFI_EXIT -eq 1 ]]; then
            exit 0
        fi

        # Logic for Main Menu
        case "$CHOICE" in
            "$MENU_APPS") rofi -show drun; exit 0 ;;
            "$MENU_TERM") kitty & exit 0 ;;
            "$MENU_CODE") code & exit 0 ;;
            "$MENU_WEB")  MENU_STATE="web" ;;
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
        
        CHOICE=$(echo -e "$WEB_OPTIONS" | rofi -dmenu -i -p "Web Apps:" -theme-str 'window {width: 350px;}')
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        case "$CHOICE" in
            "  YouTube") google-chrome-stable --app="https://youtube.com" & exit 0 ;;
            "󰧑  Gemini") google-chrome-stable --app="https://gemini.google.com" & exit 0 ;;
            "󰊫  Gmail") google-chrome-stable --app="https://mail.google.com" & exit 0 ;;
            "  WhatsApp") google-chrome-stable --app="https://web.whatsapp.com" & exit 0 ;;
            "  GitHub") google-chrome-stable --app="https://github.com" & exit 0 ;;
            "  LinkedIn") google-chrome-stable --app="https://linkedin.com" & exit 0 ;;
            "󰿎  Crunchyroll") google-chrome-stable --app="https://crunchyroll.com" & exit 0 ;;
            *) exit 0 ;;
        esac

    # ==========================================
    # 3. KEYBINDS SUB-MENU
    # ==========================================
    elif [[ "$MENU_STATE" == "keys" ]]; then
        KEY_OPTIONS=" Open Config\n + 󰌑 : Terminal\n + Space : Menu\n + B : Browser\n + F : Files\n + C : Close Window\n + V : Toggle Floating\n + 󰘶 + S : Screenshot"
        
        CHOICE=$(echo -e "$KEY_OPTIONS" | rofi -dmenu -i -p "Shortcuts:" -theme-str 'window {width: 320px;}')
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi
        
        case "$CHOICE" in
            "Open Config")
                kitty nvim ~/.config/hypr/modules/keybinds.lua &
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
        
        CHOICE=$(echo -e "$PWR_OPTIONS" | rofi -dmenu -i -p "System:" -theme-str 'window {width: 350px;}')
        ROFI_EXIT=$?

        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        case "$CHOICE" in
            "  Lock") hyprlock; exit 0 ;; 
            "󰍃  Logout") hyprctl dispatch exit; exit 0 ;; 
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
        THEME_OPTIONS="󰄛  Catppuccin Mocha\n󰐊  Evergreen (Everforest)\n󰏘  Tokyo Night"
        
        CHOICE=$(echo -e "$THEME_OPTIONS" | rofi -dmenu -i -p "Select Theme:" -theme-str 'window {width: 350px;}')
        ROFI_EXIT=$?

        # If user presses Escape, return to main
        if [[ $ROFI_EXIT -eq 1 ]]; then
            MENU_STATE="main"
            continue
        fi

        # Pass the selection directly to your master apply engine
        case "$CHOICE" in
            *Catppuccin*) ~/.config/hypr/scripts/apply_theme.sh "catppuccin" & exit 0 ;;
            *Evergreen*)  ~/.config/hypr/scripts/apply_theme.sh "evergreen" & exit 0 ;;
            *Tokyo*)      ~/.config/hypr/scripts/apply_theme.sh "tokyonight" & exit 0 ;;
            *) exit 0 ;;
        esac
    fi

done