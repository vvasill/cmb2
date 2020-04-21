#!/bin/bash

#########################################################################
### Pixels statistics
#########################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
slice=12
correlations_results='correlations_results_'$slice
cd $project_home_path$correlations_results

fwhm_corr='60 120 180 300 600 900'
fw='30'
random_n='100'
eps="0.05"

python3 $project_home_path'centre_line_generator.py' $eps

#############################################################################################################

for fw_corr in $fwhm_corr
do
	> ./'stat_'$fw'_'$fw_corr'.txt'
	
	while read centre
	do
		num=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
		echo $centre' '$eps' '$num >> 'stat_'$fw'_'$fw_corr'.txt'
	done <<< "$(cat ./centre_line)" #trick for preserving value of variable
done

for fw_corr in $fwhm_corr
do
	> ./'stat_lcdm_'$fw'_'$fw_corr'.txt'
	
	while read centre
	do
		av=0
		sigma=0
		> ./temp_line
		for (( random = 1; random <= $random_n; random++ ))
		do
			num_add=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
			av=$( echo $av + $num_add/$random_n | bc -l )
			echo $num_add >> temp_line
		done
		
		while read line
		do 
			sigma=$( echo "$sigma + ($line-$av)*($line-$av)/($random_n-1)" | bc -l )
		done <<< "$(cat ./temp_line)"
		
		echo $centre' '$eps' '$av' '$sigma>> 'stat_lcdm_'$fw'_'$fw_corr'.txt'
	done <<< "$(cat ./centre_line)"
done

for fw_corr in $fwhm_corr
do
	python3 $project_home_path'print.py' $project_home_path$correlations_results'/stat_'$fw'_'$fw_corr $project_home_path$correlations_results'/stat_lcdm_'$fw'_'$fw_corr $project_home_path$correlations_results'/'$slice'_stat_'$fw'_'$fw_corr $fw $fw_corr
done

rm ./temp_line
