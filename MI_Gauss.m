function MI = MI_Gauss(Cov_X,Cov_XY,Cov_Y,Z)

%-----------------------------------------------------------------------
% FUNCTION: MI_Gauss.m
% PURPOSE:  calculate Multi (Mutual) Information given covariance of data
%
% (Ay, 2001; Ay, 2015, Entropy; Barrett & Seth, 2011, PLoS Comp Biol)  
%
% INPUTS:   
%           Cov_X: covariance of data X (past, t-tau)
%           Cov_XY: cross-covariance of X (past, t-tau) and Y (present, t)
%           Cov_Y: covariance of data Y (present, t)
%           Z: partition of each channel (default: atomic partition)
%
% OUTPUT:
%           MI: multi interaction SI(Y|X) among subsystems
%
%  Jun Kitazono, 2017
%-----------------------------------------------------------------------

N = size(Cov_X,1); % number of channels
if nargin < 3
    Cov_Y = Cov_X;
end
if nargin < 4
    Z = 1: 1: N;
end

H = H_gauss([Cov_X, Cov_XY; Cov_XY', Cov_Y]);

%%
N_c = max(Z); % number of clusters
H_p = zeros(N_c,1);

for i=1: N_c
    M = find(Z==i);
    Cov_X_p = Cov_X(M,M);
    Cov_Y_p = Cov_Y(M,M);
    Cov_XY_p = Cov_XY(M,M);
    
    Cov_p = [Cov_X_p, Cov_XY_p; Cov_XY_p', Cov_Y_p];
    H_p(i) = H_gauss(Cov_p);
end

%% stochastic interaction
MI = sum(H_p) - H;


end