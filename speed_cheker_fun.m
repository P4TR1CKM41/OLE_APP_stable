function [is_valid] = speed_cheker_fun(velocity, OPTIONS, current_task_id, trialnames, current_leg_bin, current_trial)
trialnames = trialnames';
for tr = 1 : length (trialnames)
    matrix(tr,1) =double( OPTIONS.ANALYZEDLEG_BIN.(trialnames{tr, 1})) ;
    matrix(tr,2) =double( OPTIONS.WAS_VALID.(trialnames{tr, 1}));
    matrix(tr,3) =double(OPTIONS.Instruction.(trialnames{tr, 1}));
    matrix(tr,4) =double(OPTIONS.TASK_ID_NUMERIC.(trialnames{tr, 1}));
    matrix(tr,5) =velocity(tr);
end
%% now get the mean of the leg from the current task and leg without feedback/ instructions and valid
MEAN_BASELINE = mean(matrix(find(matrix(:,1)==current_leg_bin & matrix(:,4) == current_task_id & matrix(:,3)==0 & matrix(:,2) ==1 ),5));
%% check if the current velocity is higher than mean-10% of mean
if matrix(current_trial,5) > MEAN_BASELINE-(MEAN_BASELINE*0.1)
    %% target speed reached
    is_valid =1;
else
    is_valid =0;
end
end