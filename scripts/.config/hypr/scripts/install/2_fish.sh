#!/bin/bash

# install packages for fish shell
yay -S --noconfirm --needed fish fastfetch

# check if fish is in the allowed shell list
FISH_PATH=$(which fish)
if grep -Fxq "$FISH_PATH" /etc/shells; then
  echo "Fish is already in /etc/shells"
else
  echo "Adding Fish to /etc/shells"
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# make fish the default shell
chsh -s "$FISH_PATH"

# create basic alias set
alias --save cl 'clear'
alias --save la 'ls -ah1 --color=auto --group-directories-first'
alias --save ll 'ls -lisah --color=auto --group-directories-first'

echo "fish shell has been installed!"
