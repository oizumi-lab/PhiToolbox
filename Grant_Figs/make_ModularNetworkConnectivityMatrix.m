function As = make_ModularNetworkConnectivityMatrix(Z, w_intra, w_inter, ratios)

nElems = length(Z);
nModules = length(unique(Z));

A_base = zeros(nElems);

ration_intra = 0.5
for i = 1:nModules
    rand(nnz(Z==i),nnz(Z==i))
    A_base(Z==i, Z==i) = w_intra;
end
[row, col] = find(A_base==0);
A_base(1:(nElems+1):end) = 0;

As = cell(length(ratios),1);
for i = 1:length(ratios)
    As{i} = A_base;
end

for i = 1:length(row)
    if row(i) < col(i)
        rand_temp = rand;
        for j = 1:length(ratios)
            if ratios(j) > rand_temp
                As{j}(row(i), col(i)) = w_inter;
                As{j}(col(i), row(i)) = w_inter;
            end
        end
    end
end

end