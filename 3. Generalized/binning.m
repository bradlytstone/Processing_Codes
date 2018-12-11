file_load = load('BS23 _Combined_passive.mat'); sessions = size(fieldnames(file_load.combined_data),1);

for x=1:sessions    
        
        initial_array_names = fieldnames(file_load.combined_data);data_array = file_load.combined_data.(initial_array_names{x});
        secondary_names = fieldnames(data_array); data_array = file_load.combined_data.(initial_array_names{x}).(secondary_names{1});

        data_array = squeeze(data_array(1,:,:,:));
        sizes = size(data_array); big_bin_dur = 300000; small_bin_dur =5000;
        minute_array=zeros(size(data_array,2)/big_bin_dur,size(data_array,1));

        jump =0; bin_struct = struct;
        for i=1:size(data_array,2)/big_bin_dur
            bin_struct.(['bin_' num2str(i)]) = data_array(:,jump+1:big_bin_dur*i);
            jump = big_bin_dur*i;
        end

        new_struct = struct;
        for i=1:size(data_array,2)/big_bin_dur
            for channel=1:size(data_array,1)
                new_struct.(['bin_' num2str(i)]).(['channel_' num2str(channel)]) = reshape([bin_struct.(['bin_' num2str(i)])(channel,:),nan(1,small_bin_dur-mod(numel(bin_struct.(['bin_' num2str(i)])(channel,:)),small_bin_dur))],small_bin_dur,[])';
                new_struct.(['bin_' num2str(i)]).(['channel_' num2str(channel)])(isnan(new_struct.(['bin_' num2str(i)]).(['channel_' num2str(channel)]))) = [];
                new_struct.(['bin_' num2str(i)]).(['channel_' num2str(channel)]) = reshape(new_struct.(['bin_' num2str(i)]).(['channel_' num2str(channel)]), big_bin_dur/small_bin_dur ,small_bin_dur);
            end
        end
        
         Fs = 1000;              %Sampling frequency in Hz.
         sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
         fmin = 3; fmax = 20;    %set cutoffs for frequencies to look at
         tmin = 0;               %set time window to look at
       
         s_window = 500;         %assigns window criteria to divide the signal (length you input) into segments of this size
         s_overlap = 450;        %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
         meanfact=(big_bin_dur/small_bin_dur)* size(data_array,1); %calculate denominator; pseudo-trials*channels
            
        
        for large_bins=1:size(data_array,2)/big_bin_dur
            MeanP=zeros(8193,91);     %Create array for mean power (column length dictated by window/overlap), second number is based on 5000ms binning;
            
            for channel=1:size(data_array,1)
                for pseudo_trial=1:big_bin_dur/small_bin_dur
                    signal = squeeze(new_struct.(['bin_' num2str(large_bins)]).(['channel_' num2str(channel)])(pseudo_trial,:));
                    [S, F, T, P] = spectrogram(detrend(signal), s_window, s_overlap, sig_length, Fs);
                    good = find(F < fmax);
                    MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials*channels

                    good = find(F < fmax);
                    good = intersect(good,find(F > fmin));
                    Tgood = find(T > tmin);
                end
            end
            power_spec = figure(large_bins); subplot(2,1,x); hold on; imagesc(T(Tgood),F(good),(MeanP(good,Tgood)/10^6));  axis xy; colorbar; 
        end
end

