function minE_history = Ehistory2minEhistory(Energy_history)
%UNTITLED4 この関数の概要をここに記述
%   詳細説明をここに記述

[N_steps, num_T] = size(Energy_history);

minE_history_temp = min(Energy_history(1,:));
minE_history = zeros(N_steps, 1);
minE_history(1) = minE_history_temp(1);

for i = 2:N_steps
    minE_at_the_step = min(Energy_history(i,:));
    if minE_at_the_step < minE_history_temp
        minE_history_temp = minE_at_the_step;
    end
    minE_history(i) = minE_history_temp;
end

end

