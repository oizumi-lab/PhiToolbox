function [groupMember, LabelRegion] = anatomical_groups( SubjectName )

switch SubjectName
    case 'Chibi'
        groupMember = {...  
            [10 11 15 16 21 25 35 7]; ...  %PFC
            % [8 9]; ...  %SMC
            [8 9 12 17 22 40]; ... %PM
            [23 26 27 36 41 13 18 14 19]; ... %MS
            [20 24 28 29 30 31 37 43]; ...%PC
            [42 46 47 48 58 52 53 54]; ... %TC
            [32 34 39 45 51 57 33 38 44 50 56 49 55]; ... %VC
            [1 2 3 4 5 6]; ... %MB
            [59 60 61 62];... %% PP
            [63 64]}; %NG
        LabelRegion={'PF' 'PM' 'MS' 'PC' 'TC' 'VC' 'MB' 'PP' 'NG'};
end

end

