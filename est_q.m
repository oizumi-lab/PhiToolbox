function [q_TPM, q_past, q_joint, q_present] = est_q(X,N_s,tau,Z)

%-------------------------------------------------------------------------------------------------
% PURPOSE: estimate mismatched probability distribution q from discretized time series data X 
%
% INPUTS:
%   X: discretized time series data in form units x time
%   N_s: the number of states in each unit
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

N = size(X,1);
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
    M = M_cell{k};
    X_p = X(M,:);
    [q_past{k}, q_joint{k}, q_present{k}] = est_prior_joint(X_p,N_s,tau);
end

q_ind = cell(N_c,1);
for k=1: N_c
    N_k = length(M_cell{k}); % number of units in each cluster   
    q_k = zeros(N_s^N_k,N_s^N_k);
    for i=1: N_s^N_k % present
        for j=1: N_s^N_k % past
            if q_joint{k}(i,j) ~= 0
                q_k(i,j) = q_joint{k}(i,j)/q_past{k}(j);
            end
        end
    end
    q_ind{k} = q_k;
end

q_TPM = ones(N_s^N,N_s^N);
for i=1: N_s^N
    i_b = convert_index(i,M_cell,N,N_s,N_c);
    for j=1: N_s^N
        j_b = convert_index(j,M_cell,N,N_s,N_c);
        for k=1: N_c
            q_TPM(i,j) = q_TPM(i,j)*q_ind{k}(i_b(k),j_b(k));
        end
    end
end

end



function x_local = convert_index(x_global,M_cell,N,N_bin, N_c)

x_gb = base10toM(x_global-1,N,N_bin); % covert N_bin base

x_local = zeros(N_c,1);

for k=1: N_c
    M = M_cell{k};
    x_lb = x_gb(M); % N_bin base index in each cluster
    x_l = baseMto10(x_lb,N_bin) + 1; % index in each cluster
    x_local(k) = x_l;
end

end