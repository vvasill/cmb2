#!/bin/bash

#########################################################################
### Another statistical details ###
#########################################################################

smooth_line='30'
corr_line='60 120 180 300 600 900'
slice_line='1 2 3 4 5 6 7 8 9 10 11 12'

#for smooth in $smooth_line
#do
#	for corr in $corr_line
#	do
#		> './re_results/ad_stat2_'$smooth'_'$corr
	
#		for slice in $slice_line
#		do
#			echo $smooth $corr $slice
#			map_name='./'$smooth'/correlations_results_'$slice'/corr_'$smooth'_'$corr'_masked_eq.fits'
#			left=$(echo $( difmap -st -lev -0.5 -eps 0.5 $map_name ) | grep -o '[^=]\+$' | cut -d' ' -f1)
#			right=$(echo $( difmap -st -lev 0.5 -eps 0.5 $map_name ) | grep -o '[^=]\+$' | cut -d' ' -f1)
#			av=$( echo "$left/2 + $right/2" | bc -l )
#			left_full=$( echo "($left - $av)/$av" | bc -l )
#			right_full=$( echo "($right - $av)/$av" | bc -l )
#			echo $slice' '$left_full' '$right_full >> './re_results/ad_stat2_'$smooth'_'$corr
#		done	
		
#		python3 sp.py $smooth $corr
#	done
#done

#for smooth in $smooth_line
#do
#	for slice in $slice_line
#	do
#		> './re_results/re_ad_stat_'$smooth'_'$slice
#		
#		for corr in $corr_line
#		do
#			echo $smooth $corr $slice
#			res=$( python3 advanced_stat.py $smooth $corr $slice )
#			echo $corr' '$res >> './re_results/re_ad_stat_'$smooth'_'$slice
#		done	
#		
#		python3 sp.py $smooth $slice
#	done
#done

for smooth in $smooth_line
do
	for corr in $corr_line
	do
		> './re_results/lcdm_ad_stat2_'$smooth'_'$corr
		
		for slice in $slice_line
		do
			left_full=0
			right_full=0
			
			for (( lcdm_number = 1; lcdm_number <= 100; lcdm_number++ ))
			do
				echo $smooth $corr $slice
				map_name='./'$smooth'/correlations_results_'$slice'/corr_lcdm_'$smooth'_'$corr'_'$lcdm_number'_masked_eq.fits'
				echo $map_name
				left=$(echo $( difmap -st -lev -0.5 -eps 0.5 $map_name ) | grep -o '[^=]\+$' | cut -d' ' -f1)
				right=$(echo $( difmap -st -lev 0.5 -eps 0.5 $map_name ) | grep -o '[^=]\+$' | cut -d' ' -f1)
				av=$( echo "$left/2 + $right/2" | bc -l )
				left_full=$( echo "$left_full + ($left - $av)/$av/100" | bc -l )
				right_full=$( echo "$right_full + ($right - $av)/$av/100" | bc -l )
			done
			echo $slice' '$left_full' '$right_full >> './re_results/lcdm_ad_stat2_'$smooth'_'$corr
		done
		
		python3 sp.py $smooth $corr
	done
done
