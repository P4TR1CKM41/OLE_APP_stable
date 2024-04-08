function make_stick_figure_new(OPTIONS, beine, MARKERS, FP,  structname,  CONTACT,  app, NORMAL, BK_POS_TABLE, GRF_TABLE, MOMENT_TABLE)
cla(app.UIAxes22);
% load('C:\Users\patrickmai\Desktop\TestFolder\PAB01\PAB01.mat')
% structname ='Cutting14';
% ftkratio = mainStruct.(name).Force(fp).SamplingFactor;

framesfor100ms = round(0.1/(1/OPTIONS.FREQ_KINEMATIC));
TD_kinematic = CONTACT.(structname)(1);

TD_analog_frame = fix(CONTACT.(structname)(1)*OPTIONS.ftkratio);
index_current_struct = find(strcmp(NORMAL.HEADER,structname ) ==1);

[value , pos] = max( NORMAL.KAM(:,index_current_struct));
variableNames = BK_POS_TABLE.(structname).Properties.VariableNames;
cleanedNames = {};
for i = 1:length(variableNames)
    name = variableNames{i};
    % Check if the name contains 'Ox', 'Oy', or 'Oz'
    if contains(name, '_X') || contains(name, '_Y') || contains(name, '_Z')
        % Remove 'Ox', 'Oy', 'Oz' from the name
        name = replace(name, '_X', '');
        name = replace(name, '_Y', '');
        name = replace(name, '_Z', '');
        % Add the cleaned name to the list
        cleanedNames{end+1} = name;
    end
end
[uniqueStrings, ~, ic] = unique(cleanedNames);
for p = 1 : length (uniqueStrings)
    DUM.(structname).(uniqueStrings{1, p})(:,1) =  BK_POS_TABLE.(structname).([uniqueStrings{1, p}, '_X'])*100;
    DUM.(structname).(uniqueStrings{1, p})(:,2) =  BK_POS_TABLE.(structname).([uniqueStrings{1, p}, '_Y'])*100;
    DUM.(structname).(uniqueStrings{1, p})(:,3) =  BK_POS_TABLE.(structname).([uniqueStrings{1, p}, '_Z'])*100;
end
pos_video= TD_kinematic;
jcnames = fieldnames (DUM.(structname));
set(app.UIAxes22,'color','w');
for j = 1 : length (jcnames)
    if  strcmp(jcnames{j, 1}, 'center_of_mass') ==1;
        groesse = 50;
        farbe = 'r';
    else
        groesse = 5;
        farbe ='k';
    end
    scatter3(app.UIAxes22,DUM.(structname).(jcnames{j, 1})(TD_kinematic,1), DUM.(structname).(jcnames{j, 1})(TD_kinematic,2), DUM.(structname).(jcnames{j, 1})(TD_kinematic,3) ,groesse,'filled', farbe)
    hold(app.UIAxes22, 'on');
    axis (app.UIAxes22, 'equal');
    grid (app.UIAxes22, 'off');
    axis(app.UIAxes22, 'off');
end




plot3(app.UIAxes22,[DUM.(structname).patella_r(pos_video,1),  DUM.(structname).talus_r(pos_video,1)],[DUM.(structname).patella_r(pos_video,2),  DUM.(structname).talus_r(pos_video,2)],[DUM.(structname).patella_r(pos_video,3),  DUM.(structname).talus_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).patella_l(pos_video,1),  DUM.(structname).talus_l(pos_video,1)],[DUM.(structname).patella_l(pos_video,2),  DUM.(structname).talus_l(pos_video,2)],[DUM.(structname).patella_l(pos_video,3),  DUM.(structname).talus_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).patella_l(pos_video,1),  DUM.(structname).femur_l(pos_video,1)],[DUM.(structname).patella_l(pos_video,2),  DUM.(structname).femur_l(pos_video,2)],[DUM.(structname).patella_l(pos_video,3),  DUM.(structname).femur_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).patella_r(pos_video,1),  DUM.(structname).femur_r(pos_video,1)],[DUM.(structname).patella_r(pos_video,2),  DUM.(structname).femur_r(pos_video,2)],[DUM.(structname).patella_r(pos_video,3),  DUM.(structname).femur_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).toes_r(pos_video,1),  DUM.(structname).talus_r(pos_video,1)],[DUM.(structname).toes_r(pos_video,2),  DUM.(structname).talus_r(pos_video,2)],[DUM.(structname).toes_r(pos_video,3),  DUM.(structname).talus_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).toes_l(pos_video,1),  DUM.(structname).talus_l(pos_video,1)],[DUM.(structname).toes_l(pos_video,2),  DUM.(structname).talus_l(pos_video,2)],[DUM.(structname).toes_l(pos_video,3),  DUM.(structname).talus_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).pelvis(pos_video,1),  DUM.(structname).femur_l(pos_video,1)],[DUM.(structname).pelvis(pos_video,2),  DUM.(structname).femur_l(pos_video,2)],[DUM.(structname).pelvis(pos_video,3),  DUM.(structname).femur_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).pelvis(pos_video,1),  DUM.(structname).femur_r(pos_video,1)],[DUM.(structname).pelvis(pos_video,2),  DUM.(structname).femur_r(pos_video,2)],[DUM.(structname).pelvis(pos_video,3),  DUM.(structname).femur_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).pelvis(pos_video,1),  DUM.(structname).torso(pos_video,1)],[DUM.(structname).pelvis(pos_video,2),  DUM.(structname).torso(pos_video,2)],[DUM.(structname).pelvis(pos_video,3),  DUM.(structname).torso(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).humerus_l(pos_video,1),  DUM.(structname).torso(pos_video,1)],[DUM.(structname).humerus_l(pos_video,2),  DUM.(structname).torso(pos_video,2)],[DUM.(structname).humerus_l(pos_video,3),  DUM.(structname).torso(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).humerus_r(pos_video,1),  DUM.(structname).torso(pos_video,1)],[DUM.(structname).humerus_r(pos_video,2),  DUM.(structname).torso(pos_video,2)],[DUM.(structname).humerus_r(pos_video,3),  DUM.(structname).torso(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).humerus_r(pos_video,1),  DUM.(structname).ulna_r(pos_video,1)],[DUM.(structname).humerus_r(pos_video,2),  DUM.(structname).ulna_r(pos_video,2)],[DUM.(structname).humerus_r(pos_video,3),  DUM.(structname).ulna_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).humerus_l(pos_video,1),  DUM.(structname).ulna_l(pos_video,1)],[DUM.(structname).humerus_l(pos_video,2),  DUM.(structname).ulna_l(pos_video,2)],[DUM.(structname).humerus_l(pos_video,3),  DUM.(structname).ulna_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).hand_l(pos_video,1),  DUM.(structname).ulna_l(pos_video,1)],[DUM.(structname).hand_l(pos_video,2),  DUM.(structname).ulna_l(pos_video,2)],[DUM.(structname).hand_l(pos_video,3),  DUM.(structname).ulna_l(pos_video,3)], 'LineWidth', 2, 'color', 'k')
plot3(app.UIAxes22,[DUM.(structname).hand_r(pos_video,1),  DUM.(structname).ulna_r(pos_video,1)],[DUM.(structname).hand_r(pos_video,2),  DUM.(structname).ulna_r(pos_video,2)],[DUM.(structname).hand_r(pos_video,3),  DUM.(structname).ulna_r(pos_video,3)], 'LineWidth', 2, 'color', 'k')


scatter3(app.UIAxes22,GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_px'])(TD_analog_frame)*100,GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_py'])(TD_analog_frame)*100,GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_pz'])(TD_analog_frame)*100, 'filled' , 'r')
quiver3(app.UIAxes22,GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_px'])(TD_analog_frame)*100, GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_py'])(TD_analog_frame)*100, GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_pz'])(TD_analog_frame)*100, GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_vx'])(TD_analog_frame), GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_vy'])(TD_analog_frame), GRF_TABLE.(structname).(['ground_force_',num2str(FP.(structname)),'_vz'])(TD_analog_frame) , 'r' , 'LineWidth', 2 )
[azimuth, elevation] = xyzEulerToAzEl(BK_POS_TABLE.(structname).(['patella_',lower(beine),'_Ox'])(TD_kinematic), BK_POS_TABLE.(structname).(['patella_',lower(beine),'_Oy'])(TD_kinematic), BK_POS_TABLE.(structname).(['patella_',lower(beine),'_Oz'])(TD_kinematic));
title (app.UIAxes22,['TD analog=',num2str(GRF_TABLE.(structname).time(TD_analog_frame)),' TD Kinematic=', num2str(BK_POS_TABLE.(structname).time(TD_kinematic))])
if azimuth <0
      view(app.UIAxes22,(azimuth)*+100+90, -90)
else
    view(app.UIAxes22,(azimuth)*-100+90, -90)
  
end

grid (app.UIAxes22, 'off');
axis(app.UIAxes22, 'off');
end