function phi = phi_comp(type_of_dist, type_of_phi, Z, X, params)

probs = data_to_probs(type_of_dist,X,params);
phi = phi_comp_probs(type_of_dist, type_of_phi, Z, params, probs);


end