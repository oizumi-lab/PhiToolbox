function [indices_Complex, phi_Complex, indices, phis, Zs, group_indices_Complex, group_indices] = ...
    Complex_Exhaustive_probs( type_of_phi, type_of_MIPsearch, probs, varargin )
%Complex_Exhaustive_probs: Find main complex using the exhaustive search
%
% INPUTS:
%    type_of_phi: 
%       'SI': phi_H, stochastic interaction
%       'Geo': phi_G, information geometry version
%       'star': phi_star, based on mismatched decoding
%       'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%       'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%    type_of_MIPsearch: 
%       'exhaustive': 
%       'Queyranne': 
%       'REMCMC': 
%    probs: The target probability distribution. See also data_to_probs.m
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
groups = [];
options = [];

num_params_other_than_groups_and_options = 3;
if nargin > num_params_other_than_groups_and_options
    for i = 1:2:nargin-num_params_other_than_groups_and_options
        switch varargin{i}
            case 'groups'
                groups = varargin{i+1};
            case 'options'
                options = varargin{i+1};
        end
    end
end
if isempty(groups)
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
    for j = 1:size(group_indices_temp, 1);
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
    %disp(['i/length_ind_groups: ', num2str(i), '/', num2str(length(ind_groups))])
    indices_temp = indices{i};
    probs_Sub = ExtractSubsystem( probs, indices_temp );
    if length(indices_temp) == 1
        phi_MIP = 0;%phi_comp_probs( type_of_phi, 1, probs_Sub );
        Z_MIP = 1;
    else
        switch type_of_MIPsearch
            case 'Exhaustive'
                [Z_MIP, phi_MIP] = MIP_Exhaustive_probs( type_of_phi, probs_Sub );
            case 'Queyranne'
                [Z_MIP, phi_MIP] = MIP_Queyranne_probs( type_of_phi, probs_Sub );
            case 'REMCMC'
                [Z_MIP, phi_MIP] = MIP_REMCMC_probs( type_of_phi, probs_Sub, options );
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

