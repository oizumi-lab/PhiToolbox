function SI = SI_dis(Z, N_st, p_past, p_joint, p_present)

%-------------------------------------------------------------------------------------------------
% PURPOSE: calculate stochastic interaction in discretized data
%
% INPUTS:
%   Z: partition
%   N_st: number of states in each unit
%   p_past: probability distribution of past state (X^t-tau)
%   joint: joint distribution of X^t (present) and X^(t-\tau) (past)
%   p_present: probability distribution of present state (X^t-tau)
%
% OUTPUTS:
%   SI: stochastic interaction proposed by Ay or Barrett & Seth  
%-------------------------------------------------------------------------------------------------
%
% Masafumi Oizumi, 2018

q_TPM = est_q(p_past, p_joint, p_present, N_st, Z);

TNS = length(p_past);

H_cond = 0;
H_cond_q = 0;

% i: present, j: past
for i=1: TNS
    for j=1: TNS
        if p_joint(i,j) ~= 0
            H_cond = H_cond - p_joint(i,j)*log(p_joint(i,j)/p_past(j));
        end
        
        if q_TPM(i,j) ~= 0
            H_cond_q = H_cond_q - p_joint(i,j)*log(q_TPM(i,j));
        end
    end
end

SI = H_cond_q - H_cond;

end