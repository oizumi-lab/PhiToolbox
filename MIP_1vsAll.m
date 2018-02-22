function [Z_MIP, phi_MIP] = MIP_1vsAll( type_of_phi, Cov_X, Cov_XY, Cov_Y )
%-----------------------------------------------------------------------
% FUNCTION: MIP_1vsAll.m
% PURPOSE: Find the 1-vs-all partition with the minimum phi among the other 
% 1-vs-all partitions. 
%
% INPUTS:   
%     type_of_phi:
%         'MI1': Multi (Mutual) information, I(X_1; X_2). (IIT1.0)
%         'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%         'SI': phi_H, stochastic interaction
%         'star': phi_star, based on mismatched decoding
%         'Geo': phi_G, information geometry version
%     Cov_X: covariance of data X (past, t-tau)
%     Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%     Cov_Y: covariance of data Y (present, t)
%     phi_G_OptimMethod: Optimization method of phi_G, {'AL', 'LI'}.
%              
%
% OUTPUT:
%           Z_MIP: the estimated MIP
%           phi_MIP: the amount of integrated information at the Minimum
%           Information partition
%-----------------------------------------------------------------------

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
if nargin >= 3
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

% % check Geo_OptimMethod
% if nargin >= 5
% %     if ~strcmp( type_of_phi, 'Geo' )
% %         error('The option phi_G_OptimMethod is available only for phi_G!')
% %     end
%     assert( isa( phi_G_OptimMethod, 'char' ) )
% if ~any(strcmp(phi_G_OptimMethod, {'AL', 'LI'}))
%     error('OptimMethod of phi_G must be AL or LI!')
% end
% end


N = size(Cov_X, 1);

phi_MIP = Inf;
Z_MIP = zeros(1, N);
for i = 1:N
    Z = ones(1,N);
    Z(1,i) = 2;
    switch type_of_phi
        case 'MI1'
            phi_temp = MI1_Gauss(Cov_X, Z);
        case 'MI'
            phi_temp = MI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
        case 'SI'
            phi_temp = SI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
        case 'star'
            phi_temp = phi_star_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
        case 'Geo'
%             if nargin < 6
                phi_temp = phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
%             else
%                 phi_temp = phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z );
%             end
    end

    if phi_temp < phi_MIP
        phi_MIP = phi_temp;
        Z_MIP = Z;
    end
    
end



end