#!/bin/bash
#author: Arne Gockeln, https://www.arnegockeln.com
#description: This scripts downloads, extracts, converts, concatenates and processes tick data of FXCM public repository.
#             It is tested on macOS Mojave. You need to install dos2unix! like brew install dos2unix.
# 
#             Usage: ./fxcm.sh SYMBOL YEAR STARTWEEK ENDWEEK
# 
#             Example: Download week 1-4 of 2018 of EURUSD. Output will be saved to EURUSD-2018-1-4.csv
# 
#             $ ./fxcm.sh EURUSD 2018 1 4
#version: 1.0
#notes: requires tr, dos2unix

if [ $# -lt 4 ]; then
	echo "Usage:"
	echo "  $0 SYMBOL YEAR STARTWEEK ENDWEEK"
	exit 1
fi

SYMBOL=$1
YEAR=$2
START=$3
END=$4

OUTPUTFILE="${SYMBOL}-${YEAR}-${START}-${END}"

# download the week files with curl. [1-14] means week 1-14
curl -O "https://tickdata.fxcorporate.com/${SYMBOL}/${YEAR}/[${START}-${END}].csv.gz"
# extract all week files:
echo " "
echo "Extraction..."
for file in $(ls -1p|sort -n|grep -v /|grep csv.gz); do echo "  ${file}"; gunzip "${file}"; done
# replace 0byte characters
echo "0byte replacement..."
for file in $(ls -1p|sort -n|grep -v /|grep csv); do echo "  ${file}"; tr < "${file}" -d '\000' > "${file}.out"; rm "${file}"; done
# convert to unix (get it with: brew install dos2unix), replace Datetime,Bid,Ask lines
echo "dos2unix conversion and replace headers..."
for file in $(ls -1p|sort -n|grep -v /|grep csv.out); do dos2unix "${file}"; sed -i '' '/DateTime,Bid,Ask/d' "${file}"; done
# concat to 1 file, ls -1p sorted
echo "concatenation..."
for file in $(ls -1p|sort -n|grep -v /|grep csv.out); do echo "  ${file} >> ${OUTPUTFILE}.result"; cat "${file}" >> "${OUTPUTFILE}.result"; done
# clear csv files
echo "file cleanup..."
rm *.csv.out
# renaming
mv "${OUTPUTFILE}.result" "${OUTPUTFILE}.csv"
# file size
echo "Done."
du -sh "${OUTPUTFILE}.csv"