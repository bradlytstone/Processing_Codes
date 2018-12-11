[PP1, PP2, PP3, PP4, EP1, EP2, EP3, EP4, LP1, LP2, LP3, LP4, Freq] = compileFFTarrays('/home/bradly/drive2/Data');

%Average across pre
avg_row = length(PP1(:,1));        
for i=1:length(PP1(1,:))
    PP1(avg_row+1,i) = mean(PP1(1:length(PP1(:,1)),i));
end
avg_row = length(PP2(:,1));        
for i=1:length(PP2(1,:))
    PP2(avg_row+1,i) = mean(PP2(1:length(PP2(:,1)),i));
end
avg_row = length(PP3(:,1));        
for i=1:length(PP3(1,:))
    PP3(avg_row+1,i) = mean(PP3(1:length(PP3(:,1)),i));
end
avg_row = length(PP4(:,1));        
for i=1:length(PP4(1,:))
    PP4(avg_row+1,i) = mean(PP4(1:length(PP4(:,1)),i));
end

%Average across early
avg_row = length(EP1(:,1));        
for i=1:length(EP1(1,:))
    EP1(avg_row+1,i) = mean(EP1(1:length(EP1(:,1)),i));
end
avg_row = length(EP2(:,1));        
for i=1:length(EP2(1,:))
    EP2(avg_row+1,i) = mean(EP2(1:length(EP2(:,1)),i));
end
avg_row = length(EP3(:,1));        
for i=1:length(EP3(1,:))
    EP3(avg_row+1,i) = mean(EP3(1:length(EP3(:,1)),i));
end;
avg_row = length(EP4(:,1));        
for i=1:length(EP4(1,:))
    EP4(avg_row+1,i) = mean(EP4(1:length(EP4(:,1)),i));
end

%Average across late
avg_row = length(LP1(:,1));        
for i=1:length(LP1(1,:))
    LP1(avg_row+1,i) = mean(LP1(1:length(LP1(:,1)),i));
end
avg_row = length(LP2(:,1));        
for i=1:length(LP2(1,:))
    LP2(avg_row+1,i) = mean(LP2(1:length(LP2(:,1)),i));
end
avg_row = length(LP3(:,1));        
for i=1:length(LP3(1,:))
    LP3(avg_row+1,i) = mean(LP3(1:length(LP3(:,1)),i));
end
avg_row = length(LP4(:,1));        
for i=1:length(LP4(1,:))
    LP4(avg_row+1,i) = mean(LP4(1:length(LP4(:,1)),i));
end

%Plotting
% Construct a questdlg with three options
choice = questdlg('Would you like to plot the raw data?', ...
'Raw Data Plotting','No');

% Handle response
switch choice
case 'Yes'
    xmax = inputdlg('Enter desired maximum value for X-axis:',...
                 'X-Maximum'); xmax = str2num(xmax{:});
    figure(1); subplot(2,2,1); hold on; plot(Freq.',PP1(length(PP1(:,1)),:)/10^6,'b'); hold on; plot(Freq.',EP1(length(EP1(:,1)),:)/10^6,'r');
    hold on; plot(Freq.',LP1(length(LP1(:,1)),:)/10^6,'k');hold on; ymax = max([PP1(length(PP1(:,1)),:)/10^6,EP1(length(EP1(:,1)),:)/10^6,LP1(length(LP1(:,1)),:)/10^6]); 
    axis([0 xmax 0 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    hold on; title('0 - 0');

    figure(1); subplot(2,2,2); hold on; plot(Freq.',PP2(length(PP2(:,1)),:)/10^6,'b'); hold on; plot(Freq.',EP2(length(EP2(:,1)),:)/10^6,'r');
    hold on; plot(Freq.',LP2(length(LP2(:,1)),:)/10^6,'k');hold on; ymax = max([PP2(length(PP2(:,1)),:)/10^6,EP2(length(EP2(:,1)),:)/10^6,LP2(length(LP2(:,1)),:)/10^6]); 
    axis([0 xmax 0 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    hold on; title('900 - 0');

    figure(1); subplot(2,2,3); hold on; plot(Freq.',PP3(length(PP3(:,1)),:)/10^6,'b'); hold on; plot(Freq.',EP3(length(EP3(:,1)),:)/10^6,'r');
    hold on; plot(Freq.',LP3(length(LP3(:,1)),:)/10^6,'k');hold on; ymax = max([PP3(length(PP3(:,1)),:)/10^6,EP3(length(EP3(:,1)),:)/10^6,LP3(length(LP3(:,1)),:)/10^6]); 
    axis([0 xmax 0 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    hold on; title('900 - 700');

    figure(1); subplot(2,2,4); hold on; plot(Freq.',PP4(length(PP4(:,1)),:)/10^6,'b'); hold on; plot(Freq.',EP4(length(EP4(:,1)),:)/10^6,'r');
    hold on; plot(Freq.',LP4(length(LP4(:,1)),:)/10^6,'k');hold on; ymax = max([PP4(length(PP4(:,1)),:)/10^6,EP4(length(EP4(:,1)),:)/10^6,LP4(length(LP4(:,1)),:)/10^6]); 
    axis([0 xmax 0 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
    hold on; title('900 - 1400');
    
case 'No'   
    disp('You are plotting data with a smoothing spline');
    %Plotting with smoothing spline
    xmax =inputdlg('Enter desired maximum value for X-axis:',...
                 'X-Maximum'); xmax = str2num(xmax{:});
    pre_0_0_avg = PP1(length(PP1(:,1)),:)/10^6; pre_fit_0_0 = fit(Freq.',pre_0_0_avg.','smoothingspline'); early_0_0_avg = EP1(length(EP1(:,1)),:)/10^6; early_fit_0_0 = fit(Freq.',early_0_0_avg.','smoothingspline');
    late_0_0_avg = LP1(length(LP1(:,1)),:)/10^6; late_fit_0_0 = fit(Freq.',late_0_0_avg.','smoothingspline');
    figure(2); subplot(2,2,1); hold on; p1 = plot(pre_fit_0_0,Freq,PP1(length(PP1(:,1)),:),'b'); hold on; p2 = plot(early_fit_0_0,Freq,EP1(length(EP1(:,1)),:),'r'); hold on; p3= plot(late_fit_0_0,Freq,LP1(length(LP1(:,1)),:),'k');
    hold on; ymax = max([PP1(length(PP1(:,1)),:)/10^6,EP1(length(EP1(:,1)),:)/10^6,LP1(length(LP1(:,1)),:)/10^6]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); axis([0 xmax 0 ymax]); hold on; title('0 - 0'); hold on;
    hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
    legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

    pre_500_0_avg = PP2(length(PP2(:,1)),:)/10^6; pre_fit_500_0 = fit(Freq.',pre_500_0_avg.','smoothingspline'); early_500_0_avg = EP2(length(EP2(:,1)),:)/10^6; early_fit_500_0 = fit(Freq.',early_500_0_avg.','smoothingspline');
    late_500_0_avg = LP2(length(LP2(:,1)),:)/10^6; late_fit_500_0 = fit(Freq.',late_500_0_avg.','smoothingspline');
    figure(2); subplot(2,2,2); hold on; p1 = plot(pre_fit_500_0,Freq,PP2(length(PP2(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_0,Freq,EP2(length(EP2(:,1)),:),'r'); hold on; p3= plot(late_fit_500_0,Freq,LP2(length(LP2(:,1)),:),'k');
    hold on; ymax = max([PP2(length(PP2(:,1)),:)/10^6,EP2(length(EP2(:,1)),:)/10^6,LP2(length(LP2(:,1)),:)/10^6]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); axis([0 xmax 0 ymax]); hold on; title('500 - 0'); hold on;
    hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
    legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

    pre_500_700_avg = PP3(length(PP3(:,1)),:)/10^6; pre_fit_500_700 = fit(Freq.',pre_500_700_avg.','smoothingspline'); early_500_700_avg = EP3(length(EP3(:,1)),:)/10^6; early_fit_500_700 = fit(Freq.',early_500_700_avg.','smoothingspline');
    late_500_700_avg = LP3(length(LP3(:,1)),:)/10^6; late_fit_500_700 = fit(Freq.',late_500_700_avg.','smoothingspline');
    figure(2); subplot(2,2,3); hold on; p1 = plot(pre_fit_500_700,Freq,PP3(length(PP3(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_700,Freq,EP3(length(EP3(:,1)),:),'r'); hold on; p3= plot(late_fit_500_700,Freq,LP3(length(LP3(:,1)),:),'k');
    hold on; ymax = max([PP3(length(PP3(:,1)),:)/10^6,EP3(length(EP3(:,1)),:)/10^6,LP3(length(LP3(:,1)),:)/10^6]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); axis([0 xmax 0 ymax]); hold on; title('500 - 700'); hold on;
    hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
    legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

    pre_500_1400_avg = PP4(length(PP4(:,1)),:)/10^6; pre_fit_500_1400 = fit(Freq.',pre_500_1400_avg.','smoothingspline'); early_500_1400_avg = EP4(length(EP4(:,1)),:)/10^6; early_fit_500_1400 = fit(Freq.',early_500_1400_avg.','smoothingspline');
    late_500_1400_avg = LP4(length(LP4(:,1)),:)/10^6; late_fit_500_1400 = fit(Freq.',late_500_1400_avg.','smoothingspline');
    figure(2); subplot(2,2,4); hold on; p1 = plot(pre_fit_500_1400,Freq,PP4(length(PP4(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_1400,Freq,EP4(length(EP4(:,1)),:),'r'); hold on; p3= plot(late_fit_500_1400,Freq,LP4(length(LP4(:,1)),:),'k');
    hold on; ymax = max([PP4(length(PP4(:,1)),:)/10^6,EP4(length(EP4(:,1)),:)/10^6,LP4(length(LP4(:,1)),:)/10^6]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); axis([0 xmax 0 ymax]); hold on; title('500 - 1400'); hold on;
    hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
    legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')
end