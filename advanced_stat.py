import numpy as np
import matplotlib.pyplot as plt
import sys

############################################
### Another statistical details ###
############################################

smooth = sys.argv[1]
corr = sys.argv[2]
num_slice = sys.argv[3]
path = './' + str(smooth) + '/correlations_results_' + str(num_slice) + '/'
data1 = np.loadtxt(path + 're_stat_' + str(smooth) + '_' + str(corr) + '.txt')
data2 = np.loadtxt(path + 're_stat_lcdm_' + str(smooth) + '_' + str(corr) + '.txt')

left = 0
right = 0
num = 18
for i in range(0,num):
	left += (data1[i][2] - data2[i][2]) / num
	
for i in range(0,num):
	right += (data1[i+num+1][2] - data2[i+num+1][2]) / num

print(left*2/data2[num+1][2], right*2/data2[num+1][2])
