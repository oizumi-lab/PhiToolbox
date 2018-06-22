
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
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_Recursive_probs( probs, options );

[phis_sorted, idx_phis_sorted] = sort(Res.phi, 'descend');
h1 = figure;
subplot(2,1,1), imagesc(Res.Z(idx_phis_sorted,:)'),title('Subsets')
subplot(2,1,2), plot(phis_sorted), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')

h2 = figure;
VisualizeComplexes(Res, 1);
ylabel('\Phi')
xlabel('Indices')

[main_phis_sorted, idx_main_phis_sorted] = sort(phis_main_complexes, 'descend');
main_Complexes_str = cell(size(main_complexes));
for i = 1:length(main_complexes)
    main_Complexes_str{i} =  num2str(main_complexes{idx_main_phis_sorted(i)});
end
h3 = figure;
bar(main_phis_sorted)
set(gca, 'xticklabel', main_Complexes_str)
title('Main Complexes')
ylabel('\Phi')
xlabel('Indices of the main complexes')


[complexes_E, phis_complexes_E, main_complexes_E, phis_main_complexes_E, Res_E] = ...
    Complex_Exhaustive_probs( probs, options );