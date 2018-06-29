%% compute integrated information in a multivariate autoregressive model, 
% X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

%% options
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


clear all;
addpath(genpath('../../PhiToolbox'))

%% generate random gaussian time series X
N = 4; % the number of elements

A_diag = [0.2 0.5; 0.5 0.2];
A_off = zeros(2,2);
A = [A_diag A_off; A_off A_diag];

figure(1)
imagesc(A);
title('Connectivity Matrix A');
colorbar;

Cov_E = eye(N,N); % covariance matrix of E
T = 10^5; % the total length of time series
X = zeros(N,T); % time series data

X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end


%% params
params.tau= 1; % time delay

%% options
options.type_of_dist = 'Gauss'; % type of probability distributions
options.type_of_phi = 'Geo'; % type of phi

Z = [1 1 2 2]; % partition with which phi is computed
% Z = [1 2 1 2]; % partition with which phi is computed

phi = phi_comp(X, Z, params, options);

%% show the resullts
fprintf('partition\n')
disp(Z);
fprintf('phi=%f\n',phi);