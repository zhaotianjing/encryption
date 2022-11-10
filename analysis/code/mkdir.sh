#!/bin/bash

#this file is to make folders
h2All=("0.1" "0.3" "0.5" "0.7")  
pctAll=("0.01" "0.1" "0.5" "1.0")  #QTLpct

for pct in "${pctAll[@]}"
do
	for h2 in "${h2All[@]}"
	do
		mkdir -p pct."$pct".h2."$h2"
	done
done
