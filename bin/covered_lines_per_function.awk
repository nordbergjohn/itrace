#!/usr/bin/awk -f
# Given pretty printed addr2line output,
# this script prints the function name and number of lines reported per function
# The number of lines are subtracted by 2 to remove function prologue and epilogue
# (Assumption: The input is sorted and unique)
BEGIN { FS="[ :]"; OFS=":"; functionName="";} 
{if ($1 != functionName) 
  {if (functionName != "") {print functionPath, functionName, allLines} functionName=$1; functionPath=$3; numberOfLines=1; allLines=$4} 
   else {allLines=allLines" "$4}} 
END {print functionPath, functionName, allLines}

