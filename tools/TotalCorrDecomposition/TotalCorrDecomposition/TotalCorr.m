function [ TC ] = TotalCorr( CV )
TC = sum( log( diag( CV ) ) ) - sub_logdet( CV );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [ADD] Revised Jan 13th 2016
function [ logdet ] = sub_logdet( CV )
det0 = det( CV );
if det0 == 0
    logdet = sum( log( abs( eig( CV ) ) ) ); 
else
    logdet = log( det0 );
end

