function [NC, Suc, CA, QHC] = extracttastearrays(dirname);

matfile = dir([dirname filesep '*LFP.mat']);
NC = []; Suc = []; CA = []; QHC = [];

%Flip through each matlab output file and contruct merged arrays
for file = matfile'
    working_mat = load(file.name);
    disp(
    %Obtain number of channels that recorded neurons from file
    channels = length(working_mat.Data(1,:));
    for i=1:channels;
        tastes = length(working_mat.Data(i).taste);
        disp(['Working file is ' num2str(i) '.']); %Displays working file
        %Flip through tastes and build arrays
        for x=1:tastes;
            LFP_array = working_mat.Data(i).taste(x).LFP_P;
            switch x
            case 1
               NC = vertcat(NC, LFP_array');
            case 2
               Suc = vertcat(Suc, LFP_array');
            case 3
               CA = vertcat(CA, LFP_array');
            case 4
               QHC = vertcat(QHC, LFP_array');
            end          
        end
    end
end
    