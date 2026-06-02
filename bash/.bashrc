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
# CUSTOM BOXED PROMPT (Diamond Edition)
# ==============================================================================
_mocha_prompt() {
    # ANSI escape color declarations (Catppuccin Mocha TrueColor)
    local surface1="\[\033[38;2;69;71;90m\]"
    local sapphire="\[\033[38;2;116;199;236m\]"
    local blue="\[\033[38;2;137;180;250m\]"
    local lavender="\[\033[38;2;180;190;254m\]"
    local rosewater="\[\033[38;2;245;224;220m\]"
    local text="\[\033[38;2;205;214;244m\]"
    local reset="\[\033[0m\]"

    # High-resolution Nerd Font structural symbols
    local arch_icon="󰣇 "
    local split_sym=" @ "   # The diamond divider
    local dir_icon="  "
    local prompt_sym="❯"

    # Build layout structure
    PS1="${surface1}╭─(${sapphire}${arch_icon}${text}\u${blue}${split_sym}\h${surface1})─[${lavender}${dir_icon}\w${surface1}]\n${surface1}╰─${rosewater}${prompt_sym}${reset} "
}
_mocha_prompt
