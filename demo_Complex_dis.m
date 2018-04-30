
% Find the complex in a Boltzmann machine, 
%   input = beta*W*x;
%   prob(x=1) = sigmoid(input);
% where W is a connectivity matrix

clear all;

addpath(genpath('../PhiToolbox'))

%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

Z = [1 2 2 1 3 2 3 1];
Z = [1 2 3 3 2 1];
N = length(Z); % number of units
T = 10^6; % number of iterations

W = zeros(N,N);

for i=1: N
    for j=1: N
        if i~=j
            if Z(i) == Z(j)
                % W(i,j) = 0.2; % for N=8
                W(i,j) = 0.4; % for N=4
            else
                W(i,j) = 0;
            end
        else
            W(i,i) = 0.1;
        end
    end
end

beta = 4; % inverse temperature

X = generate_Boltzmann(beta,W,N,T); % generate time series of Boltzman machine

%% 

T_seg = 1000;
figure(1)
t_vec1 = 1: T_seg;
t_vec2 = 2*10^3: 2*10^3+T_seg;
t_vec3 = 10^4: 10^4+T_seg;
t_vec4 = 10^5: 10^5+T_seg;
t_vec5 = T-300: T;
subplot(3,2,1),imagesc(X(:,t_vec1));
subplot(3,2,2),imagesc(X(:,t_vec2));
subplot(3,2,3),imagesc(X(:,t_vec3));
subplot(3,2,4),imagesc(X(:,t_vec4));
subplot(3,2,5),imagesc(X(:,t_vec5));

%% compute correlation
R = corrcoef(X');
disp('Correlation Matrix')
disp(R);

figure(2)
[Z_sort, s_ind] = sort(Z);
imagesc(R(s_ind,s_ind));
set(gca, 'XTick', [1: 1: N], 'XTickLabel', s_ind); 
set(gca, 'YTick', [1: 1: N], 'YTickLabel', s_ind); 

%% find the complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.type_of_dist = 'discrete';
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

options.type_of_MIPsearch = 'Exhaustive';
% type_of_search: 
%    'Exhaustive': 
%    'Queyranne': 
%    'REMCMC':

params.tau = 1; % time delay
params.number_of_states = 2;  % number of states

%%% with pre-computed probabilities %%%
% Convert data to probabilities
% probs = data_to_probs(type_of_dist, X, tau, N_st);
% [indices_Complex, phi_Complex, indices, phis, Zs] = ...
%     Complex_Exhaustive_probs( type_of_phi, type_of_MIPsearch, probs );

% %%% without pre-computed probabilities %%%
[ indices_Complex, phi_Complex, indices, phis, Zs ] = ...
   Complex_Exhaustive( X, params, options);
%  indices_Complex: indices of elements in the complex
%  phi_Complex: the amount of integrated information at the (estimated) MIP of the complex 
%  indices: the indices of every subsystem
%  phis: the amount of integrated information for every subsystem
%  Zs: the (estimated) MIP of every subsystem

[complexes, phis_complexes] = find_complexes_repetitive(indices, phis, 1);

