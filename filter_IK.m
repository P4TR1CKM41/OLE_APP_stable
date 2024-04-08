function [TAB] = filter_IK(table, filter_IK)

if filter_IK >= 0
    names = table.Properties.VariableNames;
    [b_filt,a_filt] = butter(2,  filter_IK/(1/((table.time(2))-(table.time(1)))/2), 'low');
    for i = 1: length(names)
        if i ==1
            R(:,i) = table.(names{1, i});
        else
            R(:,i) = filtfilt(b_filt,a_filt,table.(names{1, i}));
        end
    end
    TAB = array2table(R,'VariableNames',names);

else
    TAB = table;
end

end