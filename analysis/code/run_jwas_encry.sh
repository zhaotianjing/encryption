#! /bin/bash

nRep=10 #5 
h2All=("0.1" "0.3" "0.5" "0.7")  #("0.1" "0.3" "0.5" "0.7")  
pctAll=("0.01" "0.1" "0.5" "1.0")  #QTLpct.   "0.01" "0.1" "0.5" "1.0"


for pct in "${pctAll[@]}"
do
	for h2 in "${h2All[@]}"
	do
		cd pct."$pct".h2."$h2"

		for rep in $( eval echo {4..$nRep} )  #rep1,...,rep20
		do
		    sbatch /group/qtlchenggrp/tianjing/encryption/jwas_encry.sbatch $pct $h2 $rep
		done

		cd .. 
	done
done