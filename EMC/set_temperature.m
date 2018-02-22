function T = set_temperature(T, subE_history, ar, ar_tol)

ar_lb = ar*(1 - ar_tol);
ar_ub = ar*(1 + ar_tol);

beta = 1/T;

beta_min = 0;
T_min = 0;

mean_ar = 0;

tol = 1e-14;
while mean_ar < ar_lb || mean_ar > ar_ub
    if all(isinf(subE_history))
        disp('allInf!!!!!')
    end
    if isempty(find(subE_history>tol,1)) || all(isinf(subE_history))
        break
    end
    mean_ar = mean( exp( -beta*subE_history(subE_history>tol) ) );%%%%%%%%%%%
    
    if mean_ar < ar_lb;
        beta_max = beta;
        beta = (beta_min + beta)/2;
        T = 1/beta;
        T_min = 1/beta_max;
    elseif mean_ar > ar_ub;
        T_max = T;
        T = (T_min + T)/2;
        beta = 1/T;
        beta_min = 1/T_max;
    end
end

end
