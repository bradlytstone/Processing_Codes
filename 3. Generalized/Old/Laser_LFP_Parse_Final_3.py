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

# Create a LFP_laser group in the hdf5 file
try:
    hf5.remove_node('/LFP_Lasers', recursive = True)
except:
    pass
hf5.create_group('/', 'LFP_Lasers')

#Get laser conditions from hdf5 file (after ancillary analysis.py)
laser_conditions = hf5.root.ancillary_analysis.laser_combination_d_l[:]
laser_trials = hf5.root.ancillary_analysis.trials[:]

#Get taste and LFP information
num_tastes = len(hf5.list_nodes('/spike_trains'))
lfp_nodes = hf5.list_nodes('/Parsed_LFP')

#Get trial information based on tastants (assumes that each taste has equal number of trials)
num_trials = hf5.root.spike_trains.dig_in_0.spike_array[:].shape[0]

# Run through the tastes and laser conditions, and build arrays with respective data
for x in range(laser_conditions.shape[0]):
    #lfp_coll = np.mean(lfp_nodes[x][:],axis=(0))
    #taste = 'taste_' + str(x)         
    #hf5.create_group('/LFP_Lasers', str.split(taste, '/')[-1])  
    for y in range(num_tastes):
        taste = 'taste_' + str(y) 
        laser_trial_LFPs = []
        lfp_coll = np.mean(lfp_nodes[y][:],axis=(0))
        start_trial = int(y*(num_trials/num_tastes))
        trial_group = laser_trials[x,start_trial:int(start_trial+num_trials/num_tastes)]-int(y*num_trials)
        laser_trial_LFPs.append(lfp_coll[trial_group])
        
        
        las_type = str(int(laser_conditions[x,0]))+'_'+str(int(laser_conditions[x,1]))
        savename = 'taste_'+str(y)+'_'+ str(las_type)
        vars()["LFP_"+str(savename)]= np.asarray(np.mean(laser_trial_LFPs,axis=(0)))       
       
        for z in range(num_trials):
          
            
          # Pick the right trial numbers here, and fill them in your array
          
          las_type = str(int(laser_conditions[y,0]))+'_'+str(int(laser_conditions[y,1]))
          
          
          laser_trial_LFPs.append(lfp_coll[laser_trials[y,z]])
          savename = 'taste_'+str(x)+'_'+ str(las_type)
          vars()["LFP_"+str(savename)]= np.asarray(laser_trial_LFPs)
          
        # Create a laser_LFP group in the hdf5 file, and write these arrays to that group
        hf5.create_array('/LFP_Lasers/%s' % taste, 'laser_combos_%s' %las_type, np.asarray(laser_trial_LFPs))
        hf5.flush()
            

#Establish number of tastes and laser_combination variables
lfp_nodes = hf5.list_nodes('/Parsed_LFP')
laser_nodes = hf5.list_nodes('/spike_trains')
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

# Create a taste group in the hdf5 file
for i in range(taste_count):
    taste = 'taste_' + str(i)         
    hf5.create_group('/LFP_Lasers', str.split(taste, '/')[-1])    
    
#Create loop based on number of laser conditions and create groupings of blank arrays to fill
for z in range(taste_count):        #Where z indicates dig_in (laser condition)
    whole_array = hf5.root.ancillary_analysis.trials[z:,:]
    shappen = blockshaped(whole_array, taste_count-z, trials_per_taste_las_cond)
    laser_dur = int(hf5.root.ancillary_analysis.laser_combination_d_l[z,0])
    laser_lag = int(hf5.root.ancillary_analysis.laser_combination_d_l[z,1])
    las_type = str(laser_dur)+'_'+str(laser_lag)
    lists = [[] for _ in range(len(shappen))]
    
    for x in range(taste_count):    #Where x indicates taste
        lists[x].append(shappen[x,:,:])
        working_array = np.asarray(lists[x])
        lfp_coll = np.mean(lfp_nodes[x],axis=(0))
        taste = 'taste_' + str(x)
            
        laser_trial_LFPs = []
        for m in range(len(working_array[0,0,:])):
            
            if x>=1:
                index_value = int((working_array[0,0,m])-(trials_per_taste_las_cond*taste_count*x))
            else:
                index_value = int(working_array[0,0,m])
            laser_trial_LFPs.append(lfp_coll[index_value])
            """Turn the bottom two lines of code on to check/confirm proper indexing and array building"""
            #savename = 'taste_'+str(x)+'_'+ str(laser_dur)+'_'+str(laser_lag)
            #vars()["LFP_"+str(savename)]= np.asarray(laser_trial_LFPs)
        
        # Create a laser_LFP group in the hdf5 file, and write these arrays to that group
        hf5.create_array('/LFP_Lasers/%s' % taste, 'laser_combos_%s' %las_type, np.asarray(laser_trial_LFPs))
        hf5.flush()
        
#Close file        
hf5.close()    