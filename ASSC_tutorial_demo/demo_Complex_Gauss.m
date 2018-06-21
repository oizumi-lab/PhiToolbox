
% Find the complex in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

clear all;

addpath(genpath('../PhiToolbox'))


%% generate time series data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating time series data...')

%%% construct connectivity matrix %%%
N = 7; % the number of elements
A = eye(N)/N; % A: connectivity matrix
A(3:N-2, 3:N-2) = 1/N;
A(1:2, 1:2) = 1/N;
A(6:7, 6:7) = 0.5/N;
A = A + 0.01*randn(N)/sqrt(N);

figure(1)
imagesc(A)
title('Connectivity Matrix A')
colorbar;

%%% generate time series X using the AR model %%%
T = 10^6;
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end


%% params
params.tau = 1; % time lag

%% options
options.type_of_dist = 'Gauss'; % type of probability distribution
options.type_of_phi = 'Geo'; % type of phi
options.type_of_MIPsearch = 'Queyranne'; % type of MIP search

%% find the complex
[Complexes, phis, Res, main_Complexes, main_phis] = Complex_Recursive(X, params, options);

figure(2)
hoge = sortrows([Res.phi, Res.Z], -1);
subplot(2,1,1), imagesc(hoge(:,2:end)'),title('Subsets')
subplot(2,1,2), plot(hoge(:,1)), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')