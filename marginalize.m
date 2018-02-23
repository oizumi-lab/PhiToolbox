function p_m = marginalize(p,index,N,N_st)
% ---------------------------------
% PURPOSE: marginalize probability distribution p(X)
% Input
% p: probability distribution of X
% index: indexes over which p(X) is marginalized
%
% Output
% p_m: marginalized probability distribution

%----------------------------------


N_sub = length(index);
p_m = zeros(2^N_sub,1);

for i=1: 2^N
    sigma = base10toM(i-1,N,N_st);
    
    % marginalize
    sub_i = baseMto10(sigma(index),N_st)+1;
    p_m(sub_i) = p_m(sub_i) + p(i);
end