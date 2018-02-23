function [Z_MIP, phi_MIP, phis] = MIP_Exhaustive_probs( type_of_dist, type_of_phi, params, probs)

N = params(1);
all_comb = power_set(2:N);
nComb = length(all_comb);
phis = zeros(nComb,1);

for i=1: nComb
    subcluster = all_comb{i};
    Z = ones(1,N);
    Z(subcluster) = 2;
    % compute phi
    phis(i) = phi_comp_probs(type_of_dist, type_of_phi, Z, params, probs);
end

[phi_MIP, MIP_ind] = min(phis);

Z_MIP = ones(1,N);
Z_MIP(all_comb{MIP_ind}) = 2;



end