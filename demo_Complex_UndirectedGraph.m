addpath(genpath('../PhiToolbox'))

g = zeros(7,7);  % creat a graph
g(1,[2,4]) = [3 2];  g(2,[3,4]) = [2 1];
g(3,[4,6]) = [2 2];  g(4,5) = 1;
g(5,[6 7]) = [3 2];  g(6,7) = 1;
g = g + g';      % keep symmetry

probs.g = g;
probs.number_of_elements = size(probs.g,1);

options.type_of_dist = 'UndirectedGraph';
options.type_of_MIPsearch = 'StoerWagner';

tic;
[complexes, phis_complexes, main_complexes, phis_main_complexes, Res] = ...
    Complex_Recursive( probs, options );
t = toc;