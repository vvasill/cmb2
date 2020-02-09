#!/usr/bin/python

import sys
import numpy as np
import healpy as hlp
import matplotlib.pyplot as plt

#################################################################
dir_path = sys.argv[1]
infile = dir_path + sys.argv[2] + '.fits'
lmax = int(sys.argv[3])
print(infile)
#dir_path = '/home/vasiliy/cmb_2/maps/'
#infile = dir_path + 'COM_CMB_IQU-smica_2048_R3.00_full.fits'
#lmax = 4096
outfile_l = dir_path + 'l_healpix.txt'
outfile_m = dir_path + 'm_healpix.txt'
outfile_real = dir_path + 'real_healpix.txt'
outfile_imag = dir_path + 'imag_healpix.txt'

mapT = hlp.fitsfunc.read_map(infile, hdu=1)
'''
#hdu = fits.open(infile)
#print(hdu[1].header)
#print(hdu[2].header)
#mapT = hdu[1].data['I_STOKES']
'''

#hlp.mollview(mapT)
#plt.show()

#mapQ = hdu[1].data['Q_STOKES']
#mapU = hdu[1].data['U_STOKES']
#cl, alm = hlp.sphtfunc.anafast((mapT, mapQ, mapU), lmax=4096, alm=True)
#cl, alm = hlp.sphtfunc.anafast(mapT, lmax=4096, alm=True)
alm = hlp.sphtfunc.map2alm(mapT, lmax=lmax)
index_l, index_m = hlp.sphtfunc.Alm.getlm(lmax=lmax)

'''
n = alm.shape[0]
index_l = np.zeros(n) 
index_m = np.zeros(n) 
l = 1
m = 0
for i in range(n):
	index_l[i] = l
	index_m[i] = m
	m += 1
	if (m > l):
		l += 1
		m = 0
'''

np.savetxt(outfile_l, index_l, fmt='%d')
np.savetxt(outfile_m, index_m, fmt='%d')
np.savetxt(outfile_real, np.real(alm))
np.savetxt(outfile_imag, np.imag(alm))

'''
hlp.fitsfunc.write_alm(outfile, alm)
fits.setval(outfile, 'TFORM1', value='1J', ext=1)
fits.setval(outfile, 'TFORM2', value='1D', ext=1)
fits.setval(outfile, 'TFORM3', value='1D', ext=1)
'''

'''
index = np.array([1, 3, 4, 7, 8, 9, 13, 14, 15, 16])
alm = np.array([9.19155973e-14+0.00000000e+00j, -4.71149609e-14+0.00000000e+00j, -2.02682639e-15+6.71538359e-14j, 
1.070185681e-05+0.000000000e+00j, -2.699767492e-06+9.136712833e-06j, 
-1.231469287e-05+-1.504891316e-05j, -6.399447102e-06+0.000000000e+00j, -9.178583241e-06+8.081902934e-07j,
2.144613609e-05+9.975963167e-07j, -2.91886571e-14+2.30288641e-14j])

print(n)

t = fits.table_to_hdu(table.Table([index, np.real(alm), np.imag(alm)], dtype=('i4', 'f8', 'f8')))
out_hdu1 = fits.PrimaryHDU()
out_hdu2 = t
out_fits = fits.HDUList([out_hdu1, out_hdu2]) 
hdr = out_fits[1].header
out_fits.writeto(outfile, overwrite=True)
fits.setval(outfile, 'TFORM1', value='1J', ext=1)
fits.setval(outfile, 'TFORM2', value='1D', ext=1)
fits.setval(outfile, 'TFORM3', value='1D', ext=1)
'''
'''
#################################################################
dl = np.zeros(cl.shape[0])
#for l in range(cl.shape[0]):
#	dl[l] = cl[l]*l*(l+1)/2.0/np.pi
cl[0] = 0.0
cl[1] = 0.0
plt.plot(cl)
plt.xlabel('l')
plt.ylabel('TT')
#plt.show()
'''
