function [ Partition, Fval ] = MaxTotalCorrNested( CV, NumCells )
%MAXTOTALCORRNESTED この関数の概要をここに記述
%   詳細説明をここに記述
if nargin < 2
    NumCells = 2;
end

%F = @(x) sum( log( abs( eig( CV( x{1}, x{1} ) ) ) ) ) + sum( log( abs( eig( CV( x{2}, x{2} ) ) ) ) ) ;
Index = 1:size( CV, 1 );
%complement = @(x) setdiff( Index, x );
%F = @(x) sum( log( abs( eig( CV( x, x ) ) ) ) ) + sum( log( abs( eig( CV( complement(x), complement(x) ) ) ) ) ) ;
F = @( ind, Index ) TotalCorrDiff( ind, CV( Index, Index ) );
    
[ Partition, Fval ] = SubBiPartition( Index, F, NumCells );

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ Partition, Fval ] = SubBiPartition( Index, F, NumCells )

F0 = @( ind ) F( ind, Index );
%% Modified on March 18th, 2016
%index = arrayfun( @(x) x, 1:length( Index ), 'UniformOutput', false );
index = 1:length( Index );
%% Modified on March 18th, 2016


ind1 = QueyranneAlgorithm( F0, index );
ind1 = Index( ind1 );
ind2 = Index( setdiff( 1:length( Index ), ind1 ) );

Fval0 = F0( ind1 );

if NumCells <= 2
    Fval = Fval0;
    Partition = { ind1, ind2 };
    return;
end

[ P1, Fval1 ] = SubBiPartition( ind1, F, NumCells - 1 );
[ P2, Fval2 ] = SubBiPartition( ind2, F, NumCells - 1 );

if Fval1 < Fval2
    Fval = Fval1 + Fval0;
    Partition = { ind2 };
    Partition( end + 1 : end + numel(P1) ) = P1;
else
    Fval = Fval2 + Fval0;
    Partition = { ind1 };
    Partition( end + 1 : end + numel(P2) ) = P2;
end

end
