function [EdgePhis, EdgeColors] = ...
    ComplexGraphs(X, Y, complexes, phis, type_of_colormap, LineWidth, MarkerSize, g, isshown, clim, isclim)
% Visualize complexes as superimposed graphs
%
% INPUT:
%    X, Y: X and Y coordinates of nodes
%    complexes: The indices of complexes. (#complexes-by-1 cell array. Each cell contains indices of a subset.)
%    phis: The amount of integrated information for complexes. (#complexes-by-1 vector)
%    type_of_colormap: ex. 'parula'
%    LineWidth: max. width of edges
%    g: relative width of edges
%    isshown: show the image or not
%    clim: clim of colormap
%
% OUTPUT:
%    EdgePhis: the amount of integrated information of the complex where
%    each edge is included
%    EdgeColors: the color of each edge
%
% Jun Kitazono, 2018

nBinsColormap = 256;
nElems = length(X);

nComplexes = length(phis);

[phis_sorted, index_phis_sorted] = sort(phis, 'ascend');
complexes_sorted = complexes(index_phis_sorted);

if isempty(g) || max(g(:))<=0
    g = ones(nElems);
else
    max_g = max(g(:));
    g = g/max_g;
end


if nargin < 9
    phis_sorted_rescaled = rescale(phis_sorted);
    clim = [phis_sorted(1), phis_sorted(end)];
else
    if clim(1) ~= clim(2)
        phis_sorted_rescaled = (phis_sorted-clim(1))./(clim(2)-clim(1));
    else
        phis_sorted_rescaled = 0;
    end
end

Colors = eval([type_of_colormap, '(nBinsColormap);']);
ColorIndices = 1 + floor( (nBinsColormap-1)*phis_sorted_rescaled );
Colors = Colors(ColorIndices,:);

EdgePhis = zeros(nElems, nElems);
EdgeColors = cell(nElems, nElems);
for iComplexes = 1:nComplexes
    Pairs = nchoosek(complexes_sorted{iComplexes}, 2);
    for iPairs = 1:size(Pairs, 1)
        Pair = Pairs(iPairs, :);
        EdgePhis(Pair(1), Pair(2)) = phis_sorted(iComplexes);
        EdgeColors{Pair(1), Pair(2)} = Colors(iComplexes,:);
    end
end
EdgePhis = EdgePhis + EdgePhis';
%EdgeColors
%EdgeColors = EdgeColors + EdgeColors';

if isshown
    hold on
    Pairs = nchoosek(1:nElems, 2);
    EdgePhis_vec = zeros(size(Pairs, 1), 1);
    for iPairs = 1:size(Pairs, 1)
        Pair = Pairs(iPairs, :);
        EdgePhis_vec(iPairs) = EdgePhis(Pair(1), Pair(2));
    end
    [EdgePhis_vec_sorted, ind_sort] = sort(EdgePhis_vec, 'ascend');
    Pairs_sorted = Pairs(ind_sort,:);

    scatter(X, Y, 'Visible', 'off');
    for iPairs = 1:size(Pairs, 1)
        Pair = Pairs_sorted(iPairs,:);
        Xs = X(Pair);
        Ys = Y(Pair);
        if ~isempty(EdgeColors{Pair(1), Pair(2)}) && LineWidth*g(Pair(1), Pair(2))>0
            line(Xs, Ys, 'Color', EdgeColors{Pair(1), Pair(2)}, 'LineWidth', LineWidth*g(Pair(1), Pair(2)) );
            
            scatter(Xs, Ys, MarkerSize, EdgeColors{Pair(1), Pair(2)}, 'filled')
        end
    end

    eval(['colormap(', type_of_colormap, '(nBinsColormap));']);
    
    if clim(1)~=clim(2)
        caxis(clim)
        if isclim == 1
            colorbar('Ticks', clim, 'TickLabels', {num2str(clim(1)), num2str(clim(end))})
        end
    end
end

end

