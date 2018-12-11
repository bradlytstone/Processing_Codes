#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun  5 11:43:12 2018

@author: bradly
"""

import numpy as np
from scipy import stats
import matplotlib.pylab as plt

#Load appropriate files
licl_ID = np.load("lda_identity_LiCl.npy")
saline_ID = np.load("lda_identity_Saline.npy")
healthy_ID = np.load("lda_identity_Jian_you.npy")

#Create xtick range (default = 0ms-1000ms post stimulus)
x = np.arange(0,1001,25)

#Calculate mean correct trials for I.D. period
mean_val_licl = np.mean(licl_ID[0,88:108])
mean_val_saline = np.mean(saline_ID[0,88:108])
mean_val_healthy = np.mean(healthy_ID[0,88:108])

#SEMs for conditions
SEM_licl = stats.sem(licl_ID[0,88:108])
SEM_saline = stats.sem(saline_ID[0,88:108])
SEM_healthy = stats.sem(healthy_ID[0,88:108])
yerr = (SEM_licl, SEM_saline, SEM_healthy)

#Indicate objects for x-axis
objects = ('LiCl', 'Saline', 'Control')
y_pos = [1,2,3]
x_values = (mean_val_licl,mean_val_saline,mean_val_healthy)

#Plot data
plt.figure()
plt.bar(y_pos, x_values, yerr=yerr, color = ['blue','orange','green'])
plt.xticks(y_pos, objects)

#format plot
plt.title('Identity LDA, Window(ms): 250, Step(ms): 25 \n I.D. Window: 200-700ms')
plt.xlabel('Condition')
plt.ylabel('Fraction correct trials')
plt.tight_layout()

#Save output
plt.savefig('Identity_LDA_Bar.png', bbox_inches = 'tight')
plt.close('all') 

