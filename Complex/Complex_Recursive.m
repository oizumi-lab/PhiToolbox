function [complexes, phis, Res, main_complexes, main_phis] = Complex_Recursive(X, params, options )

probs = data_to_probs(X, params, options);
[complexes, phis, Res, main_complexes, main_phis] = Complex_Recursive_probs( probs, options );

end