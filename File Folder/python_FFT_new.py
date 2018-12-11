# -*- coding: utf-8 -*-
"""
Created on Fri Jul  7 09:47:33 2017

@author: Bradly
"""

#Import necessary tools
import numpy as np
import easygui
import tables
import os
from scipy.signal import periodogram

#Get name of directory where the data files and hdf5 file sits, and change to that directory for processing
dir_name = easygui.diropenbox()
os.chdir(dir_name)

#Look for the hdf5 file in the directory
file_list = os.listdir('./')
hdf5_name = ''
for files in file_list:
	if files[-2:] == 'h5':
		hdf5_name = files

#Open the hdf5 file and create list of child paths
hf5 = tables.open_file(hdf5_name, 'r+')

#Extract arrays and perform FFTs based on taste and laser duration
t_0_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_0[:]
t_0_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_0[:]
t_0_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_0[:]
t_0_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_0[:]
[t_0_f_1, t_0_p_1] = periodogram(t_0_dur_1, fs = 1000.0, return_onesided=True)
[t_0_f_2, t_0_p_2] = periodogram(t_0_dur_2, fs = 1000.0, return_onesided=True)
[t_0_f_3, t_0_p_3] = periodogram(t_0_dur_3, fs = 1000.0, return_onesided=True)
[t_0_f_4, t_0_p_4] = periodogram(t_0_dur_4, fs = 1000.0, return_onesided=True)

t_1_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_1[:]
t_1_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_1[:]
t_1_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_1[:]
t_1_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_1[:]
[t_1_f_1, t_1_p_1] = periodogram(t_1_dur_1, fs = 1000.0, return_onesided=True)
[t_1_f_2, t_1_p_2] = periodogram(t_1_dur_2, fs = 1000.0, return_onesided=True)
[t_1_f_3, t_1_p_3] = periodogram(t_1_dur_3, fs = 1000.0, return_onesided=True)
[t_1_f_4, t_1_p_4] = periodogram(t_1_dur_4, fs = 1000.0, return_onesided=True)

t_2_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_2[:]
t_2_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_2[:]
t_2_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_2[:]
t_2_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_2[:]
[t_2_f_1, t_2_p_1] = periodogram(t_2_dur_1, fs = 1000.0, return_onesided=True)
[t_2_f_2, t_2_p_2] = periodogram(t_2_dur_2, fs = 1000.0, return_onesided=True)
[t_2_f_3, t_2_p_3] = periodogram(t_2_dur_3, fs = 1000.0, return_onesided=True)
[t_2_f_4, t_2_p_4] = periodogram(t_2_dur_4, fs = 1000.0, return_onesided=True)

t_3_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_3[:]
t_3_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_3[:]
t_3_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_3[:]
t_3_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_3[:]
[t_3_f_1, t_3_p_1] = periodogram(t_3_dur_1, fs = 1000.0, return_onesided=True)
[t_3_f_2, t_3_p_2] = periodogram(t_3_dur_2, fs = 1000.0, return_onesided=True)
[t_3_f_3, t_3_p_3] = periodogram(t_3_dur_3, fs = 1000.0, return_onesided=True)
[t_3_f_4, t_3_p_4] = periodogram(t_3_dur_4, fs = 1000.0, return_onesided=True)

#Collapse trials by taste and perform FFTs
all_tastes_dur_1 = np.concatenate((t_0_dur_1,t_1_dur_1,t_2_dur_1,t_3_dur_1),axis=0)
all_tastes_dur_2 = np.concatenate((t_0_dur_2,t_1_dur_2,t_2_dur_2,t_3_dur_2),axis=0)
all_tastes_dur_3 = np.concatenate((t_0_dur_3,t_1_dur_3,t_2_dur_3,t_3_dur_3),axis=0)
all_tastes_dur_4 = np.concatenate((t_0_dur_4,t_1_dur_4,t_2_dur_4,t_3_dur_4),axis=0)
[all_f_1, all_p_1] = periodogram(all_tastes_dur_1, fs = 1000.0, return_onesided=True)
[all_f_2, all_p_2] = periodogram(all_tastes_dur_2, fs = 1000.0, return_onesided=True)
[all_f_3, all_p_3] = periodogram(all_tastes_dur_3, fs = 1000.0, return_onesided=True)
[all_f_4, all_p_4] = periodogram(all_tastes_dur_4, fs = 1000.0, return_onesided=True)

#Parse out collaposed datasets (laser combos) into taste processing time frames
pre = 1249      #-750ms in reference to stim onset
early = 2249    #+250ms in reference to stim onset
late = 3249     #+1250ms in reference to stim onset

pre_dur_1 = all_tastes_dur_1[:,pre:pre+500]
pre_dur_2 = all_tastes_dur_2[:,pre:pre+500]
pre_dur_3 = all_tastes_dur_3[:,pre:pre+500]
pre_dur_4 = all_tastes_dur_4[:,pre:pre+500]
[pre_f_1, pre_p_1] = periodogram(pre_dur_1, fs = 1000.0, return_onesided=True)
[pre_f_2, pre_p_2] = periodogram(pre_dur_2, fs = 1000.0, return_onesided=True)
[pre_f_3, pre_p_3] = periodogram(pre_dur_3, fs = 1000.0, return_onesided=True)
[pre_f_4, pre_p_4] = periodogram(pre_dur_4, fs = 1000.0, return_onesided=True)

early_dur_1 = all_tastes_dur_1[:,early:early+500]
early_dur_2 = all_tastes_dur_2[:,early:early+500]
early_dur_3 = all_tastes_dur_3[:,early:early+500]
early_dur_4 = all_tastes_dur_4[:,early:early+500]
[early_f_1, early_p_1] = periodogram(early_dur_1, fs = 1000.0, return_onesided=True)
[early_f_2, early_p_2] = periodogram(early_dur_2, fs = 1000.0, return_onesided=True)
[early_f_3, early_p_3] = periodogram(early_dur_3, fs = 1000.0, return_onesided=True)
[early_f_4, early_p_4] = periodogram(early_dur_4, fs = 1000.0, return_onesided=True)

late_dur_1 = all_tastes_dur_1[:,late:late+500]
late_dur_2 = all_tastes_dur_2[:,late:late+500]
late_dur_3 = all_tastes_dur_3[:,late:late+500]
late_dur_4 = all_tastes_dur_4[:,late:late+500]
[late_f_1, late_p_1] = periodogram(late_dur_1, fs = 1000.0, return_onesided=True)
[late_f_2, late_p_2] = periodogram(late_dur_2, fs = 1000.0, return_onesided=True)
[late_f_3, late_p_3] = periodogram(late_dur_3, fs = 1000.0, return_onesided=True)
[late_f_4, late_p_4] = periodogram(late_dur_4, fs = 1000.0, return_onesided=True)
