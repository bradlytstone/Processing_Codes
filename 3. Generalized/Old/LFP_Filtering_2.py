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

#Create vector of electodes
electrodegroup = hf5.root.unit_descriptor[:]['electrode_number']

#Remove duplicates within array
electrodegroup = np.unique(electrodegroup)

#Dictate whether EMG electrodes are present (based on experimental configuration) and allocate file names accordingly
noncell_channels = easygui.integerbox(msg='Number of channels', title='Purposes other than cell recording (i.e. EMG)', default='0',lowerbound=0,upperbound=64)

if noncell_channels == 0:		#If all channels are used for cell recording, move on.
	fieldValues = []
	
else:							#If there are channels used, otherwise: create variable array for channel specification
	Fields = []
	for channel in range(noncell_channels):
		chan_variable = "Channel " + "%01d" % (channel)
		Fields.append(chan_variable)

	fieldValues = easygui.multenterbox('Which Channels are these (i.e. EMG)?', 'Used Channels?', Fields) #Specify which channels are used for non-cell recording
	
	for i in range(len(Fields)):	#Check to make sure that user input as many non-cell channel numbers as they indicated were used
		if fieldValues[i-1].strip() == "":
			errmsg = "You did not specify as many channels as you indicated you had!"
			print(errmsg)
			fieldValues = easygui.multenterbox('Your input did not match number of entries. Pay Attention!', 'Used Channels?', Fields)	#If user messed up, they will be given a chance to correct this
				
EMG_Channels = fieldValues

Raw_Electrodefiles = []			#Create and fill array with appropriate .dat file names according to occupied cell recording channels
for electrode in electrodegroup:
    if len(EMG_Channels) > 0:
        if electrode<int(EMG_Channels[0]):
            electrode = electrode
        else:
            electrode = electrode+len(EMG_Channels)
    if electrode > 31:
        electrode = electrode - 32
        ampletter = "-B-"
    else:
        ampletter = "-A-"

    filename = "amp" + ampletter + "%03d" % (electrode) + ".dat"
    Raw_Electrodefiles.append(filename)

#Import specific functions in order to filter the data file
from scipy.signal import butter
from scipy.signal import filtfilt

#Specify filtering parameters (linear finite impulse response filter) to define filter specificity across electrodes
freqparam = easygui.integerbox(msg = 'Specify LFP bandpass filtering paramter (assumes 30kHz as sampling rate)', title = 'Low-Frequency Cut-off (Hz)', default='300', lowerbound=0,upperbound=500)

def get_filtered_electrode(data, freq = freqparam, sampling_rate = 30000.0):
	el = 0.195*(data)
	m, n = butter(2, 2.0*freq/sampling_rate, btype = 'lowpass')
	filt_el = filtfilt(m, n, el)
	return filt_el

#Check if LFP data is already within file and remove node if so. Create new raw LFP group within H5 file. 
try:
	hf5.remove_node('/raw_LFP', recursive = True)
except:
	pass
hf5.create_group('/', 'raw_LFP')

#Loop through each neuron-recording electrode, filter data, and create array in new LFP node
for i in range(len(Raw_Electrodefiles)):

    #Filter data
    data = np.fromfile(Raw_Electrodefiles[i], dtype = np.dtype('int16'))
    filt_el = get_filtered_electrode(data)
    hf5.create_array('/raw_LFP','electrode%i' % electrodegroup[i], filt_el)
    hf5.flush()
    del filt_el, data
    print (float(i)/len(Raw_Electrodefiles)) #Shows progress

hf5.close()
