# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 09:59:36 2017

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

#Ask users how many tastes they want to analyze
num_tastes = easygui.integerbox(msg='Number of tastes to analyze?', title='Tastes to analyze from experiment', default='2',lowerbound=0,upperbound=6)

if num_tastes == 0:		#If no tastes to analyze, end.
	print("Well, I guess there is nothing to analyze here!")
	sys.exit()
	
else:							#If there are channels used, otherwise: create variable array for channel specification
	Fields = []
    
for tastes in range(num_tastes):
	taste_variable = "Taste " + "%01d" % (tastes)
	Fields.append(taste_variable)

fieldValues = easygui.multenterbox('Which tastes are these (i.e. NaCl, Quinine)?', 'Enter tastes to analyze in order of Digital input files', Fields) #Specify which tastes are to be assessed
	
for i in range(len(Fields)):	#Check to make sure that user input as many tastes as they indicated they want to look at
    if fieldValues[i-1].strip() == "":
        errmsg = "You did not specify as many tastes as you indicated you wanted to look at!"
        print(errmsg)
        fieldValues = easygui.multenterbox('Your input did not match number of entries. Pay Attention!', 'Tastes to look at?', Fields)	#If user messed up, they will be given a chance to correct this
    
analyze_tastes = fieldValues

#Ask if lasers are on
laser_check = easygui.ynbox(msg = 'Are you assessing data using lasers?', title = 'Decide if a laser-analysis will be conducted')

#Flip through laser data if user says yes
if laser_check:
    
    #Create parent list and Flip through the tastes-to-analyze and create individual arrays
    laser_nodes = hf5.list_nodes('/spike_trains')
    for l in range(0,len(analyze_tastes)):
        trial_count = len(laser_nodes[l].laser_durations)
        laser_on_trials = []
        laser_off_trials = []
        parsed_trials_on = []
        parsed_trials_off = []
        node_parent = np.mean(lfp_nodes[l],axis=(0))
        
        #Flip through trials and dictate whether a laser was on/off and the duration to create new arrays as such
        for j in range(trial_count):
            las_trial_check = laser_nodes[l].laser_durations[j]
            if las_trial_check>0:
                trial_num = j
                las_duration = las_trial_check
                laser_on_trials.append([trial_num,las_duration])
                parsed_trials_on.append(node_parent[j])
            else:
                laser_off_trials.append(j)
                parsed_trials_off.append(node_parent[j])
                
        #Create arrays of the mean data by collapsing across electrodes (0 = num_electrodes, 1= num_trials, 2 =durations[0] + durations[1])
        vars()["Coll_"+analyze_tastes[l]]= np.mean(lfp_nodes[l],axis=(0))
	  
	    #Creat arrays detailing tastants with lasers on/off and the duration thereof
        vars()[analyze_tastes[l]+"_on"]= np.asarray(laser_on_trials)
        vars()[analyze_tastes[l]+"_off"]= np.asarray(laser_off_trials)
        vars()["Parsed_"+analyze_tastes[l]+"_on"]= np.asarray(parsed_trials_on)
        vars()["Parsed_"+analyze_tastes[l]+"_off"]= np.asarray(parsed_trials_off)
	  
	    #Perform A fast Fourier transform (FFT) to compute frequency and power
        vars()["f_"+analyze_tastes[l]+"_on"], vars()["p_"+analyze_tastes[l]+"_on"] = periodogram(np.asarray(parsed_trials_on), fs = 1000.0, return_onesided=True)
        vars()["f_"+analyze_tastes[l]+"_off"], vars()["p_"+analyze_tastes[l]+"_off"] = periodogram(np.asarray(parsed_trials_off), fs = 1000.0, return_onesided=True)
				
else:
    for l in range(0,len(analyze_tastes)):
        vars()["tastes_"+analyze_tastes[l]]= np.mean(lfp_nodes[l],axis=(0))
        vars()["f_"+analyze_tastes[l]], vars()["p_"+analyze_tastes[l]] = periodogram(np.asarray(np.mean(lfp_nodes[l],axis=(0)), fs = 1000.0, return_onesided=True))