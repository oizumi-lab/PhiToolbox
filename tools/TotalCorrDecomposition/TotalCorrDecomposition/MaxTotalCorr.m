function [ indrec ] = MaxTotalCorr( CV, K, IC )
%% [ IndexSet ] = MaxTotalCorr( CV, K, IC ) 
%% 
%% This function returns a partition for the set of variables { 1, 2, .., N }, 
%% which the given covariance matrix CV implies, by incrementally building bi-partition,
%% which maximizes the summed total correlations of the sub-partition.
%%
%% Input ---
%%       CV: A covariance matrix of N variables
%%       K (optional): The maximum number of iterative steps (default = size( CV, 1 ) )
%%
%% Output ---
%%       IndexSet: A cell variable (1 x (K+1)), in which each element
%%                 contains a subset of the index set { 1, 2, ..., N }.
%% 
%% First written by Shohei Hidaka   Oct 22nd, 2015.
%% Revised (add the second input argument) by Shohei Hidaka Jan 13th, 2016.
%% Revised (modify the index line for the preprocess in the QueyranneAlgorithm) by Shohei Hidaka March 18th, 2016.
%% Revised (IC, the third input argument is added) by Shohei Hidaka March 29th, 2016.
%%
%% See also: TotalCorrDiff, QueyranneAlgorithm, InsertPartition
%% 

if nargin < 1
    CV = corrcoef( x );
end
if nargin < 2
    K = size( CV, 1 );
end
if nargin < 3
    N = 1000; %% The number of samples
    %IC = @( DOF ) DOF * ( DOF - 1 ) / ( log( N ) * N ); %% BIC
    IC = @( DOF ) DOF * ( DOF - 1 ) / 2 / N; %% AIC
end

indexAll = 1:size( CV, 1 );
indrec = cell( 1, 2 );

for i =  1:K
    indmat = setdiff( indexAll, cell2mat( indrec ) );
    %% Modified on March 18th, 2016
    %index = arrayfun( @(x) x, 1:length( indmat ), 'UniformOutput', false );
    index = 1:length( indmat );
    %% Modified on March 18th, 2016
    cv = CV( indmat, indmat );
    if nargin < 3
        F = @( ind ) TotalCorrDiff( ind, cv );
    else
        F = @( ind ) TotalCorrDiff( ind, cv, IC );
    end
    if numel( index ) <= 1
        break;
    end
    fprintf( '\n Bi-partition step %d \n', i );
    ind = QueyranneAlgorithm( F, index );
    if numel( ind ) > numel( indmat )/ 2
        ind = setdiff( 1:numel( indmat ), ind );
    end
    indrec{ i } = indmat( ind );
end
indrec( cellfun( @isempty, indrec ) ) = [];
indrec{ end + 1 } = setdiff( indexAll, cell2mat( indrec ) );
ind = cell2mat( indrec );

end

