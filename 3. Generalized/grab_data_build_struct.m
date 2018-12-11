%This script (after initiating) requires you to select a directory that has
%the '*_all_tastes.mat' or '*_affective_session.mat' file (obtained from
%python script) from the affective trials, followed by a dialog box that
%requires you to select a directory that has the '*_all_tastes.mat' or
%'*_affective_session.mat' file (obtained from python script) from the
%saline trials. Dependent on which type (passive v. taste) %data, the
%output file will be a struct which consists of affective and saline data
%saved as either '*_Combined_all_tastes.mat' or '*_Combined_passive.mat'.

% Construct a Question Dialog Box with 2 options data finding
data_type = questdlg('Are you looking at Taste data or Passive data?', ...
	'Plotting Menu', ...
	'Taste','Passive', 'Maybe');

%Ask user to go to affective perturbation and saline directories for .mat files 
affective_folder_name = uigetdir('','Choose folder where the .mat (Under Affective State Change) file is'); 
saline_folder_name = uigetdir('','Choose folder where the .mat (Under SALINE) file is'); 

%Create structures for the data
switch data_type
    case 'Taste'
        affective_file = dir([affective_folder_name filesep '*_all_tastes.mat']); aff_full_dir = [affective_folder_name filesep affective_file.name];
        saline_file = dir([saline_folder_name filesep '*_all_tastes.mat']); saline_full_dir = [saline_folder_name filesep saline_file.name];
        
        %concatenate directory information and load structures
        aff_str=whos('-file',aff_full_dir); aff_str={aff_str.name}; aff_struct = load(aff_full_dir,aff_str{:}); aff_data = aff_struct.all_tastes;
        sal_str=whos('-file',saline_full_dir); sal_str={sal_str.name}; sal_struct = load(saline_full_dir,sal_str{:}); sal_data = sal_struct.all_tastes;
        
        %Contruct an input box for Taste information to store output struct
        prompt1 = {'Where are you saving the output file (default = Combined_4Taste_Data'}; dlg_title1 = 'Parent Folder Path'; num_lines1 = 1;
        defaultans1 = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_4Taste_Data'}; labels1 = inputdlg(prompt1,dlg_title1,num_lines1,defaultans1);

    case 'Passive'
        affective_file = dir([affective_folder_name filesep '*_affective_session.mat']); aff_full_dir = [affective_folder_name filesep affective_file.name];
        saline_file = dir([saline_folder_name filesep '*_affective_session.mat']); saline_full_dir = [saline_folder_name filesep saline_file.name];
        
        %concatenate directory information and load structures
        aff_str=whos('-file',aff_full_dir); aff_str={aff_str.name}; aff_struct = load(aff_full_dir,aff_str{:}); aff_data = aff_struct.affective_states;
        sal_str=whos('-file',saline_full_dir); sal_str={sal_str.name}; sal_struct = load(saline_full_dir,sal_str{:}); sal_data = sal_struct.affective_states;
      
        %Contruct an input box for Taste information to store output struct
        prompt1 = {'Where are you saving the output file (default = Combined_Passive_Data'}; dlg_title1 = 'Parent Folder Path'; num_lines1 = 1;
        defaultans1 = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data'}; labels1 = inputdlg(prompt1,dlg_title1,num_lines1,defaultans1);
end

%change field names to appropriate session and establish array sizes
aff_data = cell2struct(struct2cell(aff_data), {'drug_sess'}); aff_data_size = size(aff_data.drug_sess);
sal_data = cell2struct(struct2cell(sal_data), {'saline_sess'}); sal_data_size = size(sal_data.saline_sess);

%Ask user where to create an folder to save combined file for later use
animal = aff_full_dir(strfind(aff_full_dir,'BS'):strfind(aff_full_dir,'BS')+3); animal={animal}; %grab animal name for folder labeling
save_folder_directory = labels1{1}; folder_name = animal{1};
mkdir(save_folder_directory,folder_name); animal_directory = dir([save_folder_directory filesep folder_name filesep]); animal_directory = animal_directory.folder;

%Combine data into one structure and revalue the variables
combined_data = struct('affective',aff_data,'saline',sal_data);
aff_data = combined_data.affective; sal_data = combined_data.saline;

%Set file saving name
switch data_type
    case 'Taste'
        save_file_name = join([animal, '_Combined_all_tastes.mat']); 
    case 'Passive'
        save_file_name = join([animal, '_Combined_passive.mat']);
end

%Save file
savefile = fullfile(animal_directory, save_file_name);
save(cell2mat(savefile),'combined_data'); clear all;