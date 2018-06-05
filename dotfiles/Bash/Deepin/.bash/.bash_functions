#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, " \
			"do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" \
				&& cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
    fi
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create data URI from a file.

function datauri() {

	local mimeType=""

	if [ -f "$1" ]; then
		mimeType=$(file -b --mime-type "$1")
		#                └─ do not prepend the filename to the output

		if [[ $mimeType == text/* ]]; then
			mimeType="$mimeType;charset=utf-8"
		fi

		printf "data:%s;base64,%s" \
					"$mimeType" \
					"$(openssl base64 -in "$1" | tr -d "\n")"
	else
		printf "%s is not a file.\n" "$1"
	fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Delete files that match a certain pattern from the current directory.

function cleanup() {
	local q="${1:-*.DS_Store}"
	find . -type f -name "$q" -ls -delete
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Get gzip information (gzipped file size + reduction size).

function gz() {

	declare -i gzippedSize=0
	declare -i originalSize=0

	if [ -f "$1" ]; then
		if [ -s "$1" ]; then

			originalSize=$( wc -c < "$1" )
			printf "\n original size:   %12s\n" "$(hrfs "$originalSize")"

			gzippedSize=$( gzip -c "$1" | wc -c )
			printf " gzipped size:    %12s\n" "$(hrfs "$gzippedSize")"

			printf " ─────────────────────────────\n"
			printf " reduction:       %12s [%s%%]\n\n" \
						"$( hrfs $((originalSize - gzippedSize)) )" \
						"$( printf "%s" "$originalSize $gzippedSize" | \
							awk '{ printf "%.1f", 100 - $2 * 100 / $1 }' | \
							sed -e "s/0*$//;s/\.$//" )"
							#              └─ remove tailing zeros

		else
			printf "\"%s\" is empty.\n" "$1"
		fi
	else
		printf "\"%s\" is not a file.\n" "$1"
	fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Human readable file size
# (because `du -h` doesn't cut it for me).

function hrfs() {

	printf "%s" "$1" |
	awk '{
		i = 1;
			split("B KB MB GB TB PB EB ZB YB WTFB", v);
			value = $1;

			# confirm that the input is a number
			if ( value + .0 == value )
			{
				while ( value >= 1024 )
				{
					value/=1024;
					i++;
				}
				if ( value == int(value) )
				{
					printf "%d %s", value, v[i]
				}
			else
				{
					printf "%.1f %s", value, v[i]
				}
			}
		}' |
	sed -e ":l" \
	-e "s/\([0-9]\)\([0-9]\{3\}\)/\1,\2/; t l"
	#    └─ add thousands separator
	#       (changes "1023.2 KB" to "1,023.2 KB")
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create new directories and enter the first one.

function mkd() {
	if [ -n "$*" ]; then

		mkdir -p "$@"
		#      └─ make parent directories if needed

		cd "$@" \
			|| exit 1

	fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Process phone images.

function ppi() {
	command -v "convert" &> /dev/null \
		|| exit 0;

	declare query="${1:-*.jpg}"
	declare geometry="${2:-50%}"

	for i in "$query"; do
		imgName="${i%.*}.png"
		convert "$i" \
			-colorspace RGB \
			+sigmoidal-contrast 11.6933 \
			-define filter:filter=Sinc \
			-define filter:window=Jinc \
			-define filter:lobes=3 \
			-sigmoidal-contrast 11.6933 \
			-colorspace sRGB \
			-background transparent \
			-gravity center \
			-resize "$geometry" \
			+append \
			"$imgName" \
		&& printf "* %s (%s)\n" \
			"$imgName" \
			"$geometry"
	done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search history.

function qh() {
	#           ┌─ enable colors for pipe
	#           │  ("--color=auto" enables colors only if
	#           │  the output is in the terminal)
	grep --color=always "$*" "$HISTFILE" |       less -RX
	# display ANSI color escape sequences in raw form ─┘│
	#       don't clear the screen after quitting less ─┘
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search for text within the current directory.

function qt() {
	grep -ir --color=always "$*" --exclude-dir=".git" --exclude-dir="node_modules" . | less -RX
	#     │└─ search all files under each directory, recursively
	#     └─ ignore case
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location

function s() {
	if [ $# -eq 0 ]; then
		subl .;
	else
		subl "$@";
	fi;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		dde-file-manager .;
	else
		dde-file-manager "$@";
	fi;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
	if [ $# -eq 0 ]; then
		vim .;
	else
		vim "$@";
	fi;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# `a` with no arguments opens the current directory in Atom, otherwise opens the
# given location
function a() {
	if [ $# -eq 0 ]; then
		atom .;
	else
		atom "$@";
	fi;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}
