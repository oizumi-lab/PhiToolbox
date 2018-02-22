function [ R_c, R_interval ] = BrooksGelman( thetas, alpha )
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述


[N, M] = size(thetas);

mean_theta = zeros(M, 1);
var_theta = zeros(M, 1);
interval_theta = zeros(M, 1);


%% Calc R_c
for i = 1:M
    mean_theta(i) = mean(thetas(:,i));
    var_theta(i) = var(thetas(:,i));
end

mean_mean_theta = mean(mean_theta);

B = N*sum((mean_theta-mean_mean_theta).^2)/(M-1);
W = sum(var_theta)/M;

V_hat = (N-1)*W/N + (M+1)*B/(M*N);

cov_var_mean2 = cov(var_theta, mean_theta.^2);
cov_var_mean2 = cov_var_mean2(1,2);

cov_var_mean = cov(var_theta, mean_theta);
cov_var_mean = cov_var_mean(1,2);

var_V_hat = ((N-1)/N)^2*var(var_theta)/M + ((M+1)/(M*N))^2*2*B^2/(M-1) + ...
    2*(M+1)*(N-1)* (cov_var_mean2-2*mean_mean_theta*cov_var_mean) /(M^2*N);

df = 2*V_hat^2/var_V_hat;

R_c = sqrt((df+3)*V_hat/(W*(df+1)));


%% Calc R_interval
for i = 1:M
    theta_Alpha = my_prctile(thetas(:,i), alpha);
    theta_100MinusAalpha = my_prctile(thetas(:,i), 100-alpha);
    interval_theta(i) = theta_100MinusAalpha-theta_Alpha;
end
interval_all_theta = my_prctile(thetas(:), 100-alpha) - my_prctile(thetas(:), alpha);

R_interval = interval_all_theta/mean(interval_theta);

end

