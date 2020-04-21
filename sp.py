import numpy as np
import matplotlib.pyplot as plt
import sys

############################################
### The simplest plot ###
############################################

smooth = sys.argv[1]
corr = sys.argv[2]
#num_slice = sys.argv[2]

#fn_in = './re_results/ad_stat_' + str(smooth) + '_' + str(corr)
#fn_in = './re_results/re_ad_stat_' + str(smooth) + '_' + str(num_slice)
#fn_in = './re_results/ad_stat2_' + str(smooth) + '_' + str(corr)
fn_in = './re_results/lcdm_ad_stat2_' + str(smooth) + '_' + str(corr)
data = np.loadtxt(fn_in)

plt.plot(data[:,0], data[:,2], 'r.-', label='+')
plt.plot(data[:,0], data[:,1], 'b.-', label='-')

############################################
plt.ylim(-0.3, 0.3)
plt.title('LCDM+SDSS, сглаживание: ' + str(smooth) + ' arcmin, корреляция: ' + str(corr) + ' arcmin')
#plt.title(r'SMICA+SDSS, сглаживание: ' + str(smooth) + ' arcmin, корреляция: ' + str(corr) + ' arcmin')
plt.grid(True)
#plt.ylabel(r'$N_{pix}$')
#plt.xlabel(r'$сorr angle$, K')
plt.xlabel(r'$slice z$')
plt.legend(loc=1, prop={'size': 12})
plt.savefig(fn_in + '.png')
plt.close()
