%% Find Minimum Information Partition (MIP) in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

%% options
%           options: options for computing phi and MIP search
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

clear all;
addpath(genpath('../../PhiToolbox'))

%% generate time series data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating time series data...')

%%% construct connectivity matrix %%%
N = 20; % the number of elements
A = zeros(N); % A: connectivity matrix (block structured)
n_block = 2;
for i = 1:n_block
    indices_block = ((1+(i-1)*N/n_block):i*N/n_block)';
    A(indices_block, indices_block) = 1/N;
end
A = A + 0.01*randn(N)/sqrt(N);

figure(1)
imagesc(A)
title('Connectivity Matrix A')
colorbar;

%%% generate random gaussian time series X %%%
T = 10^6;
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end

%% params
params.tau = 1; % time delay

%% options
options.type_of_dist = 'Gauss'; % type of probability distributions
options.type_of_phi = 'Geo'; % type of phi
options.type_of_MIPsearch = 'Queyranne'; % type of MIP search

%% find Minimum Information Partition (MIP)
tic;
[Z_MIP, phi_MIP] = MIP_search(X, params, options );
CalcTime = toc;

disp( ['CalcTime=', num2str(CalcTime)])
disp(['phi at the MIP: ', num2str(phi_MIP)])
disp(['the MIP: ', num2str(Z_MIP)])
disp(' ')