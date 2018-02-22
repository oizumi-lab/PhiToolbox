function [ pendentPair, f ] = PendentPairNormalFast( CovMat, IndexInCell, InitialIndex )
%% [ pendentPair ] = PendentPairNormalFast( CovMat, InitialIndex, IndexCell ) 
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

%% Another implementation of the pendent series
Sigma = CovMat;
g = @( Sigma, U1, U2, W ) Sigma( U1, U2 ) - Sigma( U1, W ) / Sigma( W, W ) * Sigma( W, U2 );
S = Sigma ;

PutForwardInCell = @( Cell, key ) [ Cell( key ), Cell( 1:( key - 1 ) ), Cell( ( key + 1 ): end ) ];
V = PutForwardInCell( IndexInCell, InitialIndex );

N = size( Sigma, 1 );
fmin = zeros( 1, length( V ) - 1 );

%% http://math.stanford.edu/~lexing/publication/diagonal.pdf
%% "diagonal elements of the inverse matrix"
%% http://math.stackexchange.com/questions/64420/is-there-a-faster-way-to-calculate-a-few-diagonal-elements-of-the-inverse-of-a-h
logMinor = @( S ) log( diag( eye( size( S, 1 ) ) / S ) ) + sublogdet( S );
InverseUpdate = @( invS, W0, W1 ) invS( W1, W1 ) - invS( W1, W0 )/ invS( W0, W0 ) * invS( W0, W1 );
logSigmaMinor = logMinor( Sigma );
logdiagSigma = log( diag( Sigma ) );
invSigma = eye( size( Sigma, 1 ) ) / Sigma ;
%logdetinvSigmaPrevious = - sublogdet( Sigma );

IsOne = cellfun( @(x) numel(x) == 1, V );

W = [];
%V_W_ = cell2mat( V );
for i = 2:length( V )
    %W = cell2mat( V( 1:( i - 1 ) ) );
    Vi = V{ i - 1 };
    %Wpre = W;
    W = [ W, Vi ] ;
    V_W = cell2mat( V( i:end ) );
    %V_W_( 1:numel( V{ i - 1 } ) ) = [];
    %assert( all( W == W_ ) )
    %assert( all( V_W == V_W_ ) )
    

    %S_ = S;
    %S_( V_W, V_W ) = g( S, V_W, V_W, V{ i - 1 } );
    %S = S_;
    S( V_W, V_W ) = g( S, V_W, V_W, Vi );
    
    logdiagS = log( diag( S ) );    

    logdetW = sublogdet( Sigma( W, W ) );
    %     if i == 2
    %         logdetW_ = sublogdet( Sigma( V{1}, V{1} ) );
    %     else
    %         % InverseUpdate = @( invS, W0, W1 ) invS( W1, W1 ) - invS( W1, W0 )/ invS( W0, W0 ) * invS( W0, W1 );
    %         %logdetW_ = logdetW_ + sublogdet( InverseUpdate( Sigma, cell2mat( V( 1:( i - 2 ) ) ), V{ i - 1 } ) );
    %         logdetW_ = logdetW_ + sublogdet( InverseUpdate( Sigma, Wpre, Vi ) );
    %     end
    %     assert( abs( logdetW - logdetW_ ) < 1e-5 );

    f = -inf( 1, length( V ) );
    
    logVMinor = nan( 1, N );
    
    %% The following is equivalent to: logVMinor( V_W ) = logMinor( Sigma( V_W, V_W ) );    
    invSigma( V_W, V_W ) = InverseUpdate( invSigma, Vi, V_W );  %% Equivalent to: invSigma = inv( Sigma( V_W, V_W ) );

    %logdetinvSigmaPrevious = logdetinvSigmaPrevious - sublogdet( invSigma( Vi, Vi ) );
    %logVMinor( V_W ) = log( diag( invSigma( V_W, V_W ) ) ) - logdetinvSigmaPrevious;
    %% The above is equivalent to: 
    logVMinor( V_W ) = log( diag( invSigma( V_W, V_W ) ) ) + sublogdet( Sigma( V_W, V_W ) );
    %assert( max( abs( logVMinor( V_W ) - logVMinor_' ) ) < 1e-5 );
        
    indWithOne = find( IsOne( i:length( V ) ) ) + i-1;
    indWithMultiple = find( ~IsOne( i:length( V ) ) ) + i-1 ;
    
    %% For cells with one element:
    v = cell2mat( V( indWithOne ) );
    f( indWithOne ) = logdiagS( v ) - ( logSigmaMinor( v ) - logdetW ) - logdiagSigma( v ) + logVMinor( v )';
    %f1 = @(v) logdiagS( v ) - ( logSigmaMinor( v ) - logdetW ) - logdiagSigma( v ) + logVMinor( v );
    %f( indWithOne ) = cellfun( f1, V( indWithOne ) );
    %assert( max( abs( f( indWithOne ) - gg( indWithOne ) ) ) < 1e-5 );

    
    %% For cells with multiple elements:    
    for j = indWithMultiple %i:length( V )
        %% For indWithOne
        % f( j ) = logdiagS( V{ j } ) - ( logSigmaMinor( V{j} ) - logdetW ) - logdiagSigma( V{ j } ) + logVMinor( V{j} ); %% Fastest

        indc = 1:N; indc( [ V{ j }, W ] ) = [];
        f( j ) = sublogdet( S( V{ j }, V{ j } ) ) - sublogdet( S( indc, indc ) )  ...
            - sublogdet( Sigma( V{ j }, V{ j } ) ) + sublogdet( Sigma( indc, indc ) );
        %% Equivalent to: 
        %% F = @( ind ) TotalCorrDiff( ind, Sigma );
        %% f( j ) = F( [ W, V{ j } ] ) - F( V{ j } )
    end
    
    [ fmin( i - 1 ), minind ] = min( f( i:length( V ) ) );    
    V( i:end ) = PutForwardInCell( V( i:end ), minind );
    IsOne( i:end ) = PutForwardInCell( IsOne( i:end ), minind );
    %% sort IsOne
    %V( i:length( V ) ) = PutForwardInCell( V( i:length( V ) ), minind );
end
pendentPair = V;
f = fmin;

end

% function [] = subcell2mat( V )
% isOne = cellfun( @numel, V );
% Vmat( isOne ) = cellfun( @(x) x, V( isOne ) )
% end

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



