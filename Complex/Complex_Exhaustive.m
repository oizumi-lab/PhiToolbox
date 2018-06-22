function [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_Exhaustive( X, params, options)
%Complex_Exhaustive: Find main complex using the exhaustive search
%
% INPUTS:
%           X: time series data in the form (units X time)
%           params: parameters used for estimating probability distributions
%           (covariances in the case of Gaussian distribution) from time
%           series data
%
%           params.tau: time lag between past and present states
%           params.number_of_states: number of states (only for the discrete case)
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
%    Complex_Exhaustive( 'Gauss', 'SI', 'Queyranne', X, tau ) finds the
%    main complex for a Gaussian distribution.
%
%    Complex_Exhaustive( 'discrete', 'SI', 'Queyranne', X, tau, number_of_states )
%    finds the main complex for a discrete distribution. 
%
%    Available options:
%       Complex_Exhaustive( 'Gauss', ..., tau, 'groups', groups )
%       Complex_Exhaustive( 'discrete',  ..., number_of_state, 'groups', groups )
%       The variable groups is a cell array. This cell array indicates the
%       groups of elements. The exhaustive search is done based on these
%       groups. 
%
%       Complex_Exhaustive( 'Gauss', ..., 'REMCMC', ..., tau, 'options', options )
%       Complex_Exhaustive( 'discrete', ..., 'REMCMC', ..., number_of_state, 'options', options )
%
%       Complex_Exhaustive( 'Gauss', ..., 'REMCMC', ..., tau, 'groups', groups, 'options', options )
%       Complex_Exhaustive( 'discrete', ..., 'REMCMC', ..., number_of_state, 'groups', groups, 'options', options )
%
% Jun Kitazono, 2018


probs = data_to_probs(X, params, options);

[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_Exhaustive_probs( probs, options );


end

