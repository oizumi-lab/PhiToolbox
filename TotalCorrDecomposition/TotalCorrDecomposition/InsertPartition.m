function [ CV_, indrec, indrec_ ] = InsertPartition( CV, indrec )
%function [ CV_, indrec, indrec_ ] = InsertPartition( CV, indrec )
if nargin < 2
    indrec = MaxTotalCorr( CV );
end
ind = cell2mat( indrec );
CV_ = nan( size( CV ) + 1 );
CV_( 1:end-1, 1:end-1 ) = CV;
indrec_ = indrec;
indrec_( 2, : ) = repmat( { size(CV,1) + 1 }, 1, length( indrec ) );
indrec_( end ) = [];
CV_ = CV_( cell2mat( indrec_(:)' ), cell2mat( indrec_(:)' ) );

