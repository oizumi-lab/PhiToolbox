clear all;

addpath(genpath('../PhiToolbox'))

%% parameters for computing phi
Z = [1 2]; % partition
tau = 1; % time delay
N_s = 2;  % number of states

%% important
params.tau = tau;
params.number_of_states = N_s;

%% generate time series from Boltzman machine
N = 2; % number of units
T = 10^6; % number of iterations
W = [0.1 0.6; 0.4 0.2]; % connectivity matrix
beta = 4; % inverse temperature
X = generate_Boltzmann(beta,W,N,T); 

%% compute phi from time series data X
options.type_of_dist = 'discrete';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

% available options of type_of_phi for discrete distributions:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding

% mutual information
options.type_of_phi = 'MI1';
MI = phi_comp(X, Z, params, options);

% phi*
options.type_of_phi = 'star';
phi_star = phi_comp(X, Z, params, options);

% stochastic interaction
options.type_of_phi = 'SI';
SI = phi_comp(X, Z, params, options);


%%
fprintf('MI=%f phi*=%f SI=%f\n',MI,phi_star,SI);

%% compute phi from pre-computed probability distributions

% mutual information
isjoint = 0; %  whether or not joint probability distributions are computed
probs = est_p(X,N_s,tau,isjoint);
% probs.p: probability distribution of X 

q_probs = est_q(Z,N_s,probs);
MI = MI1_dis(probs,q_probs);

% phi*
isjoint = 1; % whether or not joint probability distributions are computed
probs = est_p(X,N_s,tau,isjoint);
%  probs.past: probability distribution of past state (X^t-tau)
%  probs.joint: joint distribution of X^t (present) and X^(t-\tau) (past)
%  probs.present: probability distribution of present state (X^t)

q_probs = est_q(Z,N_s,probs);
phi_star = phi_star_dis(probs,q_probs);

% stochastic interaction
SI = SI_dis(probs,q_probs);


%%
fprintf('MI=%f phi*=%f SI=%f\n',MI,phi_star,SI);