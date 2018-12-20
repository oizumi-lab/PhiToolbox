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

% select target channels
target_ch = 1:62;
X = X(target_ch, :);
N = length(target_ch);


%% select type
type = 'Gauss';

switch type
    case 'Gauss'
        params.tau = 1;
        options.type_of_dist = 'Gauss'; % type of probability distributions
        options.type_of_phi = 'MI1'; % type of phi
        options.type_of_MIPsearch = 'Queyranne'; % type of MIP search
        options.type_of_complexsearch = 'Recursive'; % type of complex search
        options.normalization = 0; % normalization of phi by Entropy
        probs = data_to_probs(X, params, options);
        
        g = [];
        
    case 'UndirectedGraph'
        %% compute a graph
        params_ToGenerateGraph.tau = 1;
        
        options_ToGenerateGraph.type_of_dist = 'Gauss';
        options_ToGenerateGraph.type_of_phi = 'MI1';
        probs_ToGenerateGraph = data_to_probs(X, params_ToGenerateGraph, options_ToGenerateGraph);
        
        %%% Compute pairwise phi and set it as the weight of the graph %%%
        g = zeros(N,N);
        for i=1:N
            for j = (i+1):N
                
                probs_pair = ExtractSubsystem(...
                    options_ToGenerateGraph.type_of_dist, ...
                    probs_ToGenerateGraph, ...
                    [i,j]);
                g(i,j) = phi_comp_probs(options_ToGenerateGraph.type_of_dist, ...
                    options_ToGenerateGraph.type_of_phi, [1,2],probs_pair, options_ToGenerateGraph);
            end
        end
        g = g + g';
        
        probs.g = g;
        probs.number_of_elements = size(probs.g,1);
        
        options.type_of_dist = 'UndirectedGraph';
        options.type_of_MIPsearch = 'StoerWagner';
        options.type_of_complexsearch = 'Recursive';
        
        figure( 'PaperPositionMode', 'auto', 'Position', [50, 150, 600, 600]);
        % visualize the graph
        imagesc(g), axis equal tight, colorbar
        title('Graph')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_search_probs( probs, options );
t = toc;


% Visualize weighted average of main complexes
figure( 'PaperPositionMode', 'auto', 'Position', [100, 100, 1000, 600]);
[weight_mc, averagedPhi_mc] = AverageTopSubsets( main_complexes, phis_main_complexes, length(target_ch), length(phis_main_complexes) );

type_of_heatmap = 1;
bipolar = 1;
subplot(1,2,1)
make_ECoG_HeatMap( 'Chibi', target_ch, weight_mc, type_of_heatmap, bipolar)
title('Average of main complexes')


type_of_colormap = 'parula';
isshown = 1;
clim = [min(phis_main_complexes), max(phis_main_complexes)];
subplot(1,2,2)
[EdgePhis_mc, EdgeColors_mc] = ...
            ComplexGraphsECoGMap('Chibi', target_ch, ...
            main_complexes, phis_main_complexes, ...
            type_of_colormap, bipolar, g, isshown, clim);
title('main complexes')


% Visualize weighted average of complexes
figure( 'PaperPositionMode', 'auto', 'Position', [150, 50, 1000, 600]);
[weight_c, averagedPhi_c] = AverageTopSubsets( complexes, phis_complexes, length(target_ch), length(phis_complexes) );

type_of_heatmap = 1;
bipolar = 1;
subplot(1,2,1)
make_ECoG_HeatMap( 'Chibi', target_ch, weight_c, type_of_heatmap, bipolar)
title('Average of complexes')


type_of_colormap = 'parula';
isshown = 1;
clim = [min(phis_complexes), max(phis_complexes)];
subplot(1,2,2)
[EdgePhis_c, EdgeColors_c] = ...
            ComplexGraphsECoGMap('Chibi', target_ch, ...
            complexes, phis_complexes, ...
            type_of_colormap, bipolar, g, isshown, clim);
title('complexes')

