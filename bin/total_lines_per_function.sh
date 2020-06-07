#!/bin/bash

ARGC="$#"
NUMLINES=0

if [[ $ARGC -eq 3 ]]; then
NUMLINES=`gdb -batch -ex "exec-file $1" -ex "symbol-file $2" -ex "disass /s $3" | awk 'BEGIN {COUNT=0} /^[0-9]+/{STORED=$1} /^ +0x/ {if (STORED != 0) {++COUNT; STORED=0}} END {print COUNT-2}'`;

elif [[ $ARGC -eq 2 ]]; then
NUMLINES=`gdb -batch -ex "file $1" -ex "disass /s $3" | awk 'BEGIN {COUNT=0} /^[0-9]+/{STORED=$1} /^ +0x/ {if (STORED != 0) {++COUNT; STORED=0}} END {print COUNT-2}'`;
else
  echo "Wrong number of arguments!"
  exit -1;
fi

exit $NUMLINES;
