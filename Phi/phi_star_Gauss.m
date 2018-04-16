function [phi_star, I, beta_opt] = phi_star_Gauss(Cov_X,Cov_XY,Cov_Y,Z,beta_init)

%-----------------------------------------------------------------------
% FUNCTION: phi_star_Gauss.m
% PURPOSE:  calculate integrated information "phi_star" based on mismatched decoding 
% See Oizumi et al., 2016, PLoS Comp for the details
% http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004654
% 
% INPUTS:   
%           Cov_X: covariance of data X (PAST, t-tau)
%           Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%           Cov_Y: covariance of data Y (PRESENT, t)
%           Z: partition of each channel (default: atomic partition)
%           beta_init: initial value of beta (default: beta_int=1)
%
% OUTPUT:
%           phi_star: integrated information based on mismatched decoding
%           I: mutual information between X (past, t-tau) and Y (present, t)
%-----------------------------------------------------------------------
%
%  Masafumi Oizumi, 2016
%  Jun Kitazono, 2017
%
% Modification History
%   - Changed the optimization method for beta from steepest descent to
%   a quasi-Newton method (Jun Kitazono)
%   - Fixed a bug in computing phi_star (Masafumi Oizumi)
%
%  This code uses an open optimization toolbox "minFunc" written by M. Shmidt.
%  M. Schmidt. minFunc: unconstrained differentiable multivariate optimization in Matlab. 
%  http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
%  [Copyright 2005-2015 Mark Schmidt. All rights reserved]
%
% Last update: Feb 12, 2018

N = size(Cov_X,1); % number of channels
if nargin < 3
    Cov_Y = Cov_X;
end
if nargin < 4
    Z = 1: 1: N;
end
if nargin < 5
    beta_init = 1;
end

Cov_Y_X = Cov_cond(Cov_Y,Cov_XY',Cov_X); % conditional covariance matrix
H_cond = H_gauss(Cov_Y_X);

if isinf(H_cond) == 1
    fprintf('Alert: Infinite Entropy\n')
end

if isreal(H_cond) == 0
    fprintf('Alert: Complex Entropy\n')
end

H = H_gauss(Cov_Y); % entropy
I = H - H_cond; % mutual information

N_c = max(Z); % number of clusters
M_cell = cell(N_c,1);
for i=1: N_c
    M_cell{i} = find(Z==i);
end

X_D = zeros(N,N); % Cov_D(X^t-tau)
YX_D = zeros(N,N); % Cov_D(X^t,X^t-tau)
C_D_cond = zeros(N,N);
for i=1: N_c
    M = M_cell{i};
    Cov_X_p = Cov_X(M,M);
    Cov_Y_p = Cov_Y(M,M);
    Cov_YX_p = Cov_XY(M,M)';
    Cov_Y_X_p = Cov_cond(Cov_Y_p,Cov_YX_p,Cov_X_p);
    
    X_D(M,M) = Cov_X_p;
    YX_D(M,M) = Cov_YX_p;
    C_D_cond(M,M) = Cov_Y_X_p;
end

Cov_X_inv = inv(Cov_X);

C_D_beta1_inv = X_D\YX_D'/C_D_cond*YX_D/X_D; % 2nd term of eq. (26)/beta
S_left = C_D_cond'\YX_D/X_D;
S_right = X_D\YX_D'/C_D_cond;

I_s_d_Const_part = 1/2*N;

%% find beta by a quasi-Newton method
% if nargin < 3
%     beta_init = 1;
% end
beta = beta_init;

% set options of minFunc
Options.Method = 'lbfgs';
Options.Display = 'off';

%% minimize  negative I_s

[beta_opt,minus_I_s,~,~] = minFunc(@I_s_I_s_d,beta,Options);
I_s = -minus_I_s;

%% 
phi_star = I - I_s;

    function [minus_I_s, minus_I_s_d] = I_s_I_s_d(beta)
        C_D_beta_inv = beta*C_D_beta1_inv; % 2nd term of eq. (26)
        Q_inv = Cov_X_inv + C_D_beta_inv; % Q_inv
        
        norm_t = 1/2*logdet(Q_inv) + 1/2*logdet(Cov_X);
        R = beta*inv(C_D_cond) - beta^2*S_left/Q_inv*S_right;
        
        trace_t = 1/2*trace(Cov_Y*R);
        I_s = norm_t + trace_t - beta*I_s_d_Const_part;
        minus_I_s = -I_s;
        
        Q_d = -Q_inv\C_D_beta1_inv/Q_inv; %derivative of Q
        R_d = inv(C_D_cond) - beta*S_left*2/Q_inv*S_right - beta*S_left*beta*Q_d*S_right;
        
        I_s_d = 1/2*(-trace(Q_inv*Q_d) + trace(Cov_Y*R_d)) - I_s_d_Const_part; % derivative of I_s
        minus_I_s_d = -I_s_d;
    end


end