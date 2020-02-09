import numpy as np
import decimal
import sys

############################################
### Centre line generator ###
############################################

eps = np.around(float(sys.argv[1]), decimals=3)

centre_line = np.arange(-1.0+2.0*eps, 1.0, 2.0*eps)
centre_line = np.around(centre_line, decimals=2)

np.savetxt('centre_line', centre_line, fmt='%s')
