# -*- coding: utf-8 -*-
"""
Created on Thu Jul  6 10:06:32 2017

@author: Bradly
"""
#Import necessary tools
import numpy as np
import easygui
import tables
import os
import matplotlib.pyplot as plt
from scipy import signal
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
lfp_nodes = hf5.list_nodes('/Parsed_LFP')
laser_nodes = hf5.list_nodes('/spike_trains')

#Establish number of tastes and laser_combination variables
taste_count = len(laser_nodes)
laser_comb_count = len(laser_nodes)
trials = hf5.root.ancillary_analysis.trials[1,:]
trials_per_taste_las_cond = int(len(trials)/taste_count)

def blockshaped(arr, nrows, ncols):
    """
    Return an array of shape (n, nrows, ncols) where
    n * nrows * ncols = arr.size
    
    If arr is a 2D array, the returned array should look like n subblocks with
    each subblock preserving the "physical" layout of arr.
    """
    h, w = arr.shape
    return (arr.reshape(h//nrows, nrows, -1, ncols)
               .swapaxes(1,2)
               .reshape(-1, nrows, ncols))
    
#Create loop based on number of laser conditions
for z in range(taste_count):
    whole_array = hf5.root.ancillary_analysis.trials[z:,:]
    shappen = blockshaped(whole_array, taste_count-z, trials_per_taste_las_cond)
    laser_dur = int(hf5.root.ancillary_analysis.laser_combination_d_l[z,0])
    laser_lag = int(hf5.root.ancillary_analysis.laser_combination_d_l[z,1])
    lists = [[] for _ in range(len(shappen))]
    
    
    for x in range(taste_count):
        lists[x].append(shappen[x,:,:])
        working_array = np.asarray(lists[x])
        lfp_coll = np.mean(lfp_nodes[x],axis=(0))
            
        laser_trial_LFPs = []
        for m in range(len(working_array[0,0,:])):
            
            if x>=1:
                index_value = int((working_array[0,0,m])-(trials_per_taste_las_cond*taste_count*x))
            else:
                index_value = int(working_array[0,0,m])
            laser_trial_LFPs.append(lfp_coll[index_value])
            savename = 'taste_'+str(x)+'_'+ str(laser_dur)+'_'+str(laser_lag)
            vars()["LFP_"+str(savename)]= np.asarray(laser_trial_LFPs)
            
            # Create a laser_LFP group in the hdf5 file, and write these arrays to that group
            try:
                	hf5.remove_node('/LFP_Lasers', recursive = True)
            except:
                	pass
            hf5.create_group('/', 'LFP_Lasers')
            
            
            
            
            
            
            