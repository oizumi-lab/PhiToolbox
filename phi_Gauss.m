function phi = phi_Gauss( type_of_phi, Z, Cov_X, Cov_XY, Cov_Y, phi_G_OptimMethod)
%-----------------------------------------------------------------------
% FUNCTION: phi_Gauss.m
% PURPOSE:  
%
% INPUTS:   
%     type_of_phi:
%         'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%         'MI': Multi (Mutual) information, e.g., I(X_1, Y_1; X_2, Y_2)
%         'SI': phi_H, stochastic interaction
%         'star': phi_star, based on mismatched decoding
%         'Geo': phi_G, information geometry version
%     Z: partition
%         - 1 by n matrix. Each element indicates the group number. 
%         - Ex.1:  (1:n) (atomic partition)
%         - Ex.2:  [1, 2,2,2, 3,3, ..., K,K] (K is the number of groups) 
%         - Ex.3:  [3, 1, K, 2, 2, ..., K, 2] (Groups don't have to be sorted in ascending order)
%     Cov_X: covariance of data X (past, t-tau)
%     Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%     Cov_Y: covariance of data Y (present, t)
%     phi_G_OptimMethod: Optimization method of phi_G, {'AL', 'LI'}.
%              
%
% OUTPUT:
%           phi: amount of integrated information 
%-----------------------------------------------------------------------

% check type_of_phi
assert( isa( type_of_phi, 'char' ) )
list_types_of_phi = {'MI1', 'MI', 'SI', 'star', 'Geo'};
if ~any( strcmp(type_of_phi, list_types_of_phi) )
    error('type_of_phi must be selected from MI1, MI, SI, star or Geo!')
end

% check Z
assert( isa( Z, 'double' ) )
[nZr, nZc] = size(Z);
if nZr~=1
    error('Partition Z must be 1 by n row vector!')
end
unique_Z = unique(Z);
if ~isequal( max(Z), length(unique_Z) )
    error('Partition Z must include at least one elment from each group!')
end
if length(unique_Z) < 2
    error('Partition Z must consist of multiple groups!')
end

% check Cov_X
assert( isa( Cov_X, 'double' ) )
[nXr, nXc] = size(Cov_X);
if ~isequal(nZc, nXr, nXc)
    error('Sizes of Z and Cov_X do not match! Z: 1 by n vector, Cov_X: n by n matrix')
end

% check Cov_XY and Cov_Y
if nargin >= 4
%     if strcmp( type_of_phi, 'MI1' )
%         error('Cov_XY and Cov_Y are not needed for computation of MI1!')
%     end
    assert( isa( Cov_XY, 'double' ) )
    assert( isa( Cov_Y, 'double' ) )
end
[nYr, nYc] = size(Cov_Y);
[nXYr, nXYc] = size(Cov_XY);
if ~isequal(nZc, nYr, nYc, nXYr, nXYc)
    error('Sizes of Cov_X and Cov_Y (Cov_XY) do not match!')
end

% check Geo_OptimMethod
if nargin == 6
    %     if ~strcmp( type_of_phi, 'Geo' )
    %         error('The option phi_G_OptimMethod is available only for phi_G!')
    %     end
    assert( isa( phi_G_OptimMethod, 'char' ) )
    if ~any(strcmp(phi_G_OptimMethod, {'AL', 'LI'}))
        error('OptimMethod of phi_G must be AL or LI!')
    end
end

switch type_of_phi
    case 'MI1'
        phi = MI1_Gauss(Cov_X, Z);
    case 'MI'
        phi = MI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'SI'
        phi = SI_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'star'
        phi = phi_star_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
    case 'Geo'
        if nargin < 6
            phi = phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z);
        else
            phi = phi_G_Gauss(Cov_X, Cov_XY, Cov_Y, Z, phi_G_OptimMethod);
        end
end


end