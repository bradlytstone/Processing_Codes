#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr  6 11:04:05 2018

@author: bradly
"""

import numpy as np
import tables
import easygui
import sys
import os
import scipy.io as sio

# Ask for the directory where the hdf5 file sits, and change to that directory
dir_name = easygui.diropenbox()
os.chdir(dir_name)

# Look for the hdf5 file in the directory
file_list = os.listdir('./')
hdf5_name = ''
for files in file_list:
	if files[-2:] == 'h5':
		hdf5_name = files

# Open the hdf5 file
hf5 = tables.open_file(hdf5_name, 'r+')

# Grab the names of the arrays containing digital inputs, and pull the data into a numpy array
dig_in_nodes = hf5.list_nodes('/digital_in')
dig_in = []
dig_in_pathname = []
for node in dig_in_nodes:
	dig_in_pathname.append(node._v_pathname)
	exec("dig_in.append(hf5.root.digital_in.%s[:])" % dig_in_pathname[-1].split('/')[-1])
dig_in = np.array(dig_in)

# Get the stimulus delivery times - take the end of the stimulus pulse as the time of delivery
dig_on = []
for i in range(len(dig_in)):
	dig_on.append(np.where(dig_in[i,:] == 1)[0])
start_points = []
end_points = []
for on_times in dig_on:
	start = []
	end = []
	try:
		start.append(on_times[0]) # Get the start of the first trial
	except:
		pass # Continue without appending anything if this port wasn't on at all
	for j in range(len(on_times) - 1):
		if np.abs(on_times[j] - on_times[j+1]) > 30:
			end.append(on_times[j])
			start.append(on_times[j+1])
	try:
		end.append(on_times[-1]) # append the last trial which will be missed by this method
	except:
		pass # Continue without appending anything if this port wasn't on at all
	start_points.append(np.array(start))
	end_points.append(np.array(end))	

# Show the user the number of trials on each digital input channel, and ask them to confirm
check = easygui.ynbox(msg = 'Digital input channels: ' + str(dig_in_pathname) + '\n' + 'No. of trials: ' + str([len(ends) for ends in end_points]), title = 'Check and confirm the number of trials detected on digital input channels')
# Go ahead only if the user approves by saying yes
if check:
	pass
else:
	print("Well, if you don't agree, blech_clust can't do much!")
	sys.exit()

# Ask the user which digital input channels should be used for getting spike train data, and convert the channel numbers into integers for pulling stuff out of change_points
dig_in_channels = easygui.multchoicebox(msg = 'Which digital input channels should be used to produce spike train data trial-wise?', choices = ([path for path in dig_in_pathname]))
dig_in_channel_nums = []
for i in range(len(dig_in_pathname)):
	if dig_in_pathname[i] in dig_in_channels:
		dig_in_channel_nums.append(i)

# Ask the user for the pre and post stimulus durations to be pulled out, and convert to integers
durations = easygui.multenterbox(msg = 'What are the signal durations pre and post stimulus that you want to pull out (Default [for Brads data] 20S ITI).', fields = ['Pre stimulus (ms)', 'Post stimulus (ms)'], values = ['20000' , '25'])
for i in range(len(durations)):
	durations[i] = int(durations[i])

# Delete the ITI_spike_trains node in the hdf5 file if it exists, and then create it
try:
	hf5.remove_node('/ITI_spike_trains', recursive = True)
except:
	pass
hf5.create_group('/', 'ITI_spike_trains')

# Get list of units under the sorted_units group. Find the latest/largest spike time amongst the units, and get an experiment end time (to account for cases where the headstage fell off mid-experiment)
units = hf5.list_nodes('/sorted_units')
expt_end_time = 0
for unit in units:
	if unit.times[-1] > expt_end_time:
		expt_end_time = unit.times[-1]
        
# Go through the dig_in_channel_nums and make an array of spike trains for ITIs of dimensions (# trials x # units x trial duration (ms)) - use end of digital input pulse as the time of taste delivery
for i in range(len(dig_in_channels)):
	ITI_spike_train = []
	for j in range(len(end_points[dig_in_channel_nums[i]])):
		# Skip the trial if the headstage fell off before it
		if end_points[dig_in_channel_nums[i]][j] >= expt_end_time:
			continue
		# Otherwise run through the units and convert their spike times to milliseconds
		else:
			spikes = np.zeros((len(units), durations[0] + durations[1]))
			for k in range(len(units)):
				# Get the spike times around the end of taste delivery
				spike_times = np.where((units[k].times[:] <= end_points[dig_in_channel_nums[i]][j] + durations[1]*30)*(units[k].times[:] >= end_points[dig_in_channel_nums[i]][j] - durations[0]*30))[0]
				spike_times = units[k].times[spike_times]
				spike_times = spike_times - end_points[dig_in_channel_nums[i]][j]
				spike_times = (spike_times/30).astype(int) + durations[0]
				# Drop any spikes that are too close to the ends of the trial
				spike_times = spike_times[np.where((spike_times >= 0)*(spike_times < durations[0] + durations[1]))[0]]
				spikes[k, spike_times] = 1
        	
        # Append the spikes array to spike_train 
		ITI_spike_train.append(spikes) 

	# Put the ITI data for this session in hdf5 file under /ITI_spike_trains
	hf5.create_array('/ITI_spike_trains', 'dig_in_%i_ITI_spike_trains' % (dig_in_channel_nums[i]), ITI_spike_train)
	hf5.flush()
    
# Ask if this analysis is looking to create a .mat file
msg   = "Do you want to create a matlab file?"
mat_check = easygui.buttonbox(msg,choices = ["Yes","No"])

if mat_check == "No":
    hf5.flush()
if mat_check == "Yes": #Assumes equal number of trials in each dig_in
    ITI_data = {}
    dig_in_ITI_nodes = hf5.list_nodes('/ITI_spike_trains')
    
# Ask if this analysis is looking to create a .mat file
typemsg   = "Is this a taste dataset?"
type_check = easygui.buttonbox(typemsg,choices = ["Yes","No"])
    
if type_check == "No":

    ITI_data['Session_1'] = [np.array(dig_in_channels[node][-8:]) for node in range(len(dig_in_ITI_nodes)-1)]
     #Update dictionary to store the arrays by dig_in number
    exec("ITI_array = hf5.root.ITI_spike_trains.dig_in_%i_ITI_spike_trains[:] " % int(dig_in_channels[-1][-1]))
    ITI_data['Session_1'] = [ITI_array]
    #Save arrays into .mat format for processing in MATLAB
    sio.savemat(hdf5_name[:-12] + '_0_1200000ms_passive.mat', {'all_tastes':ITI_data})

if type_check == "Yes":
    ITI_data['Session_1'] = [np.array(dig_in_channels[node][-8:]) for node in range(len(dig_in_ITI_nodes))]
    
    #Update dictionary to store the arrays by dig_in number
    for node in range(len(dig_in_ITI_nodes)):
        exec("ITI_array = hf5.root.ITI_spike_trains.dig_in_%i_ITI_spike_trains[:] " % node)
        ITI_data['Session_1'][node] = ITI_array
    #Save arrays into .mat format for processing in MATLAB
    sio.savemat(hdf5_name[:-12] + '_0_2000ms_tastes.mat', {'all_tastes':ITI_data})


hf5.close()

