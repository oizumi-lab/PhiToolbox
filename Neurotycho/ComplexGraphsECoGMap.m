function [EdgePhis, EdgeColors] = ComplexGraphsECoGMap(SubjectName, target_ch, indices, phis, type_of_colormap, bipolar, g, isshown, clim)
% Visualize complexes as superimposed graphs on brain image
% 
% INPUT:
%    SubjectName: monkey subject name
%    target_ch: targeted channels
%    indices: The indices of complexes. (#subsets by 1 cell array. Each cell contains indices of a subset.)
%    phis: The amount of integrated information for subsets. (#subsets by 1
%    vector)
%    type_of_colormap: ex. 'parula'
%    bipolar: is the data bipolar re-referenced or not
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

if bipolar == 1
    CortexMap = load([SubjectName, 'Map_bipolar.mat']);
else
    CortexMap = load([SubjectName, 'Map.mat']);
end

if isshown
    h = image(CortexMap.I*(1/5)+4*256/5); axis equal, hold on
    xlim([0.5 1000.5]);
    ylim([0.5, 1250.5]);
end

set(gca, 'XTickLabel', [], 'YTickLabel', [], 'xtick', [], 'ytick', [])
currunit = get(gca, 'units');
set(gca, 'units', 'points');
axisPos = plotboxpos(gca);
set(gca, 'Units', currunit);
width_a = axisPos(3);

LineWidth = width_a * 0.008;% [0.0005 0.005];

X = CortexMap.X(target_ch);
Y = CortexMap.Y(target_ch);

if nargin < 8
    [EdgePhis, EdgeColors] = ComplexGraphs(X, Y, indices, phis, type_of_colormap, LineWidth, g, isshown);
else
    [EdgePhis, EdgeColors] = ComplexGraphs(X, Y, indices, phis, type_of_colormap, LineWidth, g, isshown, clim);
end

end

