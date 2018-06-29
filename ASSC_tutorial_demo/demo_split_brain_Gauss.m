
% Find the complex in a multivariate autoregressive model, 
%   X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

clear all;
addpath(genpath('../../PhiToolbox'))

%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

%%% construct connectivity matrix %%%
N = 10; % the number of elements

Z = zeros(N,1); % 1: left, 2:right
Z(1:N/2) = 1;
Z(N/2+1:N) = 2;

A_intra = 0.2;
A_inter = 0.4;

A = 0.1*eye(N); % A: connectivity matrix
for i=1: N
    for j=i+1: N
        if Z(i) == Z(j)
            A(i,j) = A_intra;
        else
            A(i,j) = A_inter;
        end
        A(j,i) = A(i,j);
    end
end

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
options.type_of_MIPsearch = 'Queyranne'; % type of MIP search
options.type_of_complexsearch = 'Recursive'; % type of complex search

%% Find complexes and main complexes
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_search(X, params, options );

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
        title('Complexes')
        subplot(2,1,2), plot(phis_sorted), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')
        title('\Phi_{MIP}')
        
        
        figure(4)
        VisualizeComplexes(Res, 1);
        ylabel('\Phi_{MIP}')
        xlabel('Indices')
        title('Candidates of complexes')
end