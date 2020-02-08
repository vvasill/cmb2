#!/usr/bin/python

#################################################################
### Read SDSS catalog data from csv
#################################################################

import sys
import numpy as np

#################################################################

z_min = sys.argv[1]
z_max = sys.argv[2]
in_file = sys.argv[3]
out_file = sys.argv[4]

print(in_file)

data = np.genfromtxt(in_file, delimiter=',', skip_header=2, usecols=(1,2))

np.savetxt(out_file, data)
