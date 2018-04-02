function [AveragedComplex, AveragedPhi] = AverageComplexes( indices, phis, nelem, numTops )
% AverageComplexes.m
%   Calculate weighted average of complexes and phi for the Top (numTops) phi. 
%
% INPUT:
%    indices: The indices of subsets. (#subsets by 1 cell array. Each cell contains indices of a subset.)
%    phis: The amount of integrated information for subsets. (#subsets by 1
%    vector)
%    nelem: The number of elements.
%    numTops: The average is taken for Top (numTops) phi. 
%
% OUTPUT:
%    AveragedComplex: The average of complexes weighted by phi. 1 by nelem
%    vector.
%       AveragedComplex(i) = (sum_{k=1}^numTops phi(k) I(The i-th element is included in the k-th subset))/ (sum_{k=1}^numTops phi(k)), 
%       where I() is the indicator function, and denom = sum_{k=1}^numTops phi(k).
%
%    AveragedPhi: The weighted average of phi.
%       AveragedPhi = (sum_{k=1}^numTops phi(k))/numTops
%
% Jun Kitazono, 2018

[phis_sort, index_phis_sort] = sort(phis, 'descend');

AveragedComplex = zeros(1, nelem);

denom = sum(phis_sort(1:numTops));
for i = 1:numTops
    ind_temp = indices{index_phis_sort(i)};
    AveragedComplex(ind_temp) = AveragedComplex(ind_temp) + phis_sort(i);
end
AveragedComplex = AveragedComplex/denom;

AveragedPhi = denom/numTops;

end

