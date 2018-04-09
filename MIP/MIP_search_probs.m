function [Z_MIP, phi_MIP, Zs, phis] = MIP_search_probs( probs, options)
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
%
% Jun Kitazono & Masafumi Oizumi, 2018


switch options.type_of_MIPsearch
    case 'Exhaustive'
        [Z_MIP, phi_MIP, Zs, phis] = MIP_Exhaustive( probs, options);
    case 'Queyranne'
        [Z_MIP, phi_MIP] = MIP_Queyranne( probs, options);
    case 'REMCMC'
         [Z_MIP, phi_MIP, ...
    phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = MIP_REMCMC( probs, options);
end