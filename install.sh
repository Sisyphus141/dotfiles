#!/bin/bash

# Ask Y/n
function ask() {
    read -p "$1 (Y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Function to create symlink and handle existing files
function create_symlink() {
    local source_file="$1"
    local target_file="$2"
    
    if [ -L "$target_file" ]; then
        echo "Symlink for $target_file already exists. Skipping."
    elif [ -f "$target_file" ]; then
        if ask "$target_file exists. Do you want to overwrite it?"; then
            ln -sf "$source_file" "$target_file"
            echo "Overwritten $target_file with a symlink to $source_file."
        else
            echo "Skipped $target_file."
        fi
    else
        ln -s "$source_file" "$target_file"
        echo "Created symlink for $target_file."
    fi
}

# Create directories if they don't exist
mkdir -p ~/.config/i3 ~/.config/nvim ~/.config/picom ~/.config/rofi

# Install i3 config
if ask "Do you want to install i3 config?"; then
    create_symlink "$(realpath "i3/config")" ~/.config/i3/config
    create_symlink "$(realpath "i3/bumblebee-status")" ~/.config/i3/bumblebee-status
fi

# Install Neovim config
if ask "Do you want to install Neovim config?"; then
    create_symlink "$(realpath "nvim/init.vim")" ~/.config/nvim/init.vim
    create_symlink "$(realpath "nvim/lua")" ~/.config/nvim/lua
fi

# Install Picom config
if ask "Do you want to install Picom config?"; then
    create_symlink "$(realpath "picom/picom.conf")" ~/.config/picom/picom.conf
fi

# Install Rofi config
if ask "Do you want to install Rofi config?"; then
    create_symlink "$(realpath "rofi/config.rasi")" ~/.config/rofi/config.rasi
fi

# Optional: Tmux conf
if ask "Do you want to install .tmux.conf?"; then
    create_symlink "$(realpath ".tmux.conf")" ~/.tmux.conf
fi

# Optional: Vim conf
if ask "Do you want to install .vimrc?"; then
    create_symlink "$(realpath ".vimrc")" ~/.vimrc
fi

echo "Installation complete."

