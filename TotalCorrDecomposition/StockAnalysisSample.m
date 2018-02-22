
clear;

addpath( './TotalCorrDecomposition/' );

FileName = 'ForexData.xlsx' ;
%% Top 21 -> 40 -> 40 + pre-Euro currencies
[ tmp, tmp, raw ] = xlsread( FileName, 'since2000' );
Data2000 = cell2mat( raw( 3:end-2, 4:end ) );
CurrencyNames = raw( 2, 4:end );
Dates = raw( 3:end-2, 2 );

Data = Data2000;

%% Remove if finds too many missing values
if 1
    IsMissing = sum( isnan( Data ), 1 ) >= 1000;
    Data = Data( :, ~IsMissing );
    CurrencyNames = CurrencyNames( ~IsMissing );
end


if 1
    %% With Metals
    [ tmp, tmp, raw ] = xlsread( FileName, 'Sheet5' );
    Data2 = cell2mat( raw( 3:end-2, 4:end ) );
    CurrencyNames2 = raw( 2, 4:end );
    Dates2 = raw( 3:end-2, 2 );
    %[ ismem, tmp1 ] = ismember( Dates2, Dates );
    [ ismem, tmp1 ] = ismember( Dates, Dates2 );
    [ isint, tmp1, tmp2 ] = intersect( Dates, Dates2 );
    Dates = isint;
    Data = [ Data( tmp1, : ), Data2( tmp2, : ) ];
    CurrencyNames = [ CurrencyNames, CurrencyNames2 ]
end

%% CurrencyNames( [ 1:21 end-4:end] )
CurrencySelected = [ 1:21, length( CurrencyNames ) - ( 0:4 ) ];
CurrencyNames = CurrencyNames( CurrencySelected );
Data = Data( :, CurrencySelected );
Data = Data( all( ~isnan( Data ), 2 ), : );

%% Shrinkage estimator for the covariance matrix
Ret = diff( log( Data ) );
cvshrink = covshrinkKPM( Ret );
corrshrink = cvshrink ./ sqrt( diag( cvshrink ) * diag( cvshrink )' ) 

CV = corrshrink;

%% Sequential Partioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ indrec ] = MaxTotalCorrNormal( CV, size( CV, 1 ) );
%% Sequential Partioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = cell2mat( indrec );

CLabels = cellfun( @(x) x(1:3), CurrencyNames( ind ), 'UniformOutput', false );
subplot( 1, 2, 2 );
imagesc( CV( ind, ind ) );
set( gca, 'ytick', 1:26 );
set( gca, 'yticklabel', CLabels );
text( -ones( numel( indrec ) - 1, 1 ), 0.5 + cumsum( cellfun( @numel, indrec( 1: end - 1 ) ) ), '---' );
set( gca, 'xtick', 1:26 );
set( gca, 'xticklabel', '' );
title( 'Sorted correlation matrix (shrinkage estimator)' );
colorbar;
text( 1:26, 27 * ones( 26, 1 ), CLabels, 'Rotation', -90 );
text( 0.5 + cumsum( cellfun( @numel, indrec( 1: end - 1 ) ) ), 27 * ones( numel( indrec ) - 1, 1 ), '---', 'Rotation', -90 );

CV0 = corrcoef( Ret );
[ indrec0 ] = MaxTotalCorrNormal( CV0, size( CV0, 1 ) );
ind = cell2mat( indrec0 );
subplot( 1, 2, 1 );
imagesc( CV0( ind, ind ) );
set( gca, 'ytick', 1:26 );
set( gca, 'yticklabel', CLabels );
text( -ones( numel( indrec ) - 1, 1 ), 0.5 + cumsum( cellfun( @numel, indrec( 1: end - 1 ) ) ), '---' );
set( gca, 'xtick', 1:26 );
set( gca, 'xticklabel', '' );
title( 'Sorted correlation matrix (MLE)' );
text( 1:26, 27 * ones( 26, 1 ), CLabels, 'Rotation', -90 );
text( 0.5 + cumsum( cellfun( @numel, indrec( 1: end - 1 ) ) ), 27 * ones( numel( indrec ) - 1, 1 ), '---', 'Rotation', -90 );
set( gcf, 'Position', [ 172    99   740   621 ] );
colorbar;


