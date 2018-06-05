#!/bin/bash

if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source_bash_files() {

	declare -r CURRENT_DIRECTORY="$(pwd)"

	declare -r -a FILES_TO_SOURCE=(
		".bash/.bash_aliases"
		".bash/.bash_exports"
		".bash/.bash_functions"
		".bash/.bash_options"
		".bash/.bash_prompt"
		".bash.local"	# For local settings that should
						# not be under version control.
	)

	local file=""
	local i=""

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	for i in ${!FILES_TO_SOURCE[*]}; do

		file="$HOME/${FILES_TO_SOURCE[$i]}"

		[ -r "$file" ] \
			&& . "$file"

	done

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	cd "$CURRENT_DIRECTORY"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source_bash_files
unset -f source_bash_files

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.).

clear
