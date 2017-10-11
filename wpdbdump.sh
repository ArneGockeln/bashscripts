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
	echo "	$0 /path/to/wp-config.php"
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
DBNAME=$(sed -En "s/define\([\'\"]DB_NAME[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBUSER=$(sed -En "s/define\([\'\"]DB_USER[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBPWD=$(sed -En "s/define\([\'\"]DB_PASSWORD[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")
DBHOST=$(sed -En "s/define\([\'\"]DB_HOST[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\1/p" "${CFGFILE}")

BACKUPFILENAME="${DBNAME}_backup.sql"

# fill mysql dump
mysqldump -u"${DBUSER}" -p"${DBPWD}" --host="${DBHOST}" "${DBNAME}" > "${BACKUPFILENAME}"
echo "${BACKUPFILENAME} saved."
