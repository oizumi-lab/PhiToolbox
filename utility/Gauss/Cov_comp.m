function probs = Cov_comp(X,tau,isjoint)

T = size(X,2);

if isjoint
    t_range1 = 1: 1: T-tau;
    t_range2 = 1+tau: 1: T;
    
    X1 = X(:,t_range1);
    X1 = bsxfun(@minus, X1, mean(X1,2)); % subtract mean
    X2 = X(:,t_range2);
    X2 = bsxfun(@minus, X2, mean(X2,2)); % subtract mean
    
    Cov_X = X1*X1'/(T-tau-1); % equal-time covariance matrix at "PAST"
    Cov_Y = X2*X2'/(T-tau-1); % equal-time covariance matrix at "PRESENT"
    Cov_XY = X1*X2'/(T-tau-1); % time-lagged covariance matrix
    
    probs.Cov_Y = Cov_Y;
    probs.Cov_XY = Cov_XY;
else
    X = bsxfun(@minus, X, mean(X,2)); % subtract mean
    Cov_X = X*X'/(T-1); % equal-time covariance matrix
end

probs.Cov_X = Cov_X;

end