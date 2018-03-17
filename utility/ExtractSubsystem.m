function probs_Sub = ExtractSubsystem( type_of_dist, probs, indices )
% ExtractSubsystem
% 

probs_Sub.number_of_elements = length(indices);

switch type_of_dist
    case 'Gauss'
        probs_Sub.Cov_X = probs.Cov_X(indices, indices);
        probs_Sub.Cov_XY = probs.Cov_XY(indices, indices);
        probs_Sub.Cov_Y = probs.Cov_Y(indices, indices);
    case 'discrete'
        probs_Sub.number_of_states = probs.number_of_states;
        probs_Sub.past = marginalize(probs.past, indices, probs.number_of_elements, probs.number_of_states);
        probs_Sub.joint = marginalize2(probs.joint, indices, probs.number_of_elements, probs.number_of_states);
        probs_Sub.present = marginalize(probs.present, indices, probs.number_of_elements, probs.number_of_states);
end

end

