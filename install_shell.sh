#!/bin/bash

# Install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install gpg sudo curl -y


# Get $ID to choose the repository
source /etc/os-release

# Function to add Fish Shell repository based on OS
add_fish_repo() {
  if [[ "$ID" == "debian" ]]; then
    echo "Adding Fish Shell repository for Debian..."
    echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_$VERSION_ID/ /" | sudo tee /etc/apt/sources.list.d/fish.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_$VERSION_ID/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/fish.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/fish.gpg] http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_$VERSION_ID/ /" | sudo tee /etc/apt/sources.list.d/fish.list > /dev/null
  elif [[ "$ID" == "ubuntu" ]]; then
    echo "Adding Fish Shell repository for Ubuntu..."
    sudo apt-add-repository ppa:fish-shell/release-3
  else
    echo "Unsupported OS: $ID"
    exit 1
  fi
}

# Add the Fish Shell repository
add_fish_repo


# Add the Fish Shell repository and install Fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y
# Install exa
sudo apt install exa -y

# Set Fish as the default shell
chsh -s $(which fish)

# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh

# Create config directory if it doesn't exist
mkdir -p ~/.config/fish

# Add Starship initialization to the Fish config file
echo 'starship init fish | source' >> ~/.config/fish/config.fish

# Set alias
echo "alias ..='cd ..'" >> ~/.config/fish/config.fish
echo "alias ...='cd ../..'" >> ~/.config/fish/config.fish
echo "alias ls='exa -lag --header'" >> ~/.config/fish/config.fish

echo "Fished"
