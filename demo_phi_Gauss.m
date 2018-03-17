% compute several measures of integrated information in a multivariate autoregressive model, 
% X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

addpath(genpath('../PhiToolbox'))

N = 2; % the number of elements
A = [0.2 0.1; 0.5 0.2]; % connectivity matrix
Cov_E = eye(N,N); % covariance matrix of E

%% generate random gaussian time series X
T = 10^5;
X = zeros(N,T);
X(:,1) = randn(N,1);
for t=2: T
    E = randn(N,1);
    X(:,t) = A*X(:,t-1) + E;
end

%% estimate covariance matrices 
% Note: If the sample size is small and the number of elements is large, the
% empirical estimators of covariance matrices below will be very unstable.
% see https://en.wikipedia.org/wiki/Estimation_of_covariance_matrices.

type_of_dist = 'Gauss';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution
disp('Estimating probability distributions from time series data...')

tau = 1;
probs = data_to_probs(type_of_dist, X, tau);

%% compute phi
% available options of type_of_phi for Gaussian distributions:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding
%    'Geo': phi_G, information geometry version

Z = [1 2]; % labels of subsystems

% mutual information
type_of_phi = 'MI1';
MI = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

% stochastic interaction
type_of_phi = 'SI';
SI = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

% phi*
type_of_phi = 'star';
phi_star = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

% geometric phi
type_of_phi = 'Geo';
phi_G = phi_comp_probs(type_of_dist, type_of_phi, Z, probs);

%%
fprintf('MI=%f SI=%f phi*=%f phi_G=%f\n',MI,SI,phi_star,phi_G);

% %% analytically compute covariance
% Cov_X_th = dlyap(A,Cov_E); % MATLAB Control System Toolbox is required
% flag = sum(sum(isnan(Cov_X_th)));
% 
% if flag ~= 0
%     fprintf('Error!\n');
% end
% Cov_XY_th = A*Cov_X_th;
% Cov_Y_th = Cov_X_th;