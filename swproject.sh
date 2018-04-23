#!/bin/bash
# This script switches project configuration in wp-config.php

# ----------- Settings ------------
## dortmund24
D_DB="do24_test"
D_TABLE_PREFIX="d24dev_"
## unna24
U_DB="unna24_local"
U_TABLE_PREFIX="j9qk96g_"
## ahaus.jetzt
A_DB="ahaus"
A_TABLE_PREFIX="d24dev_"
## DB_USER / DB_PASSWORD
DB_USER="root"
DB_PASSWORD="root"
DB_HOST="localhost"
# Options
# Enable Debug
USE_DEBUG=0
# ---------------------------------

# test for parameter
if [ $# -lt 1 ]; then
    echo "Usage: "
    echo "  $0 {do24|un24|ahaus}"
    exit 1
fi

PROJECT=$1

# test for wp-config.php
if [ ! -f "wp-config.php" ]; then
    echo "wp-config.php file not found!"
    exit 1
fi

echo "Switching project to <$PROJECT>."

# replace user, password, host
sed -i '' -e "s/DB_USER', '.*'/DB_USER', '$DB_USER'/g" wp-config.php
sed -i '' -e "s/DB_PASSWORD', '.*'/DB_PASSWORD', '$DB_PASSWORD'/g" wp-config.php
sed -i '' -e "s/DB_HOST', '.*'/DB_HOST', '$DB_HOST'/g" wp-config.php

# change wp_debug
if [ $USE_DEBUG == 1 ]; then
    echo "Enable WP_DEBUG."
    sed -i '' -e "s/WP_DEBUG', .*)/WP_DEBUG', true)/g" wp-config.php
else
    echo "Disable WP_DEBUG."
    sed -i '' -e "s/WP_DEBUG', .*)/WP_DEBUG', false)/g" wp-config.php
fi

# replace db and db prefix 
case "$PROJECT" in
    do24)
        sed -i '' -e "s/DB_NAME', '.*'/DB_NAME', '$D_DB'/g" wp-config.php
        sed -i '' -e "s/table_prefix  = '.*'/table_prefix  = '$D_TABLE_PREFIX'/g" wp-config.php
        ;;
    un24)
        sed -i '' -e "s/DB_NAME', '.*'/DB_NAME', '$U_DB'/g" wp-config.php
        sed -i '' -e "s/table_prefix  = '.*'/table_prefix  = '$U_TABLE_PREFIX'/g" wp-config.php
        ;;
    ahaus)
        sed -i '' -e "s/DB_NAME', '.*'/DB_NAME', '$A_DB'/g" wp-config.php
        sed -i '' -e "s/table_prefix  = '.*'/table_prefix  = '$A_TABLE_PREFIX'/g" wp-config.php
        ;;
    *)
        echo "Project $PROJECT not found."
        exit 1
esac
exit 0
