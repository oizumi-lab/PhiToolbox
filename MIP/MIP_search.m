function [Z_MIP, phi_MIP] = MIP_search( X, params, options)
%-----------------------------------------------------------------------
% FUNCTION: MIP_search.m
% PURPOSE: Find the Minimum Information Partition (MIP) from time series
% data X
%
% INPUTS:
%           X: time series data in the form (units X time)
%
%           params: parameters used for estimating probability distributions
%           (covariances in the case of Gaussian distribution) from time
%           series data
%
%           params.tau: time lag between past and present states
%           params.number_of_states: number of states (only for the discrete case)
%           
%           options: options for computing phi and for MIP search
%           
%           options.type_of_dist:
%              'Gauss': Gaussian distribution
%              'discrete': discrete probability distribution
%           options.type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%           options.type_of_MIPsearch
%              'Exhaustive': exhaustive search
%              'Queyranne': Queyranne algorithm
%              'REMCMC': Replica Exchange Monte Carlo Method 
%           
%
% OUTPUT:
%           Z_MIP: the MIP
%           phi_MIP: the amount of integrated information at the MIP
%-----------------------------------------------------------------------


probs = data_to_probs(X, params, options);
[Z_MIP, phi_MIP] = MIP_search_probs( probs, options);

end
