function [ANTHRO, mass, RunningSpeed] = getANTHRO_GUI_app(anthrofile, method, REFFRAME, OPTIONS)
% Determines anthropometric infromation based on Zatziorsky and Seluyanov
% 1983
% Input information needs to be stored in the same folder as the dynamic
% andreference c3d files. In MoTrack this is normally automatically created
% using the MoTrack GUI.
if (nargin == 2 && sum(strfind(method, 'ZAT1983')))  ||  (nargin == 4)

    %A_MEASURES = csvread(anthrofile);
    A_MEASURES = [anthrofile(1), anthrofile(2)];
    X1 = A_MEASURES(1);  % body mass in kg
    mass = X1;
    X2 = A_MEASURES(2);  % body height in cm

    ANTHRO.FootLength = OPTIONS.ANTHRO.FootLength;

    ANTHRO.Mass = X1; %in kg
    ANTHRO.Height = X2/100; % in m

    %values from deleva
    %             ANTHRO.SegmentMass.Foot_old = (-0.829 + 0.0077*X1 + 0.0073*X2) ;
    ANTHRO.SegmentMass.Foot = X1*0.0129; % male 0.0137
    % ANTHRO.SegmentMass.Shank_old = (-1.592 + 0.0362*X1 + 0.0121*X2);
    ANTHRO.SegmentMass.Shank = X1*0.0481; % male 0.0433
    %  ANTHRO.SegmentMass.Thigh_old = (-2.649 + 0.1463*X1 + 0.0137*X2);
    ANTHRO.SegmentMass.Thigh = X1*0.1478; % male 0.1416
    ANTHRO.SegmentMass.Trunk = X1*0.4257; % male 0.4346
    ANTHRO.SegmentMass.Head = X1*0.0668; % male 0.0694
    ANTHRO.SegmentMass.UpperArm = X1*0.0255; % male 0.0271
    ANTHRO.SegmentMass.LowerArm = X1*0.0138; % male 0.0162
    ANTHRO.SegmentMass.Hand = X1*0.0056; %male 0.0061

    %             %Plagenhof 1983
    %             ANTHRO.SegmentMass.Foot = X1*0.0133; % male 0.0137
    %            % ANTHRO.SegmentMass.Shank_old = (-1.592 + 0.0362*X1 + 0.0121*X2);
    %             ANTHRO.SegmentMass.Shank = X1*0.0535; % male 0.0433
    %           %  ANTHRO.SegmentMass.Thigh_old = (-2.649 + 0.1463*X1 + 0.0137*X2);
    %             ANTHRO.SegmentMass.Thigh = X1*0.1175 % male 0.1416
    %             ANTHRO.SegmentMass.Trunk = X1*0.4522; % male 0.4346
    %             ANTHRO.SegmentMass.Head = X1*0.082; % male 0.0694
    %             ANTHRO.SegmentMass.UpperArm = X1*0.029; % male 0.0271
    %             ANTHRO.SegmentMass.LowerArm = X1*0.0157; % male 0.0162
    %             ANTHRO.SegmentMass.Hand = X1*0.005; %male 0.0061

    %% MoIs according deleva (de Leva 1996a; Zatsiorsky
    %et al. 1990)
    %%%   2* ANTHRO.SegmentMass.Hand+ 2* ANTHRO.SegmentMass.Foot+2* ANTHRO.SegmentMass.Shank+2*NTHRO.SegmentMass.Thigh+  ANTHRO.SegmentMass.Trunk+  ANTHRO.SegmentMass.Head+2* ANTHRO.SegmentMass.UpperArm+2* ANTHRO.SegmentMass.LowerArm
    if nargin == 4
        %  ANTHRO.MoI.Foot.X_old = (-15.48 + 0.144*X1 + 0.088*X2) / 100^2;   %/100 due to conversion from kg*cm^2  auf kg*m^2
        try
            ANTHRO.MoI.Foot.X = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.139)^2;
        catch
            ANTHRO.MoI.Foot.X = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.139)^2; % male 0.124
        end
        %    ANTHRO.MoI.Foot.Y_old = (-100 + 0.480*X1 + 0.626*X2) / 100^2;
        try
            ANTHRO.MoI.Foot.Y = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.299)^2;
        catch
            ANTHRO.MoI.Foot.Y = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.299)^2; % male 0.245
        end
        %   ANTHRO.MoI.Foot.Z_old = (-97.09 + 0.414*X1 + 0.614*X2) / 100^2;
        try
            ANTHRO.MoI.Foot.Z = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.RightFoot.Length*0.279)^2; % male 0.257
        catch
            ANTHRO.MoI.Foot.Z = ANTHRO.SegmentMass.Foot * (REFFRAME.Anatomical.LeftFoot.Length*0.279)^2;
        end
        % ANTHRO.MoI.Shank.X_old = (-1105 + 4.59*X1 + 6.63*X2) / 100^2;
        try
            ANTHRO.MoI.Shank.X = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.263)^2; % male 0.251
        catch
            ANTHRO.MoI.Shank.X = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.263)^2;
        end
        %  ANTHRO.MoI.Shank.Y_old = (-1152 + 4.594*X1 + 6.815*X2) / 100^2;
        try
            ANTHRO.MoI.Shank.Y = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.267)^2; % male 0.246
        catch
            ANTHRO.MoI.Shank.Y = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.267)^2;
        end
        %  ANTHRO.MoI.Shank.Z_old = (-70.5 + 1.134*X1 + 0.3*X2) / 100^2;
        try
            ANTHRO.MoI.Shank.Z = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.RightShank.Length*0.092)^2; % male 0.102
        catch
            ANTHRO.MoI.Shank.Z = ANTHRO.SegmentMass.Shank * (REFFRAME.Anatomical.LeftShank.Length*0.092)^2;
        end

        % ANTHRO.MoI.Thigh.X_old = (-3557 + 31.7*X1 + 18.61*X2) / 100^2;
        try
            ANTHRO.MoI.Thigh.X = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.364)^2;
        catch
            ANTHRO.MoI.Thigh.X = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.364)^2; % male 0.329
        end
        %    ANTHRO.MoI.Thigh.Y_old = (-3690 + 32.02*X1 + 19.24*X2) / 100^2;
        try
            ANTHRO.MoI.Thigh.Y = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.369)^2; % male 0.329
        catch
            ANTHRO.MoI.Thigh.Y = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.369)^2;
        end
        %  ANTHRO.MoI.Thigh.Z_old = (-13.5 + 11.3*X1 + -2.28*X2) / 100^2;
        try
            ANTHRO.MoI.Thigh.Z = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.RightThigh.Length*0.162)^2; % male 0.149
        catch
            ANTHRO.MoI.Thigh.Z = ANTHRO.SegmentMass.Thigh * (REFFRAME.Anatomical.LeftThigh.Length*0.162)^2;
        end
        try
            ANTHRO.MoI.Trunk.X = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.372)^2;
            ANTHRO.MoI.Trunk.Y = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.347)^2;
            ANTHRO.MoI.Trunk.Z = ANTHRO.SegmentMass.Trunk * (REFFRAME.Anatomical.Trunk.Length*0.191)^2;
        end
        try
            ANTHRO.MoI.Head.X = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.303)^2;
            ANTHRO.MoI.Head.Y = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.315)^2;
            ANTHRO.MoI.Head.Z = ANTHRO.SegmentMass.Head * (REFFRAME.Anatomical.Head.Length*0.261)^2;
        end
        try
            ANTHRO.MoI.UpperArm.X = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.285)^2;
            ANTHRO.MoI.UpperArm.Y = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.269)^2;
            ANTHRO.MoI.UpperArm.Z = ANTHRO.SegmentMass.UpperArm * (REFFRAME.Anatomical.RightUpperArm.Length*0.158)^2;
        end
        try
            ANTHRO.MoI.LowerArm.X = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.276)^2;
            ANTHRO.MoI.LowerArm.Y = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.265)^2;
            ANTHRO.MoI.LowerArm.Z = ANTHRO.SegmentMass.LowerArm * (REFFRAME.Anatomical.RightLowerArm.Length*0.121)^2;
        end
        try
            ANTHRO.MoI.Hand.X = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.628)^2;
            ANTHRO.MoI.Hand.Y = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.513)^2;
            ANTHRO.MoI.Hand.Z = ANTHRO.SegmentMass.Hand * (REFFRAME.Anatomical.RightHand.Length*0.401)^2;
        end
    end
end
% 
% if size(A_MEASURES, 1) > 3
%     RunningSpeed = A_MEASURES(4);
% else
    RunningSpeed = NaN;
% end
end %getANTHRO_GUI