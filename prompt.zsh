function load_colors() {
	BLUE="%F{blue}"
	RED="%F{red}"
	GREEN="%F{green}"
	CYAN="%F{cyan}"
	MAGENTA="%F{magenta}"
	YELLOW="%F{yellow}"
	WHITE="%F{white}"
	NO_COLOR="%f"
}

function unload_colors() {
	builtin unset -v BLUE RED GREEN CYAN YELLOW MAGENTA WHITE NO_COLOR
}

load_colors

prompt off

user_color="$GREEN"
[ $UID -eq 0 ] && user_color="$RED"
username="$user_color%n$NO_COLOR"
dir="$BLUE%1~$NO_COLOR"
symbol="$user_color%(!.#.$)$NO_COLOR"

function git_get_branch() {
	if symbolic_ref=$(git symbolic-ref HEAD -q); then
		echo "$symbolic_ref" | sed 's|refs/heads/||'
	else
		git rev-parse --short HEAD
	fi
}

function git_prompt_status() {
	local ZSH_THEME_GIT_PROMPT_ADDED="$GREEN+"
	local ZSH_THEME_GIT_PROMPT_MODIFIED="$BLUE*"
	local ZSH_THEME_GIT_PROMPT_DELETED="$RED-"
	local ZSH_THEME_GIT_PROMPT_STASHED="$YELLOW#"
	local ZSH_THEME_GIT_PROMPT_RENAMED="${MAGENTA}R"
	local ZSH_THEME_GIT_PROMPT_UNTRACKED="$CYAN?"
	local INDEX=$(command git status --porcelain -b 2> /dev/null)
	local STATUS=""

	if $(echo "$INDEX" | grep -q '^??'); then
		STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
	fi

	if $(echo "$INDEX" | grep -q '^A ') ||
	   $(echo "$INDEX" | grep -q '^M ') ||
	   $(echo "$INDEX" | grep -q '^MM'); then
		STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
	fi

	if $(echo "$INDEX" | grep -q '^[ MARC]M'); then
		STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
	fi

	if $(echo "$INDEX" | grep -q '^R[ MD]'); then
		STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
	fi

	if $(echo "$INDEX" | grep -q '^[ MARC]D') ||
	   $(echo "$INDEX" | grep -q '^D '); then
		STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
	fi

	if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
		STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
	fi

	echo "$STATUS"
}

function prompt_extras {
	local retval="$RED%? ↵$NO_COLOR"
	local gitness=""
	[[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]] &&
		gitness="$(git_get_branch)$(git_prompt_status)$NO_COLOR"

	if [[ "$gitness" == "" ]]; then
		echo "%(?~~($retval%) )"
	else
		echo "%(?~($gitness%)~($retval $gitness%)) "
	fi
}

function precmd {
	load_colors

	export PROMPT="$username $dir $(prompt_extras)$symbol "

	unload_colors
}

unload_colors

