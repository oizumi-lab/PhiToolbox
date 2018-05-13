
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
% N = 10;
% A = 0.01*randn(N)/sqrt(N);

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

options.type_of_phi = 'MI1';
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
probs = data_to_probs( X, params, options );


% Res = Complex_Search_Recursive( probs, options );
[Complexes, phis, Res, main_Complexes, main_phis] = Complex_Recursive_probs( probs, options );

figure
hoge = sortrows([Res.phi, Res.Z], -1);
subplot(2,1,1), imagesc(hoge(:,2:end)'),title('Subsets')
subplot(2,1,2), plot(hoge(:,1)), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')


