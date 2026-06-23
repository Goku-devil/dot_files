#!/bin/bash

# Define an array of facts
facts=(
    "Arch Linux was created by Judd Vinet in 2002."
    "Linus Torvalds built Git in just 10 days to manage the kernel."
    "Linux powers 100% of the world's top 500 supercomputers."
    "Kali Linux was originally called BackTrack before its Debian rewrite."
    "The Linux kernel contains over 30 million lines of code."
    "Pacman, the Arch package manager, is written almost entirely in C."
    "Linus Torvalds announced Linux in 1991, warning it 'won\'t be big and professional'."
    "95.9% of the Linux kernel is written in C, followed by C++ and Assembly."
    "NASA relies on Linux to run systems on the ISS and power SpaceX missions."
    "Over 90% of Hollywood's special effects rendering is done on Linux-based machines."
    "Wayland, the protocol replacing X11, was designed to eliminate screen tearing completely."
    "C was developed at Bell Labs in 1972 by Dennis Ritchie to construct the Unix utility."
    "Python is named after the British comedy troupe Monty Python, not the snake."
    "Agentic AI systems don't just answer questions; they iteratively plan, execute, and evaluate tasks."
    "Local LLMs like Llama 3 can run entirely on integrated graphics without an internet connection."
)

size=${#facts[@]}

# Generate a random index based on the array size
index=$((RANDOM % size))

echo "${facts[$index]}"
