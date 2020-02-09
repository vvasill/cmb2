#!/bin/bash

#########################################################################
### Pixels statistics
#########################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
cd $project_home_path'correlations_results/'

fwhm_corr='300 600 900'
fw='180'
random_n='100'
eps="0.05"
eps_null="0.001"

python3 $project_home_path'centre_line_generator.py' $eps

<< COMMENT
> ./centre_line
num="-0.9"
for i in {1..17}
do
	num=$( echo $num + 2*$eps | bc -l )
	echo $num >> ./centre_line
done
COMMENT

#############################################################################################################
for fw_corr in $fwhm_corr
do
	> ./'stat_'$fw' '$fw_corr'.txt'
	
	while read centre
	do
		num=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path'correlations_results/corr_'$fw_corr'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
		if (( $( echo $centre '>' -1.0*$eps | bc -l ) )) && (( $( echo $centre '<' $eps | bc -l ) )); then
			num_null=$(echo $( difmap -st -lev 0.0 -eps $eps_null $project_home_path'correlations_results/corr_'$fw_corr'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
			num=$( echo $num - $num_null | bc -l )
		fi
		echo $centre' '$eps' '$num >> 'stat_'$fw' '$fw_corr'.txt'
	done <<< "$(cat ./centre_line)"
done

for fw_corr in $fwhm_corr
do
	> ./'stat_lcdm_'$fw' '$fw_corr'.txt'
	
	while read centre
	do
		av=0
		sigma=0
		> ./temp_line
		for random in {1..100}
		do
			num_add=$(echo $( difmap -st -lev $centre -eps $eps $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
			if (( $( echo $centre '>' -1.0*$eps | bc -l ) )) && (( $( echo $centre '<' $eps | bc -l ) )); then
				num_null=$(echo $( difmap -st -lev 0.0 -eps $eps_null $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'_masked_eq.fits' ) | grep -o '[^=]\+$' | cut -d' ' -f1)
				num_add=$( echo $num_add - $num_null | bc -l )
			fi	
			av=$( echo $av + $num_add/$random_n | bc -l )
			echo $num_add >> temp_line
		done
		
		while read line
		do 
			sigma=$( echo "$sigma + ($line-$av)*($line-$av)/($random_n-1)" | bc -l )
		done <<< "$(cat ./temp_line)"
		
		echo $centre' '$eps' '$av' '$sigma>> 'stat_lcdm_'$fw' '$fw_corr'.txt'
	done <<< "$(cat ./centre_line)"
done

for fw_corr in $fwhm_corr
do
	python3 $project_home_path'print.py' $project_home_path'correlations_results/stat_'$fw' '$fw_corr'.txt' $project_home_path'correlations_results/stat_lcdm_'$fw' '$fw_corr'.txt' $fw $fw_corr
done

rm ./temp_line
