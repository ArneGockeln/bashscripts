#!/bin/bash
#title			:wpdbdump.sh
#description	:This script extracts database credentials of WordPress wp-config.php
#				 and runs mysqldump
#author			:Arne Gockeln, www.arnegockeln.com
#version		:0.1
#notes			:requires sed and mysqldump
#==================================================================================================
# usage
if [ $# -lt 1 ]; then
    echo "The script extracts database credentials of WordPress wp-config.php and runs mysqldump"
    echo "requires: sed and mysqldump"
    echo "Usage: "
    echo "  $0 /path/to/wp-config.php"
    exit 1
fi

# get config file
CFGFILE=$1

# test config file
if [ ! -f "$CFGFILE" ]; then
    echo "Error: ${CFGFILE} does not exist!"
    exit 1
fi

# extract db name from config file
# sed params for linux
SEDPARAMS="-rn"
# sed params for mac
if [[ "$OSTYPE" == "darwin"* ]]; then
	SEDPARAMS="-En"
fi

DBNAME=$(sed "$SEDPARAMS" "s/define\([\'\"]DB_NAME[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBUSER=$(sed "$SEDPARAMS" "s/define\([\'\"]DB_USER[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBPWD=$(sed "$SEDPARAMS" "s/define\([\'\"]DB_PASSWORD[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBHOST=$(sed "$SEDPARAMS" "s/define\([\'\"]DB_HOST[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")

DBFILE=$DBNAME
DBFILE=$DBFILE".sql"

# fill mysql dump
echo "user: $DBUSER"
echo "pwd: $DBPWD"
echo "dbname: $DBNAME"
echo "host: $DBHOST"
echo "backup: $DBFILE"
#mysqldump -u"${DBUSER}" -p"${DBPWD}" --host="${DBHOST}" "${DBNAME}" > "${BACKUPFILENAME}"
