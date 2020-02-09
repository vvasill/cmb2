#!/bin/bash

#########################################################################
### Let's calculate correlations between SMICA map and SDSS catalog data
#########################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
catalog_path=$project_home_path'sdss_catalog/'

lmax=1024
nx="$(( 2*$lmax + 1 ))"
np="$(( 2*$nx ))"
z_min=0.0
z_max=0.1
fwhm_corr='300 600 900'
fw="300"

#############################################################################################################
map=$maps_path'src'
lmax=$(echo 360.0*60.0/$fw | bc -l)
nx=$(python -c "print 2*$lmax + 1")
np=$(python -c "print 2*(2*$lmax + 1)")
echo "src_smoothing "$fw
		
#convolving and map generation
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
