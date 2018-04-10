function [Z_MIP, phi_MIP] = MIP_Queyranne( probs, options)
%-----------------------------------------------------------------------
% FUNCTION: MIP_Queyranne.m
% PURPOSE: Find the minimum information partition (MIP) using Queyranne's
% algorithm
%
% INPUTS:   
%   see MIP_search_probs
%              
%
% OUTPUT:
%           Z: the esetimated MIP
%           phi: amount of integrated information at the estimated MIP
%-----------------------------------------------------------------------

N = probs.number_of_elements;
type_of_dist = options.type_of_dist;
type_of_phi = options.type_of_phi;

F = @(indices)phi_comp_probs(type_of_dist, type_of_phi, indices2bipartition(indices, N), probs);

[IndexOutput] = QueyranneAlgorithm( F, 1:N );
phi_MIP = F(IndexOutput);

if ismember(1, IndexOutput)
    Z_MIP = 2*ones(1,N);
    Z_MIP(IndexOutput) = 1;
else
    Z_MIP = ones(1, N);
    Z_MIP(IndexOutput) = 2;
end

end