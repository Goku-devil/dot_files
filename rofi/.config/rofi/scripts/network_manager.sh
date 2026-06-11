#!/usr/bin/env bash

set -euo pipefail

copy_text() {
    if command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$1" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$1" | xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        printf '%s' "$1" | xsel --clipboard --input
    fi
}

wifi_state=$(nmcli radio wifi)
eth_dev=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2 == "ethernet" {print $1; exit}')
wifi_dev=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2 == "wifi" {print $1; exit}')
active_conn=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: 'NR==1 {print $1}')
active_dev=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: 'NR==1 {print $2}')

if [ -n "${active_dev:-}" ]; then
    ip_addr=$(ip -4 addr show "$active_dev" 2>/dev/null | awk '/inet / {print $2; exit}')
    gateway=$(ip route show default dev "$active_dev" 2>/dev/null | awk '/default/ {print $3; exit}')
else
    ip_addr="Offline"
    gateway="-"
fi

iface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')
if [ -n "$iface" ]; then
    rx1=$(cat "/sys/class/net/$iface/statistics/rx_bytes")
    tx1=$(cat "/sys/class/net/$iface/statistics/tx_bytes")
    sleep 0.5
    rx2=$(cat "/sys/class/net/$iface/statistics/rx_bytes")
    tx2=$(cat "/sys/class/net/$iface/statistics/tx_bytes")
    rx_speed=$(((rx2 - rx1) / 512))
    tx_speed=$(((tx2 - tx1) / 512))
    speed_msg="󰓢 ${iface}: ↓ ${rx_speed} KB/s | ↑ ${tx_speed} KB/s"
else
    speed_msg="󰓢 Offline"
fi

eth_status="Disconnected"
if [ -n "${eth_dev:-}" ] && nmcli -t -f TYPE,STATE dev | awk -F: '$1 == "ethernet" && $2 == "connected" {found=1} END {exit !found}'; then
    eth_status="Connected"
fi

options=$(cat <<EOF
󰖩  Toggle Wi-Fi (${wifi_state})
󰈀  Toggle Ethernet (${eth_status})
󰄰  Reconnect Active Connection
󰌎  Copy IP Address
󰳲  Copy Gateway
󰖣  Scan Wi-Fi Networks
󰍉  Restart NetworkManager
󰩺  Show Network Status
󰕑  Renew DHCP on Active Device
󰌗  Open Wi-Fi Manager
EOF
)

choice=$(echo "$options" | rofi -dmenu -i -p "Network:" -mesg "$speed_msg" -theme ~/.config/rofi/wifi-top-right.rasi)
[ -z "${choice:-}" ] && exit 0

case "$choice" in
    *"Toggle Wi-Fi"*)
        if [ "$wifi_state" = "enabled" ]; then
            nmcli radio wifi off
            notify-send "Network" "Wi-Fi disabled"
        else
            nmcli radio wifi on
            notify-send "Network" "Wi-Fi enabled"
        fi
        ;;
    *"Toggle Ethernet"*)
        if [ -z "${eth_dev:-}" ]; then
            notify-send "Network" "No Ethernet device detected"
        else
            if nmcli -t -f TYPE,STATE dev | awk -F: '$1 == "ethernet" && $2 == "connected" {found=1} END {exit !found}'; then
                nmcli dev disconnect "$eth_dev"
                notify-send "Network" "Ethernet disconnected"
            else
                nmcli dev connect "$eth_dev"
                notify-send "Network" "Ethernet connected"
            fi
        fi
        ;;
    *"Reconnect Active Connection"*)
        if [ -n "${active_conn:-}" ]; then
            nmcli connection down "$active_conn" >/dev/null 2>&1 || true
            sleep 1
            nmcli connection up "$active_conn"
            notify-send "Network" "Reconnected $active_conn"
        else
            notify-send "Network" "No active connection"
        fi
        ;;
    *"Copy IP Address"*)
        if [ "$ip_addr" = "Offline" ]; then
            notify-send "Network" "No IP address available"
        else
            copy_text "$ip_addr"
            notify-send "Network" "IP copied: $ip_addr"
        fi
        ;;
    *"Copy Gateway"*)
        if [ "$gateway" = "-" ]; then
            notify-send "Network" "No gateway available"
        else
            copy_text "$gateway"
            notify-send "Network" "Gateway copied: $gateway"
        fi
        ;;
    *"Scan Wi-Fi Networks"*)
        ~/.dotfiles/local/.local/bin/custom-wifi.sh
        ;;
    *"Restart NetworkManager"*)
        sudo systemctl restart NetworkManager
        notify-send "Network" "NetworkManager restarted"
        ;;
    *"Show Network Status"*)
        status_msg=$(cat <<EOF2
Active: ${active_conn:-None}
Device: ${active_dev:-None}
IP: ${ip_addr}
Gateway: ${gateway}
Wi-Fi: ${wifi_state}
EOF2
)
        notify-send "Network Status" "$status_msg"
        printf '%s\n' "$status_msg" | rofi -dmenu -i -p "Status" -theme ~/.config/rofi/wifi-top-right.rasi >/dev/null 2>&1 || true
        ;;
    *"Renew DHCP on Active Device"*)
        if [ -n "${active_dev:-}" ]; then
            nmcli dev disconnect "$active_dev" >/dev/null 2>&1 || true
            sleep 1
            nmcli dev connect "$active_dev"
            notify-send "Network" "DHCP renewed on $active_dev"
        else
            notify-send "Network" "No active device"
        fi
        ;;
    *"Open Wi-Fi Manager"*)
        ~/.dotfiles/local/.local/bin/custom-wifi.sh
        ;;
esac
