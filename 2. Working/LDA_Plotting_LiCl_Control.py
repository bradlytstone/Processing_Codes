#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 10 14:13:00 2018

@author: bradly
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 14 11:55:36 2018

@author: bradly
"""
from pylab import *
import numpy as np
import matplotlib.pylab as plt

#Load appropriate files
licl_ID = np.load("lda_identity_LiCl.npy")
healthy_ID = np.load("lda_identity_Jian_you.npy")

#Create xtick range (default = 0ms-1000ms post stimulus)
x = np.arange(0,1001,25)

#Calculate mean correct trials for period
mean_val_licl = np.full((len(x),1),np.mean(licl_ID[0,80:121]))
mean_val_healthy = np.full((len(x),1),np.mean(healthy_ID[0,80:121]))

#Plot Identity LDA
plt.figure()
plt.plot(x, licl_ID[0,80:121], label = "LiCl",color = 'b')
plt.plot(x, healthy_ID[0,80:121], label = "Control",color = 'g')
plt.legend(loc= 'upper left', fontsize = 9)

plt.plot(x,mean_val_licl,'b--')
plt.plot(x,mean_val_healthy, 'g--')


#Shade region of interest
fill([x[8],x[28],x[28],x[8]], [.18,.18,.5,.5], 'b', alpha=0.2, edgecolor='r')

#plt.title('Identity LDA, Window(ms): 250, Step(ms): 25')
#plt.xlabel('Time from stimulus (ms)')
plt.ylabel('Fraction correct trials')
plt.tight_layout()


plt.savefig('Identity_LDA_2_wo_title.png', bbox_inches = 'tight')
plt.close('all') 






