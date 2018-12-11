function [Pre, Early, Late, F] = tort_LFP_recreate_stone(dirname);

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

matfile = dir([dirname filesep '*.mat']);
Pre = []; Early =[]; Late =[]; 

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_mat = load(matfile(file).name);
    disp(['Working on file ' matfile(file).name]) %Displays working file
       
    %Obtain number of channels that recorded neurons from file
    structval = matfile(file).name(3:7); %Obtain variable for stucture
    channels = getfield(working_mat,structval);
    
    %Check struct to see if it loaded as a struct with fields (channels) or
    %as a struct with channelXtrialsXtime double. If struct...convert to
    %double and rearrange dimensions using permute, else, keep struct as is
    %and more to for loop
    type = numel([working_mat(:).(structval)]);
    
    if type < 20
       reshaped = permute((cell2mat(struct2cell(channels))),[3,1,2]);
       channels = length(channels);
    else
       reshaped =  channels;
       channels = length(channels(:,1,1));
    end
            
    for i=1:channels
             
        %Flip through trials
        for x=1:size(reshaped,2)
            LFP_array = squeeze(reshaped(i,x,:));
            
            %Run pwelch (Welch's power spectral density estimate) with specified parameters
            %Parameters
            srate = 1000; %uses sample sizes of of taste time as dps in length 
            overlap = []; %multiplied by a hamming window with 50% overlap
            dft_length = 8000; % using 8000 DFT points
            
            [PPre,F] = pwelch(LFP_array(251:750),length(251:750),[],dft_length,srate);
            [PEarly,F] = pwelch(LFP_array(1251:1750),length(251:750),[],dft_length,srate);
            [PLate,F] = pwelch(LFP_array(2251:2750),length(251:750),[],dft_length,srate);
            
            %Store in arrays
            Pre=[Pre;PPre'];
            Early=[Early;PEarly'];
            Late=[Late;PLate'];
                     
        end
    end
end

figure(2); plot(F,mean(Pre)/10^6,'b-'); hold on; plot(F,mean(Early)/10^6,'r-'); plot(F,mean(Late)/10^6,'k-');
xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)');


