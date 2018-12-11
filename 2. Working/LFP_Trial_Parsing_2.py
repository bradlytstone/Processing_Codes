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

#Grab the names of the arrays containing digital inputs, and pull the data into a numpy array
dig_in_nodes = hf5.list_nodes('/digital_in')
dig_in = []
dig_in_pathname = []
for node in dig_in_nodes:
	dig_in_pathname.append(node._v_pathname)
	exec("dig_in.append(hf5.root.digital_in.%s[:])" % dig_in_pathname[-1].split('/')[-1])
dig_in = np.array(dig_in)

#Show the user the number of trials on each digital input channel, and ask them to confirm
check = easygui.ynbox(msg = 'Digital input channels: ' + str(dig_in_pathname) + '\n' + 'No. of trials: ' + str([len(changes) for changes in change_points]), title = 'Check and confirm the number of trials detected on digital input channels')

#Go ahead only if the user approves by saying yes
if check:
	pass
else:
	print "Well, if you don't agree, blech_clust can't do much!"
	sys.exit()

#-----------------------------------------------------OLD CODE--------------------------------------------------------------------------------

#Ask user if lasers are used in the experiment? Get from older code that isolated these lag/duration things


#Ask the user which digital input channels should be used for slicing out LFP arrays, and convert the channel numbers into integers for pulling stuff out of change_points
dig_in_channels = easygui.multchoicebox(msg = 'Which digital input channels should be used to slice out LFP data trial-wise?', choices = ([path for path in dig_in_pathname]))
dig_in_channel_nums = []
for i in range(len(dig_in_pathname)):
	if dig_in_pathname[i] in dig_in_channels:
		dig_in_channel_nums.append(i)

#Ask the user for the pre and post stimulus durations to be pulled out, and convert to integers
durations = easygui.multenterbox(msg = 'What are the signal durations pre and post stimulus that you want to pull out', fields = ['Pre stimulus (ms)', 'Post stimulus (ms)'])
for i in range(len(durations)):
	durations[i] = int(durations[i])

#Grab the names of the arrays containing LFP recordings
lfp_nodes = hf5.list_nodes('/raw_LFP')

#Make the Parsed_LFP node in the hdf5 file if it doesn't exist, else move on
try:
	hf5.remove_node('/Parsed_LFP', recursive = True)
except:
	pass
hf5.create_group('/', 'Parsed_LFP')

#Run through the tastes
for i in range(len(dig_in_channels)):
	num_electrodes = len(lfp_nodes) 
	num_trials = len(change_points[dig_in_channel_nums[i]])
	this_taste_LFPs = np.zeros((num_electrodes, num_trials, durations[0] + durations[1]))
	for electrode in range(num_electrodes):
		for j in range(len(change_points[dig_in_channel_nums[i]])):
			this_taste_LFPs[electrode, j, :] = np.mean(lfp_nodes[electrode][change_points[dig_in_channel_nums[i]][j] - durations[0]*30:change_points[dig_in_channel_nums[i]][j] + durations[1]*30].reshape((-1, 30)), axis = 1)
	
	#Put the LFP data for this taste in hdf5 file under /Parsed_LFP
	hf5.create_array('/Parsed_LFP', 'dig_in_%i_LFPs' % (dig_in_channel_nums[i]), this_taste_LFPs)
	hf5.flush()
			

#Ask people if they want to delete rawLFPs or not, that way we offer the option to run analyses in many different ways. (ie. First half V back half)

msg   = "Do you want to delete the Raw LFP data?"
rawLFPdelete = easygui.buttonbox(msg,choices = ["Yes","No"])

if rawLFPdelete == "Yes":
	#Delete data
	hf5.remove_node('/raw_LFP', recursive = True)
hf5.flush()

hf5.close()
