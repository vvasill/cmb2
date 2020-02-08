#!/bin/bash

######################################################################
### This script converts from map from healpix format to glesp format
######################################################################

project_home_path='/home/vvasill/cmb_2_parts/'
maps_path=$project_home_path'maps/'
map='COM_CMB_IQU-smica_2048_R3.00_full'
lmax=4096

#########################################################
#python3 $project_home_path'how_to_convert_maps/'healp2glesp.py $maps_path $map $lmax

#########################################################
cd $maps_path
paste l_healpix.txt m_healpix.txt real_healpix.txt imag_healpix.txt > alm_healpix.txt

#########################################################
nx="$(( 2*$lmax + 1 ))"
np="$(( 2*$nx ))"
infile=$maps_path'alm_healpix.txt'
outfile=$maps_path'glesp_'$map'.fits'

cl2map -falm $infile -o $outfile -lmax $lmax -nx $nx -np $np
f2fig $outfile -o $maps_path$map'.gif'
