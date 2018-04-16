function h = make_ECoG_HeatMap( SubjectName, target_ch, weight, type_of_heatmap, bipolar )
%make_ECoG_HeatMap
% Make a heat map on ECoG channels. 
% 
% INPUT:
%    SubjectName: 'Chibi', 'George', 'Kin', 'Sue'
%    target_ch: the targeted channels
%    weight: This vector determines the size and color of channels on the map.
%    type_of_heatmap: 
%      1: weight is represented as the size and 'red-ness' of markers
%      2: weight is represented as the heatmap 'parula'. 
%    bipolar: use bipolar-paired channels (bipolar=1, default) or the original channels (bipolar=0).
%
% OUTPUT:
%    h: figure handle
%
% Jun Kitazono, 2018


if nargin < 5
    bipolar = 1;
end

if bipolar == 1
    CortexMap = load([SubjectName, 'Map_bipolar.mat']);
else
%     switch SubjectName
%         case 'Sue'
%             CortexMap = load('SuMap.mat');
%         case 'Kin'
%             CortexMap = load('Kin2Map.mat');
%         otherwise
            CortexMap = load([SubjectName, 'Map.mat']);
%     end
end

h = image(CortexMap.I*(1/3)+2*256/3); axis equal, hold on

X = CortexMap.X(target_ch);
Y = CortexMap.Y(target_ch);

max_w = max(weight);
min_w = min(weight);
weight = (weight - min_w)/(max_w - min_w);
ch_nonzero_weight = weight>0;

% size(ch_nonzero_weight)
% size(X)
% size(Y)
% 
% size(X(ch_nonzero_weight))
% size(weight)
% size(weight(ch_nonzero_weight))
% size(weight(ch_nonzero_weight)')
% size(zeros(nnz(weight),1))

if type_of_heatmap == 1
    min_point_size = 10;
    max_point_size = 150;
    scatter(X, Y, min_point_size, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k')
    scatter(X(ch_nonzero_weight), Y(ch_nonzero_weight), ...
    weight(ch_nonzero_weight)'*(max_point_size-min_point_size)+min_point_size, ...
    [weight(ch_nonzero_weight)', zeros(nnz(weight),1), zeros(nnz(weight),1)], 'filled')
    xlim([0.5 1000.5]);
    ylim([0.5, 1250.5]);

    set(gca, 'XTickLabel', [], 'YTickLabel', [], 'xtick', [], 'ytick', [])
elseif type_of_heatmap == 2
    point_sz = 50;
    clrs = parula(256);
    
    %scatter(CortexMap.X(1:N), CortexMap.Y(1:N), 30, clrs(groups_for_scatter,:), 'filled')
    
    hold on
    for i = 1:length(target_ch)
        clr_tmp = ceil(weight(i)*255 + 1);
        scatter(X(target_ch(i)), Y(target_ch(i)), point_sz, clrs(clr_tmp), 'filled' )
    end
end


end

