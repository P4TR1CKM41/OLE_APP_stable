function  app_control(app)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
selectedButton = app.ButtonGroup.SelectedObject;
cmap = colormap(parula(10));
clc
app.storageglobal_path;
load('C:\Users\patrickmai\Downloads\Norge_Test_Data_Cut\RightLeg\The_correct_for_KAM_and_leverarm.mat');
PEAKAM_mean = mean(MERGEDDATA.R.DISCRETE.REALKAM2(:));
PEAKAM_std = std(MERGEDDATA.R.DISCRETE.REALKAM2(:));

while strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==1)
    try
        File_to_load = [app.storageglobal_path, '/out_pm.mat'];
        Real_TIME_DATA = load (File_to_load);
        [n_tarils, ~] =  size (Real_TIME_DATA.GRF_FP2);


        for n = 1 : n_tarils
            %% find stance
            CONTACT = getContact_FP(Real_TIME_DATA.GRF_FP2{n, 1}(:,end)', 50);
            CONTACT_VID = round(CONTACT/Real_TIME_DATA.ANALOG_VIDEO_FRAME_RATIO{1, 1});
            %% filter
            [b,a] = butter(4/2, 20/(Real_TIME_DATA.FRAME_RATE{1, 1}*Real_TIME_DATA.ANALOG_VIDEO_FRAME_RATIO{1, 1})   , 'low');
            [b_vid,a_vid] = butter(4/2, 20/(Real_TIME_DATA.FRAME_RATE{1, 1})   , 'low');

            %% make for plots
            GRFFILT= filtfilt(b, a, Real_TIME_DATA.GRF_FP2{n, 1}(CONTACT,end));
            MOMENT_FILT= filtfilt(b_vid, a_vid, Real_TIME_DATA.MOMENT_R_KNEE{n, 1}([CONTACT_VID(1):CONTACT_VID(end)],1));
            KNEE_ANGLE_FILT= filtfilt(b_vid, a_vid, Real_TIME_DATA.ANGLE_R_KNEE{n, 1}([CONTACT_VID(1):CONTACT_VID(end)],2));


            %% visualize
            figure(1)
            set(gcf, 'Position', get(0, 'Screensize'));
            set(gcf,'color','w');
            subplot(2,2,1)
            plot(GRFFILT/ app.BodymassEditField.Value, 'color', [cmap(n,:)])
            hold on
            ylabel ('vertical GRF')
            box off
            subplot(2,2,2)
            plot(MOMENT_FILT/ app.BodymassEditField.Value, 'color', [cmap(n,:)])
            hold on
            box off
            
            subplot(2,2,3)
            notBoxPlot(MERGEDDATA.R.DISCRETE.REALKAM2(:))
            hold on
            scatter (1, (min(MOMENT_FILT/app.BodymassEditField.Value)*-1)-0.7, 'filled', 'MarkerEdgeColor',[cmap(n,:)], 'MarkerFaceColor',[cmap(n,:)] )
            scatter (1, MERGEDDATA.R.DISCRETE.REALKAM2(41,2), 'filled', 'k')
            hold on
            box off

            subplot(2,2,4)
            notBoxPlot(MERGEDDATA.R.DISCRETE.KNEEVALGUSANGLETD(:))
            ylabel ('Knee Valgus at TD')
            hold on
            scatter (1, KNEE_ANGLE_FILT(1,1)+3, 'filled', 'MarkerEdgeColor',[cmap(n,:)], 'MarkerFaceColor',[cmap(n,:)] )
            scatter (1, MERGEDDATA.R.DISCRETE.KNEEVALGUSANGLETD(41,2), 'filled', 'k')
            hold on
            box off

            tempname =  strsplit (Real_TIME_DATA.FILE_NAME{n, 1}, '\');
            cutname = erase (tempname{1, end}, '.c3d');
            legend (cutname)
            disp ('In loop')
            n = n+1;
        end
        stop= strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==0);


    catch
        app.FoldertomonitorEditField.Value = ('no matfile detected')
        stop= strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==0);
        clc


    end
    pause(2)


    if stop ==1


        break;
    end

    disp ('out loop')
end

end