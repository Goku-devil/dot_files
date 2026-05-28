#!/bin/bash

# ==========================================
# Color formatting for better readability
# ==========================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_skip() {
    echo -e "${YELLOW}[-] $1${NC}"
}

# ==========================================
# 1. Install Dependencies & AUR Helper (yay)
# ==========================================
print_info "Checking for base-devel and git..."
sudo pacman -S --needed --noconfirm git base-devel

if ! command -v yay &> /dev/null; then
    print_info "Installing yay..."
    # Cloning into /tmp keeps your home directory clean
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd - || exit
else
    print_skip "yay is already installed. Skipping."
fi

# ==========================================
# 2. Official Arch Packages
# ==========================================
# Note: The package name for nvim is 'neovim'
OFFICIAL_PACKAGES=(
    rofi
    waybar
    wlogout
    neovim
    swaync
    hyprshot
    hypridle
    hyprlock
)

print_info "Checking official repository packages..."
for pkg in "${OFFICIAL_PACKAGES[@]}"; do
    # pacman -Qs checks if the exact package name is installed locally
    if pacman -Qs "^${pkg}$" &> /dev/null; then
        print_skip "$pkg is already installed."
    else
        print_info "Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
done

# ==========================================
# 3. AUR Packages
# ==========================================
AUR_PACKAGES=(
    google-chrome
    visual-studio-code-bin
    swaylock-effects-git
)

print_info "Checking AUR packages..."
for pkg in "${AUR_PACKAGES[@]}"; do
    if yay -Qs "^${pkg}$" &> /dev/null; then
        print_skip "$pkg is already installed."
    else
        print_info "Installing $pkg..."
        yay -S --noconfirm "$pkg"
    fi
done

print_info "Setup complete!"
