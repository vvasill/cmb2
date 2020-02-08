#!/bin/bash

#########################################################################
### Pixels statistics
#########################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
cd $project_home_path'correlations_results/'

fwhm_corr='300 600 900'
fw='300'
random_n='10'

> ./centre_line
eps="0.05"
num="-0.9"
for i in {1..17}
do
	num=$( echo $num + 2*$eps | bc -l )
	echo $num >> ./centre_line
done

#############################################################################################################
for fw_corr in $fwhm_corr
do
	> ./'stat_'$fw' '$fw_corr'.txt'
	while read centre
	do
		num=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path'correlations_results/corr_'$fw_corr'.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
		echo $centre' '$eps' '$num >> 'stat_'$fw' '$fw_corr'.txt'
	done <<< "$(cat ./centre_line)"
done

for fw_corr in $fwhm_corr
do
	> ./'stat_lcdm_'$fw' '$fw_corr'.txt'
	while read centre
	do
		num=0
		sigma=0
		> ./temp_line
		for random in {1..10}
		do
			num_add=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)	
			num=$( echo $num + $num_add/$random_n | bc -l )
			echo $num_add >> temp_line
		done
		
		while read line
		do 
			sigma=$( echo $sigma + $line*$line/9 - 2.0*$line*$num/9 + $num*$num/9 | bc -l )
		done <<< "$(cat ./temp_line)"
		
		echo $centre' '$eps' '$num' '$sigma>> 'stat_lcdm_'$fw' '$fw_corr'.txt'
	done <<< "$(cat ./centre_line)"
done

for fw_corr in $fwhm_corr
do
	python3 $project_home_path'print.py' $project_home_path'correlations_results/stat_'$fw' '$fw_corr'.txt' $project_home_path'correlations_results/stat_lcdm_'$fw' '$fw_corr'.txt' $fw $fw_corr
done
