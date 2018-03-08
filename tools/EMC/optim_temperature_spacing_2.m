function [tau, T, Omega, ex_rate] = optim_temperature_spacing_2(meanE_curr, varE_curr, T_curr, Tmin_new, Tmax_new, nT )
%
% hogeeeee
% pp_meanE = spline(T_curr, meanE_curr);
% pp_varE = spline(T_curr, varE_curr);
pp_meanE = interp1(T_curr, meanE_curr, 'pchip', 'pp');
pp_varE = interp1(T_curr, varE_curr, 'pchip', 'pp');

cost_func = @(tau_int)cost_and_grad( pp_meanE, pp_varE, Tmin_new, Tmax_new, tau_int, min(varE_curr));
%tau_curr = T2tau(T_curr);
tau_init = zeros(nT-2,1);
%[Omega_init, ex_rate_init] = tau2Cost( pp_meanE, pp_varE, Tmin_new, Tmax_new, tau_init, -4, min(varE_curr));
% disp(['Omega_init: ', num2str(Omega_init)])
% disp(['ex_rate_init: ', num2str(ex_rate_init')])

options.Method = 'sd';
options.Display = 'off';
%options.MaxFunEvals = 10000;
%options.MaxIter = 5000;
%options.optTol = 1e-5;
%options.progTol =0;%1e-20;
[tau, Omega] = minFunc(cost_func, tau_init, options);

% options.Method = 'sd';
% [tau, Omega] = minFunc(cost_func, tau, options);
% disp(['T_curr:', num2str(T_curr')])
% disp(['tau:', num2str(tau)])

T = tau2T(Tmin_new, Tmax_new, tau);

% disp(['T: ', num2str(T')])

[~, ex_rate] = tau2Cost( pp_meanE, pp_varE, Tmin_new, Tmax_new, tau, -4, min(varE_curr));
% disp(['Omega: ', num2str(Omega)])
% disp(['ex_rate: ', num2str(ex_rate')])

%[~, grad_Omega] = cost_and_grad( pp_meanE, pp_varE, Tmin_new, Tmax_new, tau, min(varE_curr));
% disp(grad_Omega)

end

function [Omega, grad_Omega] = cost_and_grad( pp_meanE, pp_varE, T_st, T_end, tau_int, min_varE_curr)

r = -4;
eps = 1e-5;

Omega = tau2Cost( pp_meanE, pp_varE, T_st, T_end, tau_int, r, min_varE_curr);

grad_Omega = zeros(size(tau_int));
for i = 1:length(tau_int)
    eps_sub = eps * min(1, exp( tau_int(i) ));
    tau_int_l = tau_int;
    tau_int_l(i) = tau_int_l(i) - eps_sub/2;
    tau_int_u = tau_int;
    tau_int_u(i) = tau_int_u(i) + eps_sub/2;
    grad_Omega(i) = (tau2Cost( pp_meanE, pp_varE, T_st, T_end, tau_int_u, r, min_varE_curr ) - tau2Cost( pp_meanE, pp_varE, T_st, T_end, tau_int_l, r, min_varE_curr ))/eps_sub;
end

end

function [Omega, ex_rate] = tau2Cost( pp_meanE, pp_varE, T_st, T_end, tau, r, min_varE_curr)

% w = exp(-tau);
% T = [T_st; T_st + (T_end-T_st)*cumsum(w)./(1+sum(w)); T_end];
T = tau2T(T_st, T_end, tau);

meanE = ppval(pp_meanE, T);
varE = ppval(pp_varE, T);

if nnz(varE>0)~=0
    varE = max(varE, min(varE(varE>0)));
else
    varE = max(varE, min_varE_curr);
end

%varE = max(ppval(pp_varE, T), min(ppval(pp_varE, T)));

ex_rate = approx_ex_rate(meanE, varE, T);

Omega = sum(ex_rate.^r);

end

function T = tau2T(T_st, T_end, tau)
epsi = 10^-10;

min_tau = min(tau);

if min_tau < 0
    w = exp( -(tau-min_tau) ) + epsi;
    denom = exp(min_tau) + epsi + sum(w);
    numer = cumsum(w);
else
    w = exp( -(tau) ) + epsi;
    denom = 1 + epsi + sum(w);
    numer = cumsum(w);
end

T = [T_st; T_st + (T_end-T_st)*numer./denom; T_end];

end

% function tau = T2tau(T)
% 
% tau = log(T(end)-T(end-1));
% tau = tau - log( T(2:end-1)-T(1:end-2) );
% 
% end

function ex_rate = approx_ex_rate( meanE, varE, T )
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述

ex_rate = erfc( (meanE(2:end)-meanE(1:end-1))./sqrt(2*(varE(1:end-1)+varE(2:end))) ) / 2;
ex_rate = ex_rate + (1-ex_rate) .* exp( (1./T(2:end)-1./T(1:end-1)) .* (meanE(2:end)-meanE(1:end-1)) );
ex_rate = min(max(ex_rate, 1e-2), 1);

end

