function [complexes, phis, Res, main_complexes, main_phis] = Complex_Recursive_probs( probs, options )

Res = Complex_RecursiveFunction( probs, options );
% [phi_Largest, row_Largest_phi] = max(Res.phi);
% indices_Largest_phi = find(Res.Z(row_Largest_phi,:));

[complexes, phis] = find_Complexes(Res);
[main_complexes, main_phis] = find_main_Complexes(complexes, phis);

end

function Res = Complex_RecursiveFunction( probs, options )
%Complex_Search_Recursive
% 
% INPUTS:
%   probs: 
%   options: 
%
% OUTPUTS:
%   Res: struct
%     Res.Z: partitions
%     Res.phi: the amount of integrated information
%     Res.parent: 
%

N = probs.number_of_elements;
disp(num2str(N))

type_of_MIPsearch = options.type_of_MIPsearch;
type_of_dist = options.type_of_dist;

if N < 2
    Res.Z = [];
    Res.phi = [];
    Res.parent = 0;
else
    
    switch type_of_MIPsearch
        case 'Exhaustive'
            [Z_MIP, phi_MIP] = MIP_Exhaustive( probs, options );
        case 'Queyranne'
            [Z_MIP, phi_MIP] = MIP_Queyranne( probs, options );
        case 'REMCMC'
            [Z_MIP, phi_MIP] = MIP_REMCMC( probs, options );
    end
    
    indices_L = find(Z_MIP==1);
    indices_R = find(Z_MIP==2);
    
    probs_L = ExtractSubsystem( type_of_dist, probs, indices_L );
    probs_R = ExtractSubsystem( type_of_dist, probs, indices_R );

    Res_L = Complex_RecursiveFunction( probs_L, options );
    Res_R = Complex_RecursiveFunction( probs_R, options );
    
    Res = Concatenate_Res(N, Z_MIP, phi_MIP, indices_L, indices_R, Res_L, Res_R);
    
end

end

function Res = Concatenate_Res(N, Z, phi, indices_L, indices_R, Res_L, Res_R)

[nRows_L, ~] = size(Res_L.Z);
[nRows_R, ~] = size(Res_R.Z);
Res.Z = zeros(nRows_L+nRows_R+1, N);
Res.Z(1:nRows_R, indices_R) = Res_R.Z;
Res.Z((nRows_R+1):(nRows_R+nRows_L), indices_L) = Res_L.Z;
Res.Z(nRows_R+nRows_L+1,:) = Z;

Res.phi = [Res_R.phi; Res_L.phi; phi];

Res.parent = zeros(nRows_L+nRows_R+1, 1);
Res.parent(1:nRows_R, 1) = Res_R.parent;
Res.parent((nRows_R+1):(nRows_R+nRows_L),1) = nRows_R + Res_L.parent;

if nRows_R > 0;
    Res.parent(nRows_R, 1) = nRows_L+nRows_R+1;
end
if nRows_R+nRows_L>0
    Res.parent(nRows_R+nRows_L, 1) = nRows_L+nRows_R+1;
end

end

function [complexes, phis] = find_Complexes(Res)

nSubsets = length(Res.phi);
phi_temp_max = zeros(nSubsets, 1);
isComplex = false(nSubsets, 1);

phi_temp_max(nSubsets) = Res.phi(nSubsets);
isComplex(nSubsets) = 1;
for i = nSubsets-1: -1 :1
    if Res.phi(i) > phi_temp_max(Res.parent(i))
        phi_temp_max(i) = Res.phi(i);
        isComplex(i) = true;
    else
        phi_temp_max(i) = phi_temp_max(Res.parent(i));
    end
end

nComplexes = nnz(isComplex);
complexes = cell(nComplexes, 1);
Zs_Complexes = Res.Z(isComplex,:);
for i = 1:nComplexes
    complexes{i} = find(Zs_Complexes(i,:));
end

phis = Res.phi(isComplex);


end