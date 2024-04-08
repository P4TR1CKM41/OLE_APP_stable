function make_stick_figure(OPTIONS, beine, MARKERS, FP, WINKEL, KINETICS, structname, kneefrontalplanemoment, CONTACT,  CONTACT_downsampled)

% load('C:\Users\patrickmai\Desktop\TestFolder\PAB01\PAB01.mat')
% structname ='Cutting14';
% ftkratio = mainStruct.(name).Force(fp).SamplingFactor;

        framesfor100ms = round(0.1/(1/OPTIONS.freqGRF));

KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled_forst100ms ;
[value , pos] = max(KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled_forst100ms  );
%%%%%[~ , pos] = max (KINETICS.(structname).(kneefrontalplanemoment)(1,[CONTACT.(structname)(1):CONTACT.(structname)(framesfor100ms)]  ));
% % % subplot(2,1,1)
% % % plot(KINETICS.(structname).(kneefrontalplanemoment)(1,: ))
% % % subplot(2,1,2)
% % % plot(FP.P048_Cutting12_L.GRFfilt.Left(end,:))

pos_vid= pos+CONTACT_downsampled.(structname)(1)-1; 
jcnames = fieldnames (MARKERS.(structname).Derived);
% upper_body = {'C_7', 'acrom_left', 'acrom_right', 'elbow_top_left', }
pos_video = pos_vid  ;% fix ((pos_analog + OPTIONS.ftkratio - 1)/OPTIONS.ftkratio);
if beine == 'L'
    fp_leg = 'Left';
    torot = WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Z(pos_video);
multi =-1;
elseif beine == 'R'
    fp_leg = 'Right';
    torot = WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Z(pos_video);
multi =1;
end

set(gcf,'color','w');
for j = 1 : length (jcnames)
    scatter3(MARKERS.(structname).Derived.(jcnames{j, 1})(1,pos_video), MARKERS.(structname).Derived.(jcnames{j, 1})(2,pos_video), MARKERS.(structname).Derived.(jcnames{j, 1})(3,pos_video) ,'filled', 'k')
    hold on
    axis equal
    grid off
    axis off
end

plot3([MARKERS.(structname).Derived.RightMPJC(1,pos_video),  MARKERS.(structname).Derived.RightAnkleJC(1,pos_video)],[MARKERS.(structname).Derived.RightMPJC(2,pos_video),  MARKERS.(structname).Derived.RightAnkleJC(2,pos_video)],[MARKERS.(structname).Derived.RightMPJC(3,pos_video),  MARKERS.(structname).Derived.RightAnkleJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.RightMPJC(1,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(1,pos_video)],[MARKERS.(structname).Derived.RightMPJC(2,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(2,pos_video)],[MARKERS.(structname).Derived.RightMPJC(3,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.RightAnkleJC(1,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(1,pos_video)],[MARKERS.(structname).Derived.RightAnkleJC(2,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(2,pos_video)],[MARKERS.(structname).Derived.RightAnkleJC(3,pos_video),  MARKERS.(structname).Filt.calc_back_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Derived.RightAnkleJC(1,pos_video),  MARKERS.(structname).Derived.RightKneeJC(1,pos_video)],[MARKERS.(structname).Derived.RightAnkleJC(2,pos_video),  MARKERS.(structname).Derived.RightKneeJC(2,pos_video)],[MARKERS.(structname).Derived.RightAnkleJC(3,pos_video),  MARKERS.(structname).Derived.RightKneeJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.RightKneeJC(1,pos_video),  MARKERS.(structname).Derived.RightHipJC(1,pos_video)],[MARKERS.(structname).Derived.RightKneeJC(2,pos_video),  MARKERS.(structname).Derived.RightHipJC(2,pos_video)],[MARKERS.(structname).Derived.RightKneeJC(3,pos_video),  MARKERS.(structname).Derived.RightHipJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Derived.LeftMPJC(1,pos_video),  MARKERS.(structname).Derived.LeftAnkleJC(1,pos_video)],[MARKERS.(structname).Derived.LeftMPJC(2,pos_video),  MARKERS.(structname).Derived.LeftAnkleJC(2,pos_video)],[MARKERS.(structname).Derived.LeftMPJC(3,pos_video),  MARKERS.(structname).Derived.LeftAnkleJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.LeftAnkleJC(1,pos_video),  MARKERS.(structname).Derived.LeftKneeJC(1,pos_video)],[MARKERS.(structname).Derived.LeftAnkleJC(2,pos_video),  MARKERS.(structname).Derived.LeftKneeJC(2,pos_video)],[MARKERS.(structname).Derived.LeftAnkleJC(3,pos_video),  MARKERS.(structname).Derived.LeftKneeJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.LeftKneeJC(1,pos_video),  MARKERS.(structname).Derived.LeftHipJC(1,pos_video)],[MARKERS.(structname).Derived.LeftKneeJC(2,pos_video),  MARKERS.(structname).Derived.LeftHipJC(2,pos_video)],[MARKERS.(structname).Derived.LeftKneeJC(3,pos_video),  MARKERS.(structname).Derived.LeftHipJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Derived.LeftMPJC(1,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(1,pos_video)],[MARKERS.(structname).Derived.LeftMPJC(2,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(2,pos_video)],[MARKERS.(structname).Derived.LeftMPJC(3,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.LeftAnkleJC(1,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(1,pos_video)],[MARKERS.(structname).Derived.LeftAnkleJC(2,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(2,pos_video)],[MARKERS.(structname).Derived.LeftAnkleJC(3,pos_video),  MARKERS.(structname).Filt.calc_back_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Derived.LeftKneeJC(1,pos_video),  MARKERS.(structname).Derived.LeftHipJC(1,pos_video)],[MARKERS.(structname).Derived.LeftKneeJC(2,pos_video),  MARKERS.(structname).Derived.LeftHipJC(2,pos_video)],[MARKERS.(structname).Derived.LeftKneeJC(3,pos_video),  MARKERS.(structname).Derived.LeftHipJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Derived.LeftHipJC(1,pos_video),  MARKERS.(structname).Derived.RightHipJC(1,pos_video)],[MARKERS.(structname).Derived.LeftHipJC(2,pos_video),  MARKERS.(structname).Derived.RightHipJC(2,pos_video)],[MARKERS.(structname).Derived.LeftHipJC(3,pos_video),  MARKERS.(structname).Derived.RightHipJC(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Opti.C_7.data(1,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(1,pos_video)+  MARKERS.(structname).Derived.RightHipJC(1,pos_video)]/2]], [MARKERS.(structname).Opti.C_7.data(2,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(2,pos_video)+  MARKERS.(structname).Derived.RightHipJC(2,pos_video)]/2]], [MARKERS.(structname).Opti.C_7.data(3,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(3,pos_video)+  MARKERS.(structname).Derived.RightHipJC(3,pos_video)]/2]], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Filt.acrom_left.data(1,pos_video),  MARKERS.(structname).Filt.acrom_right.data(1,pos_video)],[MARKERS.(structname).Filt.acrom_left.data(2,pos_video),  MARKERS.(structname).Filt.acrom_right.data(2,pos_video)],[MARKERS.(structname).Filt.acrom_left.data(3,pos_video),  MARKERS.(structname).Filt.acrom_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Opti.C_7.data(1,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(1,pos_video)+  MARKERS.(structname).Derived.RightHipJC(1,pos_video)]/2]], [MARKERS.(structname).Opti.C_7.data(2,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(2,pos_video)+  MARKERS.(structname).Derived.RightHipJC(2,pos_video)]/2]], [MARKERS.(structname).Opti.C_7.data(3,pos_video), [[MARKERS.(structname).Derived.LeftHipJC(3,pos_video)+  MARKERS.(structname).Derived.RightHipJC(3,pos_video)]/2]], 'LineWidth', 2, 'color', 'k')
try
plot3([MARKERS.(structname).Filt.elbow_top_right.data(1,pos_video),  MARKERS.(structname).Filt.acrom_right.data(1,pos_video)],[MARKERS.(structname).Filt.elbow_top_right.data(2,pos_video),  MARKERS.(structname).Filt.acrom_right.data(2,pos_video)],[MARKERS.(structname).Filt.elbow_top_right.data(3,pos_video),  MARKERS.(structname).Filt.acrom_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end
try
plot3([MARKERS.(structname).Filt.elbow_top_right.data(1,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(1,pos_video)],[MARKERS.(structname).Filt.elbow_top_right.data(2,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(2,pos_video)],[MARKERS.(structname).Filt.elbow_top_right.data(3,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end
try
plot3([MARKERS.(structname).Filt.elbow_top_left.data(1,pos_video),  MARKERS.(structname).Filt.acrom_left.data(1,pos_video)],[MARKERS.(structname).Filt.elbow_top_left.data(2,pos_video),  MARKERS.(structname).Filt.acrom_left.data(2,pos_video)],[MARKERS.(structname).Filt.elbow_top_left.data(3,pos_video),  MARKERS.(structname).Filt.acrom_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end
try
plot3([MARKERS.(structname).Filt.elbow_top_left.data(1,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(1,pos_video)],[MARKERS.(structname).Filt.elbow_top_left.data(2,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(2,pos_video)],[MARKERS.(structname).Filt.elbow_top_left.data(3,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end
try
plot3([MARKERS.(structname).Filt.hand_top_left.data(1,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(1,pos_video)],[MARKERS.(structname).Filt.hand_top_left.data(2,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(2,pos_video)],[MARKERS.(structname).Filt.hand_top_left.data(3,pos_video),  MARKERS.(structname).Filt.hand_med_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end
try
plot3([MARKERS.(structname).Filt.hand_top_right.data(1,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(1,pos_video)],[MARKERS.(structname).Filt.hand_top_right.data(2,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(2,pos_video)],[MARKERS.(structname).Filt.hand_top_right.data(3,pos_video),  MARKERS.(structname).Filt.hand_med_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
end

plot3([MARKERS.(structname).Filt.C_7.data(1,pos_video),  MARKERS.(structname).Filt.head_back_left.data(1,pos_video)],[MARKERS.(structname).Filt.C_7.data(2,pos_video),  MARKERS.(structname).Filt.head_back_left.data(2,pos_video)],[MARKERS.(structname).Filt.C_7.data(3,pos_video),  MARKERS.(structname).Filt.head_back_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Filt.C_7.data(1,pos_video),  MARKERS.(structname).Filt.head_back_right.data(1,pos_video)],[MARKERS.(structname).Filt.C_7.data(2,pos_video),  MARKERS.(structname).Filt.head_back_right.data(2,pos_video)],[MARKERS.(structname).Filt.C_7.data(3,pos_video),  MARKERS.(structname).Filt.head_back_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Filt.head_front_left.data(1,pos_video),  MARKERS.(structname).Filt.head_back_left.data(1,pos_video)],[MARKERS.(structname).Filt.head_front_left.data(2,pos_video),  MARKERS.(structname).Filt.head_back_left.data(2,pos_video)],[MARKERS.(structname).Filt.head_front_left.data(3,pos_video),  MARKERS.(structname).Filt.head_back_left.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')
plot3([MARKERS.(structname).Filt.head_front_right.data(1,pos_video),  MARKERS.(structname).Filt.head_back_right.data(1,pos_video)],[MARKERS.(structname).Filt.head_front_right.data(2,pos_video),  MARKERS.(structname).Filt.head_back_right.data(2,pos_video)],[MARKERS.(structname).Filt.head_front_right.data(3,pos_video),  MARKERS.(structname).Filt.head_back_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')

plot3([MARKERS.(structname).Filt.head_front_left.data(1,pos_video),  MARKERS.(structname).Filt.head_front_right.data(1,pos_video)],[MARKERS.(structname).Filt.head_front_left.data(2,pos_video),  MARKERS.(structname).Filt.head_front_right.data(2,pos_video)],[MARKERS.(structname).Filt.head_front_left.data(3,pos_video),  MARKERS.(structname).Filt.head_front_right.data(3,pos_video)], 'LineWidth', 2, 'color', 'k')



% pos = fix ((pos + OPTIONS.ftkratio - 1)*OPTIONS.ftkratio);
scatter3(FP.(structname).COP_downsampled.(fp_leg)(1,pos_video), FP.(structname).COP_downsampled.(fp_leg)(2,pos_video), 0, 'filled' , 'r')
%FP.P048_Cutting12_L.Forceplate.Forceplate3.Global 
%plot3([FP.(structname).COP_downsampled.(fp_leg)(1,pos_video),  FP.(structname).Forceplate.Forceplate3.Global(1,pos_video)],[FP.(structname).COP_downsampled.(fp_leg)(2,pos_video),  FP.(structname).Forceplate.Forceplate3.Global(2,pos_video)],[FP.(structname).COP_downsampled.(fp_leg)(3,pos_video),  FP.(structname).Forceplate.Forceplate3.Global(3,pos_video)], 'LineWidth', 2, 'color', 'r')
quiver3(FP.(structname).COP_downsampled.(fp_leg)(1,pos_video), FP.(structname).COP_downsampled.(fp_leg)(2,pos_video), 0, FP.(structname).GRFfilt_downsampled.(fp_leg)(1,pos_video), FP.(structname).GRFfilt_downsampled.(fp_leg)(2,pos_video), FP.(structname).GRFfilt_downsampled.(fp_leg)(3,pos_video) , 'r' , 'LineWidth', 2 )
% quiver3(FP.(structname).COP_downsampled.(fp_leg)(1,pos_video), FP.(structname).COP_downsampled.(fp_leg)(2,pos_video), FP.(structname).COP_downsampled.(fp_leg)(3,pos_video), FP.(structname).GRFraw_downsampled.(fp_leg)(1,pos_video), FP.(structname).GRFraw_downsampled.(fp_leg)(2,pos_video), FP.(structname).GRFraw_downsampled.(fp_leg)(3,pos_video) , 'b' , 'LineWidth', 2)
%plot3([FP.(structname).COP_downsampled.(fp_leg)(1,pos),  FP.(structname).GRFfilt__downsampled.(fp_leg)(1,pos)],[FP.(structname).COP_downsampled.(fp_leg)(2,pos),  FP.(structname).GRFfilt__downsampled.(fp_leg)(2,pos)],[FP.(structname).COP_downsampled.(fp_leg)(3,pos),  FP.(structname).GRFfilt__downsampled.(fp_leg)(3,pos)], 'LineWidth', 2, 'color', 'r')
% scatter3(0,0,0, 'filled')
view(torot+90, 0)
axis off
hold off
end