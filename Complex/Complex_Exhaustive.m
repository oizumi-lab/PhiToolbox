function [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_Exhaustive( probs, options )
%Complex_Exhaustive: Find main complex using the exhaustive search
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
%    complexes: indices of elements in complexes
%    phis_complexes: phi at the MIP of complexes
%    main_complexes: indices of elements in main complexes
%    phis_main_complexes: phi at the MIP of main complexes
%
%    Res.subsets_all: the (micro) indices of every subsystem
%    Res.phis_all: phi at the MIP of every subsystem
%    Res.MIPs_all: the MIP of every subsystem
%    Res.group_indices_all: the (macro) indices of groups of every subsystem
%
% Jun Kitazono & Masafumi Oizumi, 2018

N = probs.number_of_elements;
type_of_MIPsearch = options.type_of_MIPsearch;
type_of_dist = options.type_of_dist;

if isfield(options,'groups')
    groups = options.groups;
else
    groups = num2cell( (1:N)' );
end

nClusters = length(groups);
group_indices_all = cell(2^nClusters-1, 1);
subsets_all = cell(2^nClusters-1, 1);

phis_all = zeros(2^nClusters-1, 1);
MIPs_all = zeros(2^nClusters-1, N);

idx = 0;
for i = 1:nClusters
    group_indices_temp = nchoosek(1:nClusters, i);
    for j = 1:size(group_indices_temp, 1)
        idx = idx + 1;
        group_indices_all{idx} = group_indices_temp(j,:);
        subsets_all{idx} = [];
%         labels{idx} = [];
        for k = 1:length(group_indices_temp(j,:))
            subsets_all{idx} = [subsets_all{idx}, groups{group_indices_temp(j,k)}];
%             labels{idx} = [labels{idx}, ', ', label_groups{k}];
        end
    end
end

parfor i = 1:length(group_indices_all)
    indices_temp = subsets_all{i};
   % disp(indices_temp);
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
    
    phis_all(i, 1) = phi_MIP;
    Z_temp = zeros(1, N);
    Z_temp(1,indices_temp) = Z_MIP;
    MIPs_all(i, :) = Z_temp;
end

[complexes, phis_complexes] = find_Complexes( subsets_all, phis_all );
[main_complexes, phis_main_complexes] = find_main_Complexes( complexes, phis_complexes );

Res.subsets_all = subsets_all;
Res.phis_all = phis_all;
Res.MIPs_all = MIPs_all;
Res.group_indices_all = group_indices_all;


end

