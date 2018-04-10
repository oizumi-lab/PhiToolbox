function [indices_Complex, phi_Complex, indices, phis, Zs, group_indices_Complex, group_indices] = ...
    Complex_Exhaustive_probs( probs, options )
%Complex_Exhaustive_probs: Find main complex using the exhaustive search
%
% INPUTS:
%           probs: probability distributions for computing phi
%           
%           In the Gaussian case
%               probs.Cov_X: covariance of data X (past, t-tau)
%               probs.Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%               probs.Cov_Y: covariance of data Y (present, t)
%           In the discrete case
%               probs.past: probability distribution of past state (X^t-tau)
%               probs.joint: joint distribution of X^t (present) and X^(t-\tau) (past)
%               probs.present: probability distribution of present state (X^t-tau)
%
%               probs.p: probability distribution of X (only used for MI)
%
%           options: options for computing phi and for MIP search
%           
%           options.type_of_dist:
%              'Gauss': Gaussian distribution
%              'discrete': discrete probability distribution
%           options.type_of_phi:
%              'SI': phi_H, stochastic interaction
%              'Geo': phi_G, information geometry version
%              'star': phi_star, based on mismatched decoding
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%           options.type_of_MIPsearch
%              'Exhaustive': exhaustive search
%              'Queyranne': Queyranne algorithm
%              'REMCMC': Replica Exchange Monte Carlo Method 
%           options.groups: search complex based on predefined groups.
%           A group is considered as an element, which is not subdivided
%           further.
%
%
% OUTPUTS:
%    indices_Complex: indices of elements in the complex
%    phi_Complex: the amount of integrated information at the MIP of the complex 
%    indices: the indices of every subsystem
%    phis: the amount of integrated information for every subsystem
%    Zs: the (estimated) MIP of every subsystem
%    group_indices_Complex: group indices of the complex
%    group_indices: the indices of groups of every subsystem
%
%
% EXAMPLES: 
%    Complex_Exhaustive_probs( 'SI', 'Queyranne', probs ) finds the
%    main complex for a Gaussian/discrete distribution.
%
%    Available options:
%       Complex_Exhaustive_probs( ..., 'groups', groups )
%
%       Complex_Exhaustive_probs( ..., 'REMCMC', ..., 'options', options )
%
%       Complex_Exhaustive_probs( ..., 'REMCMC', ..., 'groups', groups, 'options', options )
%
% Jun Kitazono, 2018

N = probs.number_of_elements;
type_of_MIPsearch = options.type_of_MIPsearch;
type_of_dist = options.type_of_dist;

if isfield(options,'groups')
    groups = options.groups;
else
    groups = num2cell( (1:N)' );
end

nClusters = length(groups);
group_indices = cell(2^nClusters-1, 1);
indices = cell(2^nClusters-1, 1);

phis = zeros(2^nClusters-1, 1);
Zs = zeros(2^nClusters-1, N);

idx = 0;
for i = 1:nClusters
    group_indices_temp = nchoosek(1:nClusters, i);
    for j = 1:size(group_indices_temp, 1)
        idx = idx + 1;
        group_indices{idx} = group_indices_temp(j,:);
        indices{idx} = [];
%         labels{idx} = [];
        for k = 1:length(group_indices_temp(j,:))
            indices{idx} = [indices{idx}, groups{group_indices_temp(j,k)}];
%             labels{idx} = [labels{idx}, ', ', label_groups{k}];
        end
    end
end

parfor i = 1:length(group_indices)
    indices_temp = indices{i};
   disp(indices_temp);
    % disp(['i/length_ind_groups: ', num2str(i), '/', num2str(length(ind_groups))])
    probs_Sub = ExtractSubsystem( type_of_dist, probs, indices_temp );
    if length(indices_temp) == 1
        phi_MIP = 0;%phi_comp_probs( type_of_phi, 1, probs_Sub );
        Z_MIP = 1;
    else
        switch type_of_MIPsearch
            case 'Exhaustive'
                [Z_MIP, phi_MIP] = MIP_Exhaustive( probs_Sub, options);
            case 'Queyranne'
                [Z_MIP, phi_MIP] = MIP_Queyranne( probs_Sub, options );
            case 'REMCMC'
                [Z_MIP, phi_MIP] = MIP_REMCMC( probs_Sub, options );
        end
    end
    
    phis(i, 1) = phi_MIP;
    Z_temp = zeros(1, N);
    Z_temp(1,indices_temp) = Z_MIP;
    Zs(i, :) = Z_temp;
end

[phi_Complex, i_Complex] = max(phis);

indices_Complex = indices{i_Complex};
group_indices_Complex = group_indices{i_Complex};

end

