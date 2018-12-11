function [hab_out] = habituation_decode_Stone(dirname)

%DIRNAME = directory name that files are located in 
%COMBINED_DATA = output struct of the combined raw LFP data from all files

matfile = dir([dirname filesep '*.txt']);

%Create structure for concatenating
combined_SS_hab = struct;

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_data = csvread(matfile(file).name,11);  %starts with data
    disp(['Working on file ' matfile(file).name]); %Displays working file
    
    %Create storying array and grab animal name
    animal = matfile(file).name(strfind((matfile(file).name),'SS'):strfind((matfile(file).name),'SS')+3);    
    if contains(animal,".")
        animal = animal(1:3);
    end
    
    %establish trials animal licked in and create matching latency index
    trials = working_data(:,7); lick_trials = trials>0; lat_data = working_data(251:500,:);
    
    %cummulative sum up values for trials
    licks = working_data(lick_trials(1:250),7);
    lat_start = working_data(lick_trials(1:250),8);
    cum_sum_lat = cumsum(lat_data(lick_trials(251:500),:)');
    
    %clean up the cummulative file to reflect NaNs where latency count is
    %less than needed for given trial    
    for column=1:size(cum_sum_lat,2)
        start_max = cum_sum_lat(cum_sum_lat(:,column)<max(cum_sum_lat(:,column)));
        cum_sum_lat(length(start_max)+2:size(cum_sum_lat,1),column) = NaN;
    end
        
    %Place in structure under animal name
    combined_SS_hab.([animal]).('licks_per_trial') = licks;
    combined_SS_hab.([animal]).('lat_first_trial') = lat_start;
    combined_SS_hab.([animal]).('cummulative_latency_trial') = cum_sum_lat; %latenciesXtrials

end

hab_out = combined_SS_hab;