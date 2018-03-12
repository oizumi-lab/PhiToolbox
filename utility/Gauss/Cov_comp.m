function [Cov_X, Cov_XY, Cov_Y] = Cov_comp(X,tau)

T = size(X,2);

t_range1 = 1: 1: T-tau;
t_range2 = 1+tau: 1: T;

X1 = X(:,t_range1);
X1 = bsxfun(@minus, X1, mean(X1,2)); % subtract mean
X2 = X(:,t_range2);
X2 = bsxfun(@minus, X2, mean(X2,2)); % subtract mean

Cov_X = X1*X1'/(T-tau-1); % equal-time covariance matrix at "PAST"
Cov_Y = X2*X2'/(T-tau-1); % equal-time covariance matrix at "PRESENT"
Cov_XY = X1*X2'/(T-tau-1); % time-lagged covariance matrix

end