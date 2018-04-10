function [Z_MIP, phi_MIP, Zs, phis] = MIP_search_probs( probs, options)
%-----------------------------------------------------------------------
% FUNCTION: MIP_search_probs.m
% PURPOSE: Find the Minimum Informamtion Partition by the exhaustive search
% from probability distirubtions
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

%
% OUTPUT:
%           Z_MIP: the MIP
%           phi_MIP: the amount of integrated information at the MIP
%-----------------------------------------------------------------------
%
% Jun Kitazono & Masafumi Oizumi, 2018


switch options.type_of_MIPsearch
    case 'Exhaustive'
        [Z_MIP, phi_MIP, Zs, phis] = MIP_Exhaustive( probs, options);
    case 'Queyranne'
        [Z_MIP, phi_MIP] = MIP_Queyranne( probs, options);
    case 'REMCMC'
         [Z_MIP, phi_MIP, ...
    phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = MIP_REMCMC( probs, options);
end