
addpath(genpath('../../PhiToolbox'))


%% Set parameters of an AR model X(t+1) = AX(t) + E(t), where A is the connectivity matrix and E is Gaussian noise.
N = 6; % N: the number of elements

A = zeros(N); % A: the connextivity Matrix

A(1:2, 1:2) = 0.05;
A(3:6, 3:6) = 0.05;
A(5:6, 5:6) = 0.1;
A(1:(N+1):end) = 0.9; % self connections

A(1,3) = 0.01;
A(3,1) = 0.01;
A(2,4) = 0.01;
A(4,2) = 0.01;

A = A/N;

figure, imagesc(A), axis equal tight
title('Connectivity Matrix', 'FontSize', 18)
colorbar

sigmaE = 0.1; % sigmaE: std of noise

% Compute covariances of the stationary distribution
probs.number_of_elements = N;

if license('test', 'control_toolbox')
    product_info = ver('control');
    if ~isempty(product_info) % check if Control System Toolbox is installed.
        probs.Cov_X = dlyap(A, sigmaE^2*eye(N)); % 'dlyap' belongs to Control System Toolbox. 
        probs.Cov_XY = probs.Cov_X * A';
        probs.Cov_Y = probs.Cov_X;
    else
        probs.Cov_X = sigmaE^2 * eye(N,N) / (eye(N,N)-A*A); % This equation can be used only when A is symmetric.
        probs.Cov_XY = probs.Cov_X * A';
        probs.Cov_Y = probs.Cov_X;
    end
end

%% Find complexes
options.type_of_dist = 'Gauss';
options.type_of_MIPsearch = 'Queyranne';
options.type_of_phi = 'MI1';
options.type_of_complexsearch = 'Recursive';

[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
         Complex_search_probs( probs, options );

%% show results

% Set X and Y coordinates of nodes
XCoor_all = [0 0 1 1 2 2];
YCoor_all = [1 0 1 0 1 0];


color_level = (Res.phi - min(Res.phi))/(max(Res.phi)-min(Res.phi)); 
cmap = KovesiRainbow(256); % Get colormap KovesiRainbow (in PhiToolbox/tools/Colormaps/)

figure, hold on

indices = 1:N;
for i = 1:length(Res.phi)
    members = Res.Z(i,:)>0; % extract the members of i-th complex
    G_temp = ones(nnz(members));
    
    G_temp(1:(length(G_temp)+1):end) = 0;
    G = graph(G_temp);
    
    XCoor = XCoor_all(1,members);
    YCorr = YCoor_all(1,members);
    ZCorr = Res.phi(i) * ones(1,nnz(members));
    
    NodeLabel = indices(members);
    
    color_temp = cmap(floor(color_level(i)*255 + 1),:);
    
   if Res.isComplex(i)
       LineStyle = '-';
   else
       LineStyle = '--';
   end
    
    p = plot(G, 'XData', XCoor, ...
            'YData', YCorr, ...
            'ZData', ZCorr, ...
            'NodeLabel', NodeLabel, ...
            'NodeColor', color_temp, ...
            'EdgeColor', color_temp, ...
            'LineStyle', LineStyle, ...
            'MarkerSize', 10, ...
            'LineWidth', 2);
       
end


zlim([-0.01 0.14]*1e-4)
zlabel('$I^\mathrm{MIP}$', 'Interpreter', 'latex', 'FontSize', 18)

xticks([])
yticks([])
colormap(cmap)
c_handle = colorbar('Ticks', (0:4)/4, 'TickLabels', num2str( min(Res.phi) + (0:4)'*(max(Res.phi)-min(Res.phi))/4, 3));
c_handle.Label.Interpreter = 'latex';
c_handle.Label.FontSize = 18;
c_handle.Label.String = '$I^\mathrm{MIP}$';
view(-6.8, 11.6)
