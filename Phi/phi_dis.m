function phi = phi_dis(type_of_phi, Z, N_st, p_past, p_joint, p_present)

switch type_of_phi
    case 'MI1'
        phi = MI1_dis(Z,N_st, p_past);
    case 'SI'
        phi = SI_dis(Z, N_st, p_past, p_joint, p_present);
    case 'star'
        phi = phi_star_dis(Z, N_st, p_past, p_joint, p_present);
end


end