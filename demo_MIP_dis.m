%% globally coupled Map phase diagram

addpath(genpath('minFunc_2012'));

N = 6; % number of units
T = 10^6; % number of iterations
tau = 4; % time delay
N_st = 2;  % number of states

W = zeros(N,N);
% Z = [1 2 2 1 2 1 2 1];
Z = [1 2 2 1 2 1];

for i=1: N
    for j=1: N
        if i~=j
            if Z(i) == Z(j)
                % W(i,j) = 0.2; % for N = 8
                W(i,j) = 0.4;
            else
                W(i,j) = 0;
            end
        else
            W(i,i) = 0.1;
        end
    end
end

beta = 4; % inverse temperature

x_t = generate_Boltzman(beta,W,N,T); % generate time series of Boltzman machine

%% 

T_seg = 1000;
figure(1)
t_vec1 = 1: T_seg;
t_vec2 = 2*10^3: 2*10^3+T_seg;
t_vec3 = 10^4: 10^4+T_seg;
t_vec4 = 10^5: 10^5+T_seg;
t_vec5 = T-300: T;
subplot(3,2,1),imagesc(x_t(:,t_vec1));
subplot(3,2,2),imagesc(x_t(:,t_vec2));
subplot(3,2,3),imagesc(x_t(:,t_vec3));
subplot(3,2,4),imagesc(x_t(:,t_vec4));
subplot(3,2,5),imagesc(x_t(:,t_vec5));

%% compute correlation
R = corrcoef(x_t');
disp(R);

%% select data
n_vec = 1:N;
X = x_t(n_vec,:);

% % %% estimate probability distributions
% [p_past, joint, p_present] = est_prior_joint(X,N_st,tau);
% [q_TPM, q_past, q_joint, q_present] = est_q(p_past, joint, p_present, N_st, Z);
% 
% %% compute phi
% tic;
% [phi_star, I, H] = phi_star_dis(Z,N_st,p_past,joint,p_present); % quasi-Newton method (fast, but requires MinFunc)

% %% compute stochastic interaction (Phi_H)
% SI = SI_dis(p_past,joint,q_TPM);
% 
% %% compute Phi_I
% phi_I = phi_I_dis(I,q_past,q_joint,q_present);
% 
% %%
% fprintf('phi*=%f SI=%f phi_I=%f\n',phi_star,SI,phi_I);
% 
%% find MIP with pre-computed probability distributions
fprintf('Searching for MIP\n');
[p_past, joint, p_present] = est_prior_joint(X,N_st,tau);
probs{1} = p_past;
probs{2} = joint;
probs{3} = p_present;
params(1) = N;
params(2) = tau;
params(3) = N_st;
type_of_dist = 'dis';
type_of_phi = 'star';
[Z_MIP, phi_MIP, phis] =  MIP_Exhaustive_probs( type_of_dist, type_of_phi, params, probs);

disp(Z_MIP);
fprintf('phi_MIP=%f\n',phi_MIP);
toc;

%% find MIP without probability distributions
fprintf('Searching for MIP\n');
[Z_MIP, phi_MIP, phis] =  MIP_Exhaustive( type_of_dist, type_of_phi, X, params);

disp(Z_MIP);
fprintf('phi_MIP=%f\n',phi_MIP);




