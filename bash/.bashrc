#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='sudo pacman'

# ==============================================================================
# KALI LINUX PROMPT (ROUNDED & COLORED SYMBOL)
# ==============================================================================
# Define colors
kali_blue='\[\e[34m\]'
kali_white='\[\e[97m\]'
kali_red='\[\e[31m\]'
symbol_color='\[\e[35m\]'  # Magenta/Pink for the symbol
reset='\[\e[0m\]'

# Check if root or normal user
if [ "$EUID" -eq 0 ]; then
    # Root gets the red prompt and a skull
    frame_color=$kali_red
    prompt_symbol="☠"
else
    # Normal user gets the blue prompt
    frame_color=$kali_blue
    prompt_symbol="@"
fi

# Set the PS1 variable
PS1="${frame_color}╭──(${kali_blue}\u${symbol_color}${prompt_symbol}${kali_blue}\h${frame_color})-[${kali_white}\w${frame_color}]\n${frame_color}╰─${kali_blue}\$${reset} "
