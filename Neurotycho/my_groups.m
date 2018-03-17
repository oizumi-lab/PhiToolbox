function groupMember = my_groups( SubjectName, SorL )
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述

switch SubjectName
    case 'Chibi'
        groupMember_temp = {...
            [1, 2, 3, 5];
            [4, 6, 63, 64];
            [59, 60, 61, 62];
            [7 10 8 15];
            [9 11, 16, 21];
            [12, 17, 22, 26];
            [13, 18, 23, 27];
            [14, 19, 20, 24];
            [25, 35, 36, 40];
            [28, 30, 31, 37];
            [29 32 33 34];
            [46, 52, 53, 58];
            [41, 42, 47, 48];
            [43, 49, 54, 55];
            [38, 39, 44, 45];
            [50, 51, 56, 57]...
            };
        switch SorL
            case 'Small'
                groupMember = groupMember_temp;
            case 'Large'
                groupMember = {...
                    [groupMember_temp{1:3}];
                    [groupMember_temp{4:6},groupMember_temp{9}]; ...
                    [groupMember_temp{7:8},groupMember_temp{10:11}];...
                    [groupMember_temp{12:13}];...
                    [groupMember_temp{14:16}]...
                    };
        end
end

end

