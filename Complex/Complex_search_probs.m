function [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_search_probs( probs, options)
% Complex_search_probs: Find complexes and main complexes from probability
% distributions
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

switch options.type_of_complexsearch
    case 'Exhaustive'
        [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_Exhaustive( probs, options);
    case 'Recursive'
         [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_Recursive( probs, options);
end

end