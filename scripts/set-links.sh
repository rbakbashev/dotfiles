#!/bin/zsh

# Credit to https://github.com/nicksp/dotfiles/blob/master/setup.sh

print_result()
{
	[[ $1 -eq 0 ]] \
		&& print_success "$2" \
		|| print_error "$2"
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
	'gvimrc'
	'tmux.conf'
	'vimrc'
	'zshrc.local'
)

echo

cd ~/dotfiles

for i in $dotfiles; do
	target="$(pwd)/$i"
	link_name="$HOME/.$i"

	if [[ ! -e "$link_name" ]]; then
		ln -sf "$target" "$link_name"
		print_result $? "$link_name -> $target"
	elif [[ "$(readlink "$link_name")" == "$target" ]]; then
		print_success "link already exists: $link_name -> $target"
	else
		local target_type=""
		if [[ -d "$target" ]]; then
			target_type="directory"
		else
			target_type="file"
		fi
		print_error "$target_type already exists: $link_name"
	fi
done

