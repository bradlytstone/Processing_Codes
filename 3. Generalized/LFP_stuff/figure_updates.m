cscale_set = {};
for fig=1:fig_count
    for sub=1:sessions
        figure(fig); subplot(2,1,sub); 
        cscale_set{end+1} = max(caxis);
    end
end

max_cscale = max(cell2mat(cscale_set));min_cscale = min(cell2mat(cscale_set));
for fig=1:fig_count
    for sub=1:sessions
        figure(fig); subplot(2,1,sub); 
        caxis([0 min_cscale]); colormap('jet');
    end
end

for fig=1:fig_count
    for sub=1:sessions
        figure(fig); subplot(2,1,sub); 
        ylim([fmin fmax]); xlim([0.25 secs-0.25]);
    end
end

cscale_set = {};
for sub=1:sessions
    figure(1); subplot(2,1,sub); 
    cscale_set{end+1} = max(caxis);
end

max_cscale = max(cell2mat(cscale_set));min_cscale = min(cell2mat(cscale_set));
for sub=1:sessions
        figure(1); subplot(2,1,sub); 
        caxis([0  1*10^-3]); colormap('jet');
end


