function [p_spec_aff, p_spec_sal] = full_passive_stone(file_load, num_sessions, freq_max, freq_min);

for x=1:num_sessions    
        
    initial_array_names = fieldnames(file_load.combined_data);data_array = file_load.combined_data.(initial_array_names{x});
    secondary_names = fieldnames(data_array); data_array = file_load.combined_data.(initial_array_names{x}).(secondary_names{1});

    data_array = squeeze(data_array(1,:,:,:));
    sizes = size(data_array); 

    if sizes(1) > 1
        
        new_struct = struct;
        for channel=1:size(data_array,1)
                new_struct.(['channel_' num2str(channel)]) = data_array(channel,:);
        end

         meanfact= size(data_array,1); %calculate denominator = channels because only 1 trial per channel
    else

        F = fieldnames(data_array);
        for channel=1:length(F)
            newName = ['channel_' num2str(channel)];
            oldName = char(F(channel));
            [data_array.(newName)] = data_array.(oldName);
            data_array = rmfield(data_array,oldName);
        end
        new_struct = data_array;

        meanfact= length(F); %calculate denominator = channels because only 1 trial per channel
    end

    if x ==1
        affective_struct = new_struct;
    else
        saline_struct = new_struct;
    end

    Fs = 1000;              %Sampling frequency in Hz.
    sig_length = 2.^14;     %denotes signal length (16384 samples ? N samples) with (128 samples ? ?N / 128? samples = segment length)
    fmin = freq_min; fmax = freq_max;    %set cutoffs for frequencies to look at
    tmin = 0;               %set time window to look at

    s_window = 500;                     %assigns window criteria to divide the signal (length you input) into segments of this size
    s_overlap = 450;                    %multiplied by a hamming window with 90% overlap (90% of s_window means ~ 14776 points are considered (0.9 x 16384). This is the number of common points used in two consecutive FFT. It is used to smooth the spectrogram.)
    max_pow = (1200000-s_overlap)/(s_window-s_overlap)   %find the # of time points to calculate the maximum of the power spectral density 

    MeanP=zeros(8193,max_pow);     %Create array for mean power (column length dictated by window/overlap), second number is based on 5000ms binning;

    for channel=1:length(fieldnames(new_struct))
        disp(['Analyzing channel ' num2str(channel) ' of ' num2str(length(fieldnames(new_struct))) '...']);
        signal = new_struct.(['channel_' num2str(channel)])(1,:);
        [S, F, T, P] = spectrogram(detrend(signal), s_window, s_overlap, sig_length, Fs); % S is the power, F is the frequency,T is the time (center of the windows), P is the power in each window
        good = find(F < fmax);
        MeanP=MeanP+P/meanfact;                  %divides total power by number of total trials*channels

        good = find(F < fmax);
        good = intersect(good,find(F > fmin));
        Tgood = find(T > tmin);

    end
    
    power_spec = figure(1); subplot(2,1,x); hold on; imagesc(T(Tgood),F(good),(MeanP(good,Tgood)/10^6));  axis xy; colorbar; 
    if x ==1
        p_spec_aff = struct('T',T, 'F', F, 'MeanP', MeanP, 'Good', good, 'Tgood', Tgood); 
    else
        p_spec_sal = struct('T',T, 'F', F, 'MeanP', MeanP, 'Good', good, 'Tgood', Tgood);
    end

end

