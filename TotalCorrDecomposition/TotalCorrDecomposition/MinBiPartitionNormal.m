function [ Partition ] = MinBiPartitionNormal( CovMat, IC )
%% [ Partition ] = MinBiPartitionNormal( CovMat, IC )
%%
%% This function compute the bi-partition minimizing the information loss
%% between the subsets in it, by assuming the data is distributed normally.
%% 
%% Input --- 
%%       CovMat: a N x N covariance or correlation matrix computed from a dataset.
%%       IC (optional): a function handle reflecting an information criterion.
%%
%% Output ---
%%       Partition: a 1 x 2 cell array, in which the first and second
%%       element are the subset of indices 1:N.
%%       
%% A more generic function for the equivalent computation can be performed
%% by MaxTotalCorr. This function is an implementation of a specialized algorithm for
%% normally distributed dataset. Due to this specialization, this function
%% performs much faster than the generic one.
%% 
%% First written by Shohei Hidaka, March 31st, 2016.
%%
%% See also: QueyranneAlgorithm, 
%%

if nargin < 1
    N = 1e3; dim = 10;
    data = randn( num, dim );
    CV = corrcoef( data );
end
if nargin < 3
    N = 1e3; %% The number of samples
    %IC = @( DOF ) DOF * ( DOF - 1 ) / ( log( N ) * N ); %% BIC
    IC = @( DOF ) DOF * ( DOF - 1 ) / ( 2 * N ); %% AIC
end

index = 1:size( CovMat, 1 );

%[ cutset ] = subQueyranneAlgorithm( CovMat, index );
[ cutset ] = QueyranneAlgorithmNormalModified( CovMat, index );
if length( cutset ) <= length( index ) / 2 
    Partition = { cutset, setdiff( index, cutset ) };
else
    Partition = { setdiff( index, cutset ), cutset };
end
end

% function [ IndexOutput ] = subQueyranneAlgorithm( CovMat, index )
% %% A special case of QueyranneAlgorithm with a fixed F.
% 
% %% Added March 18th, 2016.
% index = arrayfun( @(x) x, 1:length( index ), 'UniformOutput', false );
% %% Added March 18th, 2016.
% 
% N = length( index );
% indexrec = cell( 1, N - 1 );
% f = zeros( 1, N - 1 );
% for i = 1:( N - 1 );
%     fprintf( 'i = %d: ', i );
%     if 0 %% Generic algorithm
%         [ pp ] = PendentPair( F, index, 1 );
%         indexrec( i ) = index( pp( end ) );
%         f( i ) = F( index( pp( end ) ) ); %TotalCorr( index( pp( end ) ), CV );
%     else %% Specialized algorithm
%         [ pp, ff ] = PendentPairNormal( CovMat, index );
%         indexrec( i ) = index( pp( end ) );
%         f( i ) = f( end );
%     end
%     index = index( pp );
%     index = [ index( 1:end-2 ), { cell2mat( index( end-1:end ) ) } ];
%     fprintf( 'F = %.3f\n', f( i ) );
% end
% [ tmp, minind ] = min( f );
% IndexOutput = indexrec{ minind };
% 
% end


