function [aff_cond1, aff_cond2, power_spec] = katz_LFP_stone_spec_affective(dirname)

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

% saline_folder_name = uigetdir('','Choose folder where Saline trial is'); saline_file = dir([saline_folder_name filesep '*_affective_session.mat']);
% full_dir = [saline_folder_name filesep saline_file.name];
% str=whos('-file',full_dir); str={str.name}; saline = load(full_dir,str{:}); sal_data = saline.affective_states;      %grab saline data
% working_mat = load(matfile.name); comb_files = working_mat.affective_states; new_name = 'drug_sess'; [comb_files.(new_name)]=comb_files.('Session_0'); %grab affective data and change name of field
% comb_files = rmfield(comb_files,'Session_0');
% 
% %put saline data into comb_files struct
% [comb_files(:).saline_sess] = sal_data.Session_0; 

% % Construct a Question Dialog Box with 2 options for spectorgram plotting
% choice = questdlg('What type of spectrogram do you want?', ...
% % 	'Plotting Menu', ...
% % 	'Mean','Normalized', 'Maybe');
% 

% Construct a Question Dialog Box with 2 options for spectorgram plotting
trial_split = questdlg('Do you want to split this trial into smaller bins (ie. for averaging purposes)?', ...
	'Plotting Menu', ...
	'Yes','No', 'Maybe');

%Asks user to dictate how to split the array using milliseconds
switch trial_split 
    case 'Yes'
        prompt_2 = {'Milliseconds to split by'}; dlg_title_2 = 'Trial Binning:'; num_lines_2 = 1;
        defaultans_2 = {'5000'}; labels_2 = inputdlg(prompt_2,dlg_title_2,num_lines_2,defaultans_2);
        trial_length = size(working_mat.(array_set).affective.drug_sess,4)/str2num(labels_2{1});
        
        %Indicates the number of trials the large 20-min section will be
        %split into and then sets the millisecs variable for later use
        if rem(trial_length,1) > 0
            trial_length = round(trial_length)+1; millisecs = str2num(labels_2{1}); 
        else 
            trial_length = round(trial_length); millisecs = str2num(labels_2{1}); 
        end
        %details choices made
        disp(['You are splitting the 20-minute section into ' num2str(trial_length) ' psuedo-trials!']);
    case 'No'    
        %details choices made
        disp(['Assumes 20 minutes (1,200,000ms) per condition']);
end

%Flip through each matlab output file and contruct merged arrays

disp(['Working on ' animal 's data']); %Displays working file
build1 = []; build2= [];

%Flip through sessions
for x=1:sessions(1)
    %Create array for session names
    array_set = fieldnames(comb_files);
    
     if x == 1
            file_data = 'drug_sess';
        else
            file_data = 'saline_sess';
     end
     
    session_name = fieldnames(comb_files.(array_set{x}));
    session_data = comb_files.(array_set{x}).(session_name{1});
    array_sizes = size(session_data);   
    
    taste_data = squeeze(session_data(1,:,:,:));
    cut_by_5_min = reshape(taste_data(:,:),millisecs*60,[])'; %split file into 5-minute chunks (channel*chunks:duration)
    trials = size(taste_data(:,:,:,:),(3));  %sets up array to be like others in rest of analysis
    channels = size(taste_data(:,:,:,:),(1)); %get number of channels for later use
    
    switch trial_split 
        case 'No'
            %stores data in arrays for spectral analyses 
            if x ==1;
                build1 = taste_data; 
            else
                build2 = taste_data;
            end
        case 'Yes'
            %stores data in arrays for spectral analyses 
            if x ==1;
                build1 = cut_by_5_min; 
            else
                build2 = cut_by_5_min;
            end           
    end

end %end session loop

aff_cond1 = build1; aff_cond2 = build2; divider =array_sizes(1,4)/(millisecs*60);
        
Fs = 1000;              %Sampling frequency in Hz.
sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
fmin = 3; fmax = 20;    %set cutoffs for frequencies to look at
tmin = 0;               %set time window to look at

%Flip through sessions
for x=1:sessions(1)
   
    sess_cond = {['aff_cond' num2str(x)]};           
    array = eval(sess_cond{1});
    channels = size(array,1)/divider;
    
    %reshape the array if user wants to split the 20-min section
    switch trial_split
        case 'Yes'
            
            %create arrays with binned data (default, 5 min)
           % bin_1 = array(1:channels,:); bin_2 = array(channels+1:channels*2,:); bin_3 = array((channels*2)+1:channels*3,:); bin_4 = array((channels*3)+1:channels*4,:);
            
             %contruct array that is arranged as such:
            %(channel:pseudo-trial:duration)
            
            bin_start = 1;
            %Go through each bin (
            for bin=1:channels/divider
                binned_array = array(bin_start:(bin*channels),:);
                
                split_array = zeros(channels,trial_length/divider,millisecs); %channels:pseudo-trials:duration
                
                Fs = 1000;              %Sampling frequency in Hz.
                s_window = 500;         %assigns window criteria to divide the signal (length you input) into segments of this size
                s_overlap = 450;        %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
                sig_length = 2.^14;      %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
                fmin = 3; fmax = 20;    %set cutoffs for frequencies to look at
                tmin = 0;               %set time window to look at
    
                MeanP=zeros(8193,91);     %Create array for mean power (column length dictated by window/overlap) for a 5000 duration;
                                
                for channel=1:size(binned_array,1);
                    disp(['Analyzing electrode ' num2str(channel) '...']);
                    psuedo_trial_split = reshape([binned_array(channel,:),nan(1,millisecs-mod(numel(binned_array(channel,:)),millisecs))],millisecs,[])';
                    psuedo_trial_split(isnan(psuedo_trial_split)) = []; psuedo_trial_split = reshape(psuedo_trial_split,trial_length/divider,millisecs);
                    split_array(channel,:,:) = [psuedo_trial_split];
                    meanfact=size(split_array,2)* size(split_array,1); %calculate denominator; pseudo-trials*channels
                    
                    %flip through trials and perform spectrogram calculations       
                     for trial = 1:size(split_array,2);
                         signal = squeeze(split_array(channel,trial,:)); %signal(isnan(signal))=[];
                         [S, F, T, P] = spectrogram(detrend(signal), s_window, s_overlap, sig_length, Fs);
                         %P(cellfun(@isnan,P)) = {[]}
                         MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials
                     end    
                end
                
                good = find(F < fmax);
                good = intersect(good,find(F > fmin));
                Tgood = find(T > tmin);

                power_spec = figure(bin); subplot(2,1,x); hold on; imagesc(T(Tgood),F(good),(MeanP(good,Tgood)/10^6));  axis xy; colorbar;
            
                %place all plotting things here
                suptitle_name = (['First ' num2str(bin*5) ' minutes']);
                hold on;  xticklabels([1:5]); ylim([fmin fmax]); xlim([0.25 4.75]);
                suptitle([animal ' - ' suptitle_name]);
                bin_start = bin*channels;
            end
                       
        case 'No'
            s_window = 5000;         %assigns window criteria to divide the signal (length you input) into segments of this size
            s_overlap = 4500;        %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
            MeanP=zeros(8193,2391);     %Create array for mean power (column length dictated by window/overlap);
            meanfact=size(array,1);     %Assumes 1 LARGE trial so no multiplying
            
             %flip through trials and perform spectrogram
            for trial = 1:size(array,1);

                [S, F, T, P] = spectrogram(detrend(array(trial,:)), s_window, s_overlap, sig_length, Fs);

                good = find(F < fmax);
                MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials*channels

                good = find(F < fmax);
                good = intersect(good,find(F > fmin));
                Tgood = find(T > tmin);

            end
            power_spec = subplot(2,1,x); hold on; imagesc(T(Tgood)-1,F(good),(MeanP(good,Tgood)/10^6));  axis xy; colorbar; 

    end
           
    hold on; xticks([0:60:1200]); xticklabels([0:1:20]); ylim([fmin fmax]); xlim([0 1200]);
    xlabel('Time [min]');  ylabel('Freq [Hz]'); 
    if x == 1;
        title('Affective State = LiCl');
        cscale1 = max(caxis);
    else
        title('Affective State = Healthy');
        cscale2 = max(caxis);
    end
end;

%set colorbar scales
c_set = max(cscale1,cscale2);

for x=1:sessions;
    subplot(2,1,x); caxis([0 c_set]); 
    h = colorbar; ylabel(h,'Power Spectral Density (mV^{2}/Hz)');
end

%Set print preferences and save the file as such
figure(1); suptitle([animal ' ' 0 'ms-' 7000 'ms']); colormap('jet');
h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
print(h, [animal '_spectral_analysis_' choice '_0ms_7000ms.pdf'],'-dpdf', '-r0');

    