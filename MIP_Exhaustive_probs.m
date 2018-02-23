function [Z_MIP, phi_MIP, phis] = MIP_Exhaustive_probs( type_of_dist, type_of_phi, params, probs)
%-----------------------------------------------------------------------
% FUNCTION: MIP_Exhaustive_probs.m
% PURPOSE: Find the Minimum Informamtion Partition by the exhaustive search
% from probability distirubtions
%
% INPUTS: 
%           type_of_dist:
%              'Gauss': Gaussian distribution
%              'dis': discrete probability distribution
%           type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%           Z: partition
%         - 1 by n matrix. Each element indicates the group number. 
%         - Ex.1:  (1:n) (atomic partition)
%         - Ex.2:  [1, 2,2,2, 3,3, ..., K,K] (K is the number of groups) 
%         - Ex.3:  [3, 1, K, 2, 2, ..., K, 2] (Groups don't have to be sorted in ascending order)
%           X: time series data in the form (unit x time)
%           params: parameters for computing phi
%
% OUTPUT:
%           Z_MIP: the MIP
%           phi_MIP: the amount of integrated information at the MIP
%-----------------------------------------------------------------------

N = params(1);
all_comb = power_set(2:N);
nComb = length(all_comb);
phis = zeros(nComb,1);

parfor i=1: nComb
    subcluster = all_comb{i};
    Z = ones(1,N);
    Z(subcluster) = 2;
    % compute phi
    phis(i) = phi_comp_probs(type_of_dist, type_of_phi, Z, params, probs);
end

[phi_MIP, MIP_ind] = min(phis);

Z_MIP = ones(1,N);
Z_MIP(all_comb{MIP_ind}) = 2;



end