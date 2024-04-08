clc
clear all
close all
folder = 'C:\Users\patrickmai\Desktop\P014\'

fileList = dir(fullfile(folder, '*.mat'));


for i = 1 : length (fileList)-1

    [fileList(i).folder, '/', fileList(i).name]

    datatemp = load([fileList(i).folder, '/', fileList(i).name]);
    tempname = erase (fileList(i).name, '.mat');
    DEL.force = datatemp.(tempname).Force.Force;
    DEL.moments = datatemp.(tempname).Force.Moment;
    DEL.cop = datatemp.(tempname).Force.COP  ;

    %rotate the force to the surface
    FPStruct.FP1.Corners(1,:) = [2266.74636108893; 2.40915779654646; 181.171333585836];
    FPStruct.FP1.Corners(2,:) = [2266.74636108893; 1052.40915779655; 181.171333585836];
    FPStruct.FP1.Corners(3,:) = [-33.3459780184836; 1049.65488362879; -45.6534216360338];
    FPStruct.FP1.Corners(4,:) = [-32.0124572268319; -0.342961076211169; -46.425505270115];

    X = (FPStruct.FP1.Corners(1,:)+FPStruct.FP1.Corners(4,:))./2 - (FPStruct.FP1.Corners(2,:)+FPStruct.FP1.Corners(3,:))./2;
    Y = (FPStruct.FP1.Corners(1,:)+FPStruct.FP1.Corners(2,:))./2 - (FPStruct.FP1.Corners(3,:)+FPStruct.FP1.Corners(4,:))./2;
    Z = cross(X,Y);
    X = X / norm(X);
    Y = Y / norm(Y);
    Z = Z / norm(Z);
    Midpoint =  sum(FPStruct.FP1.Corners)/4;

    FPStruct.FP1.RFP = [X;Y;Z]; %RFP contains the roation matrix of each forceplate
    DEL.forcetrans = DEL.force';
    for k = 1: length (DEL.forcetrans)
        DEL.tmpForce = DEL.forcetrans(k,:);

        FProtiert.FP1.GlobalFORCE_F(k,:) =  FPStruct.FP1.RFP *DEL.tmpForce';

    end

    DEL.FORCErot =  FProtiert.FP1.GlobalFORCE_F';

    [b,a] = butter(4/2, 20/(datatemp.(tempname).Force.Frequency/2), 'low');

    for j = 1 : 3
        DEL.forceFilt(j,:) = filtfilt(b,a,double(DEL.force(j,:)));
        DEL.forceFiltrot(j,:) = filtfilt(b,a,double(DEL.FORCErot(j,:)));
    end

    figure(1)

    subplot(3,1,1)
    plot (DEL.forceFilt(1,:), 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(1,:), 'r', 'LineWidth', 2)
    box off
    ylabel ('Ant-Post [N]')
    subplot(3,1,2)
    plot (DEL.forceFilt(2,:), 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(2,:), 'r', 'LineWidth', 2)
    box off
    ylabel ('Med-Lat [N]')
    subplot(3,1,3)
    plot (DEL.forceFilt(3,:)*-1, 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(3,:)*-1, 'r', 'LineWidth', 2)
    box off
    legend ('Force Global', 'Force rotated to surface')
    legend boxoff
    ylabel ('Vertical [N]')
    clearvars DEL
end


folder = 'C:\Users\patrickmai\Desktop\P014_Up\'

fileList = dir(fullfile(folder, '*.mat'));


for i = 1 : length (fileList)-1

    [fileList(i).folder, '/', fileList(i).name]

    datatemp = load([fileList(i).folder, '/', fileList(i).name]);
    tempname = erase (fileList(i).name, '.mat');
    DEL.force = datatemp.(tempname).Force.Force;
    DEL.moments = datatemp.(tempname).Force.Moment;
    DEL.cop = datatemp.(tempname).Force.COP  ;

    %rotate the force to the surface
    FPStruct.FP1.Corners(1,:) = [2266.74636108893; 2.40915779654646; 181.171333585836];
    FPStruct.FP1.Corners(2,:) = [2266.74636108893; 1052.40915779655; 181.171333585836];
    FPStruct.FP1.Corners(3,:) = [-33.3459780184836; 1049.65488362879; -45.6534216360338];
    FPStruct.FP1.Corners(4,:) = [-32.0124572268319; -0.342961076211169; -46.425505270115];

    X = (FPStruct.FP1.Corners(1,:)+FPStruct.FP1.Corners(4,:))./2 - (FPStruct.FP1.Corners(2,:)+FPStruct.FP1.Corners(3,:))./2;
    Y = (FPStruct.FP1.Corners(1,:)+FPStruct.FP1.Corners(2,:))./2 - (FPStruct.FP1.Corners(3,:)+FPStruct.FP1.Corners(4,:))./2;
    Z = cross(X,Y);
    X = X / norm(X);
    Y = Y / norm(Y);
    Z = Z / norm(Z);
    Midpoint =  sum(FPStruct.FP1.Corners)/4;

    FPStruct.FP1.RFP = [X;Y;Z]; %RFP contains the roation matrix of each forceplate
    DEL.forcetrans = DEL.force';
    for k = 1: length (DEL.forcetrans)
        DEL.tmpForce = DEL.forcetrans(k,:);

        FProtiert.FP1.GlobalFORCE_F(k,:) =  FPStruct.FP1.RFP *DEL.tmpForce';

    end

    DEL.FORCErot =  FProtiert.FP1.GlobalFORCE_F';

    [b,a] = butter(4/2, 20/(datatemp.(tempname).Force.Frequency/2), 'low');

    for j = 1 : 3
        DEL.forceFilt(j,:) = filtfilt(b,a,double(DEL.force(j,:)));
        DEL.forceFiltrot(j,:) = filtfilt(b,a,double(DEL.FORCErot(j,:)));
    end

    figure(2)

    subplot(3,1,1)
    plot (DEL.forceFilt(1,:), 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(1,:), 'r', 'LineWidth', 2)
    box off
    ylabel ('Ant-Post [N]')
    subplot(3,1,2)
    plot (DEL.forceFilt(2,:), 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(2,:), 'r', 'LineWidth', 2)
    box off
    ylabel ('Med-Lat [N]')
    subplot(3,1,3)
    plot (DEL.forceFilt(3,:)*-1, 'g', 'LineWidth', 2)
    hold on
    plot (DEL.forceFiltrot(3,:)*-1, 'r', 'LineWidth', 2)
    box off
    legend ('Force Global', 'Force rotated to surface')
    legend boxoff
    ylabel ('Vertical [N]')
    clearvars DEL
end
