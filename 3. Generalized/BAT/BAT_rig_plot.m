%Ask user to go to directory that has all .txt files 
BAT_folder_name = uigetdir('','Choose folder where the .txt files are'); 

%Run habituation_decode on directory
[hab_out] = habituation_decode_Stone(BAT_folder_name);

%Grab fieldnames and flip through the data to obtain max trials
animals = fieldnames(hab_out);

lick_counts = []; lat_counts = []; sum_lick_sess = []; sum_lat_sess = [];
for animal=1:length(animals)
    lick_counts(end+1) = size(hab_out.(animals{animal}).licks_per_trial,1);
    sum_lick_sess(end+1) = sum(hab_out.(animals{animal}).licks_per_trial,1);
    lat_counts(end+1) = size(hab_out.(animals{animal}).cummulative_latency_trial,1);
    sum_lat_sess(end+1) = sum(hab_out.(animals{animal}).lat_first_trial,1);
end

%Create array based on maxes
lat_count_max = max(lat_counts); lick_count_max = max(lick_counts);
grand_array = zeros(lat_count_max,lick_count_max);
% 
% %Plot shit
% for animal=1:length(animals)
%     lick_counts(end+1) = size(hab_out.(animals{animal}).licks_per_trial,1);
%     lat_counts(end+1) = size(hab_out.(animals{animal}).cummulative_latency_trial,1);
% end