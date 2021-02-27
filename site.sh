#!/bin/sh
# This script helps to create, run or build a jekyll site
# 
# Parameter:
# site build    Use it to build for production
# site run      Use it to serve a jekyll site
# site install  Use it to install jekyll gems
# site update   Use it to update jekyll gems
# site clean    Use it to clean the site and metadata files
# 
# Author: Arne Gockeln
# Version: 0.4
# 

CMD=$1
BUILDCMD="JEKYLL_ENV=production bundle exec jekyll build --trace"
RUNCMD="JEKYLL_ENV=development bundle exec jekyll serve --trace --draft"
INSTALLCMD="bundle install"
CLEANCMD="bundle exec jekyll clean"
UPDATECMD="bundle update"

# check if we are inside a jekyll directory
JEKYLL=$(find . -maxdepth 1 -name _config.yml)
if [[ -z "$JEKYLL" ]]; then
    echo "Run this script inside a jekyll project folder."
    exit 1
fi

case "$CMD" in
    build)
    eval $BUILDCMD
    # create index.html files in empty folders
    echo "Create index.html in all empty folders..."
    find ./_site/ -depth -type d '!' -exec test -e "{}/index.html" ';' -print|while read f; do echo '<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0;url=/index.html" /></head><body></body></html>' > "$f/index.html"; done
    echo "done."
    ;;
    
    run)
    
    eval $RUNCMD
    ;;

    install)
    eval $INSTALLCMD
    ;;

    update)
    eval $UPDATECMD
    ;;

    clean)
    eval $CLEANCMD
    ;;

    *)
    echo $"Usage: $0 {run|build|install|update|clean}"
    exit 1
esac

exit 0
