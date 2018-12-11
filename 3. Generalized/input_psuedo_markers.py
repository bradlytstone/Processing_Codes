#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  8 11:12:51 2018

@author: bradly
"""

#Import necessary tools
import numpy as np
import tables
import easygui
import os

#Get name of directory where the data files and hdf5 file sits, and change to that directory for processing
dir_name = easygui.diropenbox()
os.chdir(dir_name)

#Look for the hdf5 file in the directory
file_list = os.listdir('./')
hdf5_name = ''
for files in file_list:
	if files[-2:] == 'h5':
		hdf5_name = files

#Open the hdf5 file
hf5 = tables.open_file(hdf5_name, 'r+')

#Create variable for digital input channels
dig_in_nodes = hf5.list_nodes('/digital_in')

#Grab data and check to see if array has markers
data = np.array(dig_in_nodes[0])

if np.count_nonzero(data ==1) ==0:
    # Get starting point from user
    mark_start = easygui.multenterbox(msg = 'Look at cutoff_time.png file and choose marker start (in seconds).', fields = ['Mark Start (second)'])
    trial_dur = easygui.multenterbox(msg = 'How long is this trial supposed to be?', fields = ['Trial Duration (seconds):'])
    
    msg   = "Are you using dig_in_4 (Saline) or dig_in_5 (Drug)?"
    state_dig_in = easygui.buttonbox(msg,choices = ["4","5"])
    
    samp_rate = 30000
    mark_start = int(mark_start[0])*samp_rate
    marker_length = 3000 #milliseconds (from pi script - 0.1seconds)
    mark_end = mark_start+marker_length+(int(trial_dur[0])*samp_rate)
    
    #input pseudo-markers into dig_in
    data[mark_start:mark_start+marker_length] =1
    data[mark_end:mark_end+marker_length] =1
    
    	# Put the marked data in hdf5 file
    hf5.create_array('/digital_in', 'dig_in_%i' % int(state_dig_in[0]), data)
    hf5.flush()
    
else:
    print("Your file already has markers. Rerun script and choose correct file!")

hf5.close()