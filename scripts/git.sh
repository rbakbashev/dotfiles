#!/bin/bash

set -e

git config --global core.excludesfile ~/dotfiles/host/gitignore
git config --global rerere.enabled true
git config --global credential.helper 'cache --timeout=36000'
git config --global pull.ff only
git config --global init.defaultBranch master
git config --global commit.verbose true
git config --global branch.sort -committerdate
git config --global tag.sort version:refname
git config --global diff.algorithm histogram
git config --global diff.colorMoved false

binary=$(find -L /usr -name diff-highlight -type f 2> /dev/null | head -n 1)

# fucking debian
if [[ -z $binary ]]; then
    echo "diff-highlight binary not built"

    script=$(find -L /usr -name diff-highlight.perl -type f 2> /dev/null | head -n 1)
    if [[ -z $script ]]; then
        echo 'diff-highlight.perl script not found'
        exit 1
    fi

    dir=$(dirname "$script")

    echo "found unbuilt diff-highlight at $dir"

    cd "$dir"
    sudo make

    binary=$(find -L /usr -name diff-highlight -type f 2> /dev/null | head -n 1)
    if [[ -z $binary ]]; then
        echo "binary not found after successful build"
        exit 1
    fi

    echo "built diff-highlight binary at $binary"
else
    echo "found diff-highlight binary at $binary"
    sudo chmod +x "$binary"
fi

cat <<HERE >> ~/.gitconfig
[pager]
	log = $binary | less
	show = $binary | less
	diff = $binary | less

[color "diff"]
	commit = blue
	meta = yellow
	frag = cyan
	old = red
	new = green
	whitespace = red reverse

[color "diff-highlight"]
	oldNormal = red
	oldHighlight = red 52
	newNormal = green
	newHighlight = green 22

HERE

