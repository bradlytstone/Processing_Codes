function [comb_cond1, comb_cond2, power_spec] = katz_LFP_stone_spec(dirname)

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

% Construct a Question Dialog Box with 2 options for spectorgram plotting
choice0 = questdlg('Is this a Taste file or Affective file?', ...
	'Mat File Search Menu', ...
	'Taste','Affective', 'Maybe');

switch choice0
    case 'Taste'
        matfile = dir([dirname filesep '*_all_tastes.mat']);
    case 'Affective'
        matfile = dir([dirname filesep '*_affective_session.mat']);
end

animal = dirname(strfind(dirname,'BS'):strfind(dirname,'BS')+3);

% Construct a Question Dialog Box with 2 options for spectorgram plotting
choice = questdlg('What type of spectrogram do you want?', ...
	'Plotting Menu', ...
	'Mean','Normalized', 'Maybe');

% Construct a Question Dialog Box with 2 options for inputting whether
% equal trial numbers exist between both conditions
choice2 = questdlg('Do you have an equal number of trials within each condition?', ...
	'Trial Count Menu', ...
	'Yes','No', 'Maybe');

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_mat = load(matfile(file).name);
    disp(['Working on file ' matfile(file).name]); %Displays working file
    
    array_set = cell2mat(fieldnames(working_mat));
    sessions = size(cell2mat(fieldnames(working_mat.(array_set))),1);
    build1 = []; build2 = []; build3 = []; build4 = [];
    
    %Flip through sessions
    for x=1:sessions(1)
        %Create array for session names
        sess_names = []; Name={['Whole - Session ' num2str(x)]}; sess_names = [sess_names, Name];        
        
        session_name = cell2mat(fieldnames(working_mat.(array_set)));
        session_data = working_mat.(array_set).(session_name(x,:));
        array_sizes = size(working_mat.(array_set).(session_name(x,:)));
        tastes = array_sizes(1); yvalues = [];
        
        %Flips through tastes
        for taste=1:tastes
            taste_data = squeeze(working_mat.(array_set).(session_name(x,:))(taste,:,:,:));
            
            switch choice0
                case 'Taste'
                    trials = size(taste_data(:,:,:,:),(2));  %identifies number of trials for this taste
                case 'Affective'
                    trials = size(taste_data(:,:,:,:),(3));  %sets up array to be like others in rest of analysis
            end
            
            switch choice0
                case 'Taste'
                    %Store in arrays
                    switch taste
                        case 1
                            build1= [build1; squeeze(taste_data(1,:,:))]; %collapses across electrodes
                        case 2
                            build2= [build2; squeeze(taste_data(1,:,:))]; %collapses across electrodes
                        case 3
                            build3= [build3; squeeze(taste_data(1,:,:))]; %collapses across electrodes
                        case 4
                            build4= [build4; squeeze(taste_data(1,:,:))]; %collapses across electrodes
                    end %end concatenation
             end    
        end %end taste loop
            
    end %end session loop
    
end %end matlab file loop

switch choice0
    case 'Taste'
        switch choice2 %Fix issues with files that do not have standard 30trials/taste/cond (e.g. BS14 - only 19 trials in cond_1)
            case 'No'
                %Contruct an input box for Taste information and LFP time length
                prompt_2 = {'Trials (Condition 1)','Trials (Condition 2)'}; dlg_title_2 = 'Trial Correcting:'; num_lines_2 = 2;
                defaultans_2 = {'30','30'}; labels_2 = inputdlg(prompt_2,dlg_title_2,num_lines_2,defaultans_2);
                correction_1 = str2num(labels_2{1}); correction_2 = str2num(labels_2{2}); 
                taste1_cond1 = squeeze(build1(1:correction_1,:)); taste2_cond1 = squeeze(build2(1:correction_1,:)); taste3_cond1 = squeeze(build3(1:correction_1,:)); taste4_cond1 = squeeze(build4(1:correction_1,:)); 
                taste1_cond2 = squeeze(build1(correction_1:correction_1+correction_2,:)); taste2_cond2 = squeeze(build2(correction_1:correction_1+correction_2,:)); taste3_cond2 = squeeze(build3(correction_1:correction_1+correction_2,:)); taste4_cond2 = squeeze(build4(correction_1:correction_1+correction_2,:)); 
            case 'Yes'
                disp(['Using default settings (ie. 30 trials per taste/condition)']);
                switch choice0
                    case 'Taste'
                        taste1_cond1 = squeeze(build1(1:30,:)); taste2_cond1 = squeeze(build2(1:30,:)); taste3_cond1 = squeeze(build3(1:30,:)); taste4_cond1 = squeeze(build4(1:30,:)); 
                        taste1_cond2 = squeeze(build1(31:60,:)); taste2_cond2 = squeeze(build2(31:60,:)); taste3_cond2 = squeeze(build3(31:60,:)); taste4_cond2 = squeeze(build4(31:60,:)); 
                    case 'Affective'    
                end    
        end
end

switch choice0
    case 'Taste'
        %create arrays which combine all tastes by condition
        comb_cond1 = vertcat(taste1_cond1, taste2_cond1, taste3_cond1, taste4_cond1); comb_cond2 = vertcat(taste1_cond2, taste2_cond2, taste3_cond2, taste4_cond2);
    case 'Affective'
        comb_cond1 = taste_data;
end
        
Fs = 1000;              %Sampling frequency in Hz.
s_window = 500;         %assigns window criteria to divide the signal (length you input) into segments of this size
s_overlap = 450;        %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
fmin = 3; fmax = 20;    %set cutoffs for frequencies to look at
tmin = 0;               %set time window to look at

%Flip through sessions
for x=1:sessions(1)
   
    sess_cond = {['comb_cond' num2str(x)]};           
    array = eval(sess_cond{1});
    MeanNormP=zeros(8193,131); %Create array for normalizing power
    MeanP=zeros(8193,131);     %Create array for mean power
    meanfact=size(array,1);
    
    for trial = 1:size(array,1);
        [S, F, T, P] = spectrogram(detrend(array(trial,:)), s_window, s_overlap, sig_length, Fs);

        good = find(F < 20.0);
        preT = find(T < 2.0);       %indicates time to draw into the baseline power calcs
        preP = mean(P(:,preT),2);   %takes mean of power values of pre-taste times
        SpreP = std(P(:,preT),1,2); %takes standard deviation of power values of pre-taste times
        
        %Flip through power values
        for k=1:size(P,2)
           normP(:,k) = (P(:,k) - preP)./SpreP;  %adds normalized data to 'normP' array
        end
        
        MeanNormP=MeanNormP+normP/meanfact;      %divides normalized power by by the number of total trials
        MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials
    end
    
    good = find(F < fmax);
    good = intersect(good,find(F > fmin));
    Tgood = find(T > tmin);
   % Tgood = union(Tgood,find(T > 1.5)); %indicates time to draw into the baseline power calcs
   
    switch choice
        case 'Mean'
        power_spec = subplot(2,1,x); hold on; imagesc(T(Tgood)-1,F(good),(MeanP(good,Tgood)));  axis xy; colorbar; 
        case 'Normalized'
        power_spec = subplot(2,1,x); hold on; imagesc(T(Tgood)-1,F(good),(MeanNormP(good,Tgood)));  axis xy; colorbar;     
    end
    
    hold on; xticks([-1 0 1 2 3 4 5]); xticklabels([-2 -1 0 1 2 3 4 5]); ylim([fmin fmax]); xlim([-0.75 5]);
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
            h = colorbar; h = colorbar; ylabel(h,'Power (z-score)');
            h.Ticks = [0:labeling];
        case 'Mean'
            h = colorbar; ylabel(h,'Power Spectral Density (mV^{2}/Hz)');
            %hAxes = gca; hc = colorbar(hAxes); hc.TickLabels = arrayfun( @num2str, hc.Ticks / 10^6, 'UniformOutput', false ); %h.Ticks = [0:100:labeling]; 
    end
end

%Set print preferences and save the file as such
figure(1); suptitle([animal ' ' 0 'ms-' 7000 'ms']);
h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
print(h, [animal '_spectral_analysis_' choice '_0ms_7000ms.pdf'],'-dpdf', '-r0');

    