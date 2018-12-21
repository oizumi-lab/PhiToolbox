%% Find the complex in a Boltzmann machine, 
%   input = beta*W*x;
%   prob(x=1) = sigmoid(input);
% where W is a connectivity matrix

%% options
%           options: options for computing phi, MIP search, and complex
%           search
%           
%           options.type_of_dist:
%              'Gauss': Gaussian distribution
%              'discrete': discrete probability distribution
%              'UndirectedGraph': Undirected Graph
%           options.type_of_phi:
%              'MI1': Multi (Mutual) information. I(X_1; X_2). (IIT1.0)
%              'MI': Multi (Mutual) information, I(X_1, Y_1; X_2, Y_2)
%              'SI': phi_H, stochastic interaction
%              'star': phi_star, based on mismatched decoding
%              'Geo': phi_G, information geometry version
%           options.type_of_MIPsearch
%              'Exhaustive': exhaustive search
%              'Queyranne': Queyranne algorithm
%              'REMCMC': Replica Exchange Monte Carlo Method 
%              'StoerWagner': mincut search algorithm for undirected graphs
%           options.type_of_complexsearch
%               'Exhaustive': exhaustive search
%               'Recursive': recursive MIP search
%           options.normalization
%              (Available only when the dist. is 'Gauss' and the complex search is 'Exhaustive')
%              Regarding normalization of phi by Entropy when searching
%              the MIPs. 
%                 0: without normalization (default)
%                 1: with normalization
%              Note that, after finding the MIPs, phi wo/ normalization at
%              the MIPs is used to compare subsets and find the complexes in both options. 

clear all;
addpath(genpath('../PhiToolbox'))

%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

Z = [1 2 3 3 2 1];
N = length(Z); % number of units
T = 10^6; % number of iterations

W = zeros(N,N);

for i=1: N
    for j=1: N
        if i~=j
            if Z(i) == Z(j)
                % W(i,j) = 0.2; % for N=8
                W(i,j) = 0.4; % for N=4
            else
                W(i,j) = 0;
            end
        else
            W(i,i) = 0.1;
        end
    end
end

beta = 4; % inverse temperature

X = generate_Boltzmann(beta,W,N,T); % generate time series of Boltzman machine

%% 

T_seg = 1000;
figure(1)
t_vec1 = 1: T_seg;
t_vec2 = 2*10^3: 2*10^3+T_seg;
t_vec3 = 10^4: 10^4+T_seg;
t_vec4 = 10^5: 10^5+T_seg;
t_vec5 = T-300: T;
subplot(3,2,1),imagesc(X(:,t_vec1));
subplot(3,2,2),imagesc(X(:,t_vec2));
subplot(3,2,3),imagesc(X(:,t_vec3));
subplot(3,2,4),imagesc(X(:,t_vec4));
subplot(3,2,5),imagesc(X(:,t_vec5));

%% compute correlation
R = corrcoef(X');
disp('Correlation Matrix')
disp(R);

figure(2)
[Z_sort, s_ind] = sort(Z);
imagesc(R(s_ind,s_ind));
set(gca, 'XTick', [1: 1: N], 'XTickLabel', s_ind); 
set(gca, 'YTick', [1: 1: N], 'YTickLabel', s_ind); 

%% find the complex
options.type_of_dist = 'discrete';
options.type_of_phi = 'MI1';
options.type_of_MIPsearch = 'Queyranne';
options.type_of_complexsearch = 'Exhaustive';
options.normalization = 0;% normalization of phi by Entropy

params.tau = 1; % time delay
params.number_of_states = 2;  % number of states

%% Find complexes and main complexes
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
   Complex_search( X, params, options);

%% show results
main_complexes_str = cell(size(main_complexes));
for i = 1:length(main_complexes)
    main_complexes_str{i} =  num2str(main_complexes{i});
end
figure(2)
bar(phis_main_complexes)
set(gca, 'xticklabel', main_complexes_str)
title('Main Complexes')
ylabel('\Phi_{MIP}')
xlabel('Indices of the main complexes')

[phis_sorted, idx_phis_sorted] = sort(Res.phi, 'descend');
figure(3)
subplot(2,1,1), imagesc(Res.Z(idx_phis_sorted,:)'),title('Subsets')
title('Candidates of complexes')
subplot(2,1,2), plot(phis_sorted), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')
title('\Phi_{MIP}')

switch options.type_of_complexsearch
    case 'Recursive'
        figure(4)
        VisualizeComplexes(Res, 1);
        ylabel('\Phi_{MIP}')
        xlabel('Indices')
        title('Candidates of complexes')
end
