% compute several measures of integrated information in a multivariate autoregressive model, 
% X^t = A*X^{t-1} + E,
% where A is a connectivity matrix and E is gaussian noise.

addpath(genpath('minFunc_2012')) % Add 'minFunc_2012' to search path

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

tau = 1; % time lag
t_range1 = 1: 1: T-tau;
t_range2 = 1+tau: 1: T;

X1 = X(:,t_range1);
X1 = bsxfun(@minus, X1, mean(X1,2)); % subtract mean
X2 = X(:,t_range2);
X2 = bsxfun(@minus, X2, mean(X2,2)); % subtract mean

Cov_X = X1*X1'/(T-tau-1); % equal-time covariance matrix at past
Cov_Y = X2*X2'/(T-tau-1); % equal-time covariance matrix at present
Cov_XY = X1*X2'/(T-tau-1); % time-lagged covariance matrix

%% compute phi
Z = [1 2]; % labels of subsystems

 [SI, I, H] = SI_Gauss(Cov_X,Cov_XY,Cov_Y,Z); % stochastic interaction
fprintf('Stochastic interaction=%f Mutual information=%f Entropy=%f\n',SI,I,H);

phi_star = phi_star_Gauss(Cov_X,Cov_XY,Cov_Y,Z); % Phi* (Oizumi et al., 2016, PLoS Comp)
fprintf('phi_star=%f\n',phi_star);

phi_G = phi_G_Gauss(Cov_X,Cov_XY,Cov_Y,Z); %  Phi_G (Oizumi et al., 2016, PNAS)
fprintf('phi_G=%f\n',phi_G);


% %% analytically compute covariance
% Cov_X_th = dlyap(A,Cov_E); % MATLAB Control System Toolbox is required
% flag = sum(sum(isnan(Cov_X_th)));
% 
% if flag ~= 0
%     fprintf('Error!\n');
% end
% Cov_XY_th = A*Cov_X_th;
% Cov_Y_th = Cov_X_th;