%This script (after initiating) requires you to select a directory that has
%the 'combined_spec_data.mat' file (obtained from running
%'katz_LFP_stone_spec_affective.m) and ouputs a figure with the affective
%data in subplot 1, and saline data in subplot 2. Script saves a pdf output
%into the directory that you selected to run script on.

% data1 = struct('drug_sess',check.affective); data2 = struct('saline_sess',check.saline);
% combined_data = struct('affective',data1,'saline',data2);
% save('combined_spec_data.mat','combined_data','-v7.3');

%load grand mean file
combined_folder_name = uigetdir('','Choose folder where the .mat file is'); 
combined_file = dir([combined_folder_name filesep 'combined_spec_data.mat']); 
full_struct = load(combined_file.name); 

%Create subdirectory
subdirs = dir(combined_folder_name); subdirs(~[subdirs.isdir]) = [];

%Filter out the parent and current directory
tf = ismember( {subdirs.name}, {'.', '..'}); subdirs(tf) = []; 
num_folders = length(subdirs);

%For plot labeling
GM_number = (['N = ' num2str(num_folders) ' Animals']);

% Construct a Question Dialog Box with 2 options data finding
data_type = questdlg('Are you looking at Taste data or Passive data?', ...
	'Plotting Menu', ...
	'Taste','Passive', 'Maybe'); %make sure do figure out this for tastes

switch data_type
    %grab data info
    case 'Passive'
        aff_data = full_struct.combined_data.affective.drug_sess;
        sal_data = full_struct.combined_data.saline.saline_sess;
    case 'Taste'
        aff_data = full_struct.combined_spec_data.affective;
        sal_data = full_struct.combined_spec_data.saline;
end

%Plot settings
fmin = 3; fmax = 20;
prompt_4 = {'Set Scale:', 'Cells in affective state:', 'Cells in saline state'}; dlg_title_4 = 'Scale using binned scale:'; num_lines_4 = 3;
defaultans_4 = {'1*10^-3', '126' ,'113'}; labels_4 = inputdlg(prompt_4,dlg_title_4,num_lines_4,defaultans_4); min_cscale=str2num(labels_4{1}); 

%Plot
figure(1); ax1 = axes('Position',[0 0 1 1],'Visible','off');

switch data_type
    case 'Passive'
        figure(1); subplot(2,1,1); hold on; imagesc(aff_data.T(aff_data.Tgood),aff_data.F(aff_data.Good),(aff_data.MeanP(aff_data.Good,aff_data.Tgood)/10^6));  axis xy; colorbar; title('Affective State = LiCl');
        figure(1); subplot(2,1,2); hold on; imagesc(sal_data.T(sal_data.Tgood),sal_data.F(sal_data.Good),(sal_data.MeanP(sal_data.Good,sal_data.Tgood)/10^6));  axis xy; colorbar; title('Affective State = Healthy');
    case 'Taste'
         figure(1); subplot(2,1,1); hold on; imagesc(aff_data.T(aff_data.Tgood)-1,aff_data.F(aff_data.Good),(aff_data.MeanNormP(aff_data.Good,aff_data.Tgood)));  axis xy; colorbar; title('Affective State = LiCl');
         figure(1); subplot(2,1,2); hold on; imagesc(sal_data.T(sal_data.Tgood)-1,sal_data.F(sal_data.Good),(sal_data.MeanNormP(sal_data.Good,sal_data.Tgood)));  axis xy; colorbar; title('Affective State = Healthy');
end
for sub=1:2
    subplot(2,1,sub); 
    ylim([fmin fmax]);  caxis([0 min_cscale]); h = colorbar; ylabel(h,'Power (z-score)'); colormap('jet');hold on;
    switch data_type
        case 'Passive'
            xticks([0:60:1200]); hold on; xticklabels([0:1:20]); xlim([0 1200]);xlabel('Time [min]');
        case 'Taste'
            xticks([-1 0 1 2 3 4 5 6]); xticklabels([-2 -1 0 1 2 3 4 5]); hold on; xlim([-0.75 5.75]);
    end        
    descr = {'Cell count:'; labels_4{sub+1};};text(-1,21.65,descr,'Color','blue','FontWeight','bold' );
end

%Save
figure(1);  suptitle([GM_number]); h=gcf; set(h, 'PaperPositionMode', 'manual'); set(h, 'PaperUnits', 'inches');
set(h, 'PaperPosition', [1 1 8 7]); set(h,'PaperOrientation','landscape');
default_save_dir = {combined_folder_name,filesep};
full_location = join([default_save_dir{1},default_save_dir{2}]);
name = [GM_number '_spectral_analysis_0ms_7000ms.pdf'];
save_spot = fullfile(full_location, name); print(h, save_spot,'-dpdf', '-r0');
            
