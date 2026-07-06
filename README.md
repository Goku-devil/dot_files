# ⚡ Dotfiles

Welcome to my personal dotfiles repository. This collection contains the configuration files and scripts I use to maintain a sleek, minimalist, and highly functional Linux environment. The setup is built around a modern Wayland compositor and relies on efficient, keyboard-centric tools tailored for development and everyday use.

## Key Components

- **[Hyprland](https://hyprland.org)** — Dynamic tiling Wayland compositor with smooth animations and modern window management.
- **[Waybar](https://github.com/Alexays/Waybar)** — Highly customizable status bar styled with CSS.
- **[Rofi](https://github.com/davatorium/rofi)** — Application launcher and window switcher, themed to match the desktop aesthetic.
- **[SwayNC](https://github.com/ErikReider/SwayNotificationCenter)** — Notification center built for Wayland compositors.
- **[Wlogout](https://github.com/ArtsyMacaw/wlogout)** — Customizable logout menu for Wayland.
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** — GPU-accelerated terminal emulator configured with custom color schemes.
- **[Neovim](https://neovim.io/)** (`nvim`) — Primary editor, configured with Lua for a blazing-fast editing experience.
- **[LazyVim](https://www.lazyvim.org/)** — A Neovim setup powered by 💤 `lazy.nvim` to make customization and plugin management effortless.
- **Bash** — Shell configuration, aliases, and custom helper functions.
- **[Fastfetch](https://github.com/fastfetch-cli/fastfetch)** — Lightweight system information tool with custom presets.

## Showcase

Here are a few screenshots from `assets/show-case` highlighting the current look and feel of the setup.

![Showcase 1](assets/show-case/image.png)
![Showcase 2](assets/show-case/image%20copy.png)
![Showcase 3](assets/show-case/image%20copy%202.png)

## Repository Structure

This repository groups configurations by application or service for easy deployment, symlinking, and customization.

```text
.
├── assets/         # Curated wallpapers and media assets
│   ├── show-case/  # Example screenshots of the current config
│   └── Wallpapers/ # Minimalist and themed wallpaper sets
├── bash/           # Bash aliases, profile, and exports
├── fastfetch/      # Fastfetch presets
├── hyprland/       # Hyprland config, window rules, and autostart scripts
├── kitty/          # Kitty config and color themes
├── local/          # User scripts (install into ~/.local/bin)
├── nvim/           # Neovim Lua configuration (LazyVim)
├── rofi/           # Rofi themes and scripts
├── swaync/         # Notification center CSS and layout rules
├── waybar/         # Waybar modules and CSS styling
└── wlogout/        # Logout menu layout and assets
```

## Aesthetics & Design

These configurations favor a dark, minimalist, and terminal-first aesthetic with subtle glow effects and cyberpunk-influenced accents. Custom CSS tweaks for Waybar and SwayNC, combined with curated wallpapers in `assets/Wallpapers`, ensure a cohesive and distraction-free visual experience across the entire desktop.

## Installation

> **Important:** Review the individual configuration files before applying them to your system. Always back up your existing configurations before proceeding!

### 1. Clone the Repository

```bash
git clone https://github.com/Goku-devil/dot_files.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Arch Linux Setup (Recommended)

An installation script is provided specifically for Arch Linux. If you are using another distribution, please skip to Step 3.

```bash
cd ~/.dotfiles
chmod +x install  # Ensure the script is executable
./install
```

### 3. Other Distributions (Manual Setup)

For non-Arch distributions, first install the necessary dependencies listed in `packages.txt` using your system's package manager. Once the packages are installed, use `stow` (recommended) or manually copy the configuration files.

**Required Packages**

| Category | Packages |
| :--- | :--- |
| **Core Desktop** | `hyprland`, `hypridle`, `hyprlock`, `hyprshot`, `hyprsunset`, `swaync`, `waybar-git`, `wlogout` |
| **Utilities** | `cliphist`, `rofi`, `wl-clipboard`, `xclip`, `wtype`, `fastfetch`, `stow`, `ddcutil`, `networkmanager-dmenu`, `playerctl`, `zscroll-git`, `wf-recorder` |
| **Apps & Dev** | `neovim`, `visual-studio-code-bin`, `firefox`, `dolphin`, `nodejs`, `npm` |
| **Fonts** | `ttf-jetbrains-mono-nerd`, `noto-fonts-emoji`, `rofi-emoji` |

**Clear Existing Configurations:**

```bash
rm -rf ~/.config/hypr ~/.config/kitty ~/.config/nvim ~/.config/fastfetch ~/.config/rofi ~/.config/swaync ~/.config/waybar ~/.config/wlogout ~/.bashrc
```

**Apply Configurations using GNU Stow:**

```bash
cd ~/.dotfiles
# stowing the configs
stow hyprland
stow waybar
stow kitty
stow nvim
stow bash
stow fastfetch
stow rofi
stow swaync
stow wlogout
```

*Note: This setup was primarily built and tested on Arch Linux. You may need to adapt package names and service management commands depending on your distribution.*

## Contributing & Customization

- **Themes:** Tweak the CSS and theme files located in the `waybar/` and `swaync/` folders to match your preferred color palette.
- **Scripts:** Add your personal scripts to the `local/` directory and ensure they are executable (`chmod +x`) and added to your `$PATH`.
- **Feedback:** Feel free to open an issue or submit a pull request for suggestions, bug fixes, or improvements!

---

*Created and maintained by [Goku-devil](https://github.com/Goku-devil)*