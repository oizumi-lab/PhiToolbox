function [ pendentPair, FDiffMin ] = PendentPairModified( F, index, ind, FDiffPrevious )
%% [ pendantPair ] = PendentPairModified( F, index, ind, ppPrevious ) 
%% 
%% This function is the core sub-routine of the QueyranneAlgorithm.m
%% 
%% First written by Shohei Hidaka   Oct 22nd, 2015.
%% Revised (added its description in comments) by Shohei Hidaka Jan 13th, 2016.
%%
%% See also: QueyranneAlgorithm
%%
%% References: Queyranne, M. (1998). Minimizing symmetric submodular functions. Mathematical Programming, 82(1-2), 3-12.
%% http://link.springer.com/article/10.1007%2FBF01585863
if nargin < 3
    ind = 1;
end

FDiffMin = zeros( 1, length( index ) - 1 );
if nargin >= 4 & length( index ) > 1
    indMergedPrevious = index( end );
    indToTest = length( index );
    indMin = indToTest;
    for i = 1:( indToTest - 1 )
        fdiff = F( [ index( 1:i ), indMergedPrevious ] ) - F( indMergedPrevious );
        if i > length( FDiffPrevious ) | fdiff < FDiffPrevious( i )
            indMin = i;
            break;
        end
    end
    ind = [ 1:( indMin ), indToTest ] ;
    FDiffMin = [ FDiffPrevious( 1:( indMin - 1 ) ), fdiff ];
    if ( indMin + 1 ) == indToTest
        pendentPair = ind;
        return;
    end
else
    indMin = 0;
end

%if length( index ) == length( ind )
    
%FDiffMin = zeros( 1, length( index ) - 1 );
for i = ( indMin + 1 ):( length( index ) - 1 )
    indc = setdiff( 1:length( index ), ind );
    candidates = index( indc );
    
    FDiff = zeros( 1, length( candidates ) );
    for j = 1:length( candidates )
        FDiff( j ) = F( [ index( ind ), candidates( j ) ] ) - F( [ candidates( j ) ] );
    end
    
    [ FDiffMin( i ), minind ] = min( FDiff );
    ind = [ ind, indc( minind ) ];
end
pendentPair = ind;

