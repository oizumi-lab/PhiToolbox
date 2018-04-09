function [Z_MIP, phi_MIP] = MIP_Queyranne( probs, options)
%-----------------------------------------------------------------------
% FUNCTION: MIP_Queyranne.m
% PURPOSE: Find the minimum information partition (MIP) using Queyranne's
% algorithm
%
% INPUTS:   
%           Cov_X: covariance of data X (past, t-tau)
%           Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%           Cov_Y: covariance of data Y (present, t)
%           type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
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