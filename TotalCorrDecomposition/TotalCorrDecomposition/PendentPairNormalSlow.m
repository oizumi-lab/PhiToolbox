function [ pendentPair, f ] = PendentPairNormalFastModified( CovMat, IndexInCell, InitialIndex, FDiffPrevious )
%% [ pendentPair ] = PendentPairNormalFastModified( CovMat, InitialIndex, IndexCell ) 
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

%% Function handles
g = @( Sigma, U1, U2, W ) Sigma( U1, U2 ) - Sigma( U1, W ) / Sigma( W, W ) * Sigma( W, U2 );
PutForwardInCell = @( Cell, key ) [ Cell( key ), Cell( 1:( key - 1 ) ), Cell( ( key + 1 ): end ) ];
logMinor = @( S ) log( diag( eye( size( S, 1 ) ) / S ) ) + sublogdet( S );
InverseUpdate = @( invS, W0, W1 ) invS( W1, W1 ) - invS( W1, W0 )/ invS( W0, W0 ) * invS( W0, W1 );

Sigma = CovMat;
N = size( Sigma, 1 );

%%
fmin = zeros( 1, length( IndexInCell ) - 1 );
indMin = 0;
PutForwardInCell = @( Cell, key ) [ Cell( key ), Cell( 1:( key - 1 ) ), Cell( ( key + 1 ): end ) ];
V = PutForwardInCell( IndexInCell, InitialIndex );
W = [];
S = CovMat ;
%%%%
for i = ( indMin + 2 ):( length( V ) )
    Vi = V{ i - 1 };
    W = [ W, Vi ] ;
    V_W = cell2mat( V( i:end ) );

    S( V_W, V_W ) = g( S, V_W, V_W, Vi );
    
    f = -inf( 1, length( V ) );
    for j = i:length( V )
        indc = 1:N; indc( [ V{ j }, W ] ) = [];
        f( j ) = sublogdet( S( V{ j }, V{ j } ) ) - sublogdet( S( indc, indc ) )  ...
            - sublogdet( Sigma( V{ j }, V{ j } ) ) + sublogdet( Sigma( indc, indc ) );
        %% Equivalent to:
        %% F = @( ind ) TotalCorrDiff( ind, Sigma );
        %% f( j ) = F( [ W, V{ j } ] ) - F( V{ j } )
    end    
    [ fmin( i - 1 ), minind ] = min( f( i:length( V ) ) );    
    V( i:end ) = PutForwardInCell( V( i:end ), minind );
end
pendentPair = V;
f = fmin;

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
dim = size( mat, 1 );
if dim == 1
    logdet = log( mat );
elseif dim == 2
    det2 = @( X ) X( 1, 1 ) * X( 2, 2 ) - X( 1, 2 ) * X( 2, 1 );
    logdet = log( det2( mat ) );
elseif dim == 3
    det3 = @( X ) X( 1, 1 ) * X( 2, 2 ) * X( 3, 3 ) + X( 2, 1 ) * X( 3, 2 ) * X( 1, 3 ) + X( 3, 1 ) * X( 1, 2 ) * X( 2, 3 ) ...
        - X( 1, 1 ) * X( 3, 2 ) * X( 2, 3 ) - X( 2, 1 ) * X( 1, 2 ) * X( 3, 3 ) - X( 3, 1 ) * X( 2, 2 ) * X( 1, 3 );
    logdet = log( det3( mat ) );
else
    logdet = 2 * sum( log( diag( chol( mat ) ) ) );
end

end



