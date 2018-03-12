function [IndexOutput] = my_QueyranneAlgorithm( phi, index, Cov_X, Cov_XY, Cov_Y )

N = size(Cov_X, 1);
[IndexOutput] = QueyranneAlgorithm( symmetrized_phi, index );

    function f = symmetrized_phi( index )
        ind = cell2mat(index);
        cmplmnt_ind = setdiff((1:N),ind);
        
        f = phi( Cov_X(ind, ind), Cov_XY(ind, ind), (1:length(ind)), Cov_Y(ind, ind)) ...
            + phi( Cov_X(cmplmnt_ind, cmplmnt_ind), Cov_XY(cmplmnt_ind, cmplmnt_ind), (1:length(cmplmnt_ind)), Cov_Y(cmplmnt_ind, cmplmnt_ind));
        
    end

end


