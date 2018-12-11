function [Pre1, Pre2, Pre3, Pre4, Early1, Early2, Early3, Early4, Late1, Late2, Late3, Late4, F] = katz_LFP_stone(dirname);

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

matfile = dir([dirname filesep '*_all_tastes_dur_*.mat']);
Pre1 = []; Pre2 = []; Pre3 = []; Pre4 = [];
Early1 =[]; Early2 = []; Early3 = []; Early4 =[];
Late1 =[]; Late2 = []; Late3 =[]; Late4 =[];

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_mat = load(matfile(file).name);
    disp(['Working on file ' matfile(file).name]) %Displays working file
    
    array_set = cell2mat(fieldnames(working_mat));
    trials = size(working_mat.(array_set)); 
    dur_num = str2num(array_set(end));

    %Flip through trials
    for x=1:trials(1);
        LFP_array = squeeze(working_mat.(array_set)(x,:));

        %Run pwelch (Welch's power spectral density estimate) with specified parameters
        %Parameters
        srate = 1000; %uses sample sizes of of taste time as dps in length 
        overlap = []; %multiplied by a hamming window with 50% overlap
        dft_length = 8000; % using 8000 DFT points

        %Assumes -2000ms/+5000ms in reference to stimulus onset
        [PPre,F] = pwelch(LFP_array(1251:1750),length(1251:1750),[],dft_length,srate);
        [PEarly,F] = pwelch(LFP_array(2251:2750),length(2251:2750),[],dft_length,srate);
        [PLate,F] = pwelch(LFP_array(3251:3750),length(3251:3750),[],dft_length,srate);

        %Store in arrays
        switch dur_num
            case 1
                Pre1=[Pre1;PPre'];
                Early1=[Early1;PEarly'];
                Late1=[Late1;PLate'];
            case 2
                Pre2=[Pre2;PPre'];
                Early2=[Early2;PEarly'];
                Late2=[Late2;PLate'];
            case 3
                Pre3=[Pre3;PPre'];
                Early3=[Early3;PEarly'];
                Late3=[Late3;PLate'];
            case 4
                Pre4=[Pre4;PPre'];
                Early4=[Early4;PEarly'];
                Late4=[Late4;PLate'];
        end
    end
end

figure(1); subplot(2,2,1); plot(F,mean(Pre1)/10^6,'b-'); hold on; plot(F,mean(Early1)/10^6,'r-'); plot(F,mean(Late1)/10^6,'k-');
xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('0 - 0');

figure(1); subplot(2,2,2); plot(F,mean(Pre2)/10^6,'b-'); hold on; plot(F,mean(Early2)/10^6,'r-'); plot(F,mean(Late2)/10^6,'k-');
xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('500 - 0');

figure(1); subplot(2,2,3); plot(F,mean(Pre3)/10^6,'b-'); hold on; plot(F,mean(Early3)/10^6,'r-'); plot(F,mean(Late3)/10^6,'k-');
xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('500 - 700');

figure(1); subplot(2,2,4); plot(F,mean(Pre4)/10^6,'b-'); hold on; plot(F,mean(Early4)/10^6,'r-'); plot(F,mean(Late4)/10^6,'k-');
xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('500 - 1400');


