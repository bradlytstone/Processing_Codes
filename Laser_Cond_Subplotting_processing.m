load('NM50_500ms_161029.mat')

%Average across pre
avg_row = length(pre_p_1(:,1));        
for i=1:length(pre_p_1(1,:)),
    pre_p_1(avg_row+1,i) = mean(pre_p_1(1:length(pre_p_1(:,1)),i));
end;
avg_row = length(pre_p_2(:,1));        
for i=1:length(pre_p_2(1,:)),
    pre_p_2(avg_row+1,i) = mean(pre_p_2(1:length(pre_p_2(:,1)),i));
end;
avg_row = length(pre_p_3(:,1));        
for i=1:length(pre_p_3(1,:)),
    pre_p_3(avg_row+1,i) = mean(pre_p_3(1:length(pre_p_3(:,1)),i));
end;
avg_row = length(pre_p_4(:,1));        
for i=1:length(pre_p_4(1,:)),
    pre_p_4(avg_row+1,i) = mean(pre_p_4(1:length(pre_p_4(:,1)),i));
end;

%Average across early
avg_row = length(early_p_1(:,1));        
for i=1:length(early_p_1(1,:)),
    early_p_1(avg_row+1,i) = mean(early_p_1(1:length(early_p_1(:,1)),i));
end;
avg_row = length(early_p_2(:,1));        
for i=1:length(early_p_2(1,:)),
    early_p_2(avg_row+1,i) = mean(early_p_2(1:length(early_p_2(:,1)),i));
end;
avg_row = length(early_p_3(:,1));        
for i=1:length(early_p_3(1,:)),
    early_p_3(avg_row+1,i) = mean(early_p_3(1:length(early_p_3(:,1)),i));
end;
avg_row = length(early_p_4(:,1));        
for i=1:length(early_p_4(1,:)),
    early_p_4(avg_row+1,i) = mean(early_p_4(1:length(early_p_4(:,1)),i));
end;

%Average across late
avg_row = length(late_p_1(:,1));        
for i=1:length(late_p_1(1,:)),
    late_p_1(avg_row+1,i) = mean(late_p_1(1:length(late_p_1(:,1)),i));
end;
avg_row = length(late_p_2(:,1));        
for i=1:length(late_p_2(1,:)),
    late_p_2(avg_row+1,i) = mean(late_p_2(1:length(late_p_2(:,1)),i));
end;
avg_row = length(late_p_3(:,1));        
for i=1:length(late_p_3(1,:)),
    late_p_3(avg_row+1,i) = mean(late_p_3(1:length(late_p_3(:,1)),i));
end;
avg_row = length(late_p_4(:,1));        
for i=1:length(late_p_4(1,:)),
    late_p_4(avg_row+1,i) = mean(late_p_4(1:length(late_p_4(:,1)),i));
end;


%Plotting

xmax = 15;
figure(1); subplot(2,2,1); hold on; plot(pre_f_1,pre_p_1(length(pre_p_1(:,1)),:),'b'); hold on; plot(early_f_1,early_p_1(length(early_p_1(:,1)),:),'r');
hold on; plot(late_f_1,late_p_1(length(late_p_1(:,1)),:),'k');hold on; ymax = max([pre_p_1(length(pre_p_1(:,1)),:),early_p_1(length(early_p_1(:,1)),:),late_p_1(length(late_p_1(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
hold on; title('0 - 0');

xmax = 15;
figure(1); subplot(2,2,2); hold on; plot(pre_f_2,pre_p_2(length(pre_p_2(:,1)),:),'b'); hold on; plot(early_f_2,early_p_2(length(early_p_2(:,1)),:),'r');
hold on; plot(late_f_2,late_p_2(length(late_p_2(:,1)),:),'k');hold on; ymax = max([pre_p_2(length(pre_p_2(:,1)),:),early_p_2(length(early_p_2(:,1)),:),late_p_2(length(late_p_2(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
hold on; title('500 - 0');

xmax = 15;
figure(1); subplot(2,2,3); hold on; plot(pre_f_3,pre_p_3(length(pre_p_3(:,1)),:),'b'); hold on; plot(early_f_3,early_p_3(length(early_p_3(:,1)),:),'r');
hold on; plot(late_f_3,late_p_3(length(late_p_3(:,1)),:),'k');hold on; ymax = max([pre_p_3(length(pre_p_3(:,1)),:),early_p_3(length(early_p_3(:,1)),:),late_p_3(length(late_p_3(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
hold on; title('500 - 700');

xmax = 15;
figure(1); subplot(2,2,4); hold on; plot(pre_f_4,pre_p_4(length(pre_p_4(:,1)),:),'b'); hold on; plot(early_f_4,early_p_4(length(early_p_4(:,1)),:),'r');
hold on; plot(late_f_4,late_p_4(length(late_p_4(:,1)),:),'k');hold on; ymax = max([pre_p_4(length(pre_p_4(:,1)),:),early_p_4(length(early_p_4(:,1)),:),late_p_4(length(late_p_4(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); legend('Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast');
hold on; title('500 - 1400');


%Plotting with smoothing spline
pre_0_0_avg = pre_p_1(33,:); pre_fit_0_0 = fit(pre_f_1.',pre_0_0_avg.','smoothingspline'); early_0_0_avg = early_p_1(33:); early_fit_0_0 = fit(early_f_1.',early_0_0_avg.','smoothingspline');
late_0_0_avg = late_p_1(33,:); late_fit_0_0 = fit(late_f_1.',late_0_0_avg.','smoothingspline');
figure(2); subplot(2,2,1); hold on; p1 = plot(pre_fit_0_0,pre_f_1,pre_p_1(length(pre_p_1(:,1)),:),'b'); hold on; p2 = plot(early_fit_0_0,early_f_1,early_p_1(length(early_p_1(:,1)),:),'r'); hold on; p3= plot(late_fit_0_0,late_f_1,late_p_1(length(late_p_1(:,1)),:),'k');
hold on; ymax = max([pre_p_1(length(pre_p_1(:,1)),:),early_p_1(length(early_p_1(:,1)),:),late_p_1(length(late_p_1(:,1)),:)]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); axis([0 xmax -1 ymax]); hold on; title('0 - 0'); hold on;
hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

pre_500_0_avg = pre_p_2(33,:); pre_fit_500_0 = fit(pre_f_2.',pre_500_0_avg.','smoothingspline'); early_500_0_avg = early_p_2(33,:); early_fit_500_0 = fit(early_f_2.',early_500_0_avg.','smoothingspline');
late_500_0_avg = late_p_2(33,:); late_fit_500_0 = fit(late_f_2.',late_500_0_avg.','smoothingspline');
figure(2); subplot(2,2,2); hold on; p1 = plot(pre_fit_500_0,pre_f_2,pre_p_2(length(pre_p_2(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_0,early_f_2,early_p_2(length(early_p_2(:,1)),:),'r'); hold on; p3 = plot(late_fit_500_0,late_f_2,late_p_2(length(late_p_2(:,1)),:),'k');
hold on; ymax = max([pre_p_2(length(pre_p_2(:,1)),:),early_p_2(length(early_p_2(:,1)),:),late_p_2(length(late_p_2(:,1)),:)]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); axis([0 xmax -1 ymax]); hold on; title('500 - 0'); hold on;
hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

pre_500_700_avg = pre_p_3(33,:); pre_fit_500_700 = fit(pre_f_3.',pre_500_700_avg.','smoothingspline'); early_500_700_avg = early_p_3(33,:); early_fit_500_700 = fit(early_f_3.',early_500_700_avg.','smoothingspline');
late_500_700_avg = late_p_3(33,:); late_fit_500_700 = fit(late_f_3.',late_500_700_avg.','smoothingspline');
figure(2); subplot(2,2,3); hold on; p1 = plot(pre_fit_500_700,pre_f_3,pre_p_3(length(pre_p_3(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_700,early_f_3,early_p_3(length(early_p_3(:,1)),:),'r'); hold on; p3 = plot(late_fit_500_700,late_f_3,late_p_3(length(late_p_3(:,1)),:),'k');
hold on; ymax = max([pre_p_3(length(pre_p_3(:,1)),:),early_p_3(length(early_p_3(:,1)),:),late_p_3(length(late_p_3(:,1)),:)]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); axis([0 xmax -1 ymax]); hold on; title('500 - 700'); hold on;
hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

pre_500_1400_avg = pre_p_4(33,:); pre_fit_500_1400 = fit(pre_f_4.',pre_500_1400_avg.','smoothingspline'); early_500_1400_avg = early_p_4(33,:); early_fit_500_1400 = fit(early_f_4.',early_500_1400_avg.','smoothingspline');
late_500_1400_avg = late_p_4(33,:); late_fit_500_1400 = fit(late_f_4.',late_500_1400_avg.','smoothingspline');
figure(2); subplot(2,2,4); hold on; p1 = plot(pre_fit_500_1400,pre_f_4,pre_p_4(length(pre_p_4(:,1)),:),'b'); hold on; p2 = plot(early_fit_500_1400,early_f_4,early_p_4(length(early_p_4(:,1)),:),'r'); hold on; p3 = plot(late_fit_500_1400,late_f_4,late_p_4(length(late_p_4(:,1)),:),'k');
hold on; ymax = max([pre_p_4(length(pre_p_4(:,1)),:),early_p_4(length(early_p_4(:,1)),:),late_p_4(length(late_p_4(:,1)),:)]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (V^{2}/Hz)'); axis([0 xmax -1 ymax]); hold on; title('500 - 1400');
hLines = findobj(gca); hLines(1).Color= 'white'; hLines(2).Color = 'black';hLines(3).Color = [0,0,0,0];hLines(4).Color = 'red';hLines(5).Color = [0,0,0,0];hLines(6).Color = 'blue'; hLines(7).Color = [0,0,0,0]; hold on;
legend([p1(2), p2(2), p3(2)],'Pre-taste (-750ms,-250ms)','Early taste (250ms,750ms)','Late taste (1250ms,1750ms)','Location','northeast')

%%%
figure(1); subplot(2,2,2); hold on; plot(t_1_f_1,t_1_p_1(length(t_1_p_1(:,1)),:)); hold on; plot(t_1_f_2,t_1_p_2(length(t_1_p_2(:,1)),:));
hold on; plot(t_1_f_3,t_1_p_3(length(t_1_p_3(:,1)),:));hold on; plot(t_1_f_4,t_1_p_4(length(t_1_p_4(:,1)),:));
ymax = max([t_1_p_1(length(t_1_p_1(:,1)),:),t_1_p_2(length(t_1_p_2(:,1)),:),t_1_p_3(length(t_1_p_3(:,1)),:),t_1_p_4(length(t_1_p_4(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('0 - 0','500 - 0','500 - 700','500 - 1400','Location','northeast');
hold on; title('Concentrated Sucrose');

figure(1); subplot(2,2,3); hold on; plot(t_2_f_1,t_2_p_1(length(t_2_p_1(:,1)),:)); hold on; plot(t_2_f_2,t_2_p_2(length(t_2_p_2(:,1)),:));
hold on; plot(t_2_f_3,t_2_p_3(length(t_2_p_3(:,1)),:));hold on; plot(t_2_f_4,t_2_p_4(length(t_2_p_4(:,1)),:));
ymax = max([t_2_p_1(length(t_2_p_1(:,1)),:),t_2_p_2(length(t_2_p_2(:,1)),:),t_2_p_3(length(t_2_p_3(:,1)),:),t_2_p_4(length(t_2_p_4(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('0 - 0','500 - 0','500 - 700','500 - 1400','Location','northeast');
hold on; title('Diluted Quinine');

figure(1); subplot(2,2,4); hold on; plot(t_3_f_1,t_3_p_1(length(t_3_p_1(:,1)),:)); hold on; plot(t_3_f_2,t_3_p_2(length(t_3_p_2(:,1)),:));
hold on; plot(t_3_f_3,t_3_p_3(length(t_3_p_3(:,1)),:));hold on; plot(t_3_f_4,t_3_p_4(length(t_3_p_4(:,1)),:));
ymax = max([t_3_p_1(length(t_3_p_1(:,1)),:),t_3_p_2(length(t_3_p_2(:,1)),:),t_3_p_3(length(t_3_p_3(:,1)),:),t_3_p_4(length(t_3_p_4(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('0 - 0','500 - 0','500 - 700','500 - 1400','Location','northeast');
hold on; title('Concentrated Quinine');
%%%
