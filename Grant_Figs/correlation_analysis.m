addpath(genpath('../PhiToolbox'))

%% load datasets

% condition = 'awake'; 
condition = 'anes';

% extract 1-minute signal
window_length = 60*1000; % 1 minute
subsampling_freq = 10; % Down-sample from 1kHz to 100Hz

switch condition
    case 'awake'
        load('Neurotycho/Data_AwakeEyesClosed.mat')
        X = X_AwakeEyesClosed(:, 1:subsampling_freq:window_length);
        % X_AwakeEyesClosed: 9 minutes signals of 64 channeles. 64 by 54000 (=9 minutes * 60 sec. * 1000Hz) matrix.
    case 'anes'
        load('Neurotycho/Data_Anesthetized.mat')
        X = X_Anesthetized(:, 1:subsampling_freq:window_length);
        % X_Anesthetized: 9 minutes signals of 64 channeles. 64 by 54000 (=9 minutes* 60 sec. * 1000Hz) matrix.
end

tau = 0;
isjoint = 0;
probs = Cov_comp(X,tau,isjoint);
Cov_X = probs.Cov_X;

N = length(Cov_X);
corr_X = size(N,N);
for i=1: N
    for j=1: N
        corr_X(i,j) = Cov_X(i,j)/sqrt(Cov_X(i,i)*Cov_X(j,j));
    end
end


imagesc(corr_X);
