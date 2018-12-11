function [combined_spec_data] = katz_LFP_stone_spec_affective(dirname)

%This function takes in one input DIRNAME and grabs the
%*_Combined_passive.mat file (which is a struct ('combined_data') for one
%animal and includes two structures ('affective' and 'saline') which each
%have their respective struct containing the data for one day of recording
%consisting of: channels * duration (20min). First diaglog box will prompt
%asking if you want to split the long duration into smaller bins. If yes,
%you will have the capability of setting the bin cut parameters (run this
%analysis before anything else). If no, process proceeds with using the
%whole 20min duration as a single trial. Second dialog box asks user to set
%frequency parameters for power spectral analysis and plotting settings.
%Third dialox box asks users to set scale for colorbar (power) for figures.
%This value should come from the smallest, max power found after looking at
%the binned plots.

%DIRNAME = directory name that files are located in 
%COMBINED_SPEC_DATA = output struct of the power spec values (T, F, MeanP, good, and Tgood) for
%each condition (affective and saline).

%get file location and information
matfile = dir([dirname filesep '*_Combined_passive.mat']);

% Construct a Question Dialog Box with 2 options for spectorgram plotting
comb_file = questdlg('Is this a grand mean analysis?', ...
	'Analysis Menu', ...
	'Yes','No', 'Maybe');

switch comb_file
    case 'Yes'
        %Create subdirectory
        subdirs = dir(dirname); subdirs(~[subdirs.isdir]) = [];

        %Filter out the parent and current directory
        tf = ismember( {subdirs.name}, {'.', '..'}); subdirs(tf) = []; 
        num_folders = length(subdirs);
        
        %For plot labeling
        animal = (['N = ' num2str(num_folders)]);
        
    case 'No'
        %grab animal name for plot labeling
        animal = dirname(strfind(dirname,'BS'):strfind(dirname,'BS')+3);
end

%load data
working_mat = load(matfile(1).name); array_set = cell2mat(fieldnames(working_mat));
session_name = fieldnames(working_mat.(array_set)); sessions = size(fieldnames(working_mat.(array_set)),1);
comb_files = working_mat.combined_data;

% Construct a Question Dialog Box with 2 options for spectorgram plotting
trial_split = questdlg('Do you want to split this trial into smaller bins (ie. for averaging purposes)?', ...
	'Plotting Menu', ...
	'Yes','No', 'Maybe');

%Asks user to dictate how to split the array using milliseconds
switch trial_split 
    case 'Yes'
        prompt_2 = {'Large bin size (ms): ','Milliseconds to split by:'}; dlg_title_2 = 'Trial Binning:'; num_lines_2 = 2;
        defaultans_2 = {'300000','5000'}; labels_2 = inputdlg(prompt_2,dlg_title_2,num_lines_2,defaultans_2);
        trial_length = size(working_mat.(array_set).affective.drug_sess,4)/str2num(labels_2{2});
        
        %Indicates the number of trials the large 20-min section will be
        %split into and then sets the millisecs variable for later use
        if rem(trial_length,1) > 0
            trial_length = round(trial_length)+1; millisecs = str2num(labels_2{2}); big_split = str2num(labels_2{1});
        else 
            trial_length = round(trial_length); millisecs = str2num(labels_2{2}); big_split = str2num(labels_2{1});
        end
        %details choices made
        disp(['You are splitting the 20-minute section into ' num2str(trial_length) ' psuedo-trials!']);
    case 'No'    
        %details choices made
        disp(['Assumes 20 minutes (1,200,000ms) per condition']);
end

%Flip through each matlab output file and contruct merged arrays

disp(['Working on ' animal 's data']); %Displays working file

prompt_3 = {'Max Frequency (Hz): ', 'Minimum Frequency (Hz)'}; dlg_title_3 = 'PSD Parameters:'; num_lines_3 = 2;
defaultans_3 = {'20','3'}; labels_3 = inputdlg(prompt_3,dlg_title_3,num_lines_3,defaultans_3);
        
Fs = 1000;              %Sampling frequency in Hz.
sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
fmin = str2num(labels_3{2}); fmax = str2num(labels_3{1});    %set cutoffs for frequencies to look at
tmin = 0;               %set time window to look at

switch trial_split
    case 'Yes'        
       [T, Tgood, F, good, MeanP] = binning_stone(working_mat, sessions, big_split, millisecs, fmax, fmin);
       choice = ['20_min_session_' num2str(1200000/big_split) '_' num2str(big_split/60000) 'min_bin_']; %For saving purposes
    case 'No'
        [p_spec_aff, p_spec_sal] = full_passive_stone(working_mat, sessions, fmax, fmin);
        combined_spec_data = struct('affective',p_spec_aff,'saline',p_spec_sal);
        prompt_4 = {'Set Scale:'}; dlg_title_4 = 'Scale using binned scale:'; num_lines_4 = 1;
        defaultans_4 = {'1*10^-3'}; labels_4 = inputdlg(prompt_4,dlg_title_4,num_lines_4,defaultans_4); min_cscale=str2num(labels_4{1}); 
end

 %Get number of figures open in order to flip through and format
 fig_find =  findobj('type','figure'); fig_count = length(fig_find);

%Set all the figures scales to the same
cscale_set = {};
for fig=1:fig_count
    for sub=1:sessions
        figure(fig); subplot(2,1,sub); 
        cscale_set{end+1} = max(caxis);
    end
end
max_cscale = max(cell2mat(cscale_set)); 

switch trial_split
    case 'Yes'
        min_cscale = min(cell2mat(cscale_set));
end

for fig=1:fig_count
    for sub=1:sessions
        figure(fig); subplot(2,1,sub); colormap('jet');
        caxis([0 min_cscale]); 
    end
end 
 
switch trial_split
    case 'Yes' 
        for fig=1:fig_count
            for sub=1:sessions
                figure(fig); subplot(2,1,sub); ylim([fmin fmax]); ylabel('Freq [Hz]'); hold on; 
                h = colorbar; ylabel(h,'Power Spectral Density (mV^{2}/Hz)'); colormap('jet');
                secs = millisecs/1000; xlim([0.25 secs-0.25]); xlabel('Time [sec]');
                if sub == 1;
                    title('Affective State = LiCl');
                else
                    title('Affective State = Healthy');
                end
            end

            %Set printer/saving parameters and save file
            h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
            set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
            default_save_dir = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data',filesep, animal};
            full_location = join([default_save_dir{1},default_save_dir{2},default_save_dir{3}]);
            name = [animal '_Mean_spec_' choice num2str(fig) '_of_' num2str(fig_count) '.pdf']; 
             
        
            save_spot = fullfile(full_location, name); 
            print(h, save_spot,'-dpdf', '-r0');

        end

    case 'No'
        for sub=1:sessions
            figure(1); subplot(2,1,sub); ylabel('Freq [Hz]'); hold on; ylim([fmin fmax]);
            h = colorbar; ylabel(h,'Power Spectral Density (mV^{2}/Hz)'); colormap('jet');hold on;
            xticks([0:60:1200]); hold on; xticklabels([0:1:20]); xlim([0 1200]);xlabel('Time [min]');  
           
            if sub == 1;
                title('Affective State = LiCl');
            else
                title('Affective State = Healthy');
            end
           
        end
        
         %Set printer/saving parameters and save file
            figure(1);  suptitle([animal ' 0min-20min']); h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
            set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
            
            switch comb_file
                case 'Yes'
                    default_save_dir = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data',filesep};
                    full_location = join([default_save_dir{1},default_save_dir{2}]);
                case 'No'
                    default_save_dir = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data',filesep, animal};
                    full_location = join([default_save_dir{1},default_save_dir{2},default_save_dir{3}]);
            end
                        
           name = [animal '_spectral_analysis_0ms_1200000ms.pdf'];
           save_spot = fullfile(full_location, name); print(h, save_spot,'-dpdf', '-r0');
           save('combined_spec_data.mat', '-v7.3');
end
    