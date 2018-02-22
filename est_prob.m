function [p_past, joint, p_present, q_TPM, q_past, q_joint, q_present] = est_prob(X,N_s,tau,Z)

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
%   q_TPM: conditional probability distribution
%   q_past: 
%   q_joint: 
%   q_present:
%-------------------------------------------------------------------------------------------------
%
% Masafumi Oizumi, 2018


[p_past, joint, p_present] = est_prior_joint(X,N_s,tau);
[q_TPM, q_past, q_joint, q_present] = est_q(X,N_s,tau,Z);