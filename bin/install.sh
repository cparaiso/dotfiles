#!/bin/bash
echo "==============================================="
echo "-- Running install..."

zshrc_path="$HOME/.zshrc"
zshrc_add='source $HOME/src/dotfiles/zshrc'

if ! grep -qF "$zshrc_add" $zshrc_path; then
	# Append the code if the search line is not found
	echo "# dotfiles" >>"$zshrc_path"
	echo "$zshrc_add" >>"$zshrc_path"
	echo "-- Dotfiles have been installed."
else
	echo "-- Dotfiles have already been installed. No changes made."
fi

echo "-- Attempting to install tmux..."

brew update
brew install tmux

echo "-- Installing tmux configuration..."

old_tmux_config="$HOME/.tmux.conf"
new_tmux_config="$HOME/src/dotfiles/tmux/tmux.conf"

if [ -f "$old_tmux_config" ]; then
	echo "-- Found an old tmux configuration. Backing up..."

	timestamp=$(date +"%Y%m%dH%M%S")
	backup_file="$HOME/.tmux.conf.backup.${timestamp}"

	# Create backup
	cp "$old_tmux_config" "$backup_file"

	# Install new tmux configuration
	cp "$new_tmux_config" "$HOME/.tmux.conf"
else
	cp "$new_tmux_config" "$HOME/.tmux.conf"
fi

echo "-- Installing tmux package manager..."

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "-- The tmux package manager is already installed. Skipping..."
else
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "-- tmux package manager has been installed."
fi

cp "$HOME/src/dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
tmux source "$HOME/.tmux.conf"
echo "-- Configuration for tmux has been installed."
echo "-- Run <tmux-prefix> + I to install tmux plugins."

echo "==============================================="
