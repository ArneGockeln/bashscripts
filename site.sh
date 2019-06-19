#!/bin/bash
# This script helps to create, run or build a jekyll site
# 
# Parameter:
# site build    Use it to build for production
# site run      Use it to serve a jekyll site
# 
# Author: Arne Gockeln
# Version: 0.1
# 

CMD=$1
BUILDCMD="bundle exec jekyll build"
RUNCMD="bundle exec jekyll serve"

# check if we are inside a jekyll directory
JEKYLL=$(find . -maxdepth 1 -name _config.yml)
if [[ -z "$JEKYLL" ]]; then
    echo "Run this script inside a jekyll project folder."
    exit 1
fi

case "$CMD" in
    build)
    eval $BUILDCMD
    ;;
    
    run)
    eval $RUNCMD
    ;;

    *)
    echo $"Usage: $0 {run|build}"
    exit 1
esac

exit 0