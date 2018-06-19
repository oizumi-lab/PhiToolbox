addpath(genpath('../PhiToolbox'))

options.type_of_dist = 'Gauss';
options.type_of_phi = 'MI1';
options.type_of_MIPsearch = 'Queyranne';
params.tau = 1;

Ns = 10:10:200;

for i = 1:length(Ns)
    N = Ns(i);
    A = 0.05*randn(N)/sqrt(N); % connectivity matrix
    Cov_E = 0.01*eye(N,N); % covariance matrix of E
    
    %% generate random gaussian time series X
    T = 10^6;
    X = zeros(N,T);
    X(:,1) = randn(N,1);
    for t=2: T
        E = randn(N,1);
        X(:,t) = A*X(:,t-1) + E;
    end
    
    % Convert data to covariance matrices
    probs{i} = data_to_probs( X, params, options );    
end

toolboxes = ver;
for i = 1:length(toolboxes)
    if strcmp(toolboxes(i).Name, 'Parallel Computing Toolbox')
        delete(gcp('nocreate'))
        numCores = feature('numCores');
        parpool(min(numCores, length(Ns)));
    end
end

ts = zeros(1,length(Ns));
parfor i = 1:length(Ns)
   tic;
   
   % Res = Complex_Search_Recursive( probs, options );
   [Complexes, phis, Res] = Complex_Recursive_probs( probs{i}, options );
   
   ts(i) = toc;
end

log10_Ns = log10(Ns);
log10_ts = log10(ts);
b = log10_ts/[ones(1,length(Ns)); log10_Ns];

Ns_fit = min(Ns):1:max(Ns);
ts_fit = 10.^(b*[ones(1,length(Ns_fit));log10(Ns_fit)]);

loglog(Ns_fit, ts_fit, '-k')
hold on
loglog(Ns, ts, 'or')
if b(1) > 0
    eq_expression = ['$$ \log_{10}(T)=$$',num2str(b(2)),' $$ \log_{10}(N)+$$', num2str(b(1))];
else
    eq_expression = ['$$ \log_{10}(T)=$$',num2str(b(2)),' $$ \log_{10}(N)$$', num2str(b(1))];
end
    
title(eq_expression,'Interpreter','latex')

set(gcf,'PaperPositionMode','auto')
pos(1) = 1;
pos(2) = 1;
pos(3) = 500;
pos(4) = 300;
set(gcf,'Position',pos);
print('-r0','-dpng','Calc_Time_Complex_Recursive');


    