# bashscripts
Container for useful bash scripts

### fxcm.sh
This scripts downloads, extracts, converts, concatenates and processes tick data of FXCM public repository. It is tested on macOS Mojave. You need to install dos2unix! like brew install dos2unix.

### newpost.sh
This script creates a new jekyll post template inside the _posts folder, or inside the current folder if the _posts folder does not exist. Copy it to /usr/local/bin/newpost 

### reqdeb.php
This script sends n requests to a url and searches its response for phrases.

### spotify.sh
This script routes the spotify traffic through the wifi interface

### subl.sh
handle the start of sublimetext from the cli. the script looks inside the current directory for a .sublime-project file, if found open it, if not open the current directory. If the script is called with a path to a file as parameter it calls the sublimetext binary with that path. Copy it to /usr/local/bin/subl 

### swproject.sh
This script switches project configuration in wp-config.php

### wpdbdump.sh
This script extracts database credentials of WordPress wp-config.php and runs mysqldump

### autoindex.sh
this script finds every folder without a index.html file, creates one with a content refresh meta tag to redirect to base.de/index.html