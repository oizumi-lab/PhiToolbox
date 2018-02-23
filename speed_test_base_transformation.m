N = 21;
M = 2;

tic;
parfor i=1: 2^N
    sigma = base10toM_mex(i,N,2);
    x = baseMto10_mex(sigma,M);
end
toc;


tic;
parfor i=1: 2^N
    sigma = base10toM(i,N,2);
    x = baseMto10(sigma,M);
end
toc;

tic;
parfor i=1: 2^N
    sigma = base10toM_mex(i,N,2);
    x = baseMto10_mex(sigma,M);
end
toc;

tic;
parfor i=1: 2^N
    sigma = base10toM(i,N,2);
    x = baseMto10(sigma,M);
end
toc;