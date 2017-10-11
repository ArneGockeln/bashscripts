#!/bin/bash
#title			:wpdbumb.sh
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
DBNAME=''
DBUSER=''
DBPWD=''
DBHOST=''

# @todo:
# does not save the result in the variable \1
sed -En "/define\([\'\"]DB_NAME[\'\"],[[:blank:]]?[\'\"](.*)[\'\"]\)\;/\\1/" "${CFGFILE}"
echo $1