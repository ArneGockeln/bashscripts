#!/bin/bash
# This script creates a new jekyll post template inside the _posts folder,
# or inside the current folder if the _posts folder does not exist.
# 
# autor: Arne Gockeln, http://www.arnegockeln.com
# version: 1.0
# 

TITLE=$1
DEST="_posts/"

if [ $# -lt 1 ]; then
	echo "Usage:"
	echo "    $0 TITLE [CATEGORIES]"
	exit 1
fi

CATEGORIES="softwaredev"
if [ $# -lt 2 ]; then
	CATEGORIES=$2
fi

# the file name
DATE=$(date +"%Y-%m-%d")
DATELONG=$(date +"%Y-%m-%d %H:%M:%S %z")
FILENAME=$(echo ${TITLE} |tr '[:upper:]' '[:lower:]' |tr -cd '[0-9A-Za-z\ ]' |tr ' ' '-')
FILENAME="${DATE}-${FILENAME}.md"

PATH="${FILENAME}"
if [ -d "_posts/" ]; then
	PATH="_posts/${FILENAME}"
fi

if [ ! -f "${PATH}" ]; then
	# create file because touch does not work
	echo -n > ${PATH}
	# create jekyll header
	echo "---" >> ${PATH}
	echo "layout: post" >> ${PATH}
	echo "title: \"${TITLE}\"" >> ${PATH}
	echo "date: ${DATELONG}" >> ${PATH}
	echo "author: Arne Gockeln" >> ${PATH}
	echo "categories: [${CATEGORIES}]" >> ${PATH}
	echo "---" >> ${PATH}
	echo "" >> ${PATH}
	echo "${PATH} created."
else 
	echo "File ${PATH} already exists!"
fi
exit 0