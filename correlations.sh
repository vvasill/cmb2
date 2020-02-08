#!/bin/bash

#########################################################################
### Let's calculate correlations between SMICA map and SDSS catalog data
#########################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
catalog_path=$project_home_path'sdss_catalog/'
lmax=4096
nx="$(( 2*$lmax + 1 ))"
np="$(( 2*$nx ))"

z_min=0.0
z_max=0.1
fwhm_corr='300 600 900'
fw="300"
random_n='10'

#############################################################################################################
#extract data from csv-file
catalog_name=$catalog_path'g_'$z_min'_'$z_max
other_catalog_name=$catalog_path'temp_g_'$z_min'_'$z_max	

#python3 read_csv.py $z_min $z_max $catalog_name'.csv' $catalog_name'.dat'
#awk '{printf "%sd %sd 1.0\n", $1, $2}' $catalog_name'.dat' > $other_catalog_name'.dat'
 	
#generate map from SDSS catalog data
#mappat -fp $other_catalog_name'.dat' -o $maps_path'src.fits' -nx $nx -np $np
#f2fig $maps_path'src.fits' -o $maps_path'src'$z_min'_'$z_max'.gif' -Cs 0.0,1.0 -c 0 -notitle
#cl2map -map $maps_path'src.fits' -lmax $lmax -ao $maps_path'src_alm.fits'

#############################################################################################################
#smooth maps

map=$maps_path'src'

lmax=$(echo 360.0*60.0/$fw | bc -l)
nx=$(python -c "print 2*$lmax + 1")
np=$(python -c "print 2*(2*$lmax + 1)")
echo "src_smoothing "$fwhm
	
<<COMMENT
#convolving and map generation
rsalm $map'_alm.fits' -fw $fw -o $map'_'$fw'_alm.fits'
cl2map -falm $map'_'$fw'_alm.fits' -o $map'_'$fw'_smooth_map.fits' -lmax $lmax -nx $nx -np $np
f2fig $map'_'$fw'_smooth_map.fits' -o $map'_'$fw'_smooth_map.gif'
COMMENT

<<COMMENT
#or masking
rsalm $map'_alm_eq.fits' -fw $fw -o $map'_'$fw'_smooth_alm.fits'
echo 'difalm'
difalm -eq $map'_'$fw'_smooth_alm.fits' -o $map'_'$fw'_smooth_alm_eq.fits'
echo 'cl2map'
cl2map -falm $map'_'$fw'_smooth_alm_eq.fits' -o $map'_'$fw'_smooth_map_eq.fits' -lmax $lmax -nx $nx -np $np
f2fig $map'_'$fw'_smooth_map_eq.fits' -o test_1.gif
echo 'mapcut'
mapcut $map'_'$fw'_smooth_map_eq.fits' -rm -90.0d,0d,-5.0d,360.0d -o temp.fits
mapcut temp.fits -rm 90.0d,0.0d,20.0d -o $map'_'$fw'_smooth_masked_map_eq.fits'
f2fig $map'_'$fw'_smooth_masked_map_eq_eq.fits' -o test_3.gif
echo 'cl2map'
cl2map -map $map'_'$fw'_smooth_masked_map_eq.fits' -lmax $lmax -ao $map'_'$fw'_smooth_masked_alm_eq.fits'
echo 'difalm'
difalm $map'_'$fw'_smooth_masked_alm_eq.fits' -q2g -o $map'_'$fw'_smooth_masked_alm.fits'
echo 'cl2map'
cl2map -falm $map'_'$fw'_smooth_masked_alm.fits' -o $map'_'$fw'_smooth_masked_map.fits' -lmax $lmax -nx $nx -np $np
f2fig $map'_'$fw'_smooth_masked_map.fits' -o $map'_'$fw'_smooth_masked_map.gif'
COMMENT

#############################################################################################################
map=$maps_path'smica_release3'

lmax=$(echo 360.0*60.0/$fw | bc -l)
nx=$(python -c "print 2*$lmax + 1")
np=$(python -c "print 2*(2*$lmax + 1)")
echo "smica_smoothing "$fwhm
	
<<COMMENT		
#convolving and map generation
#rsalm $map'_alm.txt' -fw $fw -o $map'_'$fw'_alm.fits'
#cl2map -falm $map'_'$fw'_alm.fits' -o $map'_'$fw'_smooth_map.fits' -lmax $lmax -nx $nx -np $np
#f2fig $map'_'$fw'_smooth_map.fits' -o $map'_'$fw'_smooth_map.gif'
COMMENT

#find correlations between SMICA map and src map
for fw_corr in $fwhm_corr
do
	lmax=$(echo 360.0*60.0/$fw_corr | bc -l)
	nx=$(python -c "print 2*$lmax + 1")
	np=$(python -c "print 2*(2*$lmax + 1)")

	echo "correlating "$fw_corr
	difmap -cw $fw_corr $maps_path'src_'$fw'_smooth_masked_map.fits' $maps_path'smica_release3_'$fw'_smooth_map.fits' -o $project_home_path'correlations_results/corr_'$fw_corr'.fits'
	f2fig $project_home_path'correlations_results/corr_'$fw_corr'.fits' -o $project_home_path'correlations_results/corr_'$fw_corr'.gif'
	
	#mask-2
	cl2map -map $project_home_path'correlations_results/corr_'$fw_corr'.fits' -lmax $lmax -ao temp_alm.fits
	difalm -eq temp_alm.fits -o temp_alm_eq.fits
	cl2map -falm temp_alm_eq.fits -o temp_map_eq.fits -lmax $lmax -nx $nx -np $np
	mapcut temp_map_eq.fits -rm -90.0d,0d,-5.0d,360.0d -o temp.fits
	mapcut temp.fits -rm 90.0d,0.0d,20.0d -o temp_map_masked_eq.fits
	cl2map -map temp_map_masked_eq.fits -lmax $lmax -ao temp_alm_masked_eq.fits
	difalm temp_alm_masked_eq.fits -q2g -o temp_alm_masked.fits
	cl2map -falm temp_alm_masked.fits -o $project_home_path'correlations_results/corr_'$fw_corr'_masked.fits' -lmax $lmax -nx $nx -np $np
	f2fig $project_home_path'correlations_results/corr_'$fw_corr'_masked.fits' -o $project_home_path'correlations_results/corr_'$fw_corr'_masked.gif'
done

#############################################################################################################
#generate gauss-LCDM
for random in {1..10}
do
	cl2map -Cl $maps_path'cl_lcdm.dat' -lmax 1000 -nx 2001 -np 4002 -ao $maps_path'lcdm_map_alm.fits' #-o $maps_path'lcdm_map_'$random'.fits'
	#f2fig $maps_path'lcdm_map_'$random'.fits' -o $maps_path'lcdm_map_'$random'.gif'

	map=$maps_path'lcdm_map'

	lmax=$(echo 360.0*60.0/$fw | bc -l)
	nx=$(python -c "print 2*$lmax + 1")
	np=$(python -c "print 2*(2*$lmax + 1)")
	echo "lcdm smoothing "$fw
			
	#convolving and map generation
	rsalm $map'_alm.fits' -fw $fw -o $map'_'$fw'_alm.fits'
	cl2map -falm $map'_'$fw'_alm.fits' -o $map'_'$fw'_smooth_map_'$random'.fits' -lmax $lmax -nx $nx -np $np
	f2fig $map'_'$fw'_smooth_map_'$random'.fits' -o $map'_'$fw'_smooth_map_'$random'.gif'

	#find correlations between gauss-LCDM map and src map
	for fw_corr in $fwhm_corr
	do
		lmax=$(echo 360.0*60.0/$fw_corr | bc -l)
		nx=$(python -c "print 2*$lmax + 1")
		np=$(python -c "print 2*(2*$lmax + 1)")

		echo "correlating lcdm "$fw_corr'_'$random
		difmap -cw $fw_corr $maps_path'src_'$fw'_smooth_masked_map.fits' $maps_path'lcdm_map_'$fw'_smooth_map_'$random'.fits' -o $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'.fits'
		f2fig $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'.fits' -o $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'.gif'
	
		#mask-3
		cl2map -map $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'.fits' -lmax $lmax -ao temp_alm.fits
		difalm -eq temp_alm.fits -o temp_alm_eq.fits
		cl2map -falm temp_alm_eq.fits -o temp_map_eq.fits -lmax $lmax -nx $nx -np $np
		mapcut temp_map_eq.fits -rm -90.0d,0d,-5.0d,360.0d -o temp.fits
		mapcut temp.fits -rm 90.0d,0.0d,20.0d -o temp_map_masked_eq.fits
		cl2map -map temp_map_masked_eq.fits -lmax $lmax -ao temp_alm_masked_eq.fits
		difalm temp_alm_masked_eq.fits -q2g -o temp_alm_masked.fits
		cl2map -falm temp_alm_masked.fits -o $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'_masked.fits' -lmax $lmax -nx $nx -np $np
		f2fig $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'_masked.fits' -o $project_home_path'correlations_results/corr_lcdm_'$fw_corr'_'$random'_masked.gif'
	done
done
