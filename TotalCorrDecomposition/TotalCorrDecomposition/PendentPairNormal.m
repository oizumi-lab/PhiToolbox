function [ pendentPair, f ] = PendentPairNormal( CovMat, IndexInCell, InitialIndex )
%% [ pendentPair ] = PendentPairNormal( CovMat, InitialIndex, IndexCell ) 
%% 
%% This function is the core sub-routine of the QueyranneAlgorithmNormal.m
%% 
%% First written by Shohei Hidaka   Mar. 31st, 2016.
%% Revised (added its description in comments) by Shohei Hidaka Jan 13th, 2016.
%%
%% See also: QueyranneAlgorithm, PendentPair
%%
%% References: Queyranne, M. (1998). Minimizing symmetric submodular functions. Mathematical Programming, 82(1-2), 3-12.
%% http://link.springer.com/article/10.1007%2FBF01585863
%%
%% -- Demo -- 
%% To validate the this code, run the following code:
% CV = cov( randn( 1e3, 10 ) );
% F = @( ind ) TotalCorrDiff( ind, CV );
% index = arrayfun( @(x) x, 1:size( CV, 1 ), 'UniformOutput', false );
% initInd = 1;
% [ PendentPair1 ] = PendentPair( F, index, initInd )
% [ PendentPair2 ] = PendentPairNormal( CV, initInd )
% assert( all( PendentPair1 == PendentPair2 ), 'Two pendent pair is supposed to be identical' )
%


if nargin < 1
    CovMat = cov( randn( 1e3, 10 ) );
end
if nargin < 2
    N = size( CovMat, 1 );
    IndexInCell = arrayfun( @(x) x, 1:N, 'UniformOutput', false );
end
if nargin < 3
    InitialIndex = 1;
end
% if nargin < 4
%     op = 1;
% end

det2 = @( X ) X( 1, 1 ) * X( 2, 2 ) - X( 1, 2 ) * X( 2, 1 );
det3 = @( X ) X( 1, 1 ) * X( 2, 2 ) * X( 3, 3 ) + X( 2, 1 ) * X( 3, 2 ) * X( 1, 3 ) + X( 3, 1 ) * X( 1, 2 ) * X( 2, 3 ) ...
    - X( 1, 1 ) * X( 3, 2 ) * X( 2, 3 ) - X( 2, 1 ) * X( 1, 2 ) * X( 3, 3 ) - X( 3, 1 ) * X( 2, 2 ) * X( 1, 3 );

IndexToCells = 1:length( IndexInCell );
IndicesToCellsNonPendent = InitialIndex;
N = length( IndexInCell );
f = zeros( 1, N - 1 );

tmp = IndexInCell( setdiff( 1:numel( IndexInCell ), IndicesToCellsNonPendent ) );
IndexToD = [ { 1:numel( tmp{1} )}, ...
    arrayfun( @(i) ( 1:numel( tmp{i} ) ) + numel( cell2mat( tmp(1:(i-1)) ) ), 2:length( tmp ), 'UniformOutput', false ) ];

for i = 1:( N - 1 );
    %% These three lines manipulating the indices are heavy
    CandidateIndicesToCells = setdiff( IndexToCells, IndicesToCellsNonPendent );
    IndexGiven = cell2mat( IndexInCell( IndicesToCellsNonPendent ) );
    IndexToSearch = cell2mat( IndexInCell( setdiff( 1:numel( IndexInCell ), IndicesToCellsNonPendent ) ) );
    %% These three lines manipulating the indices are heavy
           
    D = CovMat( IndexToSearch, IndexGiven ) / CovMat( IndexGiven, IndexGiven ) * CovMat( IndexGiven, IndexToSearch ); 
    C = CovMat( IndexToSearch, IndexToSearch );
    %%  D == Dchol' * Dchol
    %Dchol = chol( eye( numel( IndexGiven ) ) / CovMat( IndexGiven, IndexGiven ) ) * CovMat( IndexGiven, IndexToSearch );
    
    C_D = C - D;
    indexD = 1:size( D, 1 );
    FDiff = zeros( 1, length( CandidateIndicesToCells ) );
    
    for j = 1:length( IndexToD )
        %TCtemp( j ) = F( [ index( ind ), candidates( j ) ] ) - F( [ candidates( j ) ] );
        dd = IndexToD{ j } ; 
        %dd_ = setdiff( 1:size( D, 1 ), dd );
        dd_ = indexD; dd_( dd ) = [];
        
        %% The following identity holds
        %% det( eye( size( A, 1 ) ) + A * A' ) == det( eye( size( A, 2 ) ) + A' * A )
        %% det( eye( size( A, 1 ) ) - A * A' ) == det( eye( size( A, 2 ) ) - A' * A )

        ddnum = numel( dd );        
        if ddnum == 1
            tmp1_fast = log( C_D( dd, dd ) / C( dd, dd ) );
        elseif ddnum == 2
            tmp1_fast = log( det2( C_D( dd, dd ) ) / det2( C( dd, dd ) ) );
        elseif ddnum == 3
            tmp1_fast = log( det3( C_D( dd, dd ) )/ det3( C( dd, dd ) ) );
        else
            tmp1_fast = sublogdet( C_D( dd, dd ) ) - sublogdet( C( dd, dd ) ); %% slightly faster
        end
        
        tmp2_fast = sublogdet( C_D( dd_, dd_ ) ) - sublogdet( C( dd_, dd_ ) ); %% Slightly faster

        FDiff( j ) = tmp1_fast - tmp2_fast;
    end    
    [ FDiffMin, minind ] = min( FDiff );
    IndicesToCellsNonPendent = [ IndicesToCellsNonPendent, CandidateIndicesToCells( minind ) ];
    f( 1, i ) = FDiffMin;
    
    tmp = numel( IndexToD{ minind } );
    IndexToD = [ IndexToD( 1: ( minind - 1 ) ), ...
        cellfun( @(x) x - tmp, IndexToD( ( minind + 1 ):end ), 'UniformOutput', false ) ];
    
end
pendentPair = IndicesToCellsNonPendent;
%pendentPair = IndicesToCellsNonPendent( ( end - 1 ): end );

end

%% 
function [ logdet ] = sublogdet( mat )
% if 0 %size( mat, 1 ) >= 10
%     logdet = sum( log( eig( mat ) ) );
% else
%     logdet = log( det( mat ) );
% end
%% http://blogs.sas.com/content/iml/2012/10/31/compute-the-log-determinant-of-a-matrix.html
% Let A be your matrix and let G = root(A) be the Cholesky root of the matrix A. Then the following equation is true:
%       log(det(A)) = 2*sum(log(vecdiag(G)))
% A = G`*G, by definition of the Cholesky root
% log(det(A)) = log(det(G`*G)) = log(det(G`)*det(G)) = 2*log(det(G))
% Since G is triangular, det(G) = prod(vecdiag(G))
% Therefore log(det(G))=sum(log(vecdiag(G)))
% Consequently, log(det(A)) = 2*sum(log(vecdiag(G)))
%

G = chol( mat );
logdet = 2 * sum( log( diag( G ) ) );

end




