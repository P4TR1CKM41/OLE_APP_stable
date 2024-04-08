function [KINETICS, LL] = InverseDynamik_Hof_app(FRAME, OPTIONS, FP, MARKERS)
                
                
                %% Vorgehensweise wie in Hof 1992 beschrieben
                %1. Gechwindigkeiten, Beschleunigungen und Rotationsmatrizen auf mit
                %reaktionskräften auf eine Länge bringen --> interpolieren
                for j = 1:3
                    for k = 1:3
                        
                        try
                            FRAME.RightFoot.Theta_long(j,k,:) = fit_app(FRAME.RightFoot.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightRearfoot.Theta_long(j,k,:) = fit_app(FRAME.RightRearfoot.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightShank.Theta_long(j,k,:) = fit_app(FRAME.RightShank.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightThigh.Theta_long(j,k,:) = fit_app(FRAME.RightThigh.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.Trunk.Theta_long(j,k,:) = fit_app(FRAME.Trunk.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.Head.Theta_long(j,k,:) = fit_app(FRAME.Head.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightUpperArm.Theta_long(j,k,:) = fit_app(FRAME.RightUpperArm.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightLowerArm.Theta_long(j,k,:) = fit_app(FRAME.RightLowerArm.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightHand.Theta_long(j,k,:) = fit_app(FRAME.RightHand.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftUpperArm.Theta_long(j,k,:) = fit_app(FRAME.LeftUpperArm.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftLowerArm.Theta_long(j,k,:) = fit_app(FRAME.LeftLowerArm.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftHand.Theta_long(j,k,:) = fit_app(FRAME.LeftHand.Theta(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftFoot.Theta_long(j,k,:) = fit_app(FRAME.LeftFoot.Theta(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftShank.Theta_long(j,k,:) = fit_app(FRAME.LeftShank.Theta(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftThigh.Theta_long(j,k,:) = fit_app(FRAME.LeftThigh.Theta(j,k,:), FP.COP.Left(j,:));
                        end
                        
                        %
                        try
                            FRAME.RightFoot.R_long(j,k,:) = fit_app(FRAME.RightFoot.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightRearfoot.R_long(j,k,:) = fit_app(FRAME.RightRearfoot.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightShank.R_long(j,k,:) = fit_app(FRAME.RightShank.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightThigh.R_long(j,k,:) = fit_app(FRAME.RightThigh.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightPelvis.R_long(j,k,:) = fit_app(FRAME.RightPelvis.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.Trunk.R_long(j,k,:) = fit_app(FRAME.Trunk.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.Head.R_long(j,k,:) = fit_app(FRAME.Head.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightUpperArm.R_long(j,k,:) = fit_app(FRAME.RightUpperArm.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightLowerArm.R_long(j,k,:) = fit_app(FRAME.RightLowerArm.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.RightHand.R_long(j,k,:) = fit_app(FRAME.RightHand.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftUpperArm.R_long(j,k,:) = fit_app(FRAME.LeftUpperArm.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftLowerArm.R_long(j,k,:) = fit_app(FRAME.LeftLowerArm.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftHand.R_long(j,k,:) = fit_app(FRAME.LeftHand.R(j,k,:), FP.COP.Right(j,:));
                        end
                        try
                            FRAME.LeftFoot.R_long(j,k,:) = fit_app(FRAME.LeftFoot.R(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftRearfoot.R_long(j,k,:) = fit_app(FRAME.LeftRearfoot.R(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftShank.R_long(j,k,:) = fit_app(FRAME.LeftShank.R(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftThigh.R_long(j,k,:) = fit_app(FRAME.LeftThigh.R(j,k,:), FP.COP.Left(j,:));
                        end
                        try
                            FRAME.LeftPelvis.R_long(j,k,:) = fit_app(FRAME.LeftPelvis.R(j,k,:), FP.COP.Left(j,:));
                        end
                    end
                    
                    %
                    try
                        FRAME.RightFoot.O_long(j,:) = fit_app(FRAME.RightFoot.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightRearfoot.O_long(j,:) = fit_app(FRAME.RightRearfoot.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightForefoot.O_long(j,:) = fit_app(FRAME.RightForefoot.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightShank.O_long(j,:) = fit_app(FRAME.RightShank.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightThigh.O_long(j,:) = fit_app(FRAME.RightThigh.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Trunk.O_long(j,:) = fit_app(FRAME.Trunk.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Head.O_long(j,:) = fit_app(FRAME.Head.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightUpperArm.O_long(j,:) = fit_app(FRAME.RightUpperArm.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightLowerArm.O_long(j,:) = fit_app(FRAME.RightLowerArm.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightHand.O_long(j,:) = fit_app(FRAME.RightHand.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftUpperArm.O_long(j,:) = fit_app(FRAME.LeftUpperArm.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftLowerArm.O_long(j,:) = fit_app(FRAME.LeftLowerArm.O(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftHand.O_long(j,:) = fit_app(FRAME.LeftHand.O(j,:), FP.COP.Right(j,:));
                    end
                    
                    try
                        FRAME.LeftFoot.O_long(j,:) = fit_app(FRAME.LeftFoot.O(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftShank.O_long(j,:) = fit_app(FRAME.LeftShank.O(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftThigh.O_long(j,:) = fit_app(FRAME.LeftThigh.O(j,:), FP.COP.Left(j,:));
                    end
                    
                    %
                    try
                        FRAME.RightFoot.V_long(j,:) = fit_app(FRAME.RightFoot.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightShank.V_long(j,:) = fit_app(FRAME.RightShank.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightThigh.V_long(j,:) = fit_app(FRAME.RightThigh.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Trunk.V_long(j,:) = fit_app(FRAME.Trunk.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Head.V_long(j,:) = fit_app(FRAME.Head.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightUpperArm.V_long(j,:) = fit_app(FRAME.RightUpperArm.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightLowerArm.V_long(j,:) = fit_app(FRAME.RightLowerArm.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightHand.V_long(j,:) = fit_app(FRAME.RightHand.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftUpperArm.V_long(j,:) = fit_app(FRAME.LeftUpperArm.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftLowerArm.V_long(j,:) = fit_app(FRAME.LeftLowerArm.V(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftHand.V_long(j,:) = fit_app(FRAME.LeftHand.V(j,:), FP.COP.Right(j,:));
                    end
                    
                    try
                        FRAME.LeftFoot.V_long(j,:) = fit_app(FRAME.LeftFoot.V(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftShank.V_long(j,:) = fit_app(FRAME.LeftShank.V(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftThigh.V_long(j,:) = fit_app(FRAME.LeftThigh.V(j,:), FP.COP.Left(j,:));
                    end
                    
                    %
                    try
                        FRAME.RightFoot.ACC_long(j,:) = fit_app(FRAME.RightFoot.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightShank.ACC_long(j,:) = fit_app(FRAME.RightShank.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightThigh.ACC_long(j,:) = fit_app(FRAME.RightThigh.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Trunk.ACC_long(j,:) = fit_app(FRAME.Trunk.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Head.ACC_long(j,:) = fit_app(FRAME.Head.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightUpperArm.ACC_long(j,:) = fit_app(FRAME.RightUpperArm.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightLowerArm.ACC_long(j,:) = fit_app(FRAME.RightLowerArm.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightHand.ACC_long(j,:) = fit_app(FRAME.RightHand.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftUpperArm.ACC_long(j,:) = fit_app(FRAME.LeftUpperArm.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftLowerArm.ACC_long(j,:) = fit_app(FRAME.LeftLowerArm.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftHand.ACC_long(j,:) = fit_app(FRAME.LeftHand.ACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftFoot.ACC_long(j,:) = fit_app(FRAME.LeftFoot.ACC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftShank.ACC_long(j,:) = fit_app(FRAME.LeftShank.ACC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftThigh.ACC_long(j,:) = fit_app(FRAME.LeftThigh.ACC(j,:), FP.COP.Left(j,:));
                    end
                    
                    %
                    try
                        FRAME.RightFoot.LinACC_long(j,:) = fit_app(FRAME.RightFoot.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightShank.LinACC_long(j,:) = fit_app(FRAME.RightShank.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightThigh.LinACC_long(j,:) = fit_app(FRAME.RightThigh.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Trunk.LinACC_long(j,:) = fit_app(FRAME.Trunk.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.Head.LinACC_long(j,:) = fit_app(FRAME.Head.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightUpperArm.LinACC_long(j,:) = fit_app(FRAME.RightUpperArm.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightLowerArm.LinACC_long(j,:) = fit_app(FRAME.RightLowerArm.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.RightHand.LinACC_long(j,:) = fit_app(FRAME.RightHand.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftUpperArm.LinACC_long(j,:) = fit_app(FRAME.LeftUpperArm.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftLowerArm.LinACC_long(j,:) = fit_app(FRAME.LeftLowerArm.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftHand.LinACC_long(j,:) = fit_app(FRAME.LeftHand.LinACC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        FRAME.LeftFoot.LinACC_long(j,:) = fit_app(FRAME.LeftFoot.LinACC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftShank.LinACC_long(j,:) = fit_app(FRAME.LeftShank.LinACC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        FRAME.LeftThigh.LinACC_long(j,:) = fit_app(FRAME.LeftThigh.LinACC(j,:), FP.COP.Left(j,:));
                    end
                    
                    try
                        MARKERS.Derived.RightAnkleJC_long(j,:) = fit_app(MARKERS.Derived.RightAnkleJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.RightMPJC_long(j,:) = fit_app(MARKERS.Derived.RightMPJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftMPJC_long(j,:) = fit_app(MARKERS.Derived.LeftMPJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftAnkleJC_long(j,:) = fit_app(MARKERS.Derived.LeftAnkleJC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        MARKERS.Derived.RightKneeJC_long(j,:) = fit_app(MARKERS.Derived.RightKneeJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftKneeJC_long(j,:) = fit_app(MARKERS.Derived.LeftKneeJC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        MARKERS.Derived.RightHipJC_long(j,:) = fit_app(MARKERS.Derived.RightHipJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftHipJC_long(j,:) = fit_app(MARKERS.Derived.LeftHipJC(j,:), FP.COP.Left(j,:));
                    end
                    try
                        MARKERS.Derived.RightShoulderJC_long(j,:) = fit_app(MARKERS.Derived.RightShoulderJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.RightElbowJC_long(j,:) = fit_app(MARKERS.Derived.RightElbowJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.RightWristJC_long(j,:) = fit_app(MARKERS.Derived.RightWristJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftShoulderJC_long(j,:) = fit_app(MARKERS.Derived.LeftShoulderJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftElbowJC_long(j,:) = fit_app(MARKERS.Derived.LeftElbowJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.LeftWristJC_long(j,:) = fit_app(MARKERS.Derived.LeftWristJC(j,:), FP.COP.Right(j,:));
                    end
                    try
                        MARKERS.Derived.NeckJC_long(j,:) = fit_app(MARKERS.Derived.NeckJC(j,:), FP.COP.Right(j,:));
                    end
                end
                
                
                
                
                
                
                %2. Lösen der Bewegungsgleichungen für das rechte Sprunggelenk
                try
                    Wheight.Foot = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Foot, 1, length(FP.COP.Right));
                    MA.RightFoot = repmat(OPTIONS.ANTHRO.SegmentMass.Foot,3,length(FP.COP.Right)) .* FRAME.RightFoot.LinACC_long;
                    
                    KINETICS.RightAnkle.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightAnkleJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
                    KINETICS.RightAnkle.Term2 = cross((FRAME.RightFoot.O_long  - MARKERS.Derived.RightAnkleJC_long), Wheight.Foot)./1000; %wg Nmm zu Nm
                    KINETICS.RightAnkle.Term3 = cross((FRAME.RightFoot.O_long - MARKERS.Derived.RightAnkleJC_long), MA.RightFoot)./1000; %wg Nmm zu Nm
                    
                    I.Foot = repmat([OPTIONS.ANTHRO.MoI.Foot.X;OPTIONS.ANTHRO.MoI.Foot.Y;OPTIONS.ANTHRO.MoI.Foot.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightFoot.R_long,3)
                        LL.RightFoot(:,:,kk)=FRAME.RightFoot.R_long(:,:,kk)*I.Foot*FRAME.RightFoot.R_long(:,:,kk)';
                        KINETICS.RightAnkle.Term4(:,kk)=(LL.RightFoot(:,:,kk)*FRAME.RightFoot.ACC_long(:,kk))+(FRAME.RightFoot.Theta_long(:,:,kk)*LL.RightFoot(:,:,kk)*FRAME.RightFoot.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightAnkle.Moment = -FP.FM.Right - KINETICS.RightAnkle.Term1 - KINETICS.RightAnkle.Term2 + KINETICS.RightAnkle.Term3 + KINETICS.RightAnkle.Term4;
                    for f = 1:length(KINETICS.RightAnkle.Moment)
                        KINETICS.RightAnkleMomentInProximal(:,f) = FRAME.RightShank.R_long(:,:,f)' * KINETICS.RightAnkle.Moment(:,f);
                    end
                end
                
                %2b. Lösen der Bewgungsgleichungen für das rechte MTP Gelenk
                try
                    
                    
                    KINETICS.RightMPJ.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightMPJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
                    
                    
                    
                    KINETICS.RightMPJ.Moment = -FP.FM.Right - KINETICS.RightMPJ.Term1;
                    for f = 1:length(KINETICS.RightMPJ.Moment)
                        KINETICS.RightMPJMomentInProximal(:,f) = FRAME.RightRearfoot.R_long(:,:,f)' * KINETICS.RightMPJ.Moment(:,f);
                    end
                    %     [~,indrmpjmmax] = max(KINETICS.RightMPJMomentInProximal(2,:));
                    %     for g = indrmpjmmax:-1:1
                    %        if  KINETICS.RightMPJMomentInProximal(2,g) < 0
                    %            KINETICS.RightMPJMomentInProximal(:,1:g) = 0;
                    %            break
                    %        end
                    %     end
                    isnegMPJR = find(KINETICS.RightMPJMomentInProximal(2,:) <= 0);
                    KINETICS.RightMPJMomentInProximal(:,isnegMPJR) = 0;
                    KINETICS.RightMPJMomentInProximal(1,:) = 0;
                    KINETICS.RightMPJMomentInProximal(3,:) = 0;
                    
                end
                
                %3. Lösen der Bewgungsgleichungen für das linke Sprunggelenk
                try
                    Wheight.Foot = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Foot, 1, length(FP.COP.Right));
                    MA.LeftFoot = repmat(OPTIONS.ANTHRO.SegmentMass.Foot,3,length(FP.COP.Left)) .* FRAME.LeftFoot.LinACC_long;
                    
                    KINETICS.LeftAnkle.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftAnkleJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
                    KINETICS.LeftAnkle.Term2 = cross((FRAME.LeftFoot.O_long  - MARKERS.Derived.LeftAnkleJC_long), Wheight.Foot)./1000; %wg Nmm zu Nm
                    KINETICS.LeftAnkle.Term3 = cross((FRAME.LeftFoot.O_long - MARKERS.Derived.LeftAnkleJC_long), MA.LeftFoot)./1000; %wg Nmm zu Nm
                    
                    I.Foot = repmat([OPTIONS.ANTHRO.MoI.Foot.X;OPTIONS.ANTHRO.MoI.Foot.Y;OPTIONS.ANTHRO.MoI.Foot.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftFoot.R_long,3)
                        LL.LeftFoot(:,:,kk)=FRAME.LeftFoot.R_long(:,:,kk)*I.Foot*FRAME.LeftFoot.R_long(:,:,kk)';
                        KINETICS.LeftAnkle.Term4(:,kk)=(LL.LeftFoot(:,:,kk)*FRAME.LeftFoot.ACC_long(:,kk))+(FRAME.LeftFoot.Theta_long(:,:,kk)*LL.LeftFoot(:,:,kk)*FRAME.LeftFoot.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftAnkle.Moment = -FP.FM.Left - KINETICS.LeftAnkle.Term1 - KINETICS.LeftAnkle.Term2 + KINETICS.LeftAnkle.Term3 + KINETICS.LeftAnkle.Term4;
                    for f = 1:length(KINETICS.LeftAnkle.Moment)
                        KINETICS.LeftAnkleMomentInProximal(:,f) = FRAME.LeftShank.R_long(:,:,f)' * KINETICS.LeftAnkle.Moment(:,f);
                    end
                    KINETICS.LeftAnkleMomentInProximal(1,:) = -KINETICS.LeftAnkleMomentInProximal(1,:);
                    KINETICS.LeftAnkleMomentInProximal(3,:) = -KINETICS.LeftAnkleMomentInProximal(3,:);
                end
                %3b. Lösen der Bewgungsgleichungen für das linke MTP Gelenk
                try
                    
                    
                    KINETICS.LeftMPJ.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftMPJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
                    
                    
                    
                    KINETICS.LeftMPJ.Moment = -FP.FM.Left - KINETICS.LeftMPJ.Term1;
                    for f = 1:length(KINETICS.LeftMPJ.Moment)
                        KINETICS.LeftMPJMomentInProximal(:,f) = FRAME.LeftRearfoot.R_long(:,:,f)' * KINETICS.LeftMPJ.Moment(:,f);
                    end
                    KINETICS.LeftMPJMomentInProximal(1,:) = -KINETICS.LeftMPJMomentInProximal(1,:);
                    KINETICS.LeftMPJMomentInProximal(3,:) = -KINETICS.LeftMPJMomentInProximal(3,:);
                    
                    isnegMPJL = find(KINETICS.LeftMPJMomentInProximal(2,:) <= 0);
                    KINETICS.LeftMPJMomentInProximal(:,isnegMPJL) = 0;
                    KINETICS.LeftMPJMomentInProximal(1,:) = 0;
                    KINETICS.LeftMPJMomentInProximal(3,:) = 0;
                end
                %4. Lösen der Bewgungsgleichungen für das rechte Kniegelenk
                try
                    Wheight.Shank = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Shank, 1, length(FP.COP.Right));
                    MA.RightShank = repmat(OPTIONS.ANTHRO.SegmentMass.Shank,3,length(FP.COP.Right)) .* FRAME.RightShank.LinACC_long;
                    
                    KINETICS.RightKnee.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightKneeJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
                    KINETICS.RightKnee.Term2 = cross((FRAME.RightShank.O_long  - MARKERS.Derived.RightKneeJC_long), Wheight.Shank)./1000; %wg Nmm zu Nm
                    KINETICS.RightKnee.Term3 = cross((FRAME.RightShank.O_long - MARKERS.Derived.RightKneeJC_long), MA.RightShank)./1000; %wg Nmm zu Nm
                    
                    I.Shank = repmat([OPTIONS.ANTHRO.MoI.Shank.X;OPTIONS.ANTHRO.MoI.Shank.Y;OPTIONS.ANTHRO.MoI.Shank.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightShank.R_long,3)
                        LL.RightShank(:,:,kk)=FRAME.RightShank.R_long(:,:,kk)*I.Shank*FRAME.RightShank.R_long(:,:,kk)';
                        KINETICS.RightKnee.Term4(:,kk)=(LL.RightShank(:,:,kk)*FRAME.RightShank.ACC_long(:,kk))+(FRAME.RightShank.Theta_long(:,:,kk)*LL.RightShank(:,:,kk)*FRAME.RightShank.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightKnee.Moment = -FP.FM.Right - KINETICS.RightKnee.Term1 - (KINETICS.RightKnee.Term2 + KINETICS.RightAnkle.Term2) + (KINETICS.RightKnee.Term3 + KINETICS.RightAnkle.Term3) + (KINETICS.RightKnee.Term4 + KINETICS.RightAnkle.Term4);
                    for f = 1:length(KINETICS.RightKnee.Moment)
                        KINETICS.RightKneeMomentInProximal(:,f) = FRAME.RightThigh.R_long(:,:,f)' * KINETICS.RightKnee.Moment(:,f);
                        KINETICS.GRF_IN_RIGHT_KNEE(:,f)   = FRAME.RightThigh.R_long(:,:,f)'* FP.GRFfilt.Right(:,f) ; 
                    end
                    
                end
                
% % % %                 contactPM = find(FP.GRFfilt.Right(3,:)>30);
% % % %                 plot(FP.COP.Right(3,contactPM))
                %5. Lösen der Bewgungsgleichungen für das linke Kniegelenk
                try
                    Wheight.Shank = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Shank, 1, length(FP.COP.Right));
                    MA.LeftShank = repmat(OPTIONS.ANTHRO.SegmentMass.Shank,3,length(FP.COP.Left)) .* FRAME.LeftShank.LinACC_long;
                    
                    KINETICS.LeftKnee.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftKneeJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
                    KINETICS.LeftKnee.Term2 = cross((FRAME.LeftShank.O_long  - MARKERS.Derived.LeftKneeJC_long), Wheight.Shank)./1000; %wg Nmm zu Nm
                    KINETICS.LeftKnee.Term3 = cross((FRAME.LeftShank.O_long - MARKERS.Derived.LeftKneeJC_long), MA.LeftShank)./1000; %wg Nmm zu Nm
                    
                    I.Shank = repmat([OPTIONS.ANTHRO.MoI.Shank.X;OPTIONS.ANTHRO.MoI.Shank.Y;OPTIONS.ANTHRO.MoI.Shank.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftShank.R_long,3)
                        LL.LeftShank(:,:,kk)=FRAME.LeftShank.R_long(:,:,kk)*I.Shank*FRAME.LeftShank.R_long(:,:,kk)';
                        KINETICS.LeftKnee.Term4(:,kk)=(LL.LeftShank(:,:,kk)*FRAME.LeftShank.ACC_long(:,kk))+(FRAME.LeftShank.Theta_long(:,:,kk)*LL.LeftShank(:,:,kk)*FRAME.LeftShank.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftKnee.Moment = -FP.FM.Left - KINETICS.LeftKnee.Term1 - (KINETICS.LeftKnee.Term2 + KINETICS.LeftAnkle.Term2) + (KINETICS.LeftKnee.Term3 + KINETICS.LeftAnkle.Term3) + (KINETICS.LeftKnee.Term4 + KINETICS.LeftAnkle.Term4);
                    for f = 1:length(KINETICS.LeftKnee.Moment)
                        KINETICS.LeftKneeMomentInProximal(:,f) = FRAME.LeftThigh.R_long(:,:,f)' * KINETICS.LeftKnee.Moment(:,f);
                        KINETICS.GRF_IN_LEFT_KNEE(:,f)   = FRAME.LeftThigh.R_long(:,:,f)'* FP.GRFfilt.Left(:,f) ; 

                    end
                    KINETICS.LeftKneeMomentInProximal(1,:) = -KINETICS.LeftKneeMomentInProximal(1,:);
                    KINETICS.LeftKneeMomentInProximal(3,:) = -KINETICS.LeftKneeMomentInProximal(3,:);
                end
                %6. Lösen der Bewgungsgleichungen für das rechte Hüftgelenk
                try
                    Wheight.Thigh = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Thigh, 1, length(FP.COP.Right));
                    MA.RightThigh = repmat(OPTIONS.ANTHRO.SegmentMass.Thigh,3,length(FP.COP.Right)) .* FRAME.RightThigh.LinACC_long;
                    
                    KINETICS.RightHip.Term1 = cross((FP.COP.Right - MARKERS.Derived.RightHipJC_long), FP.GRFfilt.Right)./1000; %wg Nmm zu Nm
                    KINETICS.RightHip.Term2 = cross((FRAME.RightThigh.O_long  - MARKERS.Derived.RightHipJC_long), Wheight.Thigh)./1000; %wg Nmm zu Nm
                    KINETICS.RightHip.Term3 = cross((FRAME.RightThigh.O_long - MARKERS.Derived.RightHipJC_long), MA.RightThigh)./1000; %wg Nmm zu Nm
                    
                    I.Thigh = repmat([OPTIONS.ANTHRO.MoI.Thigh.X;OPTIONS.ANTHRO.MoI.Thigh.Y;OPTIONS.ANTHRO.MoI.Thigh.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightThigh.R_long,3)
                        LL.RightThigh(:,:,kk)=FRAME.RightThigh.R_long(:,:,kk)*I.Thigh*FRAME.RightThigh.R_long(:,:,kk)';
                        KINETICS.RightHip.Term4(:,kk)=(LL.RightThigh(:,:,kk)*FRAME.RightThigh.ACC_long(:,kk))+(FRAME.RightThigh.Theta_long(:,:,kk)*LL.RightThigh(:,:,kk)*FRAME.RightThigh.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightHip.Moment = -FP.FM.Right - KINETICS.RightHip.Term1 - (KINETICS.RightHip.Term2 + KINETICS.RightKnee.Term2 + KINETICS.RightAnkle.Term2) + (KINETICS.RightHip.Term3 + KINETICS.RightKnee.Term3 + KINETICS.RightAnkle.Term3) + (KINETICS.RightHip.Term4 + KINETICS.RightKnee.Term4 + KINETICS.RightAnkle.Term4);
                    for f = 1:length(KINETICS.RightHip.Moment)
                        KINETICS.RightHipMomentInProximal(:,f) = FRAME.RightPelvis.R_long(:,:,f)' * KINETICS.RightHip.Moment(:,f);
                    end
                end
                %7. Lösen der Bewgungsgleichungen für das linke Hüftgelenk
                try
                    Wheight.Thigh = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Thigh, 1, length(FP.COP.Right));
                    MA.LeftThigh = repmat(OPTIONS.ANTHRO.SegmentMass.Thigh,3,length(FP.COP.Left)) .* FRAME.LeftThigh.LinACC_long;
                    
                    KINETICS.LeftHip.Term1 = cross((FP.COP.Left - MARKERS.Derived.LeftHipJC_long), FP.GRFfilt.Left)./1000; %wg Nmm zu Nm
                    KINETICS.LeftHip.Term2 = cross((FRAME.LeftThigh.O_long  - MARKERS.Derived.LeftHipJC_long), Wheight.Thigh)./1000; %wg Nmm zu Nm
                    KINETICS.LeftHip.Term3 = cross((FRAME.LeftThigh.O_long - MARKERS.Derived.LeftHipJC_long), MA.LeftThigh)./1000; %wg Nmm zu Nm
                    
                    I.Thigh = repmat([OPTIONS.ANTHRO.MoI.Thigh.X;OPTIONS.ANTHRO.MoI.Thigh.Y;OPTIONS.ANTHRO.MoI.Thigh.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftThigh.R_long,3)
                        LL.LeftThigh(:,:,kk)=FRAME.LeftThigh.R_long(:,:,kk)*I.Thigh*FRAME.LeftThigh.R_long(:,:,kk)';
                        KINETICS.LeftHip.Term4(:,kk)=(LL.LeftThigh(:,:,kk)*FRAME.LeftThigh.ACC_long(:,kk))+(FRAME.LeftThigh.Theta_long(:,:,kk)*LL.LeftThigh(:,:,kk)*FRAME.LeftThigh.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftHip.Moment = -FP.FM.Left - KINETICS.LeftHip.Term1 - (KINETICS.LeftHip.Term2 + KINETICS.LeftKnee.Term2 + KINETICS.LeftAnkle.Term2) + (KINETICS.LeftHip.Term3 + KINETICS.LeftKnee.Term3 + KINETICS.LeftAnkle.Term3) + (KINETICS.LeftHip.Term4 + KINETICS.LeftKnee.Term4 + KINETICS.LeftAnkle.Term4);
                    for f = 1:length(KINETICS.LeftHip.Moment)
                        KINETICS.LeftHipMomentInProximal(:,f) = FRAME.LeftPelvis.R_long(:,:,f)' * KINETICS.LeftHip.Moment(:,f);
                    end
                    KINETICS.LeftHipMomentInProximal(1,:) = -KINETICS.LeftHipMomentInProximal(1,:);
                    KINETICS.LeftHipMomentInProximal(3,:) = -KINETICS.LeftHipMomentInProximal(3,:);
                end
                
                %8. Lösen der Bewgungsgleichungen für das rechte Handgelenk
                try
                    Wheight.Hand = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Hand, 1, length(FP.COP.Right));
                    MA.RightHand = repmat(OPTIONS.ANTHRO.SegmentMass.Hand,3,length(FP.COP.Right)) .* FRAME.RightHand.LinACC_long;
                    
                    KINETICS.RightWrist.Term1 = zeros(3,length(FRAME.RightHand.O_long));
                    KINETICS.RightWrist.Term2 = cross((FRAME.RightHand.O_long  - MARKERS.Derived.RightWristJC_long), Wheight.Hand)./1000; %wg Nmm zu Nm
                    KINETICS.RightWrist.Term3 = cross((FRAME.RightHand.O_long - MARKERS.Derived.RightWristJC_long), MA.RightHand)./1000; %wg Nmm zu Nm
                    
                    I.Hand = repmat([OPTIONS.ANTHRO.MoI.Hand.X;OPTIONS.ANTHRO.MoI.Hand.Y;OPTIONS.ANTHRO.MoI.Hand.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightHand.R_long,3)
                        LL.RightHand(:,:,kk)=FRAME.RightHand.R_long(:,:,kk)*I.Hand*FRAME.RightHand.R_long(:,:,kk)';
                        KINETICS.RightWrist.Term4(:,kk)=(LL.RightHand(:,:,kk)*FRAME.RightHand.ACC_long(:,kk))+(FRAME.RightHand.Theta_long(:,:,kk)*LL.RightHand(:,:,kk)*FRAME.RightHand.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightWrist.Moment = KINETICS.RightWrist.Term1 - (KINETICS.RightWrist.Term2) + (KINETICS.RightWrist.Term3) + (KINETICS.RightWrist.Term4);
                    for f = 1:length(KINETICS.RightWrist.Moment)
                        KINETICS.RightWristMomentInProximal(:,f) = FRAME.RightLowerArm.R_long(:,:,f)' * KINETICS.RightWrist.Moment(:,f);
                    end
                end
                
                %9. Lösen der Bewgungsgleichungen für das rechte Ellbogengelenk
                try
                    Wheight.LowerArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.LowerArm, 1, length(FP.COP.Right));
                    MA.RightLowerArm = repmat(OPTIONS.ANTHRO.SegmentMass.LowerArm,3,length(FP.COP.Right)) .* FRAME.RightLowerArm.LinACC_long;
                    
                    KINETICS.RightElbow.Term1 = zeros(3,length(FRAME.RightLowerArm.O_long));
                    KINETICS.RightElbow.Term2 = cross((FRAME.RightLowerArm.O_long  - MARKERS.Derived.RightElbowJC_long), Wheight.LowerArm)./1000; %wg Nmm zu Nm
                    KINETICS.RightElbow.Term3 = cross((FRAME.RightLowerArm.O_long - MARKERS.Derived.RightElbowJC_long), MA.RightLowerArm)./1000; %wg Nmm zu Nm
                    
                    I.LowerArm = repmat([OPTIONS.ANTHRO.MoI.LowerArm.X;OPTIONS.ANTHRO.MoI.LowerArm.Y;OPTIONS.ANTHRO.MoI.LowerArm.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightLowerArm.R_long,3)
                        LL.RightLowerArm(:,:,kk)=FRAME.RightLowerArm.R_long(:,:,kk)*I.LowerArm*FRAME.RightLowerArm.R_long(:,:,kk)';
                        KINETICS.RightElbow.Term4(:,kk)=(LL.RightLowerArm(:,:,kk)*FRAME.RightLowerArm.ACC_long(:,kk))+(FRAME.RightLowerArm.Theta_long(:,:,kk)*LL.RightLowerArm(:,:,kk)*FRAME.RightLowerArm.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightElbow.Moment = KINETICS.RightWrist.Term1 - (KINETICS.RightWrist.Term2 + KINETICS.RightElbow.Term2) + (KINETICS.RightWrist.Term3 + KINETICS.RightElbow.Term3) + (KINETICS.RightWrist.Term4 + KINETICS.RightElbow.Term4);
                    for f = 1:length(KINETICS.RightElbow.Moment)
                        KINETICS.RightElbowMomentInProximal(:,f) = FRAME.RightUpperArm.R_long(:,:,f)' * KINETICS.RightElbow.Moment(:,f);
                    end
                end
                
                
                %10. Lösen der Bewgungsgleichungen für das rechte Schultergelenk
                try
                    Wheight.UpperArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.UpperArm, 1, length(FP.COP.Right));
                    MA.RightUpperArm = repmat(OPTIONS.ANTHRO.SegmentMass.UpperArm,3,length(FP.COP.Right)) .* FRAME.RightUpperArm.LinACC_long;
                    
                    KINETICS.RightShoulder.Term1 = zeros(3,length(FRAME.RightThigh.O_long));
                    KINETICS.RightShoulder.Term2 = cross((FRAME.RightUpperArm.O_long  - MARKERS.Derived.RightShoulderJC_long), Wheight.UpperArm)./1000; %wg Nmm zu Nm
                    KINETICS.RightShoulder.Term3 = cross((FRAME.RightUpperArm.O_long - MARKERS.Derived.RightShoulderJC_long), MA.RightUpperArm)./1000; %wg Nmm zu Nm
                    
                    I.UpperArm = repmat([OPTIONS.ANTHRO.MoI.UpperArm.X;OPTIONS.ANTHRO.MoI.UpperArm.Y;OPTIONS.ANTHRO.MoI.UpperArm.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.RightUpperArm.R_long,3)
                        LL.RightUpperArm(:,:,kk)=FRAME.RightUpperArm.R_long(:,:,kk)*I.UpperArm*FRAME.RightUpperArm.R_long(:,:,kk)';
                        KINETICS.RightShoulder.Term4(:,kk)=(LL.RightUpperArm(:,:,kk)*FRAME.RightUpperArm.ACC_long(:,kk))+(FRAME.RightUpperArm.Theta_long(:,:,kk)*LL.RightUpperArm(:,:,kk)*FRAME.RightUpperArm.V_long(:,kk));
                    end
                    
                    
                    KINETICS.RightShoulder.Moment = KINETICS.RightShoulder.Term1 - (KINETICS.RightWrist.Term2 + KINETICS.RightElbow.Term2 + KINETICS.RightShoulder.Term2) + (KINETICS.RightWrist.Term3 + KINETICS.RightElbow.Term3 + KINETICS.RightShoulder.Term3) + (KINETICS.RightWrist.Term4 + KINETICS.RightElbow.Term4 + KINETICS.RightShoulder.Term4);
                    for f = 1:length(KINETICS.RightShoulder.Moment)
                        KINETICS.RightShoulderMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.RightShoulder.Moment(:,f);
                    end
                end
                
                
                %11. Lösen der Bewgungsgleichungen für das linke Handgelenk
                try
                    Wheight.Hand = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Hand, 1, length(FP.COP.Left));
                    MA.LeftHand = repmat(OPTIONS.ANTHRO.SegmentMass.Hand,3,length(FP.COP.Left)) .* FRAME.LeftHand.LinACC_long;
                    
                    KINETICS.LeftWrist.Term1 = zeros(3,length(FRAME.LeftHand.O_long));
                    KINETICS.LeftWrist.Term2 = cross((FRAME.LeftHand.O_long  - MARKERS.Derived.LeftWristJC_long), Wheight.Hand)./1000; %wg Nmm zu Nm
                    KINETICS.LeftWrist.Term3 = cross((FRAME.LeftHand.O_long - MARKERS.Derived.LeftWristJC_long), MA.LeftHand)./1000; %wg Nmm zu Nm
                    
                    I.Hand = repmat([OPTIONS.ANTHRO.MoI.Hand.X;OPTIONS.ANTHRO.MoI.Hand.Y;OPTIONS.ANTHRO.MoI.Hand.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftHand.R_long,3)
                        LL.LeftHand(:,:,kk)=FRAME.LeftHand.R_long(:,:,kk)*I.Hand*FRAME.LeftHand.R_long(:,:,kk)';
                        KINETICS.LeftWrist.Term4(:,kk)=(LL.LeftHand(:,:,kk)*FRAME.LeftHand.ACC_long(:,kk))+(FRAME.LeftHand.Theta_long(:,:,kk)*LL.LeftHand(:,:,kk)*FRAME.LeftHand.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftWrist.Moment = KINETICS.LeftWrist.Term1 - (KINETICS.LeftWrist.Term2) + (KINETICS.LeftWrist.Term3) + (KINETICS.LeftWrist.Term4);
                    for f = 1:length(KINETICS.LeftWrist.Moment)
                        KINETICS.LeftWristMomentInProximal(:,f) = FRAME.LeftLowerArm.R_long(:,:,f)' * KINETICS.LeftWrist.Moment(:,f);
                    end
                end
                
                %12. Lösen der Bewgungsgleichungen für das linke Ellbogengelenk
                try
                    Wheight.LowerArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.LowerArm, 1, length(FP.COP.Left));
                    MA.LeftLowerArm = repmat(OPTIONS.ANTHRO.SegmentMass.LowerArm,3,length(FP.COP.Left)) .* FRAME.LeftLowerArm.LinACC_long;
                    
                    KINETICS.LeftElbow.Term1 = zeros(3,length(FRAME.LeftLowerArm.O_long));
                    KINETICS.LeftElbow.Term2 = cross((FRAME.LeftLowerArm.O_long  - MARKERS.Derived.LeftElbowJC_long), Wheight.LowerArm)./1000; %wg Nmm zu Nm
                    KINETICS.LeftElbow.Term3 = cross((FRAME.LeftLowerArm.O_long - MARKERS.Derived.LeftElbowJC_long), MA.LeftLowerArm)./1000; %wg Nmm zu Nm
                    
                    I.LowerArm = repmat([OPTIONS.ANTHRO.MoI.LowerArm.X;OPTIONS.ANTHRO.MoI.LowerArm.Y;OPTIONS.ANTHRO.MoI.LowerArm.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftLowerArm.R_long,3)
                        LL.LeftLowerArm(:,:,kk)=FRAME.LeftLowerArm.R_long(:,:,kk)*I.LowerArm*FRAME.LeftLowerArm.R_long(:,:,kk)';
                        KINETICS.LeftElbow.Term4(:,kk)=(LL.LeftLowerArm(:,:,kk)*FRAME.LeftLowerArm.ACC_long(:,kk))+(FRAME.LeftLowerArm.Theta_long(:,:,kk)*LL.LeftLowerArm(:,:,kk)*FRAME.LeftLowerArm.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftElbow.Moment = KINETICS.LeftWrist.Term1 - (KINETICS.LeftWrist.Term2 + KINETICS.LeftElbow.Term2) + (KINETICS.LeftWrist.Term3 + KINETICS.LeftElbow.Term3) + (KINETICS.LeftWrist.Term4 + KINETICS.LeftElbow.Term4);
                    for f = 1:length(KINETICS.LeftElbow.Moment)
                        KINETICS.LeftElbowMomentInProximal(:,f) = FRAME.LeftUpperArm.R_long(:,:,f)' * KINETICS.LeftElbow.Moment(:,f);
                    end
                end
                
                
                %13. Lösen der Bewgungsgleichungen für das linke Schultergelenk
                try
                    Wheight.UpperArm = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.UpperArm, 1, length(FP.COP.Left));
                    MA.LeftUpperArm = repmat(OPTIONS.ANTHRO.SegmentMass.UpperArm,3,length(FP.COP.Left)) .* FRAME.LeftUpperArm.LinACC_long;
                    
                    KINETICS.LeftShoulder.Term1 = zeros(3,length(FRAME.LeftThigh.O_long));
                    KINETICS.LeftShoulder.Term2 = cross((FRAME.LeftUpperArm.O_long  - MARKERS.Derived.LeftShoulderJC_long), Wheight.UpperArm)./1000; %wg Nmm zu Nm
                    KINETICS.LeftShoulder.Term3 = cross((FRAME.LeftUpperArm.O_long - MARKERS.Derived.LeftShoulderJC_long), MA.LeftUpperArm)./1000; %wg Nmm zu Nm
                    
                    I.UpperArm = repmat([OPTIONS.ANTHRO.MoI.UpperArm.X;OPTIONS.ANTHRO.MoI.UpperArm.Y;OPTIONS.ANTHRO.MoI.UpperArm.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.LeftUpperArm.R_long,3)
                        LL.LeftUpperArm(:,:,kk)=FRAME.LeftUpperArm.R_long(:,:,kk)*I.UpperArm*FRAME.LeftUpperArm.R_long(:,:,kk)';
                        KINETICS.LeftShoulder.Term4(:,kk)=(LL.LeftUpperArm(:,:,kk)*FRAME.LeftUpperArm.ACC_long(:,kk))+(FRAME.LeftUpperArm.Theta_long(:,:,kk)*LL.LeftUpperArm(:,:,kk)*FRAME.LeftUpperArm.V_long(:,kk));
                    end
                    
                    
                    KINETICS.LeftShoulder.Moment = KINETICS.LeftShoulder.Term1 - (KINETICS.LeftWrist.Term2 + KINETICS.LeftElbow.Term2 + KINETICS.LeftShoulder.Term2) + (KINETICS.LeftWrist.Term3 + KINETICS.LeftElbow.Term3 + KINETICS.LeftShoulder.Term3) + (KINETICS.LeftWrist.Term4 + KINETICS.LeftElbow.Term4 + KINETICS.LeftShoulder.Term4);
                    for f = 1:length(KINETICS.LeftShoulder.Moment)
                        KINETICS.LeftShoulderMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.LeftShoulder.Moment(:,f);
                    end
                end
                
                %14. Lösen der Bewgungsgleichungen für das Nackengelenk
                try
                    Wheight.Head = repmat([0;0;-9.81].*OPTIONS.ANTHRO.SegmentMass.Head, 1, length(FP.COP.Left));
                    MA.Head = repmat(OPTIONS.ANTHRO.SegmentMass.Head,3,length(FP.COP.Left)) .* FRAME.Head.LinACC_long;
                    
                    KINETICS.Neck.Term1 = zeros(3,length(FRAME.Head.O_long));
                    KINETICS.Neck.Term2 = cross((FRAME.Head.O_long  - MARKERS.Derived.NeckJC_long), Wheight.Head)./1000; %wg Nmm zu Nm
                    KINETICS.Neck.Term3 = cross((FRAME.Head.O_long - MARKERS.Derived.NeckJC_long), MA.Head)./1000; %wg Nmm zu Nm
                    
                    I.Head = repmat([OPTIONS.ANTHRO.MoI.Head.X;OPTIONS.ANTHRO.MoI.Head.Y;OPTIONS.ANTHRO.MoI.Head.Z],1,3).*eye(3,3);
                    I.Trunk = repmat([OPTIONS.ANTHRO.MoI.Trunk.X;OPTIONS.ANTHRO.MoI.Trunk.Y;OPTIONS.ANTHRO.MoI.Trunk.Z],1,3).*eye(3,3);
                    for kk=1:size(FRAME.Head.R_long,3)
                        LL.Head(:,:,kk)=FRAME.Head.R_long(:,:,kk)*I.Head*FRAME.Head.R_long(:,:,kk)';
                        LL.Trunk(:,:,kk)=FRAME.Trunk.R_long(:,:,kk)*I.Trunk*FRAME.Trunk.R_long(:,:,kk)';
                        KINETICS.Neck.Term4(:,kk)=(LL.Head(:,:,kk)*FRAME.Head.ACC_long(:,kk))+(FRAME.Head.Theta_long(:,:,kk)*LL.Head(:,:,kk)*FRAME.Head.V_long(:,kk));
                    end
                    
                    
                    KINETICS.Neck.Moment = KINETICS.Neck.Term1 - (KINETICS.Neck.Term2) + (KINETICS.Neck.Term3) + (KINETICS.Neck.Term4);
                    for f = 1:length(KINETICS.Neck.Moment)
                        KINETICS.NeckMomentInProximal(:,f) = FRAME.Trunk.R_long(:,:,f)' * KINETICS.Neck.Moment(:,f);
                    end
                end
                end