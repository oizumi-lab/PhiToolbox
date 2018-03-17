function phi = phi_comp_probs(type_of_dist, type_of_phi, Z, probs)

%-----------------------------------------------------------------------
% FUNCTION: phi_comp_probs.m
% PURPOSE: Compute phi from probability distributions
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
%           params: parameters for computing phi
%           probs: probability distributions for computing phi
%
% OUTPUT:
%           phi: integrated information
%-----------------------------------------------------------------------

switch type_of_dist
    case 'Gauss'
        phi = phi_Gauss( type_of_phi, Z, probs.Cov_X, probs.Cov_XY, probs.Cov_Y);
    case 'discrete'
        phi = phi_dis(type_of_phi, Z, probs.number_of_states, probs.past, probs.joint, probs.present);
end

end