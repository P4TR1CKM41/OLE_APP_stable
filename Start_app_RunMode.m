clc
filepath = matlab.desktop.editor.getActiveFilename;
lastdot_pos = find(filepath == '\', 1, 'last');
cd (filepath(1:lastdot_pos));

run ('Semi_Real_Time_Feedback_motrack.mlapp')

clear filepath lastdot_pos