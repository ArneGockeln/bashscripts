#!/bin/bash
# Author: Arne Gockeln, https://www.arnegockeln.com
# This scripts downloads, extracts, converts, concatenates and processes tick data of FXCM public repository.
# 
# Usage: ./fxcm.sh SYMBOL STARTWEEK ENDWEEK
# 
# Example: Download week 1-4 of EURUSD. Output will be saved to EURUSD.csv
# 
# $	./fxcm.sh EURUSD 1 4
# 
SYMBOL=$1
START=$2
END=$3

# 1. download the week files with curl. [1-14] means week 1-14
curl -O https://tickdata.fxcorporate.com/$SYMBOL/2018/[$START-$END].csv.gz
# 2. extract all week files:
echo "Extraction..."
find . -type f -iname "*.csv.gz" -print0 | while IFS= read -r -d $'\0' line; do gunzip $line; done
# 3. replace 0byte characters
echo "0byte replacement..."
find . -type f -iname "*.csv" -print0 | while IFS= read -r -d $'\0' line; do tr < $line -d '\000' > $line.out; done
# 4. convert to unix (get it with: brew install dos2unix)
echo "dos2unix conversion..."
find . -type f -iname "*.csv.out" -print0 | while IFS= read -r -d $'\0' line; do dos2unix $line; done
# 5. rename files
echo "renaming..."
find . -type f -iname "*.csv.out" | while read FILE; do newfile="$(echo ${FILE} |sed -e 's/csv\.out/csv/')"; mv "${FILE}" "${newfile}"; done
# 6. concat to 1 file, ls -1p sorted
echo "concatenation..."
for file in $(ls -1p|grep -v /|grep csv); do cat $file >> "${SYMBOL}.result"; done
# 7. replace Datetime,Bid,Ask lines
echo "file cleanup..."
sed -i '' '/DateTime,Bid,Ask/d' "${SYMBOL}.result"
# 8. clear csv files
rm *.csv*
# 9. renaming
mv "${SYMBOL}.result" "${SYMBOL}.csv"
echo "Done."