#!/usr/bin/python

import numpy as np
from astropy.io import fits
from astropy import table
import healpy as hlp
import matplotlib.pyplot as plt

#################################################################
dir_path = './maps/'
infile_init = dir_path + 'COM_CMB_IQU-smica-field-Int_2048_R2.01_full.fits'
infile_final = dir_path + 'alm_ascii.txt'

#mapT_init = hlp.fitsfunc.read_map(infile_init, hdu=1)
#hlp.mollview(mapT_init)
#plt.show()

#alm = hlp.sphtfunc.map2alm(mapT_init, lmax=4096)

alm = np.array([0.0+0.0j, 0.0+0.0j, 1.070185681e-05+0.000000000e+00j, 
-2.699767492e-06+9.136712833e-06j,
-1.231469287e-05+-1.504891316e-05j,
-6.399447102e-06+0.000000000e+00j,
-9.178583241e-06+8.081902934e-07j,
2.144613609e-05+9.975963167e-07j,
0.0+0.0j])
print(alm)
mapT_final = hlp.sphtfunc.alm2map(alm, lmax=1, nside=7)
hlp.mollview(mapT_final)
plt.show()
