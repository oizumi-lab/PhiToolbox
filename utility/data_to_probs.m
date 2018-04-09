function probs = data_to_probs(X, params, options)

tau = params.tau;

switch options.type_of_phi
    case 'MI1'
        isjoint = 0;
    otherwise
        isjoint = 1;
end

switch options.type_of_dist
    case 'Gauss'
        probs = Cov_comp(X, tau, isjoint);
    case 'discrete'
        number_of_states = params.number_of_states;
        probs = est_p(X, number_of_states, tau, isjoint);
        probs.number_of_states = number_of_states;
    otherwise
        error('type_of_dist must be ''Guass'' or ''discrete''.')
end

probs.number_of_elements = size(X,1);

end