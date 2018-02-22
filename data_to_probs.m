function probs = data_to_probs(type_of_dist,X,params)

switch type_of_dist
    case 'Gauss'
        tau = params(1);
        [Cov_X, Cov_XY, Cov_Y] = Cov_comp(X,tau);
        probs{1} = Cov_X;
        probs{2} = Cov_XY;
        probs{3} = Cov_Y;
    case 'dis'
        tau = params(1);
        N_s = params(2);
        [p_past, joint, p_present, q_TPM] = est_prob(X,N_s,tau);
        probs{1} = p_past;
        probs{2} = joint;
        probs{3} = q_TPM;
        probs{4} = p_present;
end