import sys, glob, os
from math import *
import numpy as np

############################################
### catalog converter ###
############################################

from coord_conv import equ2gal
from coord_conv import gal2equ

data_in = np.loadtxt(sys.argv[1])
file_out = sys.argv[2]
data_out = data_in

for i in range(0, data_in.shape[0]):
	data_out[i,0] = gal2equ(data_in[i,0], data_in[i,1])[0] #ra
	data_out[i,1] = gal2equ(data_in[i,0], data_in[i,1])[1] #dec

np.savetxt(file_out, data_out, fmt='%s %s %d')
