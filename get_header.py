#!/usr/bin/python

import numpy as np
from astropy.io import fits
from astropy import table
import healpy as hlp
import matplotlib.pyplot as plt

#################################################################

dir_path = './maps/'
infile = dir_path + 'alm_glesp.fits'
hdu = fits.open(infile)

print(hdu[1].data)
print(hdu[1].header)
print(hdu[1].data.shape[0])
print(hdu[1].data.shape[1])
