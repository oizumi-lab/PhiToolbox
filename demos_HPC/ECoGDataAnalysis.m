addpath(genpath('../../PhiToolbox'))

%% Preprocess data

% extract 1-minute signal
window_length = 60*1000; % 1 minute

load('misc/Neurotycho/X_window01.mat')
% X_128ch: 1-minute signals of 128 channeles. 128 by 920,321 (~ 15.3 minutes * 60 sec. * 1000Hz) matrix
X = Bipolar_Subtraction(X_128ch, 'Chibi'); % Bipolar re-referencing

% select target channels
target_ch = 1:62;
X = X(target_ch, :);
N = length(target_ch);

params.tau = 1;
options.type_of_dist = 'Gauss'; % type of probability distributions
options.type_of_phi = 'MI1'; % type of phi
options.type_of_MIPsearch = 'Queyranne'; % type of MIP search
options.type_of_complexsearch = 'Recursive'; % type of complex search
probs = data_to_probs(X, params, options);


%% Find complexes
tic;
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_search_probs( probs, options );
t = toc;


%% Plot the results
colormap(KovesiRainbow(256));
cLim = [min(phis_complexes), max(phis_complexes)];

CortexMap = load('ChibiMap_bipolar.mat');
XCoor = CortexMap.X(target_ch);
YCorr = CortexMap.Y(target_ch);

subplot(1,2,1) % Main complexes
image(CortexMap.I*(1/5)+4*256/5); axis equal, hold on
plotComplexes(main_complexes, phis_main_complexes, '2D', XCoor, YCorr, 'cLim', cLim, 'NodeLabel', [], 'LineWidth', 2)
colorbar
title('Main Complexes')

xlim([0.5 1000.5]);
ylim([0.5, 1250.5]);
set(gca, 'XTickLabel', [], 'YTickLabel', [], 'xtick', [], 'ytick', [])


subplot(1,2,2) % Complexes
image(CortexMap.I*(1/5)+4*256/5); axis equal, hold on
plotComplexes(complexes, phis_complexes, '2D',  XCoor, YCorr, 'cLim', cLim, 'NodeLabel', [], 'LineWidth', 2)
colorbar
title('Complexes')

xlim([0.5 1000.5]);
ylim([0.5, 1250.5]);
set(gca, 'XTickLabel', [], 'YTickLabel', [], 'xtick', [], 'ytick', [])