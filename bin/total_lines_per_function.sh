#!/bin/bash
# Expects input to be executable, executable debug symbols and a function name to disassemble
# 
EXPECTED_ARGUMENTS=3
ARGC="$#"
if [[ $ARGC -ne $EXPECTED_ARGUMENTS ]]; then
  echo "Wrong number of arguments!"
  exit -1;
fi

gdb -batch -ex "exec-file $1" -ex "symbol-file $2" -ex "disass /s $3" | awk 'BEGIN {COUNT=0} /^[0-9]+/{STORED=$1} /^ +0x/ {if (STORED != 0) {++COUNT; STORED=0}} END {print COUNT-2}'

