#!/bin/bash

set -e

cd ~/dotfiles/scripts/

echo '=== 1/9: packages.sh'
./packages.sh

echo '=== 2/9: zsh.sh'
./zsh.sh

echo '=== 3/9: set-links.sh'
./set-links.sh

echo '=== 4/9: git.sh'
./git.sh

echo '=== 5/9: alacritty.sh'
./alacritty.sh

echo '=== 6/9: fontconfig.sh'
./fontconfig.sh

echo '=== 7/9: rustup.sh'
./rustup.sh

echo '=== 8/9: monaco.sh'
./monaco.sh

echo '=== 9/9: vim.sh'
./vim.sh

