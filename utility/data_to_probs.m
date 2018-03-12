function probs = data_to_probs(type_of_dist, X, tau, number_of_states)

probs.type_of_dist = type_of_dist;
probs.number_of_elements = size(X, 1);

switch type_of_dist
    case 'Gauss'
        [probs.Cov_X, probs.Cov_XY, probs.Cov_Y] = Cov_comp(X, tau);
    case 'discrete'
        if nargin > 3 || isa(number_of_states, 'numeric')
            probs.number_of_states = number_of_states;
            [probs.past, probs.joint, probs.present] = est_p(X, probs.number_of_states, tau);
        else
            error('Number of states must be identified.')
        end
    otherwise
        error('type_of_dist must be ''Guass'' or ''discrete''.')
end

end