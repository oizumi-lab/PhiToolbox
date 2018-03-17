function [Z_MIP, phi_MIP, Zs, phis] = MIP_Exhaustive( type_of_dist, type_of_phi, X, tau, varargin )
%-----------------------------------------------------------------------
% FUNCTION: MIP_Exhaustive.m
% PURPOSE: Find the Minimum Information Partition (MIP) by the exhaustive
% search from time series data
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
% Jun Kitazono, 2018

numSt = [];

num_params_other_than_varargin = 4;
switch type_of_dist
    case 'discrete'
        if nargin <= num_params_other_than_varargin || ~isa(varargin{1}, 'numeric')
            error('Number of states must be identified.')
        else
            numSt = varargin{1};
        end
end

probs = data_to_probs(type_of_dist, X, tau, numSt);

[Z_MIP, phi_MIP, Zs, phis] = MIP_Exhaustive_probs( type_of_dist, type_of_phi, probs );


end
