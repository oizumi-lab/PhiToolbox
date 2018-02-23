function [q_TPM, q_past, q_joint, q_present] = est_q(p_past, joint, p_present, N_st, Z)

%-------------------------------------------------------------------------------------------------
% PURPOSE: estimate mismatched probability distribution q from discretized time series data X 
%
% INPUTS:
%   X: discretized time series data in form units x time
%   N_st: the number of states in each unit
%   tau: time lag between past and present
%   Z: partition with which integrated information is computed
%
% OUTPUTS:
%   q_TPM: mismatched conditional probability distribution of present state
%   given past state (q(X^t|X^t-tau))
%   q_past: mismatached probability distribution of past state (X^t-tau)
%   q_joint: mismatched joint distribution of X^t (present) and X^(t-\tau) (past)
%   q_present: mismatched probability distribution of present state (X^t)
%-------------------------------------------------------------------------------------------------
%
% Masafumi Oizumi, 2018

N = length(Z); % number of units
if nargin < 4
    Z = 1: N;
end

N_c = max(Z); % number of clusters
M_cell = cell(N_c,1);
for k=1: N_c
    M_cell{k} = find(Z==k);
end

q_past = cell(N_c,1);
q_joint = cell(N_c,1);
q_present = cell(N_c,1);
for k=1: N_c
    index = M_cell{k};
    q_past{k} = marginalize(p_past, index,N,N_st);
    q_joint{k} = marginalize2(joint, index,N,N_st);
    q_present{k} = marginalize(p_present, index,N,N_st);
end

q_ind = cell(N_c,1);
for k=1: N_c
    N_k = length(M_cell{k}); % number of units in each cluster   
    q_k = zeros(N_st^N_k,N_st^N_k);
    for i=1: N_st^N_k % present
        for j=1: N_st^N_k % past
            if q_joint{k}(i,j) ~= 0
                q_k(i,j) = q_joint{k}(i,j)/q_past{k}(j);
            end
        end
    end
    q_ind{k} = q_k;
end

q_TPM = ones(N_st^N,N_st^N);
for i=1: N_st^N
    i_b = convert_index(i,M_cell,N,N_st,N_c);
    for j=1: N_st^N
        j_b = convert_index(j,M_cell,N,N_st,N_c);
        for k=1: N_c
            q_TPM(i,j) = q_TPM(i,j)*q_ind{k}(i_b(k),j_b(k));
        end
    end
end

end



function x_local = convert_index(x_global,M_cell,N,N_st, N_c)

x_gb = base10toM(x_global-1,N,N_st); % covert N_bin base

x_local = zeros(N_c,1);

for k=1: N_c
    M = M_cell{k};
    x_lb = x_gb(M); % N_st base index in each cluster
    x_l = baseMto10(x_lb,N_st) + 1; % index in each cluster
    x_local(k) = x_l;
end

end