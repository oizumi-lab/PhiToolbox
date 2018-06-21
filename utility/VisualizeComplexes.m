function VisualizeComplexes(Res, type, Labels, threshold)


% sort the indices based on Zs
% isComplex   1:solid line, 0:dotted line
% min(index)-0.5 max(index)+0.5
[complexes, phis, isComplex] = find_Complexes(Res);
[main_complexes, main_phis] = find_main_Complexes(complexes, phis);

if nargin < 4 || isempty(threshold)
    threshold = 0;
elseif strcmp(threshold, 'min_phi_main_complexes')
    threshold = min(main_phis);
end


Z = Res.Z;
for i = 1:length(Res.phi)
    Z(i,:) = flip12(Res.Z(i,:));
end

indices_sorted = 1:size(Z, 2);
for i = 1:length(Res.phi)
    
    Z_temp = Z(i, Z(i,:)>0);
    [Z_temp_sorted, indices_sorted_temp] = sort(Z_temp);
    
    indices_sorted_sub = indices_sorted(Z(i,:)>0);
    indices_sorted_sub = indices_sorted_sub(indices_sorted_temp);
    indices_sorted(Z(i,:)>0) = indices_sorted_sub;
    
end

max_phi = max(Res.phi);
ylim_max = 1.05*max_phi;

Z_sorted = Z(:, indices_sorted);

color_level = max( Res.phi/max_phi - min(Res.phi(Res.phi>0))*1e-10, 0);

generation = zeros(length(Res.phi), 1);

for i = (length(Res.phi)-1):-1:1
    generation(i) = generation(Res.parent(i))+1;
end


cmap = colormap;

if type == 1
    for i = length(Res.phi):-1:1
        xs = [find(Z_sorted(i,:), 1, 'first')-0.5; find(Z_sorted(i,:), 1, 'last')+0.5];
        ys = [Res.phi(i); Res.phi(i)];
        
        if isComplex(i)
            LineStyle = '-';
            color = 'b';
        else
            LineStyle = '--';
            color = [0.8, 0.8, 0.8];
        end
        if ys(1) >= threshold
            line( [xs; flipud(xs); xs(1)], [ys; 0; 0; ys(1)], 'LineStyle', LineStyle, 'color', color )
        end
        ylim([0 ylim_max])
    end
elseif type == 2
    LineWidth = 1;
    
    x_MIP = zeros(length(Res.phi), 1);
    idx_finest = zeros(1, size(Z, 2));
    
    for i = length(Res.phi):-1:1
            
        x_MIP(i) = find(Z_sorted(i,:)==1, 1, 'last') + 0.5;
        
            
        if i == length(Res.phi)
            line( [x_MIP(i); x_MIP(i)], [-1; 0], 'LineWidth', LineWidth, 'color', 'k' )
        else
            color_parent_temp = cmap(floor(color_level(Res.parent(i))*64 + 1),:);
            color_temp = cmap(floor(color_level(i)*64 + 1),:);
            line( [x_MIP(Res.parent(i)), x_MIP(i)], [generation(i)-1, generation(i)-1], 'LineWidth', LineWidth, 'color', color_parent_temp)
%             line( [x_MIP(i); x_MIP(i)], [generation(i)-1; generation(i)], 'LineWidth', LineWidth);
%             set(gca.Edge, 'ColorBinding','interpolated', 'ColorData', [uint8(color_parent_temp*255), 1; uint8(color_temp*255), 1]) %%%%%%%%%%%%%%%%%%%%%
            patch( [x_MIP(i); x_MIP(i); NaN], [generation(i)-1; generation(i); NaN], [color_level(Res.parent(i)); color_level(i); NaN], 'EdgeColor','interp', 'LineWidth', LineWidth )
        end
        
        if nnz(Z_sorted(i,:)==1)==1
            idx_finest(Z_sorted(i,:)==1) = i;
        end
        if nnz(Z_sorted(i,:)==2)==1
            idx_finest(Z_sorted(i,:)==2) = i;
        end
    end

    for j = 1:size(Z, 2)
        color_temp = cmap(floor(color_level(idx_finest(j))*64 + 1),:);
        line( [x_MIP(idx_finest(j)); j], [generation(idx_finest(j)); generation(idx_finest(j))], 'LineWidth', LineWidth, 'color', color_temp )
        %line( [j; j], [Res.phi(idx_finest(j)); ylim_max], 'Color', [0.9 0.9 0.9])
        line( [j; j], [generation(idx_finest(j)); max(generation(:))+1], 'Color', [0.9 0.9 0.9])
        
    end
    set(gca, 'YDir', 'reverse')
    ylim([-1 max(generation(:))+1])
    colorbar('Ticks', (0: 0.2: 1), 'TickLabels', num2str((0: 0.2: 1)'*max(Res.phi)))
    caxis([0 1])
end

xlim([0.5, length(indices_sorted)+0.5])
xticks(1:length(indices_sorted))

if nargin < 3 || isempty(Labels)
    xticklabels(num2str(indices_sorted'));
else
    xticklabels(Labels(indices_sorted))
end
set(gca, 'xticklabelrotation', 45)

end

function [complexes, phis, isComplex] = find_Complexes(Res)

nSubsets = length(Res.phi);
phi_temp_max = zeros(nSubsets, 1);
isComplex = false(nSubsets, 1);

phi_temp_max(nSubsets) = Res.phi(nSubsets);
isComplex(nSubsets) = 1;
for i = nSubsets-1: -1 :1
    if Res.phi(i) > phi_temp_max(Res.parent(i))
        phi_temp_max(i) = Res.phi(i);
        isComplex(i) = true;
    else
        phi_temp_max(i) = phi_temp_max(Res.parent(i));
    end
end

nComplexes = nnz(isComplex);
complexes = cell(nComplexes, 1);
Zs_Complexes = Res.Z(isComplex,:);
for i = 1:nComplexes
    complexes{i} = find(Zs_Complexes(i,:));
end

phis = Res.phi(isComplex);


end

function Z = flip12(Z)

num1 = nnz(Z==1);
num2 = nnz(Z==2);

Z_temp = Z;

if num1 < num2
    Z(Z_temp==1) = 2;
    Z(Z_temp==2) = 1;
end

end