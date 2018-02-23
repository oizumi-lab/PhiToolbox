function [Z_MIP, phi_MIP, phis] = MIP_Exhaustive( type_of_dist, type_of_phi, X, params)
%-----------------------------------------------------------------------
% FUNCTION: MIP_Exhaustive.m
% PURPOSE: Find the minimum information partition (MIP) by Exhaustive Search
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
%              
%
% OUTPUT:
%           Z_MIP: the MIP
%           phi_MIP: the amount of integrated information at the MIP
%-----------------------------------------------------------------------

probs = data_to_probs(type_of_dist,X,params);

[Z_MIP, phi_MIP, phis] = MIP_Exhaustive_probs( type_of_dist, type_of_phi, params, probs);


end
