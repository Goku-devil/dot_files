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
alias U='sudo pacman -Syu && yay -Syu'

# ==============================================================================
# CUSTOM BOXED PROMPT (TrueColor Theme Engine Integration)
# ==============================================================================
_theme_prompt() {
    # Read the current theme from your Hyprland engine (default to catppuccin)
    local theme_state=$(cat ~/.config/hypr/.theme_state 2>/dev/null || echo "catppuccin")

    # 1. Catppuccin Mocha Colors (Default)
    local frame="\[\033[38;2;69;71;90m\]"        
    local accent1="\[\033[38;2;116;199;236m\]"    
    local accent2="\[\033[38;2;137;180;250m\]"    
    local accent3="\[\033[38;2;180;190;254m\]"    
    local text="\[\033[38;2;205;214;244m\]"       
    local prompt_col="\[\033[38;2;245;224;220m\]" 

    # 2. Evergreen Colors
    if [[ "$theme_state" == "evergreen" ]]; then
        frame="\[\033[38;2;133;146;137m\]"        
        accent1="\[\033[38;2;167;192;128m\]"      
        accent2="\[\033[38;2;127;187;179m\]"      
        accent3="\[\033[38;2;219;188;127m\]"      
        text="\[\033[38;2;211;198;170m\]"         
        prompt_col="\[\033[38;2;230;126;128m\]"   
        
    # 3. Tokyo Night Colors
    elif [[ "$theme_state" == "tokyonight" ]]; then
        frame="\[\033[38;2;86;95;137m\]"          
        accent1="\[\033[38;2;122;162;247m\]"      
        accent2="\[\033[38;2;187;154;247m\]"      
        accent3="\[\033[38;2;158;206;106m\]"      
        text="\[\033[38;2;192;202;245m\]"         
        prompt_col="\[\033[38;2;247;118;142m\]"   

    # 4. Rosé Pine Colors
    elif [[ "$theme_state" == "rosepine" ]]; then
        frame="\[\033[38;2;110;106;134m\]"        # Muted (#6e6a86)
        accent1="\[\033[38;2;49;116;143m\]"       # Pine (#31748f)
        accent2="\[\033[38;2;196;167;231m\]"      # Iris (#c4a7e7)
        accent3="\[\033[38;2;235;188;186m\]"      # Rose (#ebbcba)
        text="\[\033[38;2;224;222;244m\]"         # Text (#e0def4)
        prompt_col="\[\033[38;2;235;111;146m\]"   # Love (#eb6f92)

    # 5. Nord Colors (NEW!)
    elif [[ "$theme_state" == "nord" ]]; then
        frame="\[\033[38;2;76;86;106m\]"          # Muted Slate (#4c566a)
        accent1="\[\033[38;2;136;192;208m\]"      # Frost Blue (#88c0d0)
        accent2="\[\033[38;2;129;161;193m\]"      # Storm Blue (#81a1c1)
        accent3="\[\033[38;2;163;190;140m\]"      # Aurora Green (#a3be8c)
        text="\[\033[38;2;216;222;233m\]"         # Snow Storm (#d8dee9)
        prompt_col="\[\033[38;2;191;97;106m\]"    # Aurora Red (#bf616a)
        
    fi # <--- MOVED TO HERE!

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
export PATH=$PATH:/home/goku/.spicetify
export PATH=$PATH:~/.spicetify
