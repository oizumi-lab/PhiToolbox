function accept = Metropolis_step(beta, subE)

beta_subE = beta*subE;

if (beta_subE < 0) || (exp( -beta_subE ) > rand(1))
    accept = 1;
    %E_curr = E_next;
    %if beta_subE > 0
    %    beta_subE
    %end
else
    accept = 0;
end

end