function phi = phi_comp(type_of_dist, type_of_phi, Z, X, params, probs)

if nargin < 5
    probs = data_to_probs(type_of_dist,X,params);
end

switch type_of_dist
    case 'Gauss'
        Cov_X = probs{1};
        Cov_XY = probs{2};
        Cov_Y = probs{3};
        phi = phi_Gauss( type_of_phi, Z, Cov_X, Cov_XY, Cov_Y);
    case 'dis'
        % phi = phi_dis( type_of_phi);
        phi = phi_star_dis(p_past, joint, q_TPM, p_present);
end

end