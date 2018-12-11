load('analysis_by_processing.mat')

avg_row = length(t_0_p_1(:,1));        
for i=1:length(t_0_p_1(1,:)),
    t_0_p_1(avg_row+1,i) = mean(t_0_p_1(1:length(t_0_p_1(:,1)),i));
end;
avg_row = length(t_0_p_2(:,1));        
for i=1:length(t_0_p_2(1,:)),
    t_0_p_2(avg_row+1,i) = mean(t_0_p_2(1:length(t_0_p_2(:,1)),i));
end;
avg_row = length(t_0_p_3(:,1));        
for i=1:length(t_0_p_3(1,:)),
    t_0_p_3(avg_row+1,i) = mean(t_0_p_3(1:length(t_0_p_3(:,1)),i));
end;
avg_row = length(t_0_p_4(:,1));        
for i=1:length(t_0_p_4(1,:)),
    t_0_p_4(avg_row+1,i) = mean(t_0_p_4(1:length(t_0_p_4(:,1)),i));
end;

avg_row = length(t_1_p_1(:,1));        
for i=1:length(t_1_p_1(1,:)),
    t_1_p_1(avg_row+1,i) = mean(t_1_p_1(1:length(t_1_p_1(:,1)),i));
end;
avg_row = length(t_1_p_2(:,1));        
for i=1:length(t_1_p_2(1,:)),
    t_1_p_2(avg_row+1,i) = mean(t_1_p_2(1:length(t_1_p_2(:,1)),i));
end;
avg_row = length(t_1_p_3(:,1));        
for i=1:length(t_1_p_3(1,:)),
    t_1_p_3(avg_row+1,i) = mean(t_1_p_3(1:length(t_1_p_3(:,1)),i));
end;
avg_row = length(t_1_p_4(:,1));        
for i=1:length(t_1_p_4(1,:)),
    t_1_p_4(avg_row+1,i) = mean(t_1_p_4(1:length(t_1_p_4(:,1)),i));
end;

avg_row = length(t_2_p_1(:,1));        
for i=1:length(t_2_p_1(1,:)),
    t_2_p_1(avg_row+1,i) = mean(t_2_p_1(1:length(t_2_p_1(:,1)),i));
end;
avg_row = length(t_2_p_2(:,1));        
for i=1:length(t_2_p_2(1,:)),
    t_2_p_2(avg_row+1,i) = mean(t_2_p_2(1:length(t_2_p_2(:,1)),i));
end;
avg_row = length(t_2_p_3(:,1));        
for i=1:length(t_2_p_3(1,:)),
    t_2_p_3(avg_row+1,i) = mean(t_2_p_3(1:length(t_2_p_3(:,1)),i));
end;
avg_row = length(t_2_p_4(:,1));        
for i=1:length(t_2_p_4(1,:)),
    t_2_p_4(avg_row+1,i) = mean(t_2_p_4(1:length(t_2_p_4(:,1)),i));
end;

avg_row = length(t_3_p_1(:,1));        
for i=1:length(t_3_p_1(1,:)),
    t_3_p_1(avg_row+1,i) = mean(t_3_p_1(1:length(t_3_p_1(:,1)),i));
end;
avg_row = length(t_3_p_2(:,1));        
for i=1:length(t_3_p_2(1,:)),
    t_3_p_2(avg_row+1,i) = mean(t_3_p_2(1:length(t_3_p_2(:,1)),i));
end;
avg_row = length(t_3_p_3(:,1));        
for i=1:length(t_3_p_3(1,:)),
    t_3_p_3(avg_row+1,i) = mean(t_3_p_3(1:length(t_3_p_3(:,1)),i));
end;
avg_row = length(t_3_p_4(:,1));        
for i=1:length(t_3_p_4(1,:)),
    t_3_p_4(avg_row+1,i) = mean(t_3_p_4(1:length(t_3_p_4(:,1)),i));
end;


%Plot



xmax = 10;
figure(1); subplot(2,2,1); hold on; plot(t_0_f_1,t_0_p_1(length(t_0_p_1(:,1)),:)); hold on; plot(t_0_f_2,t_0_p_2(length(t_0_p_2(:,1)),:));
hold on; plot(t_0_f_3,t_0_p_3(length(t_0_p_3(:,1)),:));hold on; plot(t_0_f_4,t_0_p_4(length(t_0_p_4(:,1)),:));
ymax = max([t_0_p_1(length(t_0_p_1(:,1)),:),t_0_p_2(length(t_0_p_2(:,1)),:),t_0_p_3(length(t_0_p_3(:,1)),:),t_0_p_4(length(t_0_p_4(:,1)),:)]); 
axis([0 xmax -1 ymax]); xlabel('Frequency (Hz)');ylabel('Power Spectral Density (mV^{2}/Hz)'); legend('0 - 0','500 - 0','500 - 700','500 - 1400','Location','northeast');
hold on; title('Diluted Sucrose');

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
