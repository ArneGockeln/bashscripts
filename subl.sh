#!/bin/bash
# description: handle the start of sublimetext from the cli. 
# the script looks inside the current directory for a .sublime-project file, 
# if found open it, if not open the current directory. If the script is called
# with a path to a file as parameter it calls the sublimetext binary with that
# path.
# 
# autor: Arne Gockeln, https://www.arnegockeln.com
# version: 1.0

SUBLIME="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

if [ $# -lt 1 ]; then
	# try to find a sublime-project file
	PROJECT=$(find . -maxdepth 1 -name *.sublime-project)
	if [[ ! -z "$PROJECT" ]]; then
		# open the project file
		eval $SUBLIME $PROJECT
		exit
	else
		# open sublime with current folder
		eval $SUBLIME .
		exit
	fi
else 
	# open the file
	eval $SUBLIME $@
	exit
fi
