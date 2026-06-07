#!/usr/bin/env bash

# --- 1. CALCULATE INTERNET SPEED (0.5s delay) ---
# Find the active interface (eth or wlan)
interface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')
if [ -n "$interface" ]; then
    rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    sleep 0.5
    rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    # Calculate KB/s (multiply by 2 because we only waited 0.5 seconds)
    rx_speed=$(((rx2 - rx1) / 512)) 
    tx_speed=$(((tx2 - tx1) / 512))
    speed_msg="󰓢 Speed: ↓ ${rx_speed} KB/s  |  ↑ ${tx_speed} KB/s"
else
    speed_msg="󰓢 Speed: Offline"
fi

# --- 2. GATHER NETWORK STATES ---
# Ethernet State
eth_state=$(nmcli -t -f TYPE,STATE dev | grep ethernet | head -n1 | awk -F':' '{print $2}')
if [ "$eth_state" = "connected" ]; then
    eth_toggle="󰈀  Disconnect Ethernet"
else
    eth_toggle="󰈀  Connect Ethernet"
fi

# Wi-Fi State
wifi_state=$(nmcli radio wifi)
if [ "$wifi_state" = "enabled" ]; then
    wifi_toggle="󰖩  Disable Wi-Fi"
else
    wifi_toggle="󰖪  Enable Wi-Fi"
fi

# --- 3. FORMAT WI-FI LIST CLEANLY ---
# Format: [Signal Bars]  [Lock Icon]  [SSID]
wifi_list=$(nmcli -t -f BARS,SECURITY,SSID dev wifi | grep -v '^:$' | awk -F':' '!seen[$3]++ {
    lock = ($2 == "" || $2 == "--") ? "" : ""
    printf "%s  %s  %s\n", $1, lock, $3
}')

options="$eth_toggle\n$wifi_toggle\n$wifi_list"

# --- 4. LAUNCH ROFI ---
# We pass the speed_msg into Rofi using the -mesg flag
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Networks" -mesg "$speed_msg" -theme ~/.config/rofi/wifi-top-right.rasi)

[ -z "$chosen" ] && exit 0

# --- 5. HANDLE SELECTIONS ---
# Handle Ethernet
if [ "$chosen" = "$eth_toggle" ]; then
    eth_dev=$(nmcli -t -f DEVICE,TYPE dev | grep ethernet | head -n1 | awk -F':' '{print $1}')
    if [ "$eth_state" = "connected" ]; then
        nmcli dev disconnect "$eth_dev"
        notify-send "Network" "Ethernet disconnected."
    else
        nmcli dev connect "$eth_dev"
        notify-send "Network" "Ethernet connected."
    fi
    exit 0
fi

# Handle Wi-Fi Toggle
if [ "$chosen" = "$wifi_toggle" ]; then
    if [ "$wifi_state" = "enabled" ]; then
        nmcli radio wifi off
        notify-send "Wi-Fi" "Wi-Fi disabled."
    else
        nmcli radio wifi on
        notify-send "Wi-Fi" "Wi-Fi enabled."
    fi
    exit 0
fi

# Handle Wi-Fi Connections
# Extract SSID (Removes the bars and lock icon from the string)
ssid=$(echo "$chosen" | sed -E 's/^[^ ]+ +[^ ]+ +//')

saved_connections=$(nmcli -g NAME connection)

if echo "$saved_connections" | grep -w "$ssid" > /dev/null; then
    notify-send "Network" "Connecting to $ssid..."
    if nmcli connection up id "$ssid" > /dev/null 2>&1; then
        notify-send "Network" "Successfully connected to $ssid."
    else
        notify-send "Network" "Saved connection failed. Requesting password..."
        nmcli connection delete id "$ssid" > /dev/null 2>&1
        password=$(rofi -dmenu -p "Password for $ssid" -password -theme ~/.config/rofi/wifi-top-right.rasi -theme-str 'mainbox {children: [inputbar];}')
        [ -z "$password" ] && exit 0
        notify-send "Network" "Connecting to $ssid..."
        nmcli device wifi connect "$ssid" password "$password"
    fi
else
    password=$(rofi -dmenu -p "Password for $ssid" -password -theme ~/.config/rofi/wifi-top-right.rasi -theme-str 'mainbox {children: [inputbar];}')
    [ -z "$password" ] && exit 0
    notify-send "Network" "Connecting to $ssid..."
    nmcli device wifi connect "$ssid" password "$password"
fi
