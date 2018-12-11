function [test_out] = testing_decode_Stone(dirname)

%DIRNAME = directory name that files are located in 
%COMBINED_DATA = output struct of the combined raw LFP data from all files

matfile = dir([dirname filesep '*.txt']);

%Create structure for concatenating
combined_SS_test = struct;
    
%Prompt user to input number of trials in session for proper cutoff of
%data and alignment
prompt_1 = {'Set Trial Length:'}; dlg_title_1 = 'Set Trials in Testing Session:'; num_lines_1 = 1;
defaultans_1 = {'50'}; labels_1 = inputdlg(prompt_1,dlg_title_1,num_lines_1,defaultans_1); trials=str2num(labels_1{1}); 

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    
    %Open file and scan data using specified layout (%n = number, %c =
    %character, %s = string) starting at headerline
    fid = fopen(matfile(file).name); disp(['Working on file ' matfile(file).name]); %Displays working file
    data = textscan(fid,'%n %c %n %c %c %s %n %c %n %c %n %c %n %c %n %c %n %c %n','HeaderLines',11);
    
    %Grab headers to put into struct later
    fid = fopen(matfile(file).name); header_data = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s',11,'Delimiter',',');
    headers = [];
    for header=1:size(header_data,2)
        headers{end+1} = header_data{1,header}{11,1};
    end

    %grab the tastant info and convert to numbers
    tastes = ["Sucrose,","H2O,","H20,","NaCl,","QHCl,","Sacchrin,"]; num_var = ["1","2","2","3","4","5"]; 
    %conv_text = str2double(replace([data{1,6}(1:trials,:)],["Sucrose,","H2O,","H20,","NaCl,","QHCl,","Sacchrin,"],["1","2","2","3","4","5"]));
    conv_text = str2double(replace([data{1,6}(1:trials,:)],tastes,num_var));
     
    %create matrix of complete data
    full_data = horzcat(cell2mat(data(1,[1 3 7 9 11 13 15 17 19]))); full_data = full_data(1:trials,:); 
    full_data = horzcat(full_data(:,[1 2]),conv_text,full_data(:,[3 4 5 6 7 8 9]));
    
    %Create storying array and grab animal name
    animal = matfile(file).name(strfind((matfile(file).name),'SS'):strfind((matfile(file).name),'SS')+3);    
    if contains(animal,".")
        animal = animal(1:3);
    end
    
    %Place in structure under animal name
    combined_SS_test.([animal]).('data_headers') = headers(1,[1 2 4 5 6 7 8 9 10 11]);
    combined_SS_test.([animal]).('trial_data') = full_data;
    combined_SS_test.([animal]).('sessions_tastes_decode') = vertcat(tastes,num_var);
    
    %create variable for latency data
    lick_data = csvread(matfile(file).name,11,6); lick_data= lick_data(1:trials,1:2); %extract lick data
    working_data = csvread(matfile(file).name,62);  %extract latency data
    
    %establish trials animal licked in and create matching latency index
    lick_trials = lick_data(:,1)>0; lat_data = working_data;
    
    %cummulative sum up values for trials
    licks = lick_data(lick_trials(:),1);
    lat_start = lick_data(lick_trials(:),2);
    cum_sum_lat = cumsum(lat_data(lick_trials(:),:)');
    
    %clean up the cummulative file to reflect NaNs where latency count is
    %less than needed for given trial    
    for column=1:size(cum_sum_lat,2)
        start_max = cum_sum_lat(cum_sum_lat(:,column)<max(cum_sum_lat(:,column)));
        cum_sum_lat(length(start_max)+2:size(cum_sum_lat,1),column) = NaN;
    end
        
    %Place in structure under animal name
    combined_SS_test.([animal]).('licks_session') = lick_trials;
    combined_SS_test.([animal]).('licks_per_trial') = licks;
    combined_SS_test.([animal]).('lat_first_trial') = lat_start;
    combined_SS_test.([animal]).('cummulative_latency_trial') = cum_sum_lat'; %latenciesXtrials

end

test_out = combined_SS_test;