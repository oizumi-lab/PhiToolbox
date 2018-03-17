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

%%  display time series
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

%% estimate probability distributions
type_of_dist = 'discrete';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution
disp('Estimating probability distributions from time series data...')
probs = data_to_probs(type_of_dist, X, tau, N_st);

%% compute phi
% available options of type_of_phi for discrete distributions:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding

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