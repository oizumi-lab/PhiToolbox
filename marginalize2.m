function p_m = marginalize2(p,index,N,N_st)
% ---------------------------------
% PURPOSE: marginalize probability distribution p(X,Y)
% Input
% p: joint probability distribution of X and Y
% index: indexes over which p(X,Y) is marginalized
%
% Output
% p_m: marginalized probability distribution

%----------------------------------


N_sub = length(index);

p_m = zeros(2^N_sub,2^N_sub);

for i=1: 2^N
    sigma_i = base10toM(i-1,N,N_st);
    sub_i = baseMto10(sigma_i(index),N_st)+1;
    for j=1: 2^N
        sigma_j = base10toM(j-1,N,N_st);
        sub_j = baseMto10(sigma_j(index),N_st)+1;
        p_m(sub_i,sub_j) = p_m(sub_i,sub_j) + p(i,j);
    end
end

end