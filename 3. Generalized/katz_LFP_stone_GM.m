function [combined_pwelch] = katz_LFP_stone_GM(dirname);

%This function takes in one input DIRNAME and flips through each *.mat file
%(which is one animal, one day of recording, and one taste) within the
%given directory to perform Welch's power spectral density estimate for
%each taste period in reference to stimulus onset (Pre [-750ms,-250ms],
%Early [250ms,750ms], and Late [1250ms,1750ms]). The parameters used for
%PWELCH function are detailed herein, however, the user can change them
%using lines 51-53. The outputs are PRE, EARLY, LATE, and F.

%DIRNAME = directory name that files are located in
%PRE = output array of PSD estimates for pre-taste period
%EARLY = output array of PSD estimates for early-taste period
%LATE = output array of PSD estimates for late-taste period
%F = output vector of Frequency for given PWELCH parameters

matfile = dir([dirname filesep '*_animals_Combined_all_tastes_parsed.mat']);

%Flip through each matlab output file and contruct merged arrays
for file =1:length(matfile')
    working_mat = load(matfile(file).name);
   
    array_set = cell2mat(fieldnames(working_mat));
    sessions = size(fields(working_mat.(array_set)),1);

    %Flip through trials
    for session=1:sessions;
        
        switch session
            case 1
                cond = 'saline';
            case 2
                cond = 'affective';
        end
        
        %grab session data
        full_session = working_mat.(array_set)(1).([cond]);
        tastes = size(fields(full_session),1);
        
        %Create Pre/Early/Late Arrays
        Pre1 = []; Pre2 = []; Pre3 = []; Pre4 = [];
        Early1 =[]; Early2 = []; Early3 = []; Early4 =[];
        Late1 =[]; Late2 = []; Late3 =[]; Late4 =[];
        
        %Create Pre_1S and Post_1S array
        Pre1_1S = []; Pre2_1S = []; Pre3_1S = []; Pre4_1S = [];
        Post1_1S = []; Post2_1S = []; Post3_1S = []; Post4_1S = [];
        
        %Flip through tastes
        for taste =1:tastes;
            for data=1:size(fields(full_session.(['Taste_' num2str(taste)])),1);
                
                %grab field names
                field_names = fieldnames(full_session.(['Taste_' num2str(taste)]));
                
                %grab data array
                LFP_array = full_session.(['Taste_' num2str(taste)]).(field_names{data});
            
                %Run pwelch (Welch's power spectral density estimate) with specified parameters
                %Parameters
                srate = 1000; %uses sample sizes of of taste time as dps in length 
                overlap = []; %multiplied by a hamming window with 50% overlap
                dft_length = 8000; % using 8000 DFT points

                %Assumes -2000ms/+5000ms in reference to stimulus onset
                [PPre,F] = pwelch(LFP_array(1251:1750),length(1251:1750),[],dft_length,srate);
                [PEarly,F] = pwelch(LFP_array(2251:2750),length(2251:2750),[],dft_length,srate);
                [PLate,F] = pwelch(LFP_array(3251:3750),length(3251:3750),[],dft_length,srate);
                [PPre1Sec,F_1sec] = pwelch(LFP_array(1000:2000),length(1000:2000),[],dft_length,srate);
                [PPost1Sec,F_1sec] = pwelch(LFP_array(2000:3000),length(2000:3000),[],dft_length,srate);
                
                %Store in arrays
                switch taste
                    case 1
                        Pre1=[Pre1;PPre'];
                        Early1=[Early1;PEarly'];
                        Late1=[Late1;PLate'];
                        Pre1_1S=[Pre1_1S;PPre1Sec'];
                        Post1_1S=[Post1_1S;PPost1Sec'];
                    case 2
                        Pre2=[Pre2;PPre'];
                        Early2=[Early2;PEarly'];
                        Late2=[Late2;PLate'];
                        Pre2_1S=[Pre2_1S;PPre1Sec'];
                        Post2_1S=[Post2_1S;PPost1Sec'];
                    case 3
                        Pre3=[Pre3;PPre'];
                        Early3=[Early3;PEarly'];
                        Late3=[Late3;PLate'];
                        Pre3_1S=[Pre3_1S;PPre1Sec'];
                        Post3_1S=[Post3_1S;PPost1Sec'];
                    case 4
                        Pre4=[Pre4;PPre'];
                        Early4=[Early4;PEarly'];
                        Late4=[Late4;PLate'];
                        Pre4_1S=[Pre4_1S;PPre1Sec'];
                        Post4_1S=[Post4_1S;PPost1Sec'];
                end %end switch
            
            end %end pwelch loop
                        
        end %end taste loop
        
        %Store into indiviual structs
        if session ==1
            pwelch_sal = struct('F', F, 'F_1sec',F_1sec, 'Pre1',Pre1,'Pre2',Pre2,'Pre3',Pre3,'Pre4',Pre4, 'Early1',Early1,'Early2',Early2,'Early3',Early3,'Early4',Early4, 'Late1',Late1,'Late2',Late2,'Late3',Late3,'Late4',Late4,'Pre1_1S',Pre1_1S,'Pre2_1S',Pre2_1S,'Pre3_1S',Pre3_1S,'Pre4_1S',Pre4_1S,'Post1_1S',Post1_1S,'Post2_1S',Post2_1S,'Post3_1S',Post3_1S,'Post4_1S',Post4_1S); 
        else
            pwelch_aff = struct('F', F, 'F_1sec',F_1sec, 'Pre1',Pre1,'Pre2',Pre2,'Pre3',Pre3,'Pre4',Pre4, 'Early1',Early1,'Early2',Early2,'Early3',Early3,'Early4',Early4, 'Late1',Late1,'Late2',Late2,'Late3',Late3,'Late4',Late4,'Pre1_1S',Pre1_1S,'Pre2_1S',Pre2_1S,'Pre3_1S',Pre3_1S,'Pre4_1S',Pre4_1S,'Post1_1S',Post1_1S,'Post2_1S',Post2_1S,'Post3_1S',Post3_1S,'Post4_1S',Post4_1S); 
        end
        
    end %end session loop
    
    %Store into combined struct
    combined_pwelch = struct('saline',pwelch_sal,'affective',pwelch_aff);
        
end %end matlab loop
