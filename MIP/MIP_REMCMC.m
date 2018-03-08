function [Z_MIP, phi_MIP, ...
    phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] ...
    = MIP_REMCMC( type_of_dist, type_of_phi, X, tau, varargin )
% FUNCTION: MIP_REMCMC.m
% PURPOSE: Find the minimum information partition (MIP) using Replica
% Exchange Monte Carlo Method (REMCMC)
%
% INPUTS:
%    type_of_dist:
%       'Gauss': Gaussian distribution
%       'discrete': discrete probability distribution
%    type_of_phi: 
%       'SI': phi_H, stochastic interaction
%       'Geo': phi_G, information geometry version
%       'star': phi_star, based on mismatched decoding
%       'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%       'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%    X: time series data in the form (element x time)
%    tau: time lag between past and present states
%
% OUTPUT:
%    Z_MIP: the MIP
%    phi_MIP: the amount of integrated information at the MIP
%
% EXAMPLES: 
%    MIP_REMCMC( 'Gauss', 'SI', X, tau ) finds the MIP for a Gaussian 
%    distribution.
%
%    MIP_REMCMC( 'discrete', 'SI', X, tau, number_of_states ) finds the MIP
%    for a discrete distribution. 
%
%    Available options:
%       MIP_REMCMC( 'Gauss', ..., tau, options )
%       MIP_REMCMC( 'discrete', ..., number_of_state, options )
%
% Jun Kitazono, 2018


options = [];
numSt = [];

num_params_other_than_varargin = 4;
length_varargin = nargin - num_params_other_than_varargin;
isdiscrete = 0;
switch type_of_dist
    case 'discrete'
        isdiscrete = 1;
        if nargin <= num_params_other_than_varargin || ~isa(varargin{1}, 'numeric')
            error('Number of states must be identified.')
        else
            numSt = varargin{1};
        end
end
if length_varargin > isdiscrete
    options = varargin{isdiscrete + 1};
end

probs = data_to_probs(type_of_dist, X, tau, numSt);

[Z_MIP, phi_MIP, phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ... 
    MIP_REMCMC_probs( type_of_phi, probs, options );

end