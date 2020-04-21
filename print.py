import numpy as np
import matplotlib.pyplot as plt
import sys

############################################
### Script profile plot ###
############################################

fn1 = sys.argv[1]
fn2 = sys.argv[2]
fn_out = sys.argv[3]
smooth_angle = sys.argv[4]
corr_angle = sys.argv[5]
data1 = np.loadtxt(fn1 + '.txt')
data2 = np.loadtxt(fn2 + '.txt')

### plot 1
plt.plot(data1[:,0], data1[:,2], 'r--', label='SMICA + SDSS')
plt.plot(data1[:,0], data1[:,2], 'r.')
plt.plot(data2[:,0], data2[:,2], 'b-', label='$\Lambda$CDM + SDSS')
plt.plot(data2[:,0], data2[:,2] + np.sqrt(data2[:,3]), 'b--', label='$1\sigma$')
plt.plot(data2[:,0], data2[:,2] - np.sqrt(data2[:,3]), 'b--', label='')

############################################
plt.xlim(-1.0, 1.0)
plt.title('сглаживание: ' + str(smooth_angle) + ' arcmin, корреляция: ' + str(corr_angle) + ' arcmin')
plt.grid(True)
plt.ylabel(r'$N_{pix}$')
#plt.xlabel(r'$T$, K')
#plt.legend(loc=1, prop={'size': 12})
plt.savefig(fn_out + '.png')
plt.close()
