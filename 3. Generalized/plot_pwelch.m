%load file (change this accordingly)
pwelch_file = load('combined_pwelch_N=6 Animals.mat');

%Create session variables
for session=1:2
    
    switch session
        case 1
            data = pwelch_file.combined_pwelch.saline;
            plot_title = 'Saline';
        case 2
            data = pwelch_file.combined_pwelch.affective;
            plot_title = 'Affective';
    end
    
    %Plotting pre/early/late comparing 4 tastes
    figure(session); subplot(2,2,1); plot(data.F,mean(data.Pre1)/10^6,'b-'); hold on; plot(data.F,mean(data.Early1)/10^6,'r-'); plot(data.F,mean(data.Late1)/10^6,'k-');
    xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('NaCl');

    figure(session); subplot(2,2,2); plot(data.F,mean(data.Pre2)/10^6,'b-'); hold on; plot(data.F,mean(data.Early2)/10^6,'r-'); plot(data.F,mean(data.Late2)/10^6,'k-');
    xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('Sucrose');

    figure(session); subplot(2,2,3); plot(data.F,mean(data.Pre3)/10^6,'b-'); hold on; plot(data.F,mean(data.Early3)/10^6,'r-'); plot(data.F,mean(data.Late3)/10^6,'k-');
    xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('Citric Acid');

    figure(session); subplot(2,2,4); plot(data.F,mean(data.Pre4)/10^6,'b-'); hold on; plot(data.F,mean(data.Early4)/10^6,'r-'); plot(data.F,mean(data.Late4)/10^6,'k-');
    xlim([3 40]); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('QHCl');
       
    %Place title
    suptitle([plot_title]);
   
    %Plotting pre and post taste comparing 4 tastes
    figure(session+2); subplot(2,2,1); plot(data.F,mean(data.Pre1_1S)/10^6,':bs'); hold on; plot(data.F,mean(data.Post1_1S)/10^6,'-.k*');
    xlim([3 40]); legend('Pre-taste (-1000ms,0ms)','Post taste (0ms,1000ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('NaCl');

    figure(session+2); subplot(2,2,2); plot(data.F,mean(data.Pre2_1S)/10^6,':bs'); hold on; plot(data.F,mean(data.Post2_1S)/10^6,'-.k*');
    xlim([3 40]); legend('Pre-taste (-1000ms,0ms)','Post taste (0ms,1000ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('Sucrose');
    
    figure(session+2); subplot(2,2,3); plot(data.F,mean(data.Pre3_1S)/10^6,':bs'); hold on; plot(data.F,mean(data.Post3_1S)/10^6,'-.k*');
    xlim([3 40]); legend('Pre-taste (-1000ms,0ms)','Post taste (0ms,1000ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('Citric Acid');

    figure(session+2); subplot(2,2,4); plot(data.F,mean(data.Pre4_1S)/10^6,':bs'); hold on; plot(data.F,mean(data.Post4_1S)/10^6,'-.k*');
    xlim([3 40]); legend('Pre-taste (-1000ms,0ms)','Post taste (0ms,1000ms)','Location','northeast');
    xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); title('QHCl');
    
    %Place title
    suptitle([plot_title]);
    
end %end session loop

%set data variables for state-dependent plotting
sal_data = pwelch_file.combined_pwelch.saline; aff_data = pwelch_file.combined_pwelch.affective;

for taste =1:4
    
    %assign data to each taste 
    switch taste
        case 1
            sal_Pre = sal_data.Pre1; sal_Early = sal_data.Early1; sal_Late = sal_data.Late1; sal_Pre1S = sal_data.Pre1_1S; sal_Post1S = sal_data.Post1_1S;
            aff_Pre = aff_data.Pre1; aff_Early = aff_data.Early1; aff_Late = aff_data.Late1; aff_Pre1S = aff_data.Pre1_1S; aff_Post1S = aff_data.Post1_1S;           
            taste_label = 'NaCl';
        case 2
            sal_Pre = sal_data.Pre2; sal_Early = sal_data.Early2; sal_Late = sal_data.Late2; sal_Pre1S = sal_data.Pre2_1S; sal_Post1S = sal_data.Post2_1S;
            aff_Pre = aff_data.Pre2; aff_Early = aff_data.Early2; aff_Late = aff_data.Late2; aff_Pre1S = aff_data.Pre2_1S; aff_Post1S = aff_data.Post2_1S;
            taste_label = 'Sucrose';
        case 3
            sal_Pre = sal_data.Pre3; sal_Early = sal_data.Early3; sal_Late = sal_data.Late3; sal_Pre1S = sal_data.Pre3_1S; sal_Post1S = sal_data.Post3_1S;
            aff_Pre = aff_data.Pre3; aff_Early = aff_data.Early3; aff_Late = aff_data.Late3; aff_Pre1S = aff_data.Pre3_1S; aff_Post1S = aff_data.Post3_1S;
            taste_label = 'Citric Acid';
        case 4
            sal_Pre = sal_data.Pre4; sal_Early = sal_data.Early4; sal_Late = sal_data.Late4; sal_Pre1S = sal_data.Pre4_1S; sal_Post1S = sal_data.Post4_1S;
            aff_Pre = aff_data.Pre4; aff_Early = aff_data.Early4; aff_Late = aff_data.Late4; aff_Pre1S = aff_data.Pre4_1S; aff_Post1S = aff_data.Post4_1S;
            taste_label = 'QHCl';
    end
    
    %calculate confidence intervals around each spectral analysis (SEM =
    %standard error from mean; ts = T-score; CI = confidence intervals [pos
    %and neg])
    %CI for pre
    sal_SEM = std(sal_Pre)/sqrt(length(sal_Pre)); sal_ts = tinv([0.025 0.975],length(sal_Pre)-1); pre_sal_CI_neg = mean(sal_Pre)+sal_ts(1)*sal_SEM; pre_sal_CI_pos = mean(sal_Pre)+sal_ts(2)*sal_SEM;
    aff_SEM = std(aff_Pre)/sqrt(length(aff_Pre)); aff_ts = tinv([0.025 0.975],length(aff_Pre)-1); pre_aff_CI_neg = mean(aff_Pre)+sal_ts(1)*aff_SEM; pre_aff_CI_pos = mean(aff_Pre)+sal_ts(2)*aff_SEM;
    %CI for early
    sal_SEM = std(sal_Early)/sqrt(length(sal_Early)); sal_ts = tinv([0.025 0.975],length(sal_Early)-1); early_sal_CI_neg = mean(sal_Early)+sal_ts(1)*sal_SEM; early_sal_CI_pos = mean(sal_Early)+sal_ts(2)*sal_SEM;
    aff_SEM = std(aff_Early)/sqrt(length(aff_Early)); aff_ts = tinv([0.025 0.975],length(aff_Early)-1); early_aff_CI_neg = mean(aff_Early)+sal_ts(1)*aff_SEM; early_aff_CI_pos = mean(aff_Early)+sal_ts(2)*aff_SEM;
    %CI for late
    sal_SEM = std(sal_Late)/sqrt(length(sal_Late)); sal_ts = tinv([0.025 0.975],length(sal_Late)-1); late_sal_CI_neg = mean(sal_Late)+sal_ts(1)*sal_SEM; late_sal_CI_pos = mean(sal_Late)+sal_ts(2)*sal_SEM;
    aff_SEM = std(aff_Late)/sqrt(length(aff_Late)); aff_ts = tinv([0.025 0.975],length(aff_Late)-1); late_aff_CI_neg = mean(aff_Late)+sal_ts(1)*aff_SEM; late_aff_CI_pos = mean(aff_Late)+sal_ts(2)*aff_SEM;
    %CI for pre (1sec)
    sal_SEM = std(sal_Pre1S)/sqrt(length(sal_Pre1S)); sal_ts = tinv([0.025 0.975],length(sal_Pre1S)-1); pre1_sal_CI_neg = mean(sal_Pre1S)+sal_ts(1)*sal_SEM; pre1_sal_CI_pos = mean(sal_Pre1S)+sal_ts(2)*sal_SEM;
    aff_SEM = std(aff_Pre1S)/sqrt(length(aff_Pre1S)); aff_ts = tinv([0.025 0.975],length(aff_Pre1S)-1); pre1_aff_CI_neg = mean(aff_Pre1S)+sal_ts(1)*aff_SEM; pre1_aff_CI_pos = mean(aff_Pre1S)+sal_ts(2)*aff_SEM;
    %CI for post (1sec)
    sal_SEM = std(sal_Post1S)/sqrt(length(sal_Post1S)); sal_ts = tinv([0.025 0.975],length(sal_Post1S)-1); post1_sal_CI_neg = mean(sal_Post1S)+sal_ts(1)*sal_SEM; post1_sal_CI_pos = mean(sal_Post1S)+sal_ts(2)*sal_SEM;
    aff_SEM = std(aff_Post1S)/sqrt(length(aff_Post1S)); aff_ts = tinv([0.025 0.975],length(aff_Post1S)-1); post1_aff_CI_neg = mean(aff_Post1S)+sal_ts(1)*aff_SEM; post1_aff_CI_pos = mean(aff_Post1S)+sal_ts(2)*aff_SEM;

    
    %Plot pre (saline v. affective)
    figure(5); p(taste)= subplot(2,2,taste); plot(data.F,mean(sal_Pre)/10^6,'-b'); hold on; plot(data.F,mean(aff_Pre)/10^6,'g-');
    plot(data.F,pre_sal_CI_neg/10^6,'b--'); hold on; plot(data.F,pre_sal_CI_pos/10^6,'b--'); hold on; plot(data.F,pre_aff_CI_neg/10^6,'g--'); hold on; plot(data.F,pre_aff_CI_pos/10^6,'g--'); hold on;
    xlim([3 40]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); 
    legend('Saline','Affective','Location','northeast'); title([taste_label]);

    %Plot early (saline v. affective)
    figure(6); p(taste+4)= subplot(2,2,taste); plot(data.F,mean(sal_Early)/10^6,'-b'); hold on; plot(data.F,mean(aff_Early)/10^6,'g-');
    plot(data.F,early_sal_CI_neg/10^6,'b--'); hold on; plot(data.F,early_sal_CI_pos/10^6,'b--'); hold on; plot(data.F,early_aff_CI_neg/10^6,'g--'); hold on; plot(data.F,early_aff_CI_pos/10^6,'g--'); hold on;
    xlim([3 40]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); 
    legend('Saline','Affective','Location','northeast'); title([taste_label]); 

    %Plot Late (saline v. affective)
    figure(7); p(taste+8)= subplot(2,2,taste); plot(data.F,mean(sal_Late)/10^6,'-b'); hold on; plot(data.F,mean(aff_Late)/10^6,'g-');
    plot(data.F,late_sal_CI_neg/10^6,'b--'); hold on; plot(data.F,late_sal_CI_pos/10^6,'b--'); hold on; plot(data.F,late_aff_CI_neg/10^6,'g--'); hold on; plot(data.F,late_aff_CI_pos/10^6,'g--'); hold on;
    xlim([3 40]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); 
    legend('Saline','Affective','Location','northeast'); title([taste_label]); 

    %Plot Late (saline v. affective)
    figure(8); p(taste+12)= subplot(2,2,taste); plot(data.F,mean(sal_Pre1S)/10^6,'-b'); hold on; plot(data.F,mean(aff_Pre1S)/10^6,'g-');
    plot(data.F,pre1_sal_CI_neg/10^6,'b--'); hold on; plot(data.F,pre1_sal_CI_pos/10^6,'b--'); hold on; plot(data.F,pre1_aff_CI_neg/10^6,'g--'); hold on; plot(data.F,pre1_aff_CI_pos/10^6,'g--'); hold on;
    xlim([3 40]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); 
    legend('Saline','Affective','Location','northeast'); title([taste_label]); 

    %Plot Late (saline v. affective)
    figure(9); p(taste+16)= subplot(2,2,taste); plot(data.F,mean(sal_Post1S)/10^6,'-b'); hold on; plot(data.F,mean(aff_Post1S)/10^6,'g-');
    plot(data.F,post1_sal_CI_neg/10^6,'b--'); hold on; plot(data.F,post1_sal_CI_pos/10^6,'b--'); hold on; plot(data.F,post1_aff_CI_neg/10^6,'g--'); hold on; plot(data.F,post1_aff_CI_pos/10^6,'g--'); hold on;
    xlim([3 40]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); 
    legend('Saline','Affective','Location','northeast'); title([taste_label]); 
end

%label figures
figure(5); suptitle(['Pre-taste (-750ms,-250ms)']); figure(6); suptitle(['Early taste (250ms,750ms)']); figure(7); suptitle(['Late taste (1250ms,1750ms)']);
figure(8); suptitle(['Pre-Taste (1S prior)']); figure(9); suptitle(['Post-Taste (1S post)']);

%ask uniform scale values
prompt_3 = {'Figure 1: ', 'Figure 2: '}; dlg_title_3 = 'Set Scale:'; num_lines_3 = 2;
defaultans_3 = {'8','9'}; labels_3 = inputdlg(prompt_3,dlg_title_3,num_lines_3,defaultans_3);

scaling = [];
for scale_fig=1:length(labels_3)
    
    %assign variable for chosen figures
    selected_fig = str2num(labels_3{scale_fig});
    
    %access appropriate figure
    figure(selected_fig);
    
    %set subplot handle access number
    switch selected_fig
        case 5
            substart = 1; 
        case 6
            substart = 4; 
        case 7
            substart = 8; 
        case 8
            substart = 12;
        case 9
            substart = 16;
    end
    %assign axes
    for fig=1:4
        if substart ==1
            scaling = [scaling, axis(p(fig))'];
        else
            scaling = [scaling, axis(p(substart+fig))'];
        end
    end
end

%set scaling values
scaled_min = min(scaling(3,:)); scaled_max = max(scaling(4,:)); 

%scale figures
for scale_fig=1:length(labels_3)
    
    %assign variable for chosen figures
    selected_fig = str2num(labels_3{scale_fig});
    
    %access appropriate figure
    figure(selected_fig);
    
    %set subplot handle access number
    switch selected_fig
        case 5
            substart = 1; 
        case 6
            substart = 4; 
        case 7
            substart = 8; 
        case 8
            substart = 12;
        case 9
            substart = 16;
    end
    
    %assign axes
    for fig=1:4
        if substart ==1
            axis(p(fig),[3 40 scaled_min scaled_max]);
        else
            axis(p(substart+fig),[3 40 scaled_min scaled_max]);
        end
    end
end

