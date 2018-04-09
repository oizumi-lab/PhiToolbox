function [Z_MIP, phi_MIP, ...
    phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ... 
    MIP_REMCMC( probs, options )
% FUNCTION: MIP_REMCMC_probs.m
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
%       MIP_REMCMC( 'Gauss', ..., tau, 'options', options )
%       MIP_REMCMC( 'discrete', ..., number_of_state, 'options', options )
%
% Jun Kitazono, 2018

N = probs.number_of_elements;
type_of_dist = options.type_of_dist;
type_of_phi = options.type_of_phi;

calc_E = @(Z)phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

[min_phi_each_temperature, State_min_phi_each_temperature, phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ... 
    REMCMC_partition( calc_E, N, options );

[phi_MIP, i_T_MIP] = min(min_phi_each_temperature);
Z_MIP = State_min_phi_each_temperature(:, i_T_MIP)';

if Z_MIP(1) ~= 1
    Z_MIP = 3 - Z_MIP;
end

end