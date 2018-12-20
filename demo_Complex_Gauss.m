%% Find the complex in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

%% options
%           options: options for computing phi, MIP search, and complex
%           search
%           
%           options.type_of_dist:
%              'Gauss': Gaussian distribution
%              'discrete': discrete probability distribution
%           options.type_of_phi:
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'SI': phi_H, stochastic interaction
%              'star': phi_star, based on mismatched decoding
%              'Geo': phi_G, information geometry version
%           options.type_of_MIPsearch
%              'Exhaustive': exhaustive search
%              'Queyranne': Queyranne algorithm
%              'REMCMC': Replica Exchange Monte Carlo Method 
%           options.type_of_complexsearch
%               'Exhaustive': exhaustive search
%               'Recursive': recursive MIP search
%           options.normalization
%              (Available only when the dist. is 'Gauss' and the complex search is 'Exhaustive')
%              Regarding normalization of phi by Entropy when searching
%              the MIPs. 
%                 0: without normalization (default)
%                 1: with normalization
%              Note that, after finding the MIPs, phi wo/ normalization at
%              the MIPs is used to compare subsets and find the complexes in both options. 

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
A = A + 0.01*randn(N)/sqrt(N);

figure(1)
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

%% params
params.tau = 1; % time lag

%% options
options.type_of_dist = 'Gauss'; % type of probability distributions
options.type_of_phi = 'MI1'; % type of phi
options.type_of_MIPsearch = 'Exhaustive'; % type of MIP search
options.type_of_complexsearch = 'Recursive'; % type of complex search
options.normalization = 0; % normalization of phi by Entropy

%% Find complexes and main complexes
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_search( X, params, options );

%% show results
main_complexes_str = cell(size(main_complexes));
for i = 1:length(main_complexes)
    main_complexes_str{i} =  num2str(main_complexes{i});
end
figure(2)
bar(phis_main_complexes)
set(gca, 'xticklabel', main_complexes_str)
title('Main Complexes')
ylabel('\Phi_{MIP}')
xlabel('Indices of the main complexes')

switch options.type_of_complexsearch
    case 'Recursive'
        [phis_sorted, idx_phis_sorted] = sort(Res.phi, 'descend');
        figure(3)
        subplot(2,1,1), imagesc(Res.Z(idx_phis_sorted,:)'),title('Subsets')
        title('Candidates of complexes')
        subplot(2,1,2), plot(phis_sorted), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')
        title('\Phi_{MIP}')
        
        figure(4)
        VisualizeComplexes(Res, 1);
        ylabel('\Phi_{MIP}')
        xlabel('Indices')
        title('Candidates of complexes')
end