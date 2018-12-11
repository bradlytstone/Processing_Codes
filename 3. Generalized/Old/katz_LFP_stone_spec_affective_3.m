function [aff_cond1, aff_cond2, power_spec] = katz_LFP_stone_spec_affective_3(dirname)

%This function takes in one input DIRNAME and flips through each *.mat file
%(which is one animal, one day of recording, and one taste) within the
%given directory to perform Welch's power spectral density estimate for
%each taste period in reference to stimulus onset (Pre [-750ms,-250ms],
%Early [250ms,750ms], and Late [1250ms,1750ms]). The parameters used for
%PWELCH function are detailed herein, however, the user can change them
%using lines 51-53. The outputs are PRE, EARLY, LATE, and F.

%DIRNAME = directory name that files are located in
%PRE = output array of PSD estimates for pre-taste period
%EARLY = output array of PSD estimates for early-taste period
%LATE = output array of PSD estimates for late-taste period
%F = output vector of Frequency for given PWELCH parameters

%get file location and information
matfile = dir([dirname filesep '*_Combined_passive.mat']);

%grab animal name for plot labeling
animal = dirname(strfind(dirname,'BS'):strfind(dirname,'BS')+3);

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
       [affective_struct, saline_struct, power_spec] = binning_stone(working_mat, sessions, big_split, millisecs, fmax, fmin);
       choice = ['20_min_session_' num2str(1200000/big_split) '_' num2str(big_split/60000) 'min_bin_']; %For saving purposes
 case 'No'
       [affective_struct, saline_struct, power_spec] = full_passive_stone(working_mat, sessions, fmax, fmin);
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
            default_save_dir = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_Passive_Data',filesep, animal};
            full_location = join([default_save_dir{1},default_save_dir{2},default_save_dir{3}]);
            name = [animal '_spectral_analysis_0ms_1200000ms.pdf'];

        save_spot = fullfile(full_location, name); print(h, save_spot,'-dpdf', '-r0');
end
    