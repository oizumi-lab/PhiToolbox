function X = Bipolar_Subtraction( X_raw, monkeyname )
%bipolar subtraction

bipolar_pairs = Get_bipolar_pairs(monkeyname);

%% Bipolar subtraction
X = zeros(64, size(X_raw,2));
for i = 1:64
    X(i,:) = X_raw(bipolar_pairs(i,1),:) - X_raw(bipolar_pairs(i,2),:);
end

end

