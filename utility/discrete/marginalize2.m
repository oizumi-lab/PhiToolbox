function p_m = marginalize2(p,index,N, N_st)
% ---------------------------------
% PURPOSE: marginalize probability distribution p(X,Y)
% Input
% p: joint probability distribution of X and Y
% index: marginalized out other variables than those indicated by index
%
% Output
% p_m: marginalized probability distribution

%----------------------------------

TNS = size(p,1);
N_sub = length(index);

p_m = zeros(N_st^N_sub,N_st^N_sub);

for i=1: TNS
    sigma_i = base10toM(i-1,N,N_st);
    sub_i = baseMto10(sigma_i(index),N_st)+1;
    for j=1: TNS
        sigma_j = base10toM(j-1,N,N_st);
        sub_j = baseMto10(sigma_j(index),N_st)+1;
        p_m(sub_i,sub_j) = p_m(sub_i,sub_j) + p(i,j);
    end
end

end