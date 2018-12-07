function [EdgePhis, EdgeColors] = ComplexGraphsECoGMap(SubjectName, target_ch, Complexes, Phis, colormap, bipolar, g, isshown, clim)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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
    [EdgePhis, EdgeColors] = ComplexGraphs(X, Y, Complexes, Phis, colormap, LineWidth, g, isshown);
else
    [EdgePhis, EdgeColors] = ComplexGraphs(X, Y, Complexes, Phis, colormap, LineWidth, g, isshown, clim);
end

end

