#!/bin/bash

# install packages for yazi
yay -S --needed --noconfirm yazi swayimg

# create alias for yazi
alias --save ya="yazi"

echo "yazi has been installed!"
