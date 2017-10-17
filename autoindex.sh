#!/bin/bash
#title			:autoindex.sh
#description	:this script finds every folder without a index.html file,
#				 creates one with a content refresh meta tag to redirect to base.de/index.html
#author			:Arne Gockeln, www.arnegockeln.com
#version		:0.1
#==================================================================================================
echo "Create index.html in all empty folders..."
find . -depth -type d '!' -exec test -e "{}/index.html" ';' -print|while read f; do echo '<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0;url=/index.html" /></head><body></body></html>' > "$f/index.html"; done
echo "done."