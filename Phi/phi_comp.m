function phi = phi_comp(type_of_dist, type_of_phi, Z, X, tau, varargin)
%-----------------------------------------------------------------------
% FUNCTION: phi_comp.m
% PURPOSE: Compute phi from time series data
%
% INPUTS: 
%           type_of_dist:
%              'Gauss': Gaussian distribution
%              'discrete': discrete probability distribution
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
%              params(1) = the number of units, params(2) = time delay (tau)
%              For the discrete distribution,  params(3) = the number of states
%
% OUTPUT:
%           phi: integrated information
%-----------------------------------------------------------------------

probs = data_to_probs(type_of_dist, X, tau, varargin);
phi = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);


end