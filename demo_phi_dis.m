addpath(genpath('../PhiToolbox'))

%% parameters for computing phi
Z = [1 2]; % partition
tau = 1; % time delay
N_st = 2;  % number of states

%% generate time series from Boltzman machine
N = 2; % number of units
T = 10^6; % number of iterations
W = [0.1 0.6; 0.4 0.2]; % connectivity matrix
beta = 4; % inverse temperature
X = generate_Boltzmann(beta,W,N,T); 

%% compute phi from time series data X
type_of_dist = 'discrete';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

% available options of type_of_phi for discrete distributions:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding

% mutual information
type_of_phi = 'MI1';
MI = phi_comp(type_of_dist, type_of_phi, Z, X, tau, N_st);

% stochastic interaction
type_of_phi = 'SI';
SI = phi_comp(type_of_dist, type_of_phi, Z, X, tau, N_st);

% phi*
type_of_phi = 'star';
phi_star = phi_comp(type_of_dist, type_of_phi, Z, X, tau, N_st);

%%
fprintf('MI=%f SI=%f phi*=%f\n',MI,SI,phi_star);

%% compute phi from pre-computed covariance matrices

%% estimate probability distributions
disp('Estimating probability distributions from time series data...')
probs = data_to_probs(type_of_dist, X, tau, N_st);

%% compute phi
% mutual information
type_of_phi = 'MI1';
MI = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

% stochastic interaction
type_of_phi = 'SI';
SI = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

% phi*
type_of_phi = 'star';
phi_star = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

%%
fprintf('MI=%f SI=%f phi*=%f\n',MI,SI,phi_star);