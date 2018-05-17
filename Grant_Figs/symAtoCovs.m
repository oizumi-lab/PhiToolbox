function [ Cov_X, Cov_XY, Cov_Y ] = symAtoCovs( A, sigma_E )
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述

N = size(A, 1);

Cov_X = sigma_E^2 * eye(N,N) / (eye(N,N)-A*A);
Cov_Y = Cov_X;
Cov_XY = sigma_E^2 * ( (eye(N,N)-A*A)\A );

end

