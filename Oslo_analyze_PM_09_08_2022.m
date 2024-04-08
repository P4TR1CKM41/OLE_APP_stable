dt = 1/OPTIONS.FreqKinematics;
framesfor100ms = round(0.1/dt);
%% downsample force
FP.(structname).GRFfilt_downsampled.(GRFsite) = downsample(FP.(structname).GRFfilt.(GRFsite)'  ,OPTIONS.ftkratio)';
FP.(structname).COP_downsampled.(GRFsite) = downsample(FP.(structname).COP.(GRFsite)'  ,OPTIONS.ftkratio)';
FP.(structname).GRFraw_downsampled.(GRFsite) = downsample(FP.(structname).Forceplate.(['Forceplate', num2str(OPTIONS.ForcePlateNumber)]).GlobalRAW'  ,OPTIONS.ftkratio)';
%% find stance in downsampled force
CONTACT_downsampled.(structname) = getContact_FP_app( FP.(structname).GRFfilt_downsampled.(GRFsite)(3,:), OPTIONS.ForceTreshold);

first100ms = [CONTACT_downsampled.(structname)(1):  CONTACT_downsampled.(structname)(framesfor100ms)];
%first100msVID = [fix(CONTACT.(structname)(1)/OPTIONS.ftkratio):fix(CONTACT.(structname)(end)/OPTIONS.ftkratio)];
PARAMETERS.hv_COM(1,co) = norm(MARKERS.(structname)(1).Calc.VCoM_MALE([1, 2], first100ms(1)));
PARAMETERS.Contacttime(1,co) = length(CONTACT.(structname))*(1/OPTIONS.freqGRF);
PARAMETERS.ContacttimeVID(1,co) = length(CONTACT_downsampled.(structname))*(1/OPTIONS.FreqKinematics);




% % % % % % % % % % % % if strcmp(app.LabDropDown.Value,'Oslo')

%% DRAW A FIGURE WITH SOME PROPS

h1 = figure(1);
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'color','w');
%% Create the color matrix for the bar charts and the ratio chart
color_matrix(co, :) = bar_color;
ratio_matrix_left(co, :) = ratio_color_left;
ratio_matrix_right(co, :) = bar_color;


%% additional calculation of variables for OSLO
% PEAK KAM within first 40 ms of stance

KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled = downsample(KINETICS.(structname).(kneefrontalplanemoment)(1,:),OPTIONS.ftkratio );
KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled_forst100ms =  KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled(1,first100ms)/ OPTIONS.mass;
KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE = normalize_vector(KINETICS.(structname).(force_expression)(:, first100ms*OPTIONS.ftkratio)', 0.5);
FP.(structname).resultantGRF = normalize_vector(FP.(structname).GRFfilt.(GRFsite)(:,first100ms*OPTIONS.ftkratio)', 0.5)/ OPTIONS.mass;
[PARAMETERS.PEAK_KNEE_X(1,co), pos]=max( KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled_forst100ms);

% Ratio of the medio lateral and vGRF expressed in the knee
PARAMETERS.RATIO(1,co)=KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE(pos*OPTIONS.ftkratio,1)/KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE(pos*OPTIONS.ftkratio,3);
PARAMETERS.MED(1,co)=KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE(pos*OPTIONS.ftkratio,1);
PARAMETERS.ANT(1,co)=KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE(pos*OPTIONS.ftkratio,2);
PARAMETERS.VERT(1,co)=KINETICS.(structname).NORM_GRF_EXPRESSED_IN_KNEE(pos*OPTIONS.ftkratio,3);

% Hip abduction angle at TD
PARAMETERS.HIPABDUCTIONatTD(1,co) =   WINKEL.(structname).JOINT.Classic.(hipside).grad.X (first100ms(1))*multi;

% Foot strike angle (in global CS)
PARAMETERS.FOOTSTRIKE_PATTERN(1,co) =   WINKEL.(structname).SEGMENT.Classic.(footside).grad.X (first100ms(1));

% Frontal plane leverarm of the knee joint
PARAMETERS.LEVERARMATPEAKKAM(1,co) = (PARAMETERS.PEAK_KNEE_X(1,co)/norm(FP.(structname).resultantGRF(pos*OPTIONS.ftkratio,:)))*100; % convert from m in cm

% Cutting angle
tdmarker = fix(CONTACT.(structname)(1)/OPTIONS.ftkratio);
tomarker = fix(CONTACT.(structname)(end)/OPTIONS.ftkratio);
atTD = MARKERS.(structname).Calc.VCoM_MALE([1,2],tdmarker);
atTO = MARKERS.(structname).Calc.VCoM_MALE([1,2],tomarker);
PARAMETERS.CuttingAngle(1,co)  = acosd (dot(atTD, atTO) / ((norm(atTD)*norm(atTO))));

% foot progression angle
COMVelTD=   MARKERS.(structname).Calc.CoM_MALE ([1,2],first100ms(1));
COMVelTDplus1=   MARKERS.(structname).Calc.CoM_MALE ([1,2],first100ms(2));
toeTD=MARKERS.(structname).Opti.(toe).data([1,2], first100ms(1));
heelTD = MARKERS.(structname).Opti.(ferse).data([1,2], first100ms(1));
fuss =  (heelTD-toeTD );
x1 = fuss(1,1)*multi;
x2= fuss(2,1);
y1= (COMVelTD(1,1));
y2 = (COMVelTD(2,1));
PARAMETERS.FootProgressionAngle(:,co) = atan2d(x1*y2-y1*x2,x1*x2+y1*y2);

% vertical COM velcoity at TD
PARAMETERS.verticalCoMVelATTD(1,co) = abs((MARKERS.(structname).Calc.VCoM_MALE(end,first100ms(1))));

% Peak KAM of the cut with the highest KAM
[PeakPeakKAM, posPeakPeakKAM] = max (PARAMETERS.PEAK_KNEE_X);

%% Draw the Dashboard
n_sub = 5;
n_sub_rows = 3;

subplot(n_sub,n_sub_rows,7)
bar(PARAMETERS.HIPABDUCTIONatTD(1,:)*-1, 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', color_matrix);
xline(mean (PARAMETERS.HIPABDUCTIONatTD(1,:)*-1));
xlabel ('Hip abduction angle at TD [°]');
stan_plot_generell
set(gca,'TickLabelInterpreter','none');
set(gca, 'Ytick', [1:co]);
set(gca, 'YTickLabel', ytick_labels);
limits = ylim;
x = [13.4 22.6 22.6 13.4];
y = [limits(1) limits(1) limits(2) limits(2) ];
patch(x,y,'red', 'FaceAlpha',.3, 'EdgeColor', 'none');
box off



subplot(n_sub,n_sub_rows,4)
bar( PARAMETERS.FOOTSTRIKE_PATTERN(1,:)', 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', color_matrix);
xline(mean (PARAMETERS.FOOTSTRIKE_PATTERN(1,:)));
xlabel ('Foot strike angle [°]');
stan_plot_generell
set(gca,'TickLabelInterpreter','none');
set(gca, 'Ytick', [1:co]);
set(gca, 'YTickLabel', ytick_labels);
limits = ylim;
x = [2.6-12.5 2.6+12.5 2.6+12.5 2.6-12.5];
y = [limits(1) limits(1) limits(2) limits(2) ];
patch(x,y,'red', 'FaceAlpha',.3, 'EdgeColor', 'none')
box off



subplot(n_sub,n_sub_rows,1)
bar(PARAMETERS.PEAK_KNEE_X(1,:)', 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', color_matrix);
xline(mean (PARAMETERS.PEAK_KNEE_X(1,:)));
xlabel ('KAM [Nm/kg]');
stan_plot_generell
set(gca,'TickLabelInterpreter','none');
set(gca, 'Ytick', [1:co]);
set(gca, 'YTickLabel', ytick_labels);
limits = ylim;
x = [1.09 2.21 2.21 1.09];
y = [limits(1) limits(1) limits(2) limits(2) ];
patch(x,y,'red', 'FaceAlpha',.3, 'EdgeColor', 'none');
title ('Grey = Left leg, Black = Right leg')

sub2 = subplot(n_sub,n_sub_rows,[3 6 9 12]);
make_stick_figure(OPTIONS, beine, MARKERS, FP, WINKEL, KINETICS, structname, kneefrontalplanemoment, CONTACT,  CONTACT_downsampled);
%% location of subpart on figure
xstart=.8;
xend=0.9;
ystart=.8;
yend=0.9;
axes('position',[xstart ystart xend-xstart yend-ystart ])
box off
plot(KINETICS.(structname).Fontal_Plane_Knee_Moment_downsampled_forst100ms )% here i am plotting sub part of same figure. you plot another figure

ylabel ('KAM [Nm/kg]')
xlabel ('Video Frame within first 100 ms ')
axis on
box off
%grid on
title('at Peak KAM')

sub2 = subplot(n_sub,n_sub_rows,[2 5 8 11]);
make_stick_figure_at_TD(OPTIONS, beine, MARKERS, FP, WINKEL, KINETICS, structname, kneefrontalplanemoment, CONTACT,  CONTACT_downsampled);
title('at Touchdown (TD)')
axis off




text_plot2 = subplot(n_sub,n_sub_rows,14);%at TD
cla(text_plot2)
axis off
str_1{1,co} = sprintf("CA: %d°", round(PARAMETERS.CuttingAngle(:, co)));
str_2{1,co} = ['Hori Vel: ', num2str(round(PARAMETERS.hv_COM(1, co), 1)), 'm/s'];
str_3{1,co} = sprintf("Con. Time: %d ms", fix(PARAMETERS.Contacttime(1, co)*1000));
str_5{1,co} = ['Valgus at TD: ', num2str(round(WINKEL.(structname).JOINT.Classic.(anglename).grad.X(first100ms(1))*multi, 1)), ' °'];
str_6{1,co} = ['Foot progr.: ', num2str(round(PARAMETERS.FootProgressionAngle(:,co)*multi, 1)), ' °'];
text(0.1, 1, str_1{1,co});
text (0.1,0.8,(erase (str_1{1,posPeakPeakKAM}, 'CA: ')), 'Color', 'r');
text(0.35, 1, str_2{1,co});
text (0.35,0.8,(erase (str_2{1,posPeakPeakKAM}, 'Hori Vel: ')), 'Color', 'r');
text(0.8, 1, str_3{1,co});
text (0.8,0.8,(erase (str_3{1,posPeakPeakKAM}, 'Con. Time:')), 'Color', 'r');
text(0.35, 0.5, str_5{1,co});
text (0.35,0.3,(erase (str_5{1,posPeakPeakKAM}, 'Valgus at TD: ')), 'Color', 'r');
text(0.8, 0.5, str_6{1,co});
text (0.8,0.3,(erase (str_6{1,posPeakPeakKAM}, 'Foot progr.: ')), 'Color', 'r');
hold off


text_plot = subplot(n_sub,n_sub_rows,15); % at peak KAM
cla(text_plot)
axis off
str_4{1,co} = ['Lever arm: ', num2str(round(PARAMETERS.LEVERARMATPEAKKAM(1, co), 1)), ' cm'];
str_7{1,co} = ['Time2KAM: ', num2str(round(pos*(1/OPTIONS.FreqKinematics  )*1000)), ' ms'];
str_8{1,co} = ['Res. GRF: ', num2str(round(norm(FP.(structname).resultantGRF(pos*OPTIONS.ftkratio,:)),2))];
str_9{1,co} = ['Peak KAM: ', num2str(round(PARAMETERS.PEAK_KNEE_X(1,co),1))];

text(0.1, 0.5, str_4{1,co});
text (0.1, 0.3,(erase (str_4{1,posPeakPeakKAM}, 'Lever arm: ')), 'Color', 'r');
text(0.1, 0, str_7{1,co});
text (0.1, -0.2,(erase (str_7{1,posPeakPeakKAM}, 'Time2KAM: ')), 'Color', 'r');
text(0.5, 0, str_8{1,co});
text (0.5, -0.2,(erase (str_8{1,posPeakPeakKAM}, 'Res. GRF: ')), 'Color', 'r');
text(0.5, 0.5, str_9{1,co});
text (0.5, 0.3,(erase (str_9{1,posPeakPeakKAM}, 'Peak KAM: ')), 'Color', 'r');
hold off


subplot(n_sub,n_sub_rows,10)
bar(PARAMETERS.verticalCoMVelATTD(1,:)', 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', color_matrix)
xline(mean (PARAMETERS.verticalCoMVelATTD(1,:)))
%         xline(1.5)
xlabel ('v CoM velocity at TD [m/s]')
stan_plot_generell
set(gca,'TickLabelInterpreter','none')
set(gca, 'Ytick', [1:co]);
set(gca, 'YTickLabel', ytick_labels);
limits = ylim;
x = [1.24 1.86 1.86 1.24];
y = [limits(1) limits(1) limits(2) limits(2) ];
patch(x,y,'red', 'FaceAlpha',.3, 'EdgeColor', 'none')

subplot(n_sub, 3,13)
left = PARAMETERS.MED(1,:)./(PARAMETERS.MED(1,:)+ PARAMETERS.VERT(1,:)); % Scale 0-1, grows leftwards
right = PARAMETERS.VERT(1,:)./(PARAMETERS.MED(1,:)+ PARAMETERS.VERT(1,:)); % Scale 0-35, grows rightwards

% Automatically determine the scaling factor using the data itself
scale = max(right) / max(left);
scale=1;
% Create the left bar by scaling the magnitude
bar(-left*scale, 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', ratio_matrix_left)
hold on
bar(right, 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', ratio_matrix_right)
xticks = get(gca, 'xtick');
labels = get(gca, 'xtickLabel');
if ischar(labels);
    labels = cellstr(labels);
end
toscale = xticks < 0;
labels(toscale) = arrayfun(@(x)sprintf('%0.2f', x), ...
    abs(xticks(toscale) / scale), 'uniformoutput', false);
set(gca, 'xtick', xticks, 'xticklabel', labels)
xmax = max(get(gca, 'xlim'));
if co ==1
    label(1) = text(xmax / 2, 0, 'Vert Force');
    label(2) = text(-xmax/ 2, 0, 'Med Force');
else
end
box off
xline(-1, 'color', [1 1 1])
xline(1,  'color', [1 1 1])


PARAMETERS.RES_GRF_AT_PEAK_KAM(1,co)= (norm(FP.(structname).resultantGRF(pos*OPTIONS.ftkratio,:)));
PARAMETERS.TIME_TO_PEAK_KAM(1,co)= (pos*(1/OPTIONS.FreqKinematics )*1000); 
pause(0.0000000000001)
clearvars dt framesfor100ms first100ms
%% TODO
ANALYZEDLEG.(structname)= beine;
ANALYZEDFORCEPLATE.(structname)= OPTIONS.ForcePlateNumber;
NORMAL.(beine).DUMMYVAR.DUMMYJOINT.DUMMYPLANE=0;
%% save specific workspace variables to mat
desination =  [app.storageglobal_path,'/', app.IDEditField.Value, '/'];
mkdir (desination)
OPTIONS.Instruction.(structname) = app.InstructionsgivenCheckBox.Value  ;
save([desination,'/', app.IDEditField.Value, '.mat'], 'OPTIONS', 'FP','KINETICS','WINKEL', 'MARKERS', 'FRAME',...
    'REFFRAME', 'REFMARKERS',   'R', 'JOINT', 'LABELS', 'PARAMETERS', 'CONTACT', 'NORMAL', 'ANALYZEDLEG', 'ANALYZEDFORCEPLATE');