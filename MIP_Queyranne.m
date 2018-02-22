function [Z_MIP, phi_MIP] = MIP_Queyranne( type_of_phi, Cov_X, Cov_XY, Cov_Y )
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

addpath(genpath('TotalCorrDecomposition'))

%type_of_phi_str = string(type_of_phi);
N = size(Cov_X, 1);

if strcmp( type_of_phi, 'MI1' );
    F = @(ind)phi_for_Queyranne( type_of_phi, ind, Cov_X );
else
    F = @(ind)phi_for_Queyranne( type_of_phi, ind, Cov_X,Cov_XY,Cov_Y);
end
[IndexOutput] = QueyranneAlgorithm( F, 1:N );
phi_MIP = F(IndexOutput);

Z_MIP = ones(1, N);
Z_MIP(IndexOutput) = 2;

end

function phi = phi_for_Queyranne( type_of_phi, indices, Cov_X, Cov_XY, Cov_Y )
%-----------------------------------------------------------------------
% INPUTS:
%           type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%           indices: indices of a subsystem
%           Cov_X: covariance of data X (past, t-tau)
%           Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%           Cov_Y: covariance of data Y (present, t)
%              
%
% OUTPUT:
%           phi: amount of integrated information 
%-----------------------------------------------------------------------

N = size(Cov_X, 1);

if iscell(indices)
    ind = cell2mat(indices);
else
    ind = indices;
end

Z = ones(1, N);
Z(ind) = 2;

switch type_of_phi
    case 'SI'
        phi = SI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'Geo'
        phi = phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'star'
        phi = phi_star_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'MI'
        phi = MI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'MI1'
        phi = MI1_Gauss(Cov_X, Z);
end

end