function phi = phi_dis(type_of_phi, Z, N_st, p_past, joint, p_present)

switch type_of_phi
    case 'MI1'
        phi = MI1_dis(Cov_X, Z); % not yet implemented
    case 'MI'
        phi = MI_dis(Cov_X, Cov_XY, Cov_Y, Z); % not yet implemented
    case 'SI'
        phi = SI_dis(Cov_X, Cov_XY, Cov_Y, Z);
    case 'star'
        phi = phi_star_dis(Z, N_st, p_past, joint, p_present);
end


end