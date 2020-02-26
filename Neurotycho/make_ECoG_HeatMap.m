function make_ECoG_HeatMap( SubjectName, target_ch, weight, type_of_heatmap, bipolar )
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

image(CortexMap.I*(1/5)+4*256/5); axis equal, hold on
xlim([0.5 1000.5]);
ylim([0.5, 1250.5]);

set(gca, 'XTickLabel', [], 'YTickLabel', [], 'xtick', [], 'ytick', [])
% set(gcf, 'Units', 'points')
% position_f = get(gcf, 'Position');
% position_a_ratio = get(gca, 'Position');
% width_a = position_f(3)*position_a_ratio(3);
% set(gca, 'Units', 'points')
% position_a = get(gca, 'Position');
% width_a = position_a(3);
% set(gca, 'Units', 'normalized')
currunit = get(gca, 'units');
set(gca, 'units', 'points');
axisPos = plotboxpos(gca);
set(gca, 'Units', currunit);
width_a = axisPos(3);


X = CortexMap.X(target_ch);
Y = CortexMap.Y(target_ch);

max_w = max(weight);
min_w = min(weight);
if max_w > min_w
    weight = (weight - min_w)/(max_w - min_w);
else
    weight = weight > 0;
end
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
    min_point_size = sqrt(realmin);
    max_point_size = (width_a/100*5);
    
    sizes = min_point_size + weight'*(max_point_size-min_point_size);
    sizes = sizes.^2;
    
    scatter(X, Y, sizes, ...
    [weight', zeros(length(weight),1), zeros(length(weight),1)], 'filled')
    
%     min_point_size = (width_a/100*1e-1)^2;
%     max_point_size = (width_a/100*5)^2;
%     scatter(X, Y, ...
%     weight'*(max_point_size-min_point_size)+min_point_size, ...
%     [weight', zeros(length(weight),1), zeros(length(weight),1)], 'filled')

%     scatter(X, Y, min_point_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
%     scatter(X(ch_nonzero_weight), Y(ch_nonzero_weight), ...
%     weight(ch_nonzero_weight)'*(max_point_size-min_point_size)+min_point_size, ...
%     [weight(ch_nonzero_weight)', zeros(nnz(weight),1), zeros(nnz(weight),1)], 'filled')

elseif type_of_heatmap == 2
%         min_point_size = width_a/100*1e-10;
%     max_point_size = width_a/100*20;
    point_sz = (width_a/100*2)^2;
    clrs = parula(256);

    hold on
    for i = 1:length(target_ch)
        clr_tmp = ceil(weight(i)*255 + 1);
        scatter(X(target_ch(i)), Y(target_ch(i)), point_sz, clrs(clr_tmp,:), 'filled')
    end
elseif type_of_heatmap == 3
    min_point_size = (width_a/100*1e-1)^2;
    max_point_size = (width_a/100*2)^2;
    %scatter(X, Y, min_point_size, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k')
    scatter(X, Y, ...
    max_point_size*ones(length(weight),1), ...
    ...%weight(ch_nonzero_weight)'*(max_point_size-min_point_size)+min_point_size, ...
    [weight', zeros(length(weight),1), zeros(length(weight),1)], 'filled')
    %[zeros(nnz(weight),1), zeros(nnz(weight),1), zeros(nnz(weight),1)], 'filled')
% elseif type_of_heatmap == 4
%     min_point_size = width_a/100*1e-10;
%     max_point_size = width_a/100*20;
%     
%     point_sz = width_a/100*20;
%     clrs = parula(256);
%     
%     %scatter(X, Y, min_point_size, 'k')
%     scatter(X, Y, ...
%     weight'*(max_point_size-min_point_size)+min_point_size, ...
%     [weight', zeros(length(weight),1), zeros(length(weight),1)], 'filled')
%     %[zeros(nnz(weight),1), zeros(nnz(weight),1), zeros(nnz(weight),1)], 'filled')
end


end

