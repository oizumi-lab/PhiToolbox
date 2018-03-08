function probs_Sub = ExtractSubsystem( probs, indices )
% ExtractSubsystem
% 

probs_Sub.type_of_dist = probs.type_of_dist;
probs_Sub.number_of_elements = length(indices);

switch probs.type_of_dist
    case 'Gauss'
        probs_Sub.Cov_X = probs.Cov_X(indices, indices);
        probs_Sub.Cov_XY = probs.Cov_XY(indices, indices);
        probs_Sub.Cov_Y = probs.Cov_Y(indices, indices);
    case 'discrete'
        indices_complement = setdiff(1:probs.N, indices);
        probs_Sub.past = marginalize(probs_Sub.past, indices_complement, probs.number_of_elements, probs.number_of_states);
        probs_Sub.joint = marginalize2(probs_Sub.joint, indices_complement, probs.number_of_elements, probs.number_of_states);
        probs_Sub.present = marginalize(probs_Sub.present, indices_complement, probs.number_of_elements, probs.number_of_states);
end

end

