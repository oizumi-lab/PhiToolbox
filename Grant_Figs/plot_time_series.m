X = X_AwakeEyesClosed;

N = 10;
t_range = 1: 1000;
for i=1: N
    subplot(N,1,i), plot(X(i,t_range));
end