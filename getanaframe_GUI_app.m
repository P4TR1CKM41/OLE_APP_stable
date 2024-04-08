 
                function [O, R, SLength] = getanaframe_GUI_app(MARKERS, OPTIONS, segment)
                switch segment
                    % Determines anatomoical frames in a static measurement for
                    % each body segment
                    %%%%%%%%%%%%%%%%%%%%%%%%%% Right Leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    case 'RightFoot_regular'
                        [~, y] = size(MARKERS.calc_back_right.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = MARKERS.calc_back_right.data(:,i) + ([1;0;0])*0.4014*OPTIONS.ANTHRO.FootLength     +    ([1;0;0])*20 ; %Center of mass from Zatziorsky;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = OPTIONS.ANTHRO.FootLength./1000;
%                         SLength.Foot = SLength; 
                    case 'RightForefoot_regular'
                        [~, y] = size(MARKERS.toe_right.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(1,i) = MARKERS.forfoot_med_right.data(1,i);
                            O_allframes(3,i) = MARKERS.forfoot_med_right.data(3,i);
                            O_allframes(2,i) = (MARKERS.forfoot_med_right.data(2,i) + MARKERS.forfoot_lat_right.data(2,i)) / 2;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = 0;
                    case 'RightRearfoot_regular'
                        [~, y] = size(MARKERS.calc_back_right.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = (MARKERS.calc_back_right.data(:,i) + MARKERS.calc_med_right.data(:,i) + MARKERS.calc_lat_right.data(:,i)) / 3;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = 0;
                    case 'RightFoot_regular'
                        [~, y] = size(MARKERS.calc_back_right.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = MARKERS.calc_back_right.data(:,i) + [1;0;0].*OPTIONS.ANTHRO.FootLength;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = OPTIONS.ANTHRO.FootLength./1000;
                    case 'RightShank_regular'
                        [~, y] = size(MARKERS.mal_med_right.data);
                        O_allframes = zeros(3,y);
                        MidPointKnee = zeros(3,y);
                        MidPointAnkle = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            MidPointKnee(:,i) = (MARKERS.epi_med_right.data(:,i) + MARKERS.epi_lat_right.data(:,i)) / 2;
                            MidPointAnkle(:,i) = (MARKERS.mal_med_right.data(:,i) + MARKERS.mal_lat_right.data(:,i)) / 2;
                            O_allframes(:,i) = MidPointKnee(:,i) + ((MidPointAnkle(:,i)-MidPointKnee(:,i))*0.4352); %Center of mass after deLeva 1996;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            
                            
                            Z(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                            Zo(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                            Help1(:,i) = [0;1;0];
                            
                            X(:,i) = cross(Help1(:,i), Z(:,i));
                            Y(:,i) = cross(Z(:,i), X(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = norm(mean(Zo, 2))./1000;
%                         SLength.Shank = SLength; 
                    case 'RightPelvis_regular'
                        % This time R is initially determined; O comes subsequently
                        [~, y] = size(MARKERS.SIAS_right.data);
                        
                        MPASI = zeros(3,1,y);
                        MPPSI = zeros(3,1,y);
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            MPASI(:,i) = (MARKERS.SIAS_left.data(:,i) + MARKERS.SIAS_right.data(:,i))/2;
                            MPPSI(:,i) = (MARKERS.SIPS_left.data(:,i) + MARKERS.SIPS_right.data(:,i))/2;
                            Y(:,i) = MARKERS.SIAS_left.data(:,i) - MARKERS.SIAS_right.data(:,i);
                            Help1(:,i) = MPASI(:,i) - MPPSI(:,i);
                            Z(:,i) = cross(Help1(:,i), Y(:,i));
                            X(:,i) = cross(Y(:,i), Z(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = 0;
                        
                        
                        % Bestimmung des mittleren Abstandes zwischen LASI und RASI Marker
                        % bzw. zwischen RASI und RPSI Marker
                        DIST.ASIS = getdistance(MARKERS.SIAS_left.data, MARKERS.SIAS_right.data);
                        DIST.RASI_RPSI = getdistance(MARKERS.SIAS_right.data, MARKERS.SIPS_right.data);
                        DIST.LASI_LPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);
                        
                        % Ermittlung des Hüftgelenkmittelpunkts im loaklen
                        % Hüftkoordinatensystem (Ursprung RASI) nach Seidel (1995) (X und Y
                        % Koordinate)  bzw. Bell (1989) (Z - Koordinate)
                        POS.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
                        POS.hip.pelvis.lokal(2,1) = DIST.ASIS.mean*0.14;
                        POS.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;
                        
                        % Transformieren in globales Koordinatensystem
                        O_allframes = zeros(3,y);
                        for u = 1:y
                            O_allframes(:,u) = R*POS.hip.pelvis.lokal + MARKERS.SIAS_right.data(:,u);
                        end
                        
                        O = mean(O_allframes,2);
                        
                    case 'RightThigh_regular'
                        [~, y] = size(MARKERS.cluster_femur_right_1.data);
                        O_allframes = zeros(3,y);
                        MidPointKnee = zeros(3,y);
                        
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            MidPointKnee(:,i) = (MARKERS.epi_med_right.data(:,i) + MARKERS.epi_lat_right.data(:,i)) / 2;
                            O_allframes(:,i) = MARKERS.hip_joint_center_right.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_right.data(:,i))*0.3612; %Center of mass after deLeva 1996;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            Z(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                            Zo(:,i) = MARKERS.hip_joint_center_right.data(:,i) - MidPointKnee(:,i);
                            Help1(:,i) = [0;1;0];
                            X(:,i) = cross(Help1(:,i), Z(:,i));
                            Y(:,i) = cross(Z(:,i), X(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = norm(mean(Zo, 2))./1000;
%                          SLength.Shank = SLength; 

                        %%%%%%%%%%%%%%%%%%%%%%%%%% Left Leg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    case 'LeftFoot_regular'
                        [~, y] = size(MARKERS.calc_back_left.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = MARKERS.calc_back_left.data(:,i) + ([1;0;0])*0.4014*OPTIONS.ANTHRO.FootLength     +    ([1;0;0])*20 ; %Center of mass from Zatziorsky;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = OPTIONS.ANTHRO.FootLength./1000;
                        
                    case 'LeftForefoot_regular'
                        [~, y] = size(MARKERS.toe_left.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(1,i) = MARKERS.forefoot_med_left.data(1,i);
                            O_allframes(3,i) = MARKERS.forefoot_med_left.data(3,i);
                            O_allframes(2,i) = (MARKERS.forefoot_med_left.data(2,i) + MARKERS.forefoot_lat_left.data(2,i)) / 2;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = 0;
                        
                    case 'LeftRearfoot_regular'
                        [~, y] = size(MARKERS.calc_back_left.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = (MARKERS.calc_back_left.data(:,i) + MARKERS.calc_med_left.data(:,i) + MARKERS.calc_lat_left.data(:,i)) / 3;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = 0;
                        
                    case 'LeftFoot_regular'
                        [~, y] = size(MARKERS.calc_back_right.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            O_allframes(:,i) = MARKERS.calc_back_left.data(:,i) + [1;0;0].*OPTIONS.ANTHRO.FootLength;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = OPTIONS.ANTHRO.FootLength./1000;
                        
                    case 'LeftShank_regular'
                        [~, y] = size(MARKERS.mal_med_left.data);
                        O_allframes = zeros(3,y);
                        MidPointKnee = zeros(3,y);
                        MidPointAnkle = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            MidPointKnee(:,i) = (MARKERS.epi_med_left.data(:,i) + MARKERS.epi_lat_left.data(:,i)) / 2;
                            MidPointAnkle(:,i) = (MARKERS.mal_med_left.data(:,i) + MARKERS.mal_lat_left.data(:,i)) / 2;
                            O_allframes(:,i) = MidPointKnee(:,i) + ((MidPointAnkle(:,i)-MidPointKnee(:,i))*0.4352); %Center of mass after deLeva 1996;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            
                            
                            Z(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                            Zo(:,i) = MidPointKnee(:,i) - MidPointAnkle(:,i);
                            Help1(:,i) = [0;1;0];
                            X(:,i) = cross(Help1(:,i), Z(:,i));
                            Y(:,i) = cross(Z(:,i), X(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = norm(mean(Zo, 2))./1000;
                        
                    case 'LeftPelvis_regular'
                        % This time R is initially determined; O comes subsequently
                        [~, y] = size(MARKERS.SIAS_left.data);
                        
                        MPASI = zeros(3,1,y);
                        MPPSI = zeros(3,1,y);
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            MPASI(:,i) = (MARKERS.SIAS_left.data(:,i) + MARKERS.SIAS_right.data(:,i))/2;
                            MPPSI(:,i) = (MARKERS.SIPS_left.data(:,i) + MARKERS.SIPS_right.data(:,i))/2;
                            Y(:,i) = MARKERS.SIAS_left.data(:,i) - MARKERS.SIAS_right.data(:,i);
                            Help1(:,i) = MPASI(:,i) - MPPSI(:,i);
                            Z(:,i) = cross(Help1(:,i), Y(:,i));
                            X(:,i) = cross(Y(:,i), Z(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = 0;
                        
                        
                        % Bestimmung des mittleren Abstandes zwischen LASI und RASI Marker
                        % bzw. zwischen RASI und RPSI Marker
                        DIST.ASIS = getdistance(MARKERS.SIAS_left.data, MARKERS.SIAS_right.data);
                        DIST.RASI_RPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);
                        DIST.LASI_LPSI = getdistance(MARKERS.SIAS_left.data, MARKERS.SIPS_left.data);
                        
                        % Ermittlung des Hüftgelenkmittelpunkts im loaklen
                        % Hüftkoordinatensystem (Ursprung RASI) nach Seidel (1995) (X und Y
                        % Koordinate)  bzw. Bell (1989) (Z - Koordinate)
                        POS.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
                        POS.hip.pelvis.lokal(2,1) = -DIST.ASIS.mean*0.14; %Minus weil linke Seite
                        POS.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;
                        
                        % Transformieren in globales Koordinatensystem
                        O_allframes = zeros(3,y);
                        for u = 1:y
                            O_allframes(:,u) = R*POS.hip.pelvis.lokal + MARKERS.SIAS_left.data(:,u);
                        end
                        
                        O = mean(O_allframes,2);
                        
                    case 'LeftThigh_regular'
                        [~, y] = size(MARKERS.cluster_femur_left_1.data);
                        O_allframes = zeros(3,y);
                        MidPointKnee = zeros(3,y);
                        
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            MidPointKnee(:,i) = (MARKERS.epi_med_left.data(:,i) + MARKERS.epi_lat_left.data(:,i)) / 2;
                            O_allframes(:,i) = MARKERS.hip_joint_center_left.data(:,i) + (MidPointKnee(:,i)-MARKERS.hip_joint_center_left.data(:,i))*0.3612; %Center of mass after deLeva 1996;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            Z(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                            Zo(:,i) = MARKERS.hip_joint_center_left.data(:,i) - MidPointKnee(:,i);
                            Help1(:,i) = [0;1;0];
                            X(:,i) = cross(Help1(:,i), Z(:,i));
                            Y(:,i) = cross(Z(:,i), X(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = norm(mean(Zo, 2))./1000;

                        %%%%%%%%%%%%%%%%% Head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    case 'Head_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            try
                	            O_allframes(:,i) = (MARKERS.ear_right.data(:,i) + MARKERS.ear_left.data(:,i)) / 2;
                            catch
                                O_allframes(:,i) = (MARKERS.head_front_right.data(:,i) + MARKERS.head_front_left.data(:,i)) / 2;
                            end
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        R = eye(3,3);
                        SLength = OPTIONS.ANTHRO.Height*0.1395;
                        
                    case 'RightUpperArm_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        ShoulderCenter = zeros(3,y);
                        ElbowCenter = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            ShoulderCenter(1,i) = MARKERS.acrom_right.data(1,i);
                            ShoulderCenter(2,i) = MARKERS.acrom_right.data(2,i);
                            ShoulderCenter(3,i) = MARKERS.shoulder_right.data(3,i);
                            ElbowCenter(:,i) = (MARKERS.elbow_lat_right.data(:,i) + MARKERS.elbow_med_right.data(:,i)) / 2;
                            O_allframes(:,i) = ShoulderCenter(:,i) + (ElbowCenter(:,i) - ShoulderCenter(:,i)).*0.5772;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  ShoulderCenter(:,1) - ElbowCenter(:,1);
                        for i = 1:y
                            Z(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                            Zo(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                    case 'RightLowerArm_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        WristCenter = zeros(3,y);
                        ElbowCenter = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            WristCenter(:,i) = (MARKERS.hand_lat_right.data(:,i) + MARKERS.hand_med_right.data(:,i)) / 2;
                            ElbowCenter(:,i) = (MARKERS.elbow_lat_right.data(:,i) + MARKERS.elbow_med_right.data(:,i)) / 2;
                            O_allframes(:,i) = ElbowCenter(:,i) + (WristCenter(:,i) - ElbowCenter(:,i)).*0.4574;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  ElbowCenter(:,1) - WristCenter(:,1);
                        for i = 1:y
                            Z(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                            Zo(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                        
                    case 'RightHand_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        WristCenter = zeros(3,y);
                        
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            WristCenter(:,i) = (MARKERS.hand_lat_right.data(:,i) + MARKERS.hand_med_right.data(:,i)) / 2;
                            O_allframes(:,i) = WristCenter(:,i) + (MARKERS.hand_top_right.data(:,i) - WristCenter(:,i)).*0.79;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  WristCenter(:,1) - MARKERS.hand_top_right.data(:,1);
                        for i = 1:y
                            Z(:,i) = WristCenter(:,i) - MARKERS.hand_top_right.data(:,i);
                            Zo(:,i) = WristCenter(:,i) - MARKERS.hand_top_right.data(:,i);
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                        
                    case 'LeftUpperArm_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        ShoulderCenter = zeros(3,y);
                        ElbowCenter = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            ShoulderCenter(1,i) = MARKERS.acrom_left.data(1,i);
                            ShoulderCenter(2,i) = MARKERS.acrom_left.data(2,i);
                            ShoulderCenter(3,i) = MARKERS.shoulder_left.data(3,i);
                            ElbowCenter(:,i) = (MARKERS.elbow_lat_left.data(:,i) + MARKERS.elbow_med_left.data(:,i)) / 2;
                            O_allframes(:,i) = ShoulderCenter(:,i) + (ElbowCenter(:,i) - ShoulderCenter(:,i)).*0.5772;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  ShoulderCenter(:,1) - ElbowCenter(:,1);
                        for i = 1:y
                            Z(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                            Zo(:,i) = ShoulderCenter(:,i) - ElbowCenter(:,i);
                            
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        SLength = norm(mean(Zo, 2))./1000;
                        
                    case 'LeftLowerArm_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        WristCenter = zeros(3,y);
                        ElbowCenter = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            WristCenter(:,i) = (MARKERS.hand_lat_left.data(:,i) + MARKERS.hand_med_left.data(:,i)) / 2;
                            ElbowCenter(:,i) = (MARKERS.elbow_lat_left.data(:,i) + MARKERS.elbow_med_left.data(:,i)) / 2;
                            O_allframes(:,i) = ElbowCenter(:,i) + (WristCenter(:,i) - ElbowCenter(:,i)).*0.4574;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  ElbowCenter(:,1) - WristCenter(:,1);
                        for i = 1:y
                            Z(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                            Zo(:,i) = ElbowCenter(:,i) - WristCenter(:,i);
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                        
                    case 'LeftHand_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        WristCenter = zeros(3,y);
                        
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            WristCenter(:,i) = (MARKERS.hand_lat_left.data(:,i) + MARKERS.hand_med_left.data(:,i)) / 2;
                            O_allframes(:,i) = WristCenter(:,i) + (MARKERS.hand_top_left.data(:,i) - WristCenter(:,i)).*0.79;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        Vtest =  WristCenter(:,1) - MARKERS.hand_top_left.data(:,1);
                        for i = 1:y
                            Z(:,i) = WristCenter(:,i) - MARKERS.hand_top_left.data(:,i);
                            Zo(:,i) = WristCenter(:,i) - MARKERS.hand_top_left.data(:,i);
                            if Vtest(3,1) > norm(Vtest(:,1))*0.5
                                Help1(:,i) = [0;1;0];
                                X(:,i) = cross(Help1(:,i), Z(:,i));
                                Y(:,i) = cross(Z(:,i), X(:,i));
                            else
                                Help1(:,i) = [1;0;0];
                                Y(:,i) = cross(Z(:,i),Help1(:,i));
                                X(:,i) = cross(Y(:,i), Z(:,i));
                            end
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                        
                    case 'Trunk_regular'
                        [~, y] = size(MARKERS.head_front_left.data);
                        O_allframes = zeros(3,y);
                        NeckCenter = zeros(3,y);
                        HipsCenter = zeros(3,y);
                        TopRefPoint = zeros(3,y);
                        % Determine origin of anatomical reference frame
                        for i = 1:y
                            NeckCenter(:,i) = (MARKERS.C_7.data(:,i) + MARKERS.clav.data(:,i)) / 2;
                            HipsCenter(:,i) = (MARKERS.hip_joint_center_left.data(:,i) + MARKERS.hip_joint_center_right.data(:,i)) / 2;
                            TopRefPoint(1,i) = NeckCenter(1,i);
                            TopRefPoint(2:3,i) = MARKERS.clav.data(2:3,i);
                            O_allframes(:,i) = HipsCenter(:,i) + (TopRefPoint(:,i) - HipsCenter(:,i)).*0.5514;
                        end
                        O = mean(O_allframes, 2);
                        % Determine coordinate system (rotation matrix R) for segment
                        Help1 = zeros(3,1,y);
                        X = zeros(3,1,y);
                        Y = zeros(3,1,y);
                        Z = zeros(3,1,y);
                        for i = 1:y
                            Z(:,i) = TopRefPoint(:,i) - HipsCenter(:,i);
                            Zo(:,i) = TopRefPoint(:,i) - HipsCenter(:,i);
                            Help1(:,i) = [0;1;0];
                            X(:,i) = cross(Help1(:,i), Z(:,i));
                            Y(:,i) = cross(Z(:,i), X(:,i));
                            X(:,i) = X(:,i) / norm(X(:,i));
                            Y(:,i) = Y(:,i) / norm(Y(:,i));
                            Z(:,i) = Z(:,i) / norm(Z(:,i));
                        end
                        
                        R = Rmean_app([X,Y,Z]);
                        
                        SLength = norm(mean(Zo, 2))./1000;
                        
                end
                end %getanaframe_GUI