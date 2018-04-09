
% Find Minimum Information Partition (MIP) in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

clear all;

%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

%%% construct connectivity matrix %%%
N = 10; % the number of elements
A = zeros(N); % A: connectivity matrix (block structured)
n_block = 2;
for i = 1:n_block
    indices_block = ((1+(i-1)*N/n_block):i*N/n_block)';
    A(indices_block, indices_block) = 1/N;
end
A = A + 0.01*randn(N)/sqrt(N);

h_A = figure;
imagesc(A)
drawnow
title('Connectivity Matrix A')

%%% generate random gaussian time series X %%%
T = 10^6;
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end

%% params
params.tau = 1;

%% find Minimum Information Partition (MIP)
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

%%%%%%%%%% without pre-computed covariances %%%%%%%%%%
disp('Find the MIP without pre-computed covariances')

%% Exhaustive search %%
options.type_of_MIPsearch = 'Exhaustive';

disp('Exhaustive Search...')
tic;
[Z_MIP_withoutCovs, phi_MIP_withoutCovs] = MIP_search( X, params, options);
t_Exhaustive_withoutCovs = toc;
disp(['Exhaustive Search finished. CalcTime=', num2str(t_Exhaustive_withoutCovs)] )
disp(['phi at the MIP: ', num2str(phi_MIP_withoutCovs)])
disp(['the MIP: ', num2str(Z_MIP_withoutCovs)])
disp(' ')

%% Queyranne's algorithm %%
options.type_of_MIPsearch = 'Queyranne';

disp('Queyranne''s algorithm...')
tic;
[Z_MIP_Q_withoutCovs, phi_MIP_Q_withoutCovs] = MIP_search( X, params, options );
t_Queyranne_withoutCovs = toc;
disp(['Exhaustive Search finished. CalcTime=', num2str(t_Queyranne_withoutCovs)])
disp(['phi at the MIP: ', num2str(phi_MIP_Q_withoutCovs)])
disp(['the MIP: ', num2str(Z_MIP_Q_withoutCovs)])
disp(' ')

%% Replica Exchange Markov Chain Monte Carlo (REMCMC) %%
options.type_of_MIPsearch = 'REMCMC';
options.ShowFig = 0;
options.nMCS = 100;
disp('REMCMC...')
tic;
[Z_MIP_REMCMC_withoutCovs, phi_MIP_REMCMC_withoutCovs] = MIP_search( X, params, options );
t_REMCMC_withoutCovs = toc;
disp(['REMCMC finished. CalcTime=', num2str(t_REMCMC_withoutCovs)])
disp(['phi at the estimated MIP: ', num2str(phi_MIP_REMCMC_withoutCovs)])
disp(['the estimated MIP: ', num2str(Z_MIP_REMCMC_withoutCovs)])
disp(' ')


%%%%%%%%%% with pre-computed covariances %%%%%%%%%%
% estimate covariance matrices
%   Note: If the sample size is small and the number of elements is large, the
%   empirical estimators of covariance matrices below will be very unstable.
%   see https://en.wikipedia.org/wiki/Estimation_of_covariance_matrices.
disp('Find the MIP with pre-computed covariances')

%% estimate covariance matrices
disp('Estimating probability distributions...')
probs = data_to_probs(X, params, options);

%% Exhaustive Search %%
disp('Exhaustive Search...')
tic;
[Z_MIP_with, phi_MIP_with, Zs, phis] = MIP_Exhaustive( probs, options );
t_Exhaustive_with = toc;
disp( ['Exhaustive Search finished. CalcTime=', num2str(t_Exhaustive_with)])
disp(['phi at the MIP: ', num2str(phi_MIP_with)])
disp(['the MIP: ', num2str(Z_MIP_with)])
disp(' ')

%% Queyeranne's algorithm %%%
disp('Queyranne''s algorithm...')
tic;
[Z_MIP_Q_with, phi_MIP_Q_with] = MIP_Queyranne( probs, options);
t_Queyranne_with = toc;
disp(['Queyranne''s algorithm finished. CalcTime=', num2str(t_Queyranne_with)])
disp(['phi at the estimated MIP: ', num2str(phi_MIP_Q_with)])
disp(['the estimated MIP: ', num2str(Z_MIP_Q_with)])
disp(' ')

%% Replica Exchange Markov Chain Monte Carlo (REMCMC) %%
options.ShowFig = 0;
options.nMCS = 100;
disp('REMCMC...')
tic;
[Z_MIP_REMCMC_with, phi_MIP_REMCMC_with, ...
    phi_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ...
    MIP_REMCMC( probs, options );
t_REMCMC_with = toc;
disp(['REMCMC finished. CalcTime=', num2str(t_REMCMC_with)])
disp(['phi at the estimated MIP: ', num2str(phi_MIP_REMCMC_with)])
disp(['the estimated MIP: ', num2str(Z_MIP_REMCMC_with)])
disp(' ')
