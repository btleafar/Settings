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
			*.zip) unzip -d `echo $1 | sed 's/\(.*\)\.zip/\1/'` "$fullpath" ;;
			*.tar.bz2) tar xvjf "$fullpath" ;;
			*.tar.gz) tar xvzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.taz) tar xvzf "$fullpath" ;;
			*.tar) tar xvf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xvjf "$fullpath" ;;
			*.tgz) tar xvzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.bz2) bunzip2 "$fullpath" ;;
			*.gz) gunzip "$fullpath" ;;
			*.rar) rar x "$fullpath";;
			*.Z) uncompress "$fullpath" ;;
			*.7z) 7z x "$fullpath" ;;
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
	grep -ir --color=always "$*" --exclude-dir=".git" \
	#     │└─ search all files under each directory, recursively
	#     └─ ignore case
	--exclude-dir="node_modules" . | less -RX
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
		open .;
	else
		open "$@";
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

# Combine both mkdir and cd in a single command
# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}
#function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\"";
#}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Tells you the weather right on your terminal. There are different options that
# the wttr.in allows for your get requests like you can specify the location,
# etc. This only gives you the results for today and if you want it for the
# default 3 days (Today + 2 Nexts) change line for:
# curl -s "wttr.in/$@";
function weather() {
	curl -s "wttr.in/$1?m1";
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Gives you the difference in weather between two cities that you input.
function compweather() {
	diff -Naur <(curl -s http://wttr.in/$1?m1) <(curl -s http://wttr.in/$2?m1);
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# A timer which counts till the specified number of seconds, and then rings a
# bell. Equivalent of ‘set timer x’ on google on terminal (without requiring
# internet connection).
function count() {
	total=$1
	for ((i=total; i>0; i--)); do
		sleep 1;
		printf "Time remaining $i secs \r";
	done
	echo -e "\a"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Needn’t do cd ../../.. any longer. Just do 'up 3'
function up() {
	times=$1
	while [ "$times" -gt "0" ]; do
		cd ..
		times=$(($times - 1))
	done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Use rg3/youtube-dl (https://github.com/rg3/youtube-dl/) to download almost any
# music/video from any major video sites on the Internet; despite its name it
# supports much more than just Youtube:
# (https://rg3.github.io/youtube-dl/supportedsites.html)
function dl_music () {
	youtube-dl --output ~/Music/"$2.%(ext)s" --extract-audio \
	--audio-format mp3 --audio-quality 0 "$1" --add-metadata -x
}

function dl_video () {
	youtube-dl --output ~/Videos/"$2.%(ext)s" "$1"
}
