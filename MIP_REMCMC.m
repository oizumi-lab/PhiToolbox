function [Z_MIP, phi_MIP, Energy_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = MIP_REMCMC( type_of_phi, options, Cov_X, Cov_XY, Cov_Y )
%-----------------------------------------------------------------------
% FUNCTION: MIP_REMCMC.m
% PURPOSE: Find the minimum information partition (MIP) using Replica
% Exchange Markov Chain Monte Carlo method
%
% INPUTS:   
%           type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%           Cov_X: covariance of data X (past, t-tau)
%           Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%           Cov_Y: covariance of data Y (present, t)
%           options: see REMCMC_processInputOptions.m
%
% OUTPUT:
%           phi_MIP: amount of integrated information at the estimated MIP
%           Z_MIP: the estimated MIP
%-----------------------------------------------------------------------

addpath(genpath('EMC'))

% check type_of_phi
assert( isa( type_of_phi, 'char' ) )
list_types_of_phi = {'MI1', 'MI', 'SI', 'star', 'Geo'};
if ~any( strcmp(type_of_phi, list_types_of_phi) )
    error('type_of_phi must be selected from MI1, MI, SI, star or Geo!')
end

% check Cov_X
assert( isa( Cov_X, 'double' ) )
% [nXr, nXc] = size(Cov_X);
% if ~isequal(nZc, nXr, nXc)
%     error('Sizes of Z and Cov_X do not match! Z: 1 by n vector, Cov_X: n by n matrix')
% end

% check Cov_XY and Cov_Y
if nargin >= 4
%     if strcmp( type_of_phi, 'MI1' )
%         error('Cov_XY and Cov_Y are not needed for computation of MI1!')
%     end
    assert( isa( Cov_XY, 'double' ) )
    assert( isa( Cov_Y, 'double' ) )
[nYr, nYc] = size(Cov_Y);
[nXYr, nXYc] = size(Cov_XY);
if ~isequal(nYr, nYc, nXYr, nXYc)
    error('Sizes of Cov_X and Cov_Y (Cov_XY) do not match!')
end
end

N = size(Cov_X, 1);

switch type_of_phi
    case 'MI1'
        calc_E = @(Z)MI1_Gauss(Cov_X, Z);
    case 'MI'
        calc_E = @(Z)MI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'SI'
        calc_E = @(Z)SI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'star'
        calc_E = @(Z)phi_star_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'Geo'
        calc_E = @(Z)phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
end

[min_Energy, State_min_Energy, Energy_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ... 
    REMCMC_partition( calc_E, N, options );

[phi_MIP, i_T_MIP] = min(min_Energy);
Z_MIP = State_min_Energy(:, i_T_MIP)';

end