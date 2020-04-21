#!/bin/bash

#############################################################################################################
### Let's calculate correlations between SMICA map and SDSS catalog data
#############################################################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
catalog_path=$project_home_path'sdss_catalog/'

z_min=2.0
z_max=3.0
slice=12
correlations_results='correlations_results_'$slice
fwhm_corr='60 120 180 300 600 900' #arcmin
fw='30' #arcmin
random_n='100'
value_out_of_range=10.0

#############################################################################################################
#generate src map

lmax=4096
nx="$(( 2*$lmax + 1 ))"
np="$(( 2*$nx ))"

	#extract data from csv-file
catalog_name=$catalog_path'g_'$z_min'_'$z_max
other_catalog_name=$catalog_path'temp_g_'$z_min'_'$z_max	

python3 read_csv.py $z_min $z_max $catalog_name'.csv' $catalog_name'.dat'
awk '{printf "%sd %sd 1.0\n", $1, $2}' $catalog_name'.dat' > $other_catalog_name'.dat'
 	
	#generate map from SDSS catalog data
mappat -fp $other_catalog_name'.dat' -o $maps_path'src_'$slice'.fits' -nx $nx -np $np
f2fig $maps_path'src_'$slice'.fits' -o $maps_path'src'$z_min'_'$z_max'.gif' -Cs 0.0,1.0 -c 0 -notitle

lmax=1000
nx="$(( 2*$lmax + 1 ))"
np="$(( 2*$nx ))"
cl2map -map $maps_path'src_'$slice'.fits' -lmax $lmax -ao $maps_path'src_'$slice'_alm.fits'

rm $other_catalog_name'.dat'

#############################################################################################################
#smooth src map

map=$maps_path'src'
lmax=$(echo 360.0*60.0/$fw | bc -l)
nx=$(python -c "print 2*$lmax + 1")
np=$(python -c "print 2*(2*$lmax + 1)")
echo "src_smoothing "$fw
	
	#smoothing
rsalm $map'_'$slice'_alm.fits' -fw $fw -o $map'_'$fw'_smooth_'$slice'_alm.fits'
	#masking
difalm -eq $map'_'$fw'_smooth_'$slice'_alm.fits' -o $map'_'$fw'_smooth_'$slice'_alm_eq.fits'
cl2map -falm $map'_'$fw'_smooth_'$slice'_alm_eq.fits' -o $map'_'$fw'_smooth_'$slice'_map_eq.fits' -lmax $lmax -nx $nx -np $np
mapcut $map'_'$fw'_smooth_'$slice'_map_eq.fits' -rm -90.0d,0d,-5.0d,360.0d -d 0.0 -o $maps_path'temp.fits'
mapcut $maps_path'temp.fits' -rm 90.0d,0.0d,20.0d -d 0.0 -o $map'_'$fw'_smooth_'$slice'_masked_map_eq.fits'
f2fig $map'_'$fw'_smooth_'$slice'_masked_map_eq.fits' -o $map'_'$fw'_smooth_'$slice'_masked_map_eq.gif'

#############################################################################################################
#smooth smica map

map=$maps_path'smica_release3'
#lmax=$(echo 360.0*60.0/$fw | bc -l)
#nx=$(python -c "print 2*$lmax + 1")
#np=$(python -c "print 2*(2*$lmax + 1)")
echo "smica_smoothing "$fw
	
	#convolving and map generation
#rsalm $map'_alm.txt' -fw $fw -o $map'_'$fw'_smooth_alm.fits'
	#masking
#difalm -eq $map'_'$fw'_smooth_alm.fits' -o $map'_'$fw'_smooth_alm_eq.fits'
#cl2map -falm $map'_'$fw'_smooth_alm_eq.fits' -o $map'_'$fw'_smooth_map_eq.fits' -lmax $lmax -nx $nx -np $np
#mapcut $map'_'$fw'_smooth_map_eq.fits' -rm -90.0d,0d,-5.0d,360.0d -d 0.0 -o $maps_path'temp.fits'
#mapcut $maps_path'temp.fits' -rm 90.0d,0.0d,20.0d -d 0.0 -o $map'_'$fw'_smooth_masked_map_eq.fits'

	#find correlations between SMICA map and src map
for fw_corr in $fwhm_corr
do
	echo "correlating "$fw_corr
	difmap -cw $fw_corr $maps_path'src_'$fw'_smooth_'$slice'_masked_map_eq.fits' $maps_path'smica_release3_'$fw'_smooth_masked_map_eq.fits' -o $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_eq.fits'
	f2fig $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_eq.fits' -o $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_eq.gif'
	
		#after masking
	mapcut $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_eq.fits' -rm -90.0d,0d,-5.0d,360.0d -d $value_out_of_range -o $maps_path'temp.fits'
	mapcut $maps_path'temp.fits' -rm 90.0d,0.0d,20.0d -d $value_out_of_range -o $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_masked_eq.fits'
	f2fig $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_masked_eq.fits' -o $project_home_path$correlations_results'/corr_'$fw'_'$fw_corr'_masked_eq.gif'
done

#############################################################################################################
for (( random = 1; random <= $random_n; random++ ))
do
	#generate gauss-LCDM
	#cl2map -Cl $maps_path'cl_lcdm.dat' -lmax 1000 -nx 2001 -np 4002 -ao $maps_path'lcdm_map_alm_'$random'.fits' #-o $maps_path'lcdm_map_'$random'.fits'
	#f2fig $maps_path'lcdm_map_'$random'.fits' -o $maps_path'lcdm_map_'$random'.gif'

	map=$maps_path'lcdm_map'
	#lmax=$(echo 360.0*60.0/$fw | bc -l)
	#nx=$(python -c "print 2*$lmax + 1")
	#np=$(python -c "print 2*(2*$lmax + 1)")
	echo 'lcdm-'$random' smoothing '$fw
					
		#convolving and map generation
	#rsalm $map'_alm_'$random'.fits' -fw $fw -o $map'_smooth_alm_temp.fits'
		#masking
	#difalm -eq $map'_smooth_alm_temp.fits' -o $map'_smooth_alm_eq_temp.fits'
	#cl2map -falm $map'_smooth_alm_eq_temp.fits' -o $map'_'$fw'_smooth_map_eq_temp.fits' -lmax $lmax -nx $nx -np $np
	#mapcut $map'_'$fw'_smooth_map_eq_temp.fits' -rm -90.0d,0d,-5.0d,360.0d -o $maps_path'temp.fits'
	#mapcut $maps_path'temp.fits' -rm 90.0d,0.0d,20.0d -o $map'_'$fw'_smooth_masked_map_eq_'$random'.fits'
	
		#find correlations between gauss-LCDM map and src map
	for fw_corr in $fwhm_corr
	do
		echo "correlating lcdm "$fw_corr'_'$random
		difmap -cw $fw_corr $maps_path'src_'$fw'_smooth_'$slice'_masked_map_eq.fits' $maps_path'lcdm_map_'$fw'_smooth_masked_map_eq_'$random'.fits' -o $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_eq.fits'
		f2fig $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_eq.fits' -o $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_eq.gif'
	
			#after masking
		mapcut $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_eq.fits' -rm -90.0d,0d,-5.0d,360.0d -d $value_out_of_range -o $maps_path'temp.fits'
		mapcut $maps_path'temp.fits' -rm 90.0d,0.0d,20.0d -d $value_out_of_range -o $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_masked_eq.fits'
		f2fig $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_masked_eq.fits' -o $project_home_path$correlations_results'/corr_lcdm_'$fw'_'$fw_corr'_'$random'_masked_eq.gif'
	done
done

#############################################################################################################
rm $maps_path'temp.fits'
rm $maps_path*'temp'*
