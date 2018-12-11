#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  2 16:11:36 2017

@author: bradly
"""

import scipy.io as sio
import easygui
import os
import numpy as np
from scipy.signal import periodogram

#Get name of directory where the data files and hdf5 file sits, and change to that directory for processing
dir_name = easygui.diropenbox()
os.chdir(dir_name)

#Look for the hdf5 file in the directory
file_list = os.listdir('./')
mat_name = ''
for files in file_list:
	if files[-4:] == '.mat':
		mat_name = files
        
mat_file = sio.loadmat(mat_name)
taste_0 = mat_file['NC']
taste_1 = mat_file['Suc']
taste_2 = mat_file['CA']
taste_3 = mat_file['QHC']

#Extract arrays and perform FFTs based on taste and laser duration
all_tastes = np.concatenate((taste_0,taste_1,taste_2,taste_3),axis=0)

#Split collapsed file into pre, early, late tastes (-2500 from stim onset)

pre = 1749      #-750ms in reference to stim onset
early = 2749    #+250ms in reference to stim onset
late = 3749     #+1250ms in reference to stim onset


pre_dur_1 = all_tastes[:,pre:pre+500]
early_dur_1 = all_tastes[:,early:early+500]
late_dur_1 = all_tastes[:,late:late+500]

[pre_f_1, pre_p_1] = periodogram(pre_dur_1, fs = 1000.0, return_onesided=True)
[early_f_1, early_p_1] = periodogram(early_dur_1, fs = 1000.0, return_onesided=True)
[late_f_1, late_p_1] = periodogram(late_dur_1, fs = 1000.0, return_onesided=True)