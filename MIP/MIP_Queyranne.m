function [Z_MIP, phi_MIP] = MIP_Queyranne( type_of_dist, type_of_phi, X, tau, varargin )
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

[Z_MIP, phi_MIP] = MIP_Queyranne_probs( type_of_dist, type_of_phi, probs );

end