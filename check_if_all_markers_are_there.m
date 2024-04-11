function [answer, missing_marker] = check_if_all_markers_are_there(recorded_markers, markers_2_check)
err = 1;
for i = 1 : length (markers_2_check)
    try
        recorded_markers.(markers_2_check{1, i});
    catch
        missing_marker{1,err} = (markers_2_check{1, i}); 
        err = err+1;
    end

end
if err >=2
    answer = 0;
else
    answer = 1;
    missing_marker{1,1} = '';
end

end