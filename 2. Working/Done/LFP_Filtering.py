#Import necessary tools
import numpy as np
import tables

# Necessary blech_clust modules
import read_file

# Get name of directory with the data files
dir_name = easygui.diropenbox()

# Get the type of data files (.rhd or .dat)
file_type = easygui.multchoicebox(msg = 'What type of files am I dealing with?', choices = ('.dat', '.rhd', 'one file per channel'))

# Change to that directory
os.chdir(dir_name)

# Get the names of all files in this directory
file_list = os.listdir('./')

# Grab directory name to create the name of the hdf5 file
hdf5_name = str.split(dir_name, '/')

#Open up H5 File
hf5 = tables.open_file('NM46_CTA_training_160929_130610_repacked.h5', 'r+')

#Create vector of electodes
electrodegroup = hf5.root.unit_descriptor[:]['electrode_number']

#Remove duplicates within array
electrodegroup = np.unique(electrodegroup)

#Dictate whether EMG electrodes are present (Change basedo on configuration)
EMG_Channels = [24,25]

Raw_Electrodefiles = []
for electrode in electrodegroup:
    if len(EMG_Channels) > 0:
        if electrode<EMG_Channels[0]:
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

#Import specific functions in order to read/write data files
from scipy.signal import butter
from scipy.signal import filtfilt
import pylab as plt

#Specify filtering parameters
def get_filtered_electrode(data, freq = 300.0, sampling_rate = 30000.0):
	el = 0.195*(data)
	m, n = butter(2, 2.0*freq/sampling_rate, btype = 'lowpass')
	filt_el = filtfilt(m, n, el)
        return filt_el

#Create group
try:
	hf5.remove_node('/raw_LFP', recursive = True)
except:
	pass
hf5.create_group('/', 'raw_LFP')

#Create loop to filter and plot each file in list
for i in range(len(Raw_Electrodefiles)):

    #Filter data
    data = np.fromfile(Raw_Electrodefiles[i], dtype = np.dtype('int16'))
    filt_el = get_filtered_electrode(data)
    hf5.create_array('/raw_LFP','electrode%i' % electrodegroup[i], filt_el)
    hf5.flush()
    del filt_el, data
    print float(i)/len(Raw_Electrodefiles)

hf5.close()
