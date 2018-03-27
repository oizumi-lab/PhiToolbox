function [complexes, phis_complexes, h] = find_complexes_repetitive(indices, phis, showFig)
% find_compexes.m
%  Find non-overlapping complexes by repetitively removing them. 
%
% INPUT:
%    indices: indices of the subsystems
%    phis: the amount of integrated information for subsystems
%    showFig: whether plot figures (showFig=1) or not (showFig=0, default). 
%
% OUPTUT:
%    complexes: indices of the complexes
%    phis_complexes: the amount of integrated information of the complexes
%    h: figure handle of the bar graph 
%
% Jun Kitazono, 2018

if nargin < 3
    showFig = 0;
end

[phis_temp, index_sorted] = sort(phis, 'descend');
groups_indices_temp = indices(index_sorted);

complexes = groups_indices_temp(1);
phis_complexes = phis_temp(1);

[groups_indices_temp, phis_temp] = exclude_overlapping_subsets( groups_indices_temp, phis_temp );

while length(groups_indices_temp) > 0
    complexes = [complexes; groups_indices_temp(1)];
    phis_complexes = [phis_complexes; phis_temp(1)];
    
    [groups_indices_temp, phis_temp] = exclude_overlapping_subsets( groups_indices_temp, phis_temp );
end

% plot a bar graph of phis for the complexes.
if showFig
    complexes_str = cell(size(complexes));
    for i = 1:length(complexes)
        complexes_str{i} =  num2str(complexes{i});
    end
    
    h = figure;
    bar(phis_complexes)
    set(gca, 'xticklabel', complexes_str)
    title('Complexes')
    ylabel('\Phi')
    xlabel('Indices of the complexes')
end

end


function [groups_indices_nonoverlapping, phis_nonoverlapping] = exclude_overlapping_subsets( groups_indices, phis )
% Remove groups overlapping with the group with the maximum phi (phis(1)). 
% We assume phis is sorted in descending order. 

    isnonoverlapping = zeros(length(groups_indices), 1);
    for i = 1:length(groups_indices)
        isnonoverlapping(i) = isempty(intersect(groups_indices{1}, groups_indices{i} ));
    end
    
    nonoverlapping = find(isnonoverlapping);
    
    groups_indices_nonoverlapping = groups_indices(nonoverlapping);
    phis_nonoverlapping = phis(nonoverlapping);

end