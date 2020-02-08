import numpy as np
import matplotlib.pyplot as plt
import sys

############################################
### Script profile plot ###
############################################

fn1 = sys.argv[1]
fn2 = sys.argv[2]
smooth_angle = sys.argv[3]
corr_angle = sys.argv[4]
data1 = np.loadtxt(fn1)
data2 = np.loadtxt(fn2)

### plot 1
plt.plot(data1[:,0], data1[:,2], 'r--', label='SMICA + SDSS')
plt.plot(data2[:,0], data2[:,2], 'b-', label='$\Lambda$CDM + SDSS')
plt.plot(data2[:,0], data2[:,2] + np.sqrt(data2[:,3]), 'b--', label='$1\sigma$')
plt.plot(data2[:,0], data2[:,2] - np.sqrt(data2[:,3]), 'b--', label='')

############################################
plt.title('сглаживание: ' + str(smooth_angle) + ' arcmin, корреляция: ' + str(corr_angle) + ' arcmin')
plt.grid(True)
plt.ylabel(r'$N_{pix}$')
#plt.xlabel(r'$T$, K')
plt.legend(loc=1, prop={'size': 12})
plt.savefig(fn1 + '.png')
plt.close()
