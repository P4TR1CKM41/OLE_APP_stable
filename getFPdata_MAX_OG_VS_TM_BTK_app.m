function [FP, RFP, Cornerpoints, freq_grf] = getFPdata_MAX_OG_VS_TM_BTK_app(FileName, AFP, cutoff_grf, FERSE, n_frames, kinetics, alphaA)
strength = 5;
M = c3dserver;
openc3d(M,0,FileName);
start = M.GetVideoFrame(0);
ende = M.GetVideoFrame(1);
ftkratio = M.GetAnalogVideoRatio;
index1 = M.GetParameterIndex('FORCE_PLATFORM', 'USED');
n_FP = M.GetParameterValue(index1,0);
fIndex = M.GetParameterIndex('FORCE_PLATFORM', 'ORIGIN');
az0 = -M.GetParameterValue(fIndex,2);
assignin('base', 'az0', az0);


fIndex2 = M.GetParameterIndex('FORCE_PLATFORM', 'CORNERS');
fIndex2length = M.GetParameterLength(fIndex2);
indexgrf = M.GetParameterIndex('ANALOG', 'RATE');
freq_grf = M.GetParameterValue(indexgrf,0);

acq = btkReadAcquisition(FileName);

[forceplates, forceplatesInfo] = btkGetForcePlatforms(acq);
fpw = btkGetForcePlatformWrenches(acq, 0);


if kinetics
    for z = 1:fIndex2length
        Corners(z,1) = M.GetParameterValue(fIndex2,z-1);
    end
    Cornerpoints.P1 = Corners(1 + (AFP-1)*12:3 + (AFP-1)*12,1);
    Cornerpoints.P2 = Corners(4 + (AFP-1)*12:6 + (AFP-1)*12,1);
    Cornerpoints.P3 = Corners(7 + (AFP-1)*12:9 + (AFP-1)*12,1);
    Cornerpoints.P4 = Corners(10 + (AFP-1)*12:12 + (AFP-1)*12,1);
    Cornerpoints.P1(3,1) = 0;
    Cornerpoints.P2(3,1) = 0;
    Cornerpoints.P3(3,1) = 0;
    Cornerpoints.P4(3,1) = 0;
    %     Midpoint = sum(Cornerpoints.P1, Cornerpoints.P2, Cornerpoints.P3, Cornerpoints.P4)/4;
    X = (Cornerpoints.P1+Cornerpoints.P4)./2 - (Cornerpoints.P2+Cornerpoints.P3)./2;
    Y = (Cornerpoints.P1+Cornerpoints.P2)./2 - (Cornerpoints.P3+Cornerpoints.P4)./2;
    Z = cross(X,Y);
    X = X / norm(X);
    Y = Y / norm(Y);
    Z = Z / norm(Z);
    
    RFP = [X,Y,Z];
    RFP = [-1 0 0; 0 1 0; 0 0 -1];
else
    RFP = [1 0 0; 0 1 0; 0 0 1];
end

foundfx = 1;
foundfy = 1;
foundfz = 1;
foundmx = 1;
foundmy = 1;
foundmz = 1;

for run2 = AFP
    
    FP.(['Forceplate',num2str(run2)]).Analog(1,:) = Filter_ECCO(fpw(run2).F(:,1)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(1,:) = fpw(run2).F(:,1)';
    
    FP.(['Forceplate',num2str(run2)]).Analog(2,:) = Filter_ECCO(fpw(run2).F(:,2)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(2,:) = fpw(run2).F(:,2)';
    
    FP.(['Forceplate',num2str(run2)]).Analog(3,:) = Filter_ECCO(fpw(run2).F(:,3)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(3,:) = fpw(run2).F(:,3)';
    
    FP.(['Forceplate',num2str(run2)]).Analog(4,:) = Filter_ECCO(fpw(run2).M(:,1)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(4,:) = fpw(run2).M(:,1)';
    
    FP.(['Forceplate',num2str(run2)]).Analog(5,:) = Filter_ECCO(fpw(run2).M(:,2)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(5,:) = fpw(run2).M(:,2)';
    
    FP.(['Forceplate',num2str(run2)]).Analog(6,:) = Filter_ECCO(fpw(run2).M(:,3)', strength, double(freq_grf), cutoff_grf);
    FP.(['Forceplate',num2str(run2)]).AnalogRAW(6,:) = fpw(run2).M(:,3)';
    
end

if kinetics == 0
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Analog)
        FP.(['Forceplate',num2str(run2)]).Analog(:,i) = 0;
        FP.(['Forceplate',num2str(run2)]).AnalogRAW(:,i) = 0;
    end
    FERSE = [0;0;0];
end

%for j = 1:6
%    FP.Kistleractio(j,:) = FP.Analog(j,:);
%end

if kinetics
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Analog)
        FP.(['Forceplate',num2str(run2)]).Global(:,i) = RFP*FP.(['Forceplate',num2str(run2)]).Analog(1:3,i);
        try
            FP.(['Forceplate',num2str(run2)]).Global_tilt(:,i) = [1 0 0; 0 cosd(alphaA) -sind(alphaA); 0 sind(alphaA) cosd(alphaA)] * FP.(['Forceplate',num2str(run2)]).Global(:,i);
        end
        FP.(['Forceplate',num2str(run2)]).AngleSAG(1,i) = atand(FP.(['Forceplate',num2str(run2)]).Global(1,i) / FP.(['Forceplate',num2str(run2)]).Global(3,i));
        FP.(['Forceplate',num2str(run2)]).AngleFRONT(1,i) = atand(FP.(['Forceplate',num2str(run2)]).Global(2,i) / FP.(['Forceplate',num2str(run2)]).Global(3,i));
        FP.(['Forceplate',num2str(run2)]).AngleTRANS(1,i) = atand(FP.(['Forceplate',num2str(run2)]).Global(1,i) / FP.(['Forceplate',num2str(run2)]).Global(2,i));
        FP.(['Forceplate',num2str(run2)]).GlobalRAW(:,i) = RFP*FP.(['Forceplate',num2str(run2)]).AnalogRAW(1:3,i);
    end
end

if kinetics == 0
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Analog)
        FP.(['Forceplate',num2str(run2)]).Global(:,i) = [0;0;0];
        FP.(['Forceplate',num2str(run2)]).AngleSAG(1,i) = 0;
        FP.(['Forceplate',num2str(run2)]).AngleFRONT(1,i) = 0;
        FP.(['Forceplate',num2str(run2)]).AngleTRANS(1,i) = 0;
        FP.(['Forceplate',num2str(run2)]).GlobalRAW(:,i) = [0;0;0];
    end
    
end




if kinetics
    Corner1.(['Forceplate',num2str(run2)]).data = Corners(run2+11*(run2-1):run2+11*(run2-1)+2,1);
    Corner2.(['Forceplate',num2str(run2)]).data = Corners(run2+11*(run2-1)+3:run2+11*(run2-1)+5,1);
    Corner3.(['Forceplate',num2str(run2)]).data = Corners(run2+11*(run2-1)+6:run2+11*(run2-1)+8,1);
    Corner4.(['Forceplate',num2str(run2)]).data = Corners(run2+11*(run2-1)+9:run2+11*(run2-1)+11,1);
    Corner1.(['Forceplate',num2str(run2)]).data(end,1) = 0 ;
    Corner2.(['Forceplate',num2str(run2)]).data(end,1) = 0 ;
    Corner3.(['Forceplate',num2str(run2)]).data(end,1) = 0 ;
    Corner4.(['Forceplate',num2str(run2)]).data(end,1) = 0 ;
    CFP.(['Forceplate',num2str(run2)]).data = (Corner1.(['Forceplate',num2str(run2)]).data + Corner2.(['Forceplate',num2str(run2)]).data + Corner3.(['Forceplate',num2str(run2)]).data + Corner4.(['Forceplate',num2str(run2)]).data) / 4;
    
    
    
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Global)
        FP.(['Forceplate',num2str(run2)]).COPkistler(1,i) = (FP.(['Forceplate',num2str(run2)]).Analog(1,i)*(-az0) - FP.(['Forceplate',num2str(run2)]).Analog(5,i)) / FP.(['Forceplate',num2str(run2)]).Analog(3,i);
        FP.(['Forceplate',num2str(run2)]).COPkistler(2,i) = (FP.(['Forceplate',num2str(run2)]).Analog(2,i)*(-az0) + FP.(['Forceplate',num2str(run2)]).Analog(4,i)) / FP.(['Forceplate',num2str(run2)]).Analog(3,i);
        FP.(['Forceplate',num2str(run2)]).COPkistler(3,i) = 0;
        
        FP.(['Forceplate',num2str(run2)]).COPkistlerRAW(1,i) = (FP.(['Forceplate',num2str(run2)]).AnalogRAW(1,i)*(-az0) - FP.(['Forceplate',num2str(run2)]).AnalogRAW(5,i)) / FP.(['Forceplate',num2str(run2)]).AnalogRAW(3,i);
        FP.(['Forceplate',num2str(run2)]).COPkistlerRAW(2,i) = (FP.(['Forceplate',num2str(run2)]).AnalogRAW(2,i)*(-az0) + FP.(['Forceplate',num2str(run2)]).AnalogRAW(4,i)) / FP.(['Forceplate',num2str(run2)]).AnalogRAW(3,i);
        FP.(['Forceplate',num2str(run2)]).COPkistlerRAW(3,i) = 0;
        
        FP.(['Forceplate',num2str(run2)]).FreeMoment(3,i) = (-FP.(['Forceplate',num2str(run2)]).Analog(6,i)  -  (-FP.(['Forceplate',num2str(run2)]).Analog(2,i) * FP.(['Forceplate',num2str(run2)]).COPkistler(1,i))  +  (-FP.(['Forceplate',num2str(run2)]).Analog(1,i) * FP.(['Forceplate',num2str(run2)]).COPkistler(2,i)))./1000;  %Umrechnung Nmm auf Nm
        
    end
end
if kinetics == 0
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Global)
        FP.(['Forceplate',num2str(run2)]).COPkistler(:,i) = [0;0;0];
        FP.(['Forceplate',num2str(run2)]).COPkistlerRAW(:,i) = [0;0;0];
        FP.(['Forceplate',num2str(run2)]).FreeMoment(:,i) = [0;0;0];
        FP.(['Forceplate',num2str(run2)]).COPfoot(1:3,i) = [0;0;0];
    end
    
end
if kinetics
    for i = 2:length(FP.(['Forceplate',num2str(run2)]).COPkistler)/ftkratio
        FP.(['Forceplate',num2str(run2)]).Vektorvid(:,i) = FP.(['Forceplate',num2str(run2)]).Global(:,(i-1)*ftkratio+1);
    end
    
    
    if size(FERSE, 2) > 1
        [~,ind_fz_max] = max(FP.(['Forceplate',num2str(run2)]).Vektorvid(3,:));
        if ind_fz_max < 13
            ind_fz_max=14;
        end
        [~,ind_ferse] = min(FERSE(3,ind_fz_max-10:ind_fz_max));
        FERSE = FERSE(:,ind_ferse + ind_fz_max - 10 - 1);
    end
    
    for i = 1:length(FP.(['Forceplate',num2str(run2)]).Global)
        FP.(['Forceplate',num2str(run2)]).COPglobal(:,i) = RFP*FP.(['Forceplate',num2str(run2)]).COPkistler(:,i) + CFP.(['Forceplate',num2str(run2)]).data;
        FP.(['Forceplate',num2str(run2)]).COPglobalFERSE(:,i) = FP.(['Forceplate',num2str(run2)]).COPglobal(:,i) - FERSE;
        FP.(['Forceplate',num2str(run2)]).COPglobalRAW(:,i) = RFP*FP.(['Forceplate',num2str(run2)]).COPkistlerRAW(:,i) + CFP.(['Forceplate',num2str(run2)]).data;
        FP.(['Forceplate',num2str(run2)]).FreeMomentglobal(3,i) = -FP.(['Forceplate',num2str(run2)]).FreeMoment(3,i);
        FP.(['Forceplate',num2str(run2)]).ReactionFreeMomentglobal(3,i) = FP.(['Forceplate',num2str(run2)]).FreeMoment(3,i);
    end
    
    FP.(['Forceplate',num2str(run2)]).COPglobalvid(:,1) = FP.(['Forceplate',num2str(run2)]).COPglobal(:,1);
    FP.(['Forceplate',num2str(run2)]).Vektorvid(:,1) = FP.(['Forceplate',num2str(run2)]).Global(:,1);
    FP.(['Forceplate',num2str(run2)]).COPglobalvidRAW(:,1) = FP.(['Forceplate',num2str(run2)]).COPglobalRAW(:,1);
    FP.(['Forceplate',num2str(run2)]).VektorvidRAW(:,1) = FP.(['Forceplate',num2str(run2)]).GlobalRAW(:,1);
    
    for i = 2:length(FP.(['Forceplate',num2str(run2)]).COPglobal)/ftkratio
        FP.(['Forceplate',num2str(run2)]).COPglobalvid(:,i) = FP.(['Forceplate',num2str(run2)]).COPglobal(:,(i-1)*ftkratio+1);
        FP.(['Forceplate',num2str(run2)]).Vektorvid(:,i) = FP.(['Forceplate',num2str(run2)]).Global(:,(i-1)*ftkratio+1);
        FP.(['Forceplate',num2str(run2)]).COPglobalvidRAW(:,i) = FP.(['Forceplate',num2str(run2)]).COPglobalRAW(:,(i-1)*ftkratio+1);
        FP.(['Forceplate',num2str(run2)]).VektorvidRAW(:,i) = FP.(['Forceplate',num2str(run2)]).GlobalRAW(:,(i-1)*ftkratio+1);
    end
end
%     for o = 1:3
%         FP.(['Forceplate',num2str(run2)]).COPglobalvid(o,:) = fit_n(FP.(['Forceplate',num2str(run2)]).COPglobalvid(o,:), n_frames);
%     end

if kinetics == 0
    Cornerpoints = [];
end

    function V = removeEndpointNaNs(Vin)
        iNan = isnan(Vin);
        V = Vin;
        if sum(iNan) > 0
            IndiNan = find(iNan);
            for ij = IndiNan(1):IndiNan(end)
                V(ij) = V(IndiNan(1)-1);
            end
        end
    end %removeEndpointNaNs
end
