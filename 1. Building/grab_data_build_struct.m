
%Ask user to go to affective perturbation directory for tastes and create
%structures for the data
affective_folder_name = uigetdir('','Choose folder where Taste .mat (Under Affective State Change) file is'); 
affective_file = dir([affective_folder_name filesep '*_all_tastes.mat']); aff_full_dir = [affective_folder_name filesep affective_file.name];
aff_str=whos('-file',aff_full_dir); aff_str={aff_str.name}; aff_struct = load(aff_full_dir,aff_str{:}); aff_data = aff_struct.all_tastes;
%change field names to appropriate session and establish array sizes
%(tastes:channels:trials:duration)
aff_data = cell2struct(struct2cell(aff_data), {'drug_sess'}); aff_data_size = size(aff_data.drug_sess);

%Ask user to go to saline vehicle directory for tastes and create
%structures for the data
saline_folder_name = uigetdir('','Choose folder where Taste .mat (Under SALINE) file is'); 
saline_file = dir([saline_folder_name filesep '*_all_tastes.mat']); saline_full_dir = [saline_folder_name filesep saline_file.name];
sal_str=whos('-file',saline_full_dir); sal_str={sal_str.name}; sal_struct = load(saline_full_dir,sal_str{:}); sal_data = sal_struct.all_tastes;
%change field names to appropriate session and establish array sizes
%(tastes:channels:trials:duration)
sal_data = cell2struct(struct2cell(sal_data), {'saline_sess'}); sal_data_size = size(sal_data.saline_sess);

%Ask user where to create an folder to save combined file for later use
%Contruct an input box for Taste information and LFP time length
prompt1 = {'Where are you saving the output file (default = Combined_4Taste_Data'}; dlg_title1 = 'Parent Folder Path'; num_lines1 = 1;
defaultans1 = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_4Taste_Data'}; labels1 = inputdlg(prompt1,dlg_title1,num_lines1,defaultans1);
animal = aff_full_dir(strfind(aff_full_dir,'BS'):strfind(aff_full_dir,'BS')+3); animal={animal}; %grab animal name for folder labeling
save_folder_directory = labels1{1}; folder_name = animal{1};
mkdir(save_folder_directory,folder_name); animal_directory = dir([save_folder_directory filesep folder_name filesep]); animal_directory = animal_directory.folder;

%Combine data into one structure and revalue the variables
combined_data = struct('affective',aff_data,'saline',sal_data);
aff_data = combined_data.affective; sal_data = combined_data.saline;
save_file_name = join([animal, '_Combined_all_tastes.mat']); savefile = fullfile(animal_directory, save_file_name);

save(cell2mat(savefile),'combined_data');