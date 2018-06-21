
% This split brain demo finds and shows the complexes and main complexes.
% Each hemisphere consists of 4 elements and all elements connect with the
% others according to the values of w_inter_hemi and w_intra_hemi.
% Change the weight strength between hemispheres (w_inter_hemi) and find 
% where the complexes and main complexes are.
% 
%   input = beta*W*x;
%   prob(x=1) = sigmoid(input);
% where W is a connectivity matrix

clear all;

addpath(genpath('/Users/kaiomisawa/Documents/GitHub/PhiToolbox-master2_1'))

%% generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generating data...')

tic;
Z = [1 1 1 1 2 2 2 2];
N = length(Z); % number of units
T = 10^6; % number of interations

W = zeros(N,N);

w_inter_hemi = 0.2; % weight strength between hemispheres, 0 = full split,  
% 0.2 = whole brain integration,  0.4 = overweight

w_intra_hemi = 0.2; % weight strength in hemispheres, 0.2

for i=1: N
    for j=1: N
        if i~=j
            if Z(i) == Z(j)
                W(i,j) = w_intra_hemi;
            else
                W(i,j) = w_inter_hemi;
            end
        else
            W(i,i) = 0;
        end
    end
end

W(1,5) = w_inter_hemi * 1.1;
W(5,1) = w_inter_hemi * 1.1;
W(2,6) = w_inter_hemi * 1.1;
W(6,2) = w_inter_hemi * 1.1;
W(3,7) = w_inter_hemi * 1.1;
W(7,3) = w_inter_hemi * 1.1;
W(4,8) = w_inter_hemi * 1.1;
W(8,4) = w_inter_hemi * 1.1;


beta = 2; % inverse temperature

X = generate_Boltzmann(beta,W,N,T); % generate time series of Boltzman machine

%% 
% 
% T_seg = 1000;
% figure(1)
% t_vec1 = 1: T_seg;
% t_vec2 = 2*10^3: 2*10^3+T_seg;
% t_vec3 = 10^4: 10^4+T_seg;
% t_vec4 = 10^5: 10^5+T_seg;
% t_vec5 = T-300: T;
% subplot(3,2,1),imagesc(X(:,t_vec1));
% subplot(3,2,2),imagesc(X(:,t_vec2));
% subplot(3,2,3),imagesc(X(:,t_vec3));
% subplot(3,2,4),imagesc(X(:,t_vec4));
% subplot(3,2,5),imagesc(X(:,t_vec5));

%% compute correlation
% R = corrcoef(X');
% disp('Correlation Matrix')
% disp(R);
% 
% figure(2)
% [Z_sort, s_ind] = sort(Z);
% imagesc(R(s_ind,s_ind));
% set(gca, 'XTick', [1: 1: N], 'XTickLabel', s_ind); 
% set(gca, 'YTick', [1: 1: N], 'YTickLabel', s_ind); 

%% find the complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.type_of_dist = 'discrete';
% type_of_dist:
%    'Gauss': Gaussian distribution
%    'discrete': discrete probability distribution

options.type_of_phi = 'star';
% type_of_phi:
%    'MI1': Multi (Mutual) information, e.g., I(X_1; X_2). (IIT1.0)
%    'MI': Multi (Mutual) information, e.g., I(X_1, Y_1; X_2, Y_2)
%    'SI': phi_H, stochastic interaction
%    'star': phi_star, based on mismatched decoding
%    'Geo': phi_G, information geometry version

options.type_of_MIPsearch = 'Queyranne';
% type_of_search: 
%    'exhaustive': 
%    'Queyranne': 
%    'REMCMC':

params.tau = 1; % time delay
params.number_of_states = 2;  % number of states

% Convert data to covariance matrices
probs = data_to_probs( X, params, options );


% Res = Complex_Search_Recursive( probs, options );
[Complexes, phis, Res, main_Complexes, main_phis] = Complex_Recursive_probs( probs, options );

%% plot the results

% hoge = sortrows([Res.phi, Res.Z], -1);
% 
% figure
% subplot(2,1,1), imagesc(hoge(:,2:end)'),title('Subsets')
% subplot(2,1,2), plot(hoge(:,1)), xlim([0.5 length(Res.phi)+0.5]),title('\Phi')

show_Complexes(Complexes, phis, main_Complexes, main_phis, w_inter_hemi, w_intra_hemi, options)
% Elements filled with same color compose same complex (or main complex).
% Detalis are discribed in show_Complexes.m.

t = toc;

