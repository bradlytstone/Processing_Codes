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
whole_struct = mat_file['Data']
val = whole_struct[0,0]
taste_struct_whole = val['taste']

taste_LFP_arrays = taste_struct_whole['LFP_D']

for arrays in len(taste_LFP_arrays[0,:]):
    

    