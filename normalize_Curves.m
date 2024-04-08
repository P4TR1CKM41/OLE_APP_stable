% Write normalized Data in NORMAL struct
if OPTIONS.ExperimentalSetup == 9
    if OPTIONS.AnalyzedLeg == 'B'
        numsteps = min([length(TOL.(structname)), length(TOR.(structname))])
    elseif OPTIONS.AnalyzedLeg == 'R'
        numsteps = length(TOR.(structname))
    elseif OPTIONS.AnalyzedLeg == 'L'
        numsteps = length(TOL.(structname))
    end
else
    numsteps = 15;
        numsteps = 1;
end
for ns = 1:numsteps
    if (OPTIONS.ExperimentalSetup == 3) || (OPTIONS.ExperimentalSetup == 4) || (OPTIONS.ExperimentalSetup == 5) || (OPTIONS.ExperimentalSetup == 9)  || (OPTIONS.ExperimentalSetup == 10)
        try
            ContactR.(structname).data = TDR.(structname)(ns):TOR.(structname)(ns);
        end
        try
            ContactL.(structname).data = TDL.(structname)(ns):TOL.(structname)(ns);
        end
    elseif (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7) || (OPTIONS.ExperimentalSetup == 8)
        if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 8)
            if (OPTIONS.AnalyzedLeg == 'R') || (OPTIONS.AnalyzedLeg == 'B')
                ContactR.(structname).data = CONTACT.(structname).EVENTS_R_vid(1,ns):CONTACT.(structname).EVENTS_R_vid(2,ns);
                ContactR_analog.(structname).data = CONTACT.(structname).EVENTS_R(1,ns):CONTACT.(structname).EVENTS_R(2,ns);
            elseif (OPTIONS.AnalyzedLeg == 'L') || (OPTIONS.AnalyzedLeg == 'B')
                ContactL.(structname).data = CONTACT.(structname).EVENTS_L_vid(1,ns):CONTACT.(structname).EVENTS_L_vid(2,ns);
                ContactL_analog.(structname).data = CONTACT.(structname).EVENTS_L(1,ns):CONTACT.(structname).EVENTS_L(2,ns);
            end
        elseif (OPTIONS.ExperimentalSetup == 7)
            try
                if (OPTIONS.AnalyzedLeg == 'R') || (OPTIONS.AnalyzedLeg == 'B')
                    ContactR_analog.(structname).data = CONTACT.(structname);
                    ContactR.(structname).data = ceil(ContactR_analog.(structname).data./OPTIONS.ftkratio);
                    ContactR.(structname).data = ContactR.(structname).data(1:OPTIONS.ftkratio:end);
                elseif (OPTIONS.AnalyzedLeg == 'L') || (OPTIONS.AnalyzedLeg == 'B')
                    ContactL_analog.(structname).data = CONTACT.(structname);
                    ContactL.(structname).data = ceil(ContactL_analog.(structname).data./OPTIONS.ftkratio);
                    ContactL.(structname).data = ContactL.(structname).data(1:OPTIONS.ftkratio:end);
                end
            end
        end
        %
    else
        ContactR.(structname).data = 1:nframes.(structname);
        ContactL.(structname).data = 1:nframes.(structname);
    end
    try
        NORMAL.HEADER{runi} = [structname,'_STEP_' ,num2str(runi)];
    end
    try
        NORMAL.R.ANGLES.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Ankle.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Knee.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_Hip.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Right_MPJ.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_FOREFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_FOREFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_FOREFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Forefoot.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_REARFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_REARFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_REARFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Rearfoot.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_FOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_FOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_FOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Foot.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_SHANK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_SHANK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_SHANK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Shank.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_THIGH.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_THIGH.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_THIGH.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Thigh.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.PELVIS.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.PELVIS.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.PELVIS.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Pelvis.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.HEAD.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.HEAD.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.HEAD.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.TRUNK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.TRUNK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.TRUNK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_UPPERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_UPPERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_UPPERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_UpperArm.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_LOWERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_LOWERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_LOWERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_LowerArm.grad.Z(ContactR.(structname).data), 0.5)';
    end
    try
        NORMAL.R.ANGLES.RIGHT_HAND.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.X(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_HAND.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Y(ContactR.(structname).data), 0.5)';
        NORMAL.R.ANGLES.RIGHT_HAND.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Right_Hand.grad.Z(ContactR.(structname).data), 0.5)';
    end




    try
        NORMAL.R.MOMENTS.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.MOMENTS.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.MOMENTS.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.MOMENTS.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.MOMENTS.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJMomentInProximal(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end

    try
        NORMAL.R.POWER.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightAnkleJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.POWER.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightKneeJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.POWER.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightHipJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.R.POWER.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.R.POWER.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).RightMPJointPower(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end

    if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7)  ||  (OPTIONS.ExperimentalSetup == 8)
        try
            NORMAL.R.GRF.DATA.X(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(1,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
            NORMAL.R.GRF.DATA.Y(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(2,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
            NORMAL.R.GRF.DATA.Z(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Right(3,ContactR_analog.(structname).data)./OPTIONS.mass, 0.5)';
        end
    end




    % Left
    try
        NORMAL.L.ANGLES.LEFT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Ankle.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Knee.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_Hip.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).JOINT.Classic.Left_MPJ.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_FOREFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_FOREFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_FOREFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Forefoot.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_REARFOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_REARFOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_REARFOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Rearfoot.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_FOOT.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_FOOT.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_FOOT.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Foot.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_SHANK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_SHANK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_SHANK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Shank.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_THIGH.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_THIGH.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_THIGH.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Thigh.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.PELVIS.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.PELVIS.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.PELVIS.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Pelvis.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.HEAD.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.HEAD.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.HEAD.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Head.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.TRUNK.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.TRUNK.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.TRUNK.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Trunk.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_UPPERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_UPPERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_UPPERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_UpperArm.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_LOWERARM.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_LOWERARM.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_LOWERARM.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_LowerArm.grad.Z(ContactL.(structname).data), 0.5)';
    end
    try
        NORMAL.L.ANGLES.LEFT_HAND.X(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.X(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_HAND.Y(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Y(ContactL.(structname).data), 0.5)';
        NORMAL.L.ANGLES.LEFT_HAND.Z(:,ns+(runi-1)*numsteps) = normalize(WINKEL.(structname).SEGMENT.Classic.Left_Hand.grad.Z(ContactL.(structname).data), 0.5)';
    end

    try
        NORMAL.L.MOMENTS.LEFT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.MOMENTS.LEFT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.MOMENTS.LEFT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.MOMENTS.LEFT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.MOMENTS.LEFT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJMomentInProximal(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end

    try
        NORMAL.L.POWER.RIGHT_ANKLE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_ANKLE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_ANKLE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftAnkleJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.POWER.RIGHT_KNEE.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_KNEE.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_KNEE.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftKneeJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.POWER.RIGHT_HIP.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_HIP.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_HIP.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftHipJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end
    try
        NORMAL.L.POWER.RIGHT_MPJ.X(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_MPJ.Y(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        NORMAL.L.POWER.RIGHT_MPJ.Z(:,ns+(runi-1)*numsteps) = normalize(KINETICS.(structname).LeftMPJointPower(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
    end


    if (OPTIONS.ExperimentalSetup == 6) || (OPTIONS.ExperimentalSetup == 7) || (OPTIONS.ExperimentalSetup == 8)
        try
            NORMAL.L.GRF.DATA.X(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(1,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
            NORMAL.L.GRF.DATA.Y(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(2,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
            NORMAL.L.GRF.DATA.Z(:,ns+(runi-1)*numsteps) = normalize(FP.(structname).GRFfilt.Left(3,ContactL_analog.(structname).data)./OPTIONS.mass, 0.5)';
        end
    end
    if (OPTIONS.ExperimentalSetup == 10)  ||  (OPTIONS.ExperimentalSetup == 9)
        try
            CONTACT.R.(structname){ns} = TDR.(structname)(ns):TOR.(structname)(ns);
        end
        try
            CONTACT.L.(structname){ns} = TDL.(structname)(ns):TOL.(structname)(ns);
        end
    end

end
if (OPTIONS.ExperimentalSetup == 10)  ||  (OPTIONS.ExperimentalSetup == 9)
    try
        PARAMETERS.R = get_parameters_from_NORMAL(NORMAL.R, 'R', CONTACT.R, OPTIONS);
    end
    try
        PARAMETERS.L = get_parameters_from_NORMAL(NORMAL.L, 'L', CONTACT.L, OPTIONS);
    end
else
    try
        PARAMETERS.R = get_parameters_from_NORMAL(NORMAL.R, 'R', CONTACT, OPTIONS);
    end
    try
        PARAMETERS.L = get_parameters_from_NORMAL(NORMAL.L, 'L', CONTACT, OPTIONS);
    end
end
