
% Find the complex in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

clear all;

addpath(genpath('../PhiToolbox'))


%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

%%% construct connectivity matrix %%%
N = 7; % the number of elements
A = eye(N)/N; % A: connectivity matrix
A(3:N-2, 3:N-2) = 1/N;
A(1:2, 1:2) = 1/N;
A(6:7, 6:7) = 0.5/N;

h_A = figure;
imagesc(A)
title('Connectivity Matrix A')
drawnow

%%% generate time series X using the AR model %%%
T = 10^6;
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end


%% find the complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.type_of_dist = 'Gauss';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

options.type_of_phi = 'star';
% type_of_phi:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'MI': Multi (Mutual) information, e.g., I(X_1, Y_1; X_2, Y_2)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding
%    'Geo': phi_G, information geometry version

options.type_of_MIPsearch = 'Queyranne';
% type_of_MIPsearch: 
%    'exhaustive': 
%    'Queyranne': 
%    'REMCMC':

params.tau = 1; % time lag

% Convert data to covariance matrices
% probs = data_to_probs(type_of_dist, X, tau);

%%% with pre-computed covariances %%%
% [indices_Complex, phi_Complex, indices, phis, Zs] = ...
%     Complex_Exhaustive_probs( type_of_phi, type_of_MIPsearch, probs );

% %%% without pre-computed covariances %%%
[ indices_Complex, phi_Complex, indices, phis, Zs ] = ...
   Complex_Exhaustive( X, params, options);
%  indices_Complex: indices of elements in the complex
%  phi_Complex: the amount of integrated information at the (estimated) MIP of the complex 
%  indices: the indices of every subsystem
%  phis: the amount of integrated information for every subsystem
%  Zs: the (estimated) MIP of every subsystem

[complexes, phis_complexes] = find_complexes_repetitive(indices, phis, 1);

numTops = 4;
[WeightedRatio, AveragedPhi] = AverageTopSubsets( indices, phis, N, numTops );

