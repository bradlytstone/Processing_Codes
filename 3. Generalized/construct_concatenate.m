function [combined_data] = construct_concatenate(dirname);

%This function is used to combine all data from either
%'*_Combined_passive.mat' or '_Combined_all_tastes.mat'. The function takes
%in one input DIRNAME, counts the number of subdirectories (animals) data
%files to combine them -- maintaining their condition structs ('affective'
%and 'saline'). All data will be stored in the 'combined_data' struct. 

%DIRNAME = directory name that files are located in 
%COMBINED_DATA = output struct of the combined raw LFP data from all files

% Construct a Question Dialog Box with 2 options data finding
data_type = questdlg('Are you looking at Taste data or Passive data?', ...
	'Plotting Menu', ...
	'Taste','Passive', 'Maybe'); %make sure do figure out this for tastes

%Create subdirectory
subdirs = dir(dirname);
subdirs(~[subdirs.isdir]) = [];

%Filter out the parent and current directory
tf = ismember( {subdirs.name}, {'.', '..'});
subdirs(tf) = [];
num_folders = length(subdirs);

%Create structures for concatenating
combined_struct_aff = struct; combined_struct_sal = struct;

for folder = 1:num_folders
    subfolder = subdirs(folder).name; %get file location and information
    subdirpath = [dirname filesep subfolder];
       
    %Grab file and make variables for data
    switch data_type
        case 'Taste'
            matfile = dir([subdirpath filesep '* _Combined_all_tastes.mat']); %make sure do figure out this for tastes
        case 'Passive'
            matfile = dir([subdirpath filesep '*_Combined_passive.mat']);
    end
            
    working_mat = load([subdirpath filesep matfile(1).name]);
    array_set = cell2mat(fieldnames(working_mat));
    sessions = size(fieldnames(working_mat.(array_set)),1);
    
    %Flip through each session and grab data
    for x=1:sessions    
        
        initial_array_names = fieldnames(working_mat.combined_data);data_array = working_mat.combined_data.(initial_array_names{x});
        secondary_names = fieldnames(data_array); data_array = working_mat.combined_data.(initial_array_names{x}).(secondary_names{1});
   
        switch data_type
            case 'Taste'
                sizes = size(data_array); 
                 %Flip through each channel, assign a name (animal dependent) and
                 %concatenate with large structure (condition dependent)
                for taste =1:sizes(1);
                    for channel=1:size(data_array,2)
                        if x ==1
                            for trial=1:size(data_array,3)
                                combined_struct_aff.([subfolder '_taste_' num2str(taste) '_channel_' num2str(channel) '_trial_' num2str(trial)]) = squeeze(data_array(taste,channel,trial,:));
                            end
                        else
                            for trial=1:size(data_array,3)
                                combined_struct_sal.([subfolder '_taste_' num2str(taste) '_channel_' num2str(channel) '_trial_' num2str(trial)]) = squeeze(data_array(taste,channel,trial,:));
                            end
                        end
                    end
                end
            case 'Passive'
                data_array = squeeze(data_array(1,:,:,:));
                sizes = size(data_array); 
                 %Flip through each channel, assign a name (animal dependent) and
                 %concatenate with large structure (condition dependent)
                for channel=1:size(data_array,1)
                    if x ==1
                    combined_struct_aff.([subfolder '_channel_' num2str(channel)]) = data_array(channel,:);
                    else
                    combined_struct_sal.([subfolder '_channel_' num2str(channel)]) = data_array(channel,:);
                    end
                end
        end
       
    end
end

%Combine data into one structure and revalue the variables
data1 = struct('drug_sess',combined_struct_aff); data2 = struct('saline_sess',combined_struct_sal);
combined_data = struct('affective',data1,'saline',data2);

%Contruct an input box for Taste information to store output struct
switch data_type
    case 'Taste'
        defaultans1 = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_4Taste_Data'};
        save_file_name = join(['N = ', num2str(num_folders), '_animals_Combined_all_tastes.mat']);
    case 'Passive'
        defaultans1 = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data'};
        save_file_name = join(['N = ', num2str(num_folders), '_animals_Combined_passive.mat']);
end

prompt1 = {'Where are you saving the output file (default = Parent Folder of analysis type'}; dlg_title1 = 'Parent Folder Path'; num_lines1 = 1;
labels1 = inputdlg(prompt1,dlg_title1,num_lines1,defaultans1);

%Set file saving name
save_folder_directory = labels1{1}; 
savefile = fullfile(save_folder_directory, save_file_name);
save(savefile,'combined_data'); %clear all;

