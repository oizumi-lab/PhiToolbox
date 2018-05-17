
% Find the complex.
% Monkey ECoG data (Neurotycho.org)
% '20120730PF_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128'
addpath(genpath('../PhiToolbox'))

%% load datasets
load('Neurotycho/Data_AwakeEyesClosed.mat')
% X_AwakeEyesClosed: 9 minutes signals of 64 channeles. 64 by 54000 (=9 minutes * 60 sec. * 1000Hz) matrix. 
% X_Anesthetized: 9 minutes signals of 64 channeles. 64 by 54000 (=9 minutes* 60 sec. * 1000Hz) matrix. 

% extract 1-minute signal
window_length = 60*1000; % 1 minute
subsampling_freq = 10; % Down-sample from 1kHz to 100Hz
X = X_AwakeEyesClosed(:, 1:subsampling_freq:window_length);

%% 
% pre-define groups
groups = my_groups( 'Chibi', 'Large');

% plot pre-defined groups
N = 64;
groups_for_gscatter = zeros(N,1);
for i = 1:length(groups)
    groups_for_gscatter(groups{i}) = i;
end
CortexMap = load('ChibiMap_bipolar.mat');
figure(1)
imagesc(CortexMap.I), axis equal
hold on
clrs = hsv(length(groups));
%scatter(CortexMap.X, CortexMap.Y, 30, clrs(groups_for_gscatter,:), 'filled')
scatter(CortexMap.X(1:N), CortexMap.Y(1:N), 30, clrs(groups_for_gscatter,:), 'filled')
title('Pre-defined groups')
drawnow


%% find the complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type_of_dist = 'Gauss';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

type_of_phi = 'MI1';
% type_of_phi:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'MI': Multi (Mutual) information, e.g., I(X_1, Y_1; X_2, Y_2)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding
%    'Geo': phi_G, information geometry version

type_of_MIPsearch = 'Queyranne';
% type_of_MIPsearch: 
%    'exhaustive': 
%    'Queyranne': 
%    'REMCMC':

tau = 1; % time lag

% Convert data to covariance matrices
probs = data_to_probs(type_of_dist, X, tau);

%%% with pre-computed covariances %%%
disp('Searching the Complex...')
tic;
[indices_Complex, phi_Complex, indices, phis, Zs] = ...
    Complex_Exhaustive_probs( type_of_phi, type_of_MIPsearch, probs, 'groups', groups );
t = toc;
%  indices_Complex: indices of elements in the complex
%  phi_Complex: the amount of integrated information at the (estimated) MIP of the complex 
%  indices: the indices of every subsystem
%  phis: the amount of integrated information for every subsystem
%  Zs: the (estimated) MIP of every subsystem

% %%% without pre-computed covariances %%%
% [ indices_Complex, phi_Complex, indices, phis, Zs ] = ...
%    Complex_Exhaustive( type_of_dist, type_of_phi, type_of_MIPsearch, X, tau);

[complexes, phis_complexes, ] = find_complexes_repetitive(indices, phis, 1);


%% plot the comlex
figure(2)
imagesc(CortexMap.I), axis equal
hold on
scatter(CortexMap.X, CortexMap.Y, 'r')
scatter(CortexMap.X(complexes{1}), CortexMap.Y(complexes{1}), 'r', 'filled') 
title('Complex')


