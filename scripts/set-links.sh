#!/bin/zsh

print_result()
{
	if [[ $? -eq 0 ]]; then
		print_success "$1"
	else
		print_error "$1"
	fi
}

print_success()
{
	printf "\e[0;32m [v] $1\e[0m\n"
}

print_error()
{
	printf "\e[0;31m [x] $1\e[0m\n"
}

declare -a dotfiles=(
	'gdbinit'
	'tmux.conf'
	'vimrc'
	'zshrc.local'
)

cd ~/dotfiles

for i in $dotfiles; do
	target="$(pwd)/$i"
	link_name="$HOME/.$i"

	if [[ ! -e "$link_name" ]]; then
		ln -sf "$target" "$link_name"
		print_result "$link_name -> $target"
	elif [[ "$(readlink "$link_name")" == "$target" ]]; then
		print_success "link already exists: $link_name -> $target"
	else
		target_type=""
		if [[ -d "$target" ]]; then
			target_type="directory"
		else
			target_type="file"
		fi
		print_error "$target_type already exists: $link_name"
	fi
done

