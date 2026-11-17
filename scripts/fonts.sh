#!/bin/bash

mkdir -p ~/.config/fontconfig

ln -s ~/dotfiles/fonts.conf ~/.config/fontconfig

sudo wget https://github.com/todylu/monaco.ttf/raw/master/monaco.ttf -O \
    /usr/share/fonts/truetype/monaco.ttf

fc-cache -fv

