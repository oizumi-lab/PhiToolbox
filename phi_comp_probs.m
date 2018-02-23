function phi = phi_comp_probs(type_of_dist, type_of_phi, Z, params, probs)

switch type_of_dist
    case 'Gauss'
        Cov_X = probs{1};
        Cov_XY = probs{2};
        Cov_Y = probs{3};
        phi = phi_Gauss( type_of_phi, Z, Cov_X, Cov_XY, Cov_Y);
    case 'dis'
        p_past = probs{1};
        joint = probs{2};
        p_present = probs{3};
        N_st = params(3);
        phi = phi_dis(type_of_phi, Z, N_st, p_past, joint, p_present);
end

end