function [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_search( X, params, options)
% Complex_search: Find complexes and main complexes from time series X
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
%           options: options for computing phi, MIP search, and complex
%           search
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
%              'Exhaustive': exhau stive search
%              'Queyranne': Queyranne algorithm
%              'REMCMC': Replica Exchange Monte Carlo Method 
%           options.type_of_complexsearch
%               'Exhaustive': exhaustive search
%               'Recursive': recursive MIP search
%               
% OUTPUTS:
%    complexes: indices of elements in complexes
%    phis_complexes: phi at the MIP of complexes
%    main_complexes: indices of elements in main complexes
%    phis_main_complexes: phi at the MIP of main complexes
%
% Jun Kitazono & Masafumi Oizumi, 2018


probs = data_to_probs(X, params, options);

[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_search_probs( probs, options );


end
