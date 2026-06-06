# ==============================================================================
# ENVIRONMENT, HISTORY, & SANE DEFAULTS
# ==============================================================================
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR="$EDITOR"

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# ==============================================================================
# ALIASES
# ==============================================================================
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias vi='nvim'
alias ..='cd ..'
alias ~='cd ~'
alias pacman='sudo pacman'
alias mk='mkdir'
alias rm='rm -i'
alias cl='clear'

# ==============================================================================
# CUSTOM BOXED PROMPT (TrueColor Theme Engine Integration)
# ==============================================================================
_theme_prompt() {
    # Read the current theme from your Hyprland engine (default to catppuccin)
    local theme_state=$(cat ~/.config/hypr/.theme_state 2>/dev/null || echo "catppuccin")

    # 1. Catppuccin Mocha Colors (Your Original)
    local frame="\[\033[38;2;69;71;90m\]"        # surface1
    local accent1="\[\033[38;2;116;199;236m\]"    # sapphire
    local accent2="\[\033[38;2;137;180;250m\]"    # blue
    local accent3="\[\033[38;2;180;190;254m\]"    # lavender
    local text="\[\033[38;2;205;214;244m\]"       # text
    local prompt_col="\[\033[38;2;245;224;220m\]" # rosewater

    # 2. Evergreen Colors (Warm, Forest Tones)
    if [[ "$theme_state" == "evergreen" ]]; then
        frame="\[\033[38;2;133;146;137m\]"        # Muted Grey-Green (#859289)
        accent1="\[\033[38;2;167;192;128m\]"      # Soft Green (#a7c080)
        accent2="\[\033[38;2;127;187;179m\]"      # Soft Blue (#7fbbb3)
        accent3="\[\033[38;2;219;188;127m\]"      # Soft Yellow (#dbbc7f)
        text="\[\033[38;2;211;198;170m\]"         # Warm Text (#d3c6aa)
        prompt_col="\[\033[38;2;230;126;128m\]"   # Soft Red (#e67e80)
        
    # 3. Tokyo Night Colors (Neon Cyberpunk)
    elif [[ "$theme_state" == "tokyonight" ]]; then
        frame="\[\033[38;2;86;95;137m\]"          # Muted Purple-Grey (#565f89)
        accent1="\[\033[38;2;122;162;247m\]"      # Bright Blue (#7aa2f7)
        accent2="\[\033[38;2;187;154;247m\]"      # Neon Purple (#bb9af7)
        accent3="\[\033[38;2;158;206;106m\]"      # Bright Green (#9ece6a)
        text="\[\033[38;2;192;202;245m\]"         # Cool Text (#c0caf5)
        prompt_col="\[\033[38;2;247;118;142m\]"   # Neon Red (#f7768e)
    fi

    local reset="\[\033[0m\]"

    # High-resolution Nerd Font structural symbols
    local arch_icon="󰣇 "
    local split_sym=" @ "
    local dir_icon="  "
    local prompt_sym="❯"

    # Build layout structure
    PS1="${frame}╭─(${accent1}${arch_icon}${text}\u${accent2}${split_sym}\h${frame})─[${accent3}${dir_icon}\w${frame}]\n${frame}╰─${prompt_col}${prompt_sym}${reset} "
}
_theme_prompt
