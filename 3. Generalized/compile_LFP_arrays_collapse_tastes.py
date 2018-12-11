#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 23 10:51:41 2017

@author: bradly
"""
#Import necessary tools
import numpy as np
import easygui
import tables
import os
import scipy.io as sio

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
#taste0
t_0_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_0[:]
t_0_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_0[:]
t_0_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_0[:]
t_0_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_0[:]

#taste1
t_1_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_1[:]
t_1_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_1[:]
t_1_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_1[:]
t_1_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_1[:]

#taste2
t_2_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_2[:]
t_2_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_2[:]
t_2_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_2[:]
t_2_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_2[:]

#taste2
t_3_dur_1 = hf5.root.LFP_Lasers.laser_combos_d_l_0_0.taste_3[:]
t_3_dur_2 = hf5.root.LFP_Lasers.laser_combos_d_l_500_0.taste_3[:]
t_3_dur_3 = hf5.root.LFP_Lasers.laser_combos_d_l_500_700.taste_3[:]
t_3_dur_4 = hf5.root.LFP_Lasers.laser_combos_d_l_500_1400.taste_3[:]

#Collapse trials by taste and perform FFTs
all_tastes_dur_1 = np.concatenate((t_0_dur_1,t_1_dur_1,t_2_dur_1,t_3_dur_1),axis=0)
all_tastes_dur_2 = np.concatenate((t_0_dur_2,t_1_dur_2,t_2_dur_2,t_3_dur_2),axis=0)
all_tastes_dur_3 = np.concatenate((t_0_dur_3,t_1_dur_3,t_2_dur_3,t_3_dur_3),axis=0)
all_tastes_dur_4 = np.concatenate((t_0_dur_4,t_1_dur_4,t_2_dur_4,t_3_dur_4),axis=0)

#Save arrays into .mat format for processing in MATLAB
sio.savemat(hdf5_name[:-12] + '_all_tastes_dur_1.mat', {'all_tastes_dur_1':all_tastes_dur_1})
sio.savemat(hdf5_name[:-12] + '_all_tastes_dur_2.mat', {'all_tastes_dur_2':all_tastes_dur_2})
sio.savemat(hdf5_name[:-12] + '_all_tastes_dur_3.mat', {'all_tastes_dur_3':all_tastes_dur_3})
sio.savemat(hdf5_name[:-12] + '_all_tastes_dur_4.mat', {'all_tastes_dur_4':all_tastes_dur_4})

#Indicate process complete
print('*.mat files saved')