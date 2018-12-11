
%Load file
file = load('N = 6_animals_Combined_all_tastes.mat');

%Specify names of LFP fields
sal_names = fieldnames(file.combined_data.saline.saline_sess); sal_data= file.combined_data.saline.saline_sess;
aff_names = fieldnames(file.combined_data.affective.drug_sess); aff_data= file.combined_data.affective.drug_sess;

%Index fields based on Taste for Saline data
T1_idx_sal = find(not(cellfun('isempty', strfind(sal_names,'taste_1'))));
T2_idx_sal = find(not(cellfun('isempty', strfind(sal_names,'taste_2'))));
T3_idx_sal = find(not(cellfun('isempty', strfind(sal_names,'taste_3'))));
T4_idx_sal = find(not(cellfun('isempty', strfind(sal_names,'taste_4'))));

%Index fields based on Taste for Affective data
T1_idx_aff = find(not(cellfun('isempty', strfind(aff_names,'taste_1'))));
T2_idx_aff = find(not(cellfun('isempty', strfind(aff_names,'taste_2'))));
T3_idx_aff = find(not(cellfun('isempty', strfind(aff_names,'taste_3'))));
T4_idx_aff = find(not(cellfun('isempty', strfind(aff_names,'taste_4'))));

%Create LFP struct
Taste_LFPs = struct;

%Flip through sessions (saline v. affective)
for session=1:2
    
    %Flip through tastes
    for taste=1:4
        if session ==1
            sess_name = sal_names; sess_id = 'saline'; data = sal_data;
            switch taste
                case 1
                    taste_id = T1_idx_sal;
                case 2
                    taste_id = T2_idx_sal;
                case 3
                    taste_id = T3_idx_sal;
                case 4
                    taste_id = T4_idx_sal;
            end
        else
            sess_name = aff_names; sess_id = 'affective'; data = aff_data;
            switch taste
                case 1
                    taste_id = T1_idx_aff;
                case 2
                    taste_id = T2_idx_aff;
                case 3
                    taste_id = T3_idx_aff;
                case 4
                    taste_id = T4_idx_aff;
            end
        end
        
        %Store data in LFP struct
        for i =1:length(taste_id)        
            Taste_LFPs.([sess_id]).(['Taste_' num2str(taste)]).([sess_name{taste_id(i)}]) = data.(sess_name{taste_id(i)});
        end
    end
end
