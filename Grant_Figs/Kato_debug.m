addpath(genpath('../../PhiToolbox'))
load A5.mat;

%% parameters
T = 10^7;
N = size(A,1);

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


%% Simulation
%% generating data
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end

%% Convert data to covariance matrices

tic;
probs = data_to_probs( X, params, options );
[Complexes, phis, Res, main_Complexes, main_phis] = Complex_Recursive_probs( probs, options );
toc;

figure(1)
hoge = sortrows([Res.phi, Res.Z], -1);
subplot(2,1,1), imagesc(hoge(:,2:end)'),title('Subsets')
subplot(2,1,2), plot(hoge(:,1)), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')

figure(2)
complexes_str = cell(size(Complexes));
for i = 1:length(Complexes)
    % complexes_str{i} =  num2str(Complexes_th{i});
    complexes_str{i} = length(Complexes{i});
end

bar(phis_th)
set(gca,'xticklabel', complexes_str)
title('Complexes')
ylabel('\Phi')
xlabel('Size of the complexes')

figure(3)
G = digraph(A);
plot(G)



%% theory
Cov_E = eye(N,N);
Cov_X_th = dlyap(A,Cov_E); 
probs.Cov_X = Cov_X_th;
probs.number_of_elements = N;
[Complexes_th, phis_th, Res_th, main_Complexes_th, main_phis_th] = Complex_Recursive_probs( probs, options );

figure(3)
hoge = sortrows([Res_th.phi, Res_th.Z], -1);
subplot(2,1,1), imagesc(hoge(:,2:end)'),title('Subsets')
subplot(2,1,2), plot(hoge(:,1)), xlim([0.5 length(Res_th.phi)+0.5]),title('\Phi')

figure(4)
complexes_str = cell(size(Complexes_th));
for i = 1:length(Complexes_th)
    % complexes_str{i} =  num2str(Complexes_th{i});
    complexes_str{i} = length(Complexes_th{i});
end

bar(phis_th)
set(gca,'xticklabel', complexes_str)
title('Complexes')
ylabel('\Phi')
xlabel('Size of the complexes')

figure(5)
G = digraph(A);
plot(G)