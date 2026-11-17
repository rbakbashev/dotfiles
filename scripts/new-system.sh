#!/bin/bash

set -e

cd ~/dotfiles/scripts/

echo '=== 1/8: packages.sh'
./packages.sh

echo '=== 2/8: zsh.sh'
./zsh.sh

echo '=== 3/8: set-links.sh'
./set-links.sh

echo '=== 4/8: git.sh'
./git.sh

echo '=== 5/8: alacritty.sh'
./alacritty.sh

echo '=== 6/8: fonts.sh'
./fonts.sh

echo '=== 7/8: rustup.sh'
./rustup.sh

echo '=== 8/8: vim.sh'
./vim.sh

