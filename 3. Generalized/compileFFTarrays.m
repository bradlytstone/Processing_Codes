function [PP1, PP2, PP3, PP4, EP1, EP2, EP3, EP4, LP1, LP2, LP3, LP4, Freq] = compileFFTarrays(dirname);

PP1 = []; PP2 = []; PP3 = []; PP4 =[];
EP1 = []; EP2 = []; EP3 = []; EP4 = [];
LP1 = []; LP2 = []; LP3 = []; LP4 = [];

matfile = dir([dirname filesep '*.mat']);

%Flip through each matlab output file and contruct merged arrays
for file = matfile'
    working_mat = load(file.name);

    %Create variables for mat files for PSD data based on pre, early,
    %late durations
    mat_pre_1 = working_mat.pre_p_1; mat_pre_2 = working_mat.pre_p_2; mat_pre_3 = working_mat.pre_p_3; mat_pre_4 = working_mat.pre_p_4;
    mat_early_1 = working_mat.early_p_1; mat_early_2 = working_mat.early_p_2; mat_early_3 = working_mat.early_p_3; mat_early_4 = working_mat.early_p_4;
    mat_late_1 = working_mat.late_p_1; mat_late_2 = working_mat.late_p_2; mat_late_3 = working_mat.late_p_3; mat_late_4 = working_mat.late_p_4;
    
    PP1 = vertcat(PP1, mat_pre_1); PP2 = vertcat(PP2, mat_pre_2); PP3 = vertcat(PP3, mat_pre_3); PP4 = vertcat(PP4, mat_pre_4);
    EP1 = vertcat(EP1, mat_early_1); EP2 = vertcat(EP2, mat_early_2); EP3 = vertcat(EP3, mat_early_3); EP4 = vertcat(EP4, mat_early_4);
    LP1 = vertcat(LP1, mat_late_1); LP2 = vertcat(LP2, mat_late_2); LP3 = vertcat(LP3, mat_late_3); LP4 = vertcat(LP4, mat_late_4);
    
    Freq = working_mat.pre_f_1;
end;
