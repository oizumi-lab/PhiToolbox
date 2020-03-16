addpath(genpath('../../PhiToolbox'))

%% Set parameters and options
n_elems = 200;
sigmaA = 0.1;
sigmaE = 0.1;

A = sigmaA*randn(n_elems)/sqrt(n_elems);

Cov_X = dlyap(A, sigmaE^2*eye(n_elems));
Cov_XY = Cov_X * A';
Cov_Y = Cov_X;

probs.Cov_X = Cov_X;
probs.Cov_XY = Cov_XY;
probs.Cov_Y = Cov_Y;
probs.number_of_elements = n_elems;


options.type_of_dist = 'Gauss';
options.type_of_phi = 'MI1';
options.type_of_MIPsearch = 'Queyranne';


%% Measure computation time
% Exhaustive search
options.type_of_complexsearch = 'Exhaustive';
nsExhaustive = (3:10)';% In the paper, this was set to (3:16)'.

tsExhaustive = zeros(size(nsExhaustive));
for i = length(nsExhaustive):-1:1
    probs_sub = ExtractSubsystem(options.type_of_dist, probs, 1:nsExhaustive(i));
    
    tic;
    [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
        Complex_search_probs( probs_sub, options );
    tsExhaustive(i) = toc;
    
end

% Hierarchical partitioninf for complex search (HPC)
options.type_of_complexsearch = 'Recursive';
nsHPC = (10:10:40)'; % In the paper, this was set to (10:10:200)'.

tsHPC = zeros(size(nsHPC));
for i = length(nsHPC):-1:1
    probs_sub = ExtractSubsystem(options.type_of_dist, probs, 1:nsHPC(i));
    
    tic;
    [complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
        Complex_search_probs( probs_sub, options );
    tsHPC(i) = toc;
    
end


%% Plot results

% Fitting analysis
ft_Ex = fittype('my_powerOf10(x, a, b)');
f_Ex = fit( log10(nsExhaustive), log10(tsExhaustive), ft_Ex, 'StartPoint', [0.4, -3], 'Exclude', 1:5  );

ft_HPC = fittype('my_linear(x, a, b)');
f_HPC = fit( log10(nsHPC), log10(tsHPC), ft_HPC, 'StartPoint', [5, -7]);
% f_HPC = fit( log10(nsHPC), log10(tsHPC), ft_HPC, 'StartPoint', [5, -7], 'Exclude', 1:5 ); % In the paper, the first five points were discarded from the fitting analysis. 

% Plot
figure
loglog(nsExhaustive, tsExhaustive, 'k^', 'MarkerSize', 8);
hold on

log10_ns_fit_Ex = log10(3):0.1:log10(40);
log10_ts_fit_Ex = f_Ex(log10_ns_fit_Ex);
loglog(10.^(log10_ns_fit_Ex), 10.^(log10_ts_fit_Ex), 'k--', 'LineWidth', 2);


loglog(nsHPC, tsHPC, 'ro', 'MarkerSize', 8);

log10_ns_fit_HPC = log10(1):0.1:log10(2000);
log10_ts_fit_HPC = f_HPC(log10_ns_fit_HPC);
loglog(10.^(log10_ns_fit_HPC), 10.^(log10_ts_fit_HPC), 'r-', 'LineWidth', 2);

xlim([1e0, 2e3])
ylim([1e-2, 1e10])
xlabel('Number of elements', 'FontSize', 20)
ylabel('Computation time (sec.)', 'FontSize', 20)
set(gca, 'FontSize', 16)

legend({'Exhaustive', 'Exhaustive, fitted', 'HPC', 'HPC, fitted'})



