function [ IndexOutput ] = QueyranneAlgorithm_phi_Gauss( type_of_phi, Cov_X, Cov_XY, Cov_Y )

assert( isa( type_of_phi, 'char' ) )
assert( isa( Cov_X, 'double' ) )
assert( isa( Cov_XY, 'double' ) )
assert( isa( Cov_Y, 'double' ) )

Nmax = 1000;
% the maximal size of Cov_X is 200by200
assert(all(size(Cov_X) <= [Nmax Nmax]));
% the maximal size of Cov_XY is 200by200
assert(all(size(Cov_XY) <= [Nmax Nmax]));
% the maximal size of Cov_Y is 200by200
assert(all(size(Cov_Y) <= [Nmax Nmax]));


N = size(Cov_X, 1);

F = @(indices)phi_for_Queyranne( indices, Cov_X, Cov_XY, Cov_Y, type_of_phi );

[ IndexOutput ] = QueyranneAlgorithm( F, 1:N );

end

