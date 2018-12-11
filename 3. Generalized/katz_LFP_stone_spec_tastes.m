function [comb_cond1, comb_cond2, power_spec] = katz_LFP_stone_spec_tastes(dirname)

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

matfile = dir([dirname filesep '*_all_tastes.mat']);
animal = dirname(strfind(dirname,'BS'):strfind(dirname,'BS')+3);

% Construct a Question Dialog Box with 2 options for spectorgram plotting
choice = questdlg('What type of spectrogram do you want?', ...
	'Plotting Menu', ...
	'Mean','Normalized', 'Maybe');

% Construct a Question Dialog Box with 2 options for spectorgram plotting
comb_file = questdlg('Is this a grand mean analysis?', ...
	'Analysis Menu', ...
	'Yes','No', 'Maybe');

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_mat = load(matfile(file).name);
    disp(['Working on file ' matfile(file).name]); %Displays working file
    
    array_set = cell2mat(fieldnames(working_mat));
    sessions = size(fieldnames(working_mat.(array_set)),1);
        
    %Flip through sessions
    for x=1:sessions(1)
        
        %Create array for session names
        sess_names = []; Name={['Whole - Session ' num2str(x)]}; sess_names = [sess_names, Name];        
        if x == 1
            file_data = 'drug_sess';
        else
            file_data = 'saline_sess';
        end
        
        session_name = fieldnames(working_mat.(array_set));
        session_data = working_mat.(array_set).(session_name{x});
        array_sizes = size(working_mat.(array_set).(session_name{x}).(file_data));
        tastes = array_sizes(1); build1 = []; build2 = []; build3 = []; build4 = [];
        
        %Flips through tastes
        for taste=1:tastes
            taste_data = squeeze(working_mat.(array_set).(session_name{x}).(file_data)(taste,:,:,:));
            trials = size(taste_data(:,:,:,:),(2));  %identifies number of trials for this taste
                       
            %Store in arrays
            switch taste
                case 1
                    build1= [build1; taste_data];
                case 2
                     build2= [build2; taste_data];
                case 3
                     build3= [build3; taste_data];
                case 4
                     build4= [build4; taste_data];
            end %end concatenation
                
        end %end taste loop
        
        %combine all taste files together
        if x ==1;
            comb_cond1 = vertcat(build1,build2,build3,build4); 
        else
            comb_cond2 = vertcat(build1,build2,build3,build4); 
        end
        
    end %end session loop
    
end %end matlab file loop

%create arrays which combine all tastes by condition
Fs = 1000;              %Sampling frequency in Hz.
s_window = 500;         %assigns window criteria to divide the signal (length you input) into segments of this size
s_overlap = 450;        %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
max_pow = (array_sizes(4)-s_overlap)/(s_window-s_overlap) %find the # of time points to calculate the maximum of the power spectral density 
fmin = 3; fmax = 20;    %set cutoffs for frequencies to look at
tmin = 0;               %set time window to look at

%Put GM processes here


%Flip through sessions
for x=1:sessions(1)
    
    sess_cond = {['comb_cond' num2str(x)]};
    array = eval(sess_cond{1});
    MeanNormP=zeros(8193,max_pow); %Create array for normalizing power (column length dictated by window/overlap);
    MeanP=zeros(8193,max_pow);     %Create array for mean power (column length dictated by window/overlap);
    meanfact=size(array,2)*size(taste_data,1); %calculate denominator; trials*channels
    
    %flip through channels
    for channel = 1:size(array,1);
        disp(['Analyzing electrode ' num2str(channel) '...']);
        
        %flip through trials and perform spectrogram calculations       
        for trial = 1:size(array,2);
            %disp(['Performing spectrogram calculations on trial ' num2str(trial) ' of ' num2str(size(array,2)) '.']);
            signal = squeeze(array(channel,trial,:));
            [S, F, T, P] = spectrogram(detrend(signal), s_window, s_overlap, sig_length, Fs);

            good = find(F < fmax);
            
            switch choice
                case 'Normalized'
                    preT = find(T < 2.0);       %indicates time to draw into the baseline power calcs
                    preP = mean(P(:,preT),2);   %takes mean of power values of pre-taste times
                    SpreP = std(P(:,preT),1,2); %takes standard deviation of power values of pre-taste times

                    %Flip through power values to normalize
                    for k=1:size(P,2)
                       normP(:,k) = (P(:,k) - preP)./SpreP;  %adds normalized data to 'normP' array
                    end
                    MeanNormP=MeanNormP+normP./meanfact;      %divides normalized power by by the number of total trials*channels
                
                case 'Mean'
                    MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials
            end
        end
    end
    
    good = find(F < fmax);
    good = intersect(good,find(F > fmin));
    Tgood = find(T > tmin);
   % Tgood = union(Tgood,find(T > 1.5)); %indicates time to draw into the baseline power calcs
   
    switch choice
        case 'Mean'
        power_spec = subplot(2,1,x); hold on; imagesc(T(Tgood)-1,F(good),(MeanP(good,Tgood)/10^6));  axis xy; colorbar; 
        case 'Normalized'
        power_spec = subplot(2,1,x); hold on; imagesc(T(Tgood)-1,F(good),(MeanNormP(good,Tgood)));  axis xy; colorbar;     
    end
    
    hold on; xticks([-1 0 1 2 3 4 5 6]); xticklabels([-2 -1 0 1 2 3 4 5]); ylim([fmin fmax]); xlim([-0.75 5.75]);
    xlabel('Time [s]');  ylabel('Freq [Hz]'); 
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
labeling = round(c_set,0);
for x=1:sessions;
    subplot(2,1,x); caxis([0 c_set]); 
    switch choice
        case 'Normalized'
            h = colorbar; ylabel(h,'Power (z-score)');
        case 'Mean'
            h = colorbar; ylabel(h,'Power Spectral Density (mV^{2}/Hz)');
    end
end

%Set print preferences and save the file as such
figure(1); suptitle([animal ' - ' choice]); colormap('jet');
h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
default_save_dir = {'/home/bradly/drive2/data/Affective_State_Protocol/LiCl/Combined_4Taste_Data',filesep, animal};
full_location = join([default_save_dir{1},default_save_dir{2},default_save_dir{3}]);
name = [animal '_spectral_analysis_' choice '_0ms_7000ms.pdf']; save_spot = fullfile(full_location, name); 
print(h, save_spot,'-dpdf', '-r0');

    