
% Find the complex.
% Monkey ECoG data (Neurotycho.org)
% '20120730PF_Anesthesia+and+Sleep_Chibi_Toru+Yanagawa_mat_ECoG128'
addpath(genpath('../PhiToolbox'))

%% load datasets

condition = 'awake'; 
% condition = 'anes';

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

%% 
% pre-define groups
% groups = my_groups( 'Chibi' );
groups = anatomical_groups( 'Chibi' );

target_ch = setdiff(1:64, groups{9});
N = length(target_ch);
X(groups{9},:)=[];
groups(9)=[];

% plot pre-defined groups
groups_for_gscatter = zeros(N,1);
for i = 1:length(groups)
    groups_for_gscatter(groups{i}) = i;
end
CortexMap = load('ChibiMap_bipolar.mat');

figure(1)
imagesc(CortexMap.I), axis equal
hold on
%gscatter(CortexMap.X(1:N), CortexMap.Y(1:N), groups_for_gscatter, [], [], 20)
clrs = hsv(length(groups));
scatter(CortexMap.X(target_ch), CortexMap.Y(target_ch), 30, clrs(groups_for_gscatter,:), 'filled')
title('Pre-defined groups')
drawnow

%% find the complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.type_of_dist = 'Gauss';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

options.type_of_phi = 'MI1';
% type_of_phi:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'MI': Multi (Mutual) information, e.g., I(X_1, Y_1; X_2, Y_2)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding
%    'Geo': phi_G, information geometry version

options.type_of_MIPsearch = 'Queyranne';
% type_of_MIPsearch: 
%    'exhaustive': 
%    'Queyranne': 
%    'REMCMC':

options.groups = groups;

params.tau = 1; % time lag

tic;
[indices_Complex, phi_Complex, indices, phis, Zs] = ...
    Complex_Exhaustive( X, params, options );
t = toc;
%  indices_Complex: indices of elements in the complex
%  phi_Complex: the amount of integrated information at the (estimated) MIP of the complex 
%  indices: the indices of every subsystem
%  phis: the amount of integrated information for every subsystem
%  Zs: the (estimated) MIP of every subsystem

% %%% without pre-computed covariances %%%
% [ indices_Complex, phi_Complex, indices, phis, Zs ] = ...
%    Complex_Exhaustive( type_of_dist, type_of_phi, type_of_MIPsearch, X, tau);

[complexes, phis_complexes] = find_complexes_repetitive(indices, phis, 1);

%% plot the comlex
figure(2)
imagesc(CortexMap.I), axis equal
hold on
scatter(CortexMap.X(target_ch), CortexMap.Y(target_ch), 'r')
scatter(CortexMap.X(complexes{1}), CortexMap.Y(complexes{1}), 'r', 'filled') 
title('Complex')

%%
% plot Average of the subsets with the top (numTops) phi
numTops = 6; % The average is taken for Top (numTops) phi
type_of_heatmap = 1;
bipolar = 1;
[WeightedRatio, AveragedPhi] = AverageTopSubsets( indices, phis, N, numTops ); %Calculate average
figure(3)
make_ECoG_HeatMap( 'Chibi', target_ch, WeightedRatio, type_of_heatmap, bipolar )
title(['Average of the top ', num2str(numTops)])
