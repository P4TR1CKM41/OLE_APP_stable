function [REFFRAME, MARKERS, WEIGHT, OPTIONS] = get_refinfo_GUI_app(ref_file, OPTIONS)
        % Function to extract the neccesary information from a static
        % reference trial.
        
        % Get Marker information
        % get marker trajectories and further information from the c3d file
        
        try
            [MARKERS.Raw, LABELS.Exist, ~, ~, ~, OPTIONS.FreqKinematics, OPTIONS.ftkratio] = getlabeledmarkers_GUI_app(ref_file);
            
            % filter marker coordinates
            ExistentMarkers = LABELS.Exist;
            [b,a] = butter(OPTIONS.FilterOrder/2, OPTIONS.CutOffMarkers/(OPTIONS.FreqKinematics/2));
            for t = 1:length(ExistentMarkers)
                MARKERS.Filt.(char(ExistentMarkers(t,1))) = markersfilt_app(MARKERS.Raw.(char(ExistentMarkers(t,1))), b, a);
            end
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems reading in marker data']}];
        end
        
        
        %% Determine subjects wheight
        
        
        WEIGHT = OPTIONS.mass*9.81;
        
        
        %% Determine Technical and Anatomical Reference Frames for each Segment
        
        % Right leg %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Right forefoot
        try
            [FRAME.Technical.RightForefoot.O, FRAME.Technical.RightForefoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.toe_right.data, MARKERS.Filt.forfoot_lat_right.data, MARKERS.Filt.forfoot_med_right.data);
            [FRAME.Anatomical.RightForefoot.O, FRAME.Anatomical.RightForefoot.R, FRAME.Anatomical.RightForefoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightForefoot_regular');
            for u = 1:size(FRAME.Technical.RightForefoot.R, 3)
                FRAME.Technical_to_Anatomical.RightForefoot.R(:,:,u) = FRAME.Technical.RightForefoot.R(:,:,u)'*FRAME.Anatomical.RightForefoot.R;
                FRAME.Technical_to_Anatomical.RightForefoot.O(:,u) = FRAME.Technical.RightForefoot.R(:,:,u)'*(FRAME.Anatomical.RightForefoot.O - FRAME.Technical.RightForefoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightForefoot.R = Rmean_app(FRAME.Technical_to_Anatomical.RightForefoot.R);
            REFFRAME.Technical_to_Anatomical.RightForefoot.O = Vmean_app(FRAME.Technical_to_Anatomical.RightForefoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Forefoot Segment in Static Reference']}];
        end
        
        % Right rearfoot
        try
            [FRAME.Technical.RightRearfoot.O, FRAME.Technical.RightRearfoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.calc_back_right.data, MARKERS.Filt.calc_med_right.data, MARKERS.Filt.calc_lat_right.data);
            [FRAME.Anatomical.RightRearfoot.O, FRAME.Anatomical.RightRearfoot.R, FRAME.Anatomical.RightRearfoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightRearfoot_regular');
            for u = 1:size(FRAME.Technical.RightRearfoot.R, 3)
                FRAME.Technical_to_Anatomical.RightRearfoot.R(:,:,u) = FRAME.Technical.RightRearfoot.R(:,:,u)'*FRAME.Anatomical.RightRearfoot.R;
                FRAME.Technical_to_Anatomical.RightRearfoot.O(:,u) = FRAME.Technical.RightRearfoot.R(:,:,u)'*(FRAME.Anatomical.RightRearfoot.O - FRAME.Technical.RightRearfoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightRearfoot.R = Rmean_app(FRAME.Technical_to_Anatomical.RightRearfoot.R);
            REFFRAME.Technical_to_Anatomical.RightRearfoot.O = Vmean_app(FRAME.Technical_to_Anatomical.RightRearfoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Rearfoot Segment in Static Reference']}];
        end
        
        % Right foot
        try
            [FRAME.Technical.RightFoot.O, FRAME.Technical.RightFoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.calc_back_right.data, MARKERS.Filt.forfoot_lat_right.data, MARKERS.Filt.forfoot_med_right.data);
            [FRAME.Anatomical.RightFoot.O, FRAME.Anatomical.RightFoot.R, FRAME.Anatomical.RightFoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightFoot_regular');
            for u = 1:size(FRAME.Technical.RightFoot.R, 3)
                FRAME.Technical_to_Anatomical.RightFoot.R(:,:,u) = FRAME.Technical.RightFoot.R(:,:,u)'*FRAME.Anatomical.RightFoot.R;
                FRAME.Technical_to_Anatomical.RightFoot.O(:,u) = FRAME.Technical.RightFoot.R(:,:,u)'*(FRAME.Anatomical.RightFoot.O - FRAME.Technical.RightFoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightFoot.R = Rmean_app(FRAME.Technical_to_Anatomical.RightFoot.R);
            REFFRAME.Technical_to_Anatomical.RightFoot.O = Vmean_app(FRAME.Technical_to_Anatomical.RightFoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Foot Segment in Static Reference']}];
        end
        
        % Right shank
        try
            [FRAME.Technical.RightShank.O, FRAME.Technical.RightShank.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_tibia_right_1.data, MARKERS.Filt.cluster_tibia_right_2.data, MARKERS.Filt.cluster_tibia_right_3.data, MARKERS.Filt.cluster_tibia_right_4.data);
            [FRAME.Anatomical.RightShank.O, FRAME.Anatomical.RightShank.R,  FRAME.Anatomical.RightShank.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightShank_regular');
            for u = 1:size(FRAME.Technical.RightShank.R, 3)
                FRAME.Technical_to_Anatomical.RightShank.R(:,:,u) = FRAME.Technical.RightShank.R(:,:,u)'*FRAME.Anatomical.RightShank.R;
                FRAME.Technical_to_Anatomical.RightShank.O(:,u) = FRAME.Technical.RightShank.R(:,:,u)'*(FRAME.Anatomical.RightShank.O - FRAME.Technical.RightShank.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightShank.R = Rmean_app(FRAME.Technical_to_Anatomical.RightShank.R);
            REFFRAME.Technical_to_Anatomical.RightShank.O = Vmean_app(FRAME.Technical_to_Anatomical.RightShank.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Shank Segment in Static Reference']}];
        end
        
        % Right pelvis
        try
            [FRAME.Technical.RightPelvis.O, FRAME.Technical.RightPelvis.R] = get_technical_frame_GUI_app(MARKERS.Filt.SIAS_right.data, MARKERS.Filt.SIAS_left.data, MARKERS.Filt.SIPS_right.data, MARKERS.Filt.SIPS_left.data);
            [FRAME.Anatomical.RightPelvis.O, FRAME.Anatomical.RightPelvis.R, FRAME.Anatomical.RightPelvis.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightPelvis_regular');
            for u = 1:size(FRAME.Technical.RightPelvis.R, 3)
                FRAME.Technical_to_Anatomical.RightPelvis.R(:,:,u) = FRAME.Technical.RightPelvis.R(:,:,u)'*FRAME.Anatomical.RightPelvis.R;
                FRAME.Technical_to_Anatomical.RightPelvis.O(:,u) = FRAME.Technical.RightPelvis.R(:,:,u)'*(FRAME.Anatomical.RightPelvis.O - FRAME.Technical.RightPelvis.O(:,u));
                MARKERS.Filt.hip_joint_center_right.data(:,u) = FRAME.Anatomical.RightPelvis.O;
            end
            REFFRAME.Technical_to_Anatomical.RightPelvis.R = Rmean_app(FRAME.Technical_to_Anatomical.RightPelvis.R);
            REFFRAME.Technical_to_Anatomical.RightPelvis.O = Vmean_app(FRAME.Technical_to_Anatomical.RightPelvis.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis Segment in Static Reference']}];
        end
        
        % Right thigh
        try
            [FRAME.Technical.RightThigh.O, FRAME.Technical.RightThigh.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_femur_right_1.data, MARKERS.Filt.cluster_femur_right_2.data, MARKERS.Filt.cluster_femur_right_3.data, MARKERS.Filt.cluster_femur_right_4.data);
            [FRAME.Anatomical.RightThigh.O, FRAME.Anatomical.RightThigh.R, FRAME.Anatomical.RightThigh.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightThigh_regular');
            for u = 1:size(FRAME.Technical.RightThigh.R, 3)
                FRAME.Technical_to_Anatomical.RightThigh.R(:,:,u) = FRAME.Technical.RightThigh.R(:,:,u)'*FRAME.Anatomical.RightThigh.R;
                FRAME.Technical_to_Anatomical.RightThigh.O(:,u) = FRAME.Technical.RightThigh.R(:,:,u)'*(FRAME.Anatomical.RightThigh.O - FRAME.Technical.RightThigh.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightThigh.R = Rmean_app(FRAME.Technical_to_Anatomical.RightThigh.R);
            REFFRAME.Technical_to_Anatomical.RightThigh.O = Vmean_app(FRAME.Technical_to_Anatomical.RightThigh.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Thigh Segment in Static Reference']}];
        end
        
        % Right Upper Extremity
        try
            [FRAME.Technical.RightUpperArm.O, FRAME.Technical.RightUpperArm.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_upperarm_right_1.data, MARKERS.Filt.cluster_upperarm_right_2.data, MARKERS.Filt.cluster_upperarm_right_3.data);
            [FRAME.Anatomical.RightUpperArm.O, FRAME.Anatomical.RightUpperArm.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightUpperArm_regular');
            for u = 1:size(FRAME.Technical.RightUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.RightUpperArm.R(:,:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*FRAME.Anatomical.RightUpperArm.R;
                FRAME.Technical_to_Anatomical.RightUpperArm.O(:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*(FRAME.Anatomical.RightUpperArm.O - FRAME.Technical.RightUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightUpperArm.R = Rmean_app(FRAME.Technical_to_Anatomical.RightUpperArm.R);
            REFFRAME.Technical_to_Anatomical.RightUpperArm.O = Vmean_app(FRAME.Technical_to_Anatomical.RightUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file,  ' : Problems constructing Right UpperArm Segment in Static Reference']}];
        end
        
        % Left leg %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Left forefoot
        try
            [FRAME.Technical.LeftForefoot.O, FRAME.Technical.LeftForefoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.toe_left.data, MARKERS.Filt.forefoot_lat_left.data, MARKERS.Filt.forefoot_med_left.data);
            [FRAME.Anatomical.LeftForefoot.O, FRAME.Anatomical.LeftForefoot.R, FRAME.Anatomical.LeftForefoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftForefoot_regular');
            for u = 1:size(FRAME.Technical.LeftForefoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftForefoot.R(:,:,u) = FRAME.Technical.LeftForefoot.R(:,:,u)'*FRAME.Anatomical.LeftForefoot.R;
                FRAME.Technical_to_Anatomical.LeftForefoot.O(:,u) = FRAME.Technical.LeftForefoot.R(:,:,u)'*(FRAME.Anatomical.LeftForefoot.O - FRAME.Technical.LeftForefoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftForefoot.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftForefoot.R);
            REFFRAME.Technical_to_Anatomical.LeftForefoot.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftForefoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Forefoot Segment in Static Reference']}];
        end
        
        % Left rearfoot
        try
            [FRAME.Technical.LeftRearfoot.O, FRAME.Technical.LeftRearfoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.calc_back_left.data, MARKERS.Filt.calc_med_left.data, MARKERS.Filt.calc_lat_left.data);
            [FRAME.Anatomical.LeftRearfoot.O, FRAME.Anatomical.LeftRearfoot.R, FRAME.Anatomical.LeftRearfoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftRearfoot_regular');
            for u = 1:size(FRAME.Technical.LeftRearfoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftRearfoot.R(:,:,u) = FRAME.Technical.LeftRearfoot.R(:,:,u)'*FRAME.Anatomical.LeftRearfoot.R;
                FRAME.Technical_to_Anatomical.LeftRearfoot.O(:,u) = FRAME.Technical.LeftRearfoot.R(:,:,u)'*(FRAME.Anatomical.LeftRearfoot.O - FRAME.Technical.LeftRearfoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftRearfoot.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftRearfoot.R);
            REFFRAME.Technical_to_Anatomical.LeftRearfoot.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftRearfoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Rearfoot Segment in Static Reference']}];
        end
        
        % Left foot
        try
            [FRAME.Technical.LeftFoot.O, FRAME.Technical.LeftFoot.R] = get_technical_frame_GUI_app(MARKERS.Filt.calc_back_left.data, MARKERS.Filt.forefoot_lat_left.data, MARKERS.Filt.forefoot_med_left.data);
            [FRAME.Anatomical.LeftFoot.O, FRAME.Anatomical.LeftFoot.R, FRAME.Anatomical.LeftFoot.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftFoot_regular');
            for u = 1:size(FRAME.Technical.LeftFoot.R, 3)
                FRAME.Technical_to_Anatomical.LeftFoot.R(:,:,u) = FRAME.Technical.LeftFoot.R(:,:,u)'*FRAME.Anatomical.LeftFoot.R;
                FRAME.Technical_to_Anatomical.LeftFoot.O(:,u) = FRAME.Technical.LeftFoot.R(:,:,u)'*(FRAME.Anatomical.LeftFoot.O - FRAME.Technical.LeftFoot.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftFoot.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftFoot.R);
            REFFRAME.Technical_to_Anatomical.LeftFoot.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftFoot.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Foot Segment in Static Reference']}];
        end
        
        % Left shank
        try
            [FRAME.Technical.LeftShank.O, FRAME.Technical.LeftShank.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_tibia_left_1.data, MARKERS.Filt.cluster_tibia_left_2.data, MARKERS.Filt.cluster_tibia_left_3.data, MARKERS.Filt.cluster_tibia_left_4.data);
            [FRAME.Anatomical.LeftShank.O, FRAME.Anatomical.LeftShank.R, FRAME.Anatomical.LeftShank.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftShank_regular');
            for u = 1:size(FRAME.Technical.LeftShank.R, 3)
                FRAME.Technical_to_Anatomical.LeftShank.R(:,:,u) = FRAME.Technical.LeftShank.R(:,:,u)'*FRAME.Anatomical.LeftShank.R;
                FRAME.Technical_to_Anatomical.LeftShank.O(:,u) = FRAME.Technical.LeftShank.R(:,:,u)'*(FRAME.Anatomical.LeftShank.O - FRAME.Technical.LeftShank.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftShank.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftShank.R);
            REFFRAME.Technical_to_Anatomical.LeftShank.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftShank.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Shank Segment in Static Reference']}];
        end
        % Left pelvis
        try
            [FRAME.Technical.LeftPelvis.O, FRAME.Technical.LeftPelvis.R] = get_technical_frame_GUI_app(MARKERS.Filt.SIAS_right.data, MARKERS.Filt.SIAS_left.data, MARKERS.Filt.SIPS_right.data, MARKERS.Filt.SIPS_left.data);
            [FRAME.Anatomical.LeftPelvis.O, FRAME.Anatomical.LeftPelvis.R,FRAME.Anatomical.LeftPelvis.Length ] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftPelvis_regular');
            for u = 1:size(FRAME.Technical.LeftPelvis.R, 3)
                FRAME.Technical_to_Anatomical.LeftPelvis.R(:,:,u) = FRAME.Technical.LeftPelvis.R(:,:,u)'*FRAME.Anatomical.LeftPelvis.R;
                FRAME.Technical_to_Anatomical.LeftPelvis.O(:,u) = FRAME.Technical.LeftPelvis.R(:,:,u)'*(FRAME.Anatomical.LeftPelvis.O - FRAME.Technical.LeftPelvis.O(:,u));
                MARKERS.Filt.hip_joint_center_left.data(:,u) = FRAME.Anatomical.LeftPelvis.O;
            end
            REFFRAME.Technical_to_Anatomical.LeftPelvis.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftPelvis.R);
            REFFRAME.Technical_to_Anatomical.LeftPelvis.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftPelvis.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis Segment in Static Reference']}];
        end
        
        % Left thigh
        try
            [FRAME.Technical.LeftThigh.O, FRAME.Technical.LeftThigh.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_femur_left_1.data, MARKERS.Filt.cluster_femur_left_2.data, MARKERS.Filt.cluster_femur_left_3.data, MARKERS.Filt.cluster_femur_left_4.data);
            [FRAME.Anatomical.LeftThigh.O, FRAME.Anatomical.LeftThigh.R, FRAME.Anatomical.LeftThigh.Length] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftThigh_regular');
            for u = 1:size(FRAME.Technical.LeftThigh.R, 3)
                FRAME.Technical_to_Anatomical.LeftThigh.R(:,:,u) = FRAME.Technical.LeftThigh.R(:,:,u)'*FRAME.Anatomical.LeftThigh.R;
                FRAME.Technical_to_Anatomical.LeftThigh.O(:,u) = FRAME.Technical.LeftThigh.R(:,:,u)'*(FRAME.Anatomical.LeftThigh.O - FRAME.Technical.LeftThigh.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftThigh.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftThigh.R);
            REFFRAME.Technical_to_Anatomical.LeftThigh.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftThigh.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Thigh Segment in Static Reference']}];
        end
        % Head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
            [FRAME.Technical.Head.O, FRAME.Technical.Head.R] = get_technical_frame_GUI_app(MARKERS.Filt.head_front_right.data, MARKERS.Filt.head_front_left.data, MARKERS.Filt.head_back_right.data, MARKERS.Filt.head_back_left.data);
            [FRAME.Anatomical.Head.O, FRAME.Anatomical.Head.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'Head_regular');
            for u = 1:size(FRAME.Technical.Head.R, 3)
                FRAME.Technical_to_Anatomical.Head.R(:,:,u) = FRAME.Technical.Head.R(:,:,u)'*FRAME.Anatomical.Head.R;
                FRAME.Technical_to_Anatomical.Head.O(:,u) = FRAME.Technical.Head.R(:,:,u)'*(FRAME.Anatomical.Head.O - FRAME.Technical.Head.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.Head.R = Rmean_app(FRAME.Technical_to_Anatomical.Head.R);
            REFFRAME.Technical_to_Anatomical.Head.O = Vmean_app(FRAME.Technical_to_Anatomical.Head.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Head Segment in Static Reference']}];
        end
        
        % Right arm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Right upper arm
        try
            [FRAME.Technical.RightUpperArm.O, FRAME.Technical.RightUpperArm.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_upperarm_right_1.data, MARKERS.Filt.cluster_upperarm_right_2.data, MARKERS.Filt.cluster_upperarm_right_3.data);
            [FRAME.Anatomical.RightUpperArm.O, FRAME.Anatomical.RightUpperArm.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightUpperArm_regular');
            for u = 1:size(FRAME.Technical.RightUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.RightUpperArm.R(:,:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*FRAME.Anatomical.RightUpperArm.R;
                FRAME.Technical_to_Anatomical.RightUpperArm.O(:,u) = FRAME.Technical.RightUpperArm.R(:,:,u)'*(FRAME.Anatomical.RightUpperArm.O - FRAME.Technical.RightUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightUpperArm.R = Rmean_app(FRAME.Technical_to_Anatomical.RightUpperArm.R);
            REFFRAME.Technical_to_Anatomical.RightUpperArm.O = Vmean_app(FRAME.Technical_to_Anatomical.RightUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Upperarm Segment in Static Reference']}];
        end
        
        % Right lower arm
        try
            [FRAME.Technical.RightLowerArm.O, FRAME.Technical.RightLowerArm.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_lowerarm_right_1.data, MARKERS.Filt.cluster_lowerarm_right_2.data, MARKERS.Filt.cluster_lowerarm_right_3.data);
            [FRAME.Anatomical.RightLowerArm.O, FRAME.Anatomical.RightLowerArm.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightLowerArm_regular');
            for u = 1:size(FRAME.Technical.RightLowerArm.R, 3)
                FRAME.Technical_to_Anatomical.RightLowerArm.R(:,:,u) = FRAME.Technical.RightLowerArm.R(:,:,u)'*FRAME.Anatomical.RightLowerArm.R;
                FRAME.Technical_to_Anatomical.RightLowerArm.O(:,u) = FRAME.Technical.RightLowerArm.R(:,:,u)'*(FRAME.Anatomical.RightLowerArm.O - FRAME.Technical.RightLowerArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightLowerArm.R = Rmean_app(FRAME.Technical_to_Anatomical.RightLowerArm.R);
            REFFRAME.Technical_to_Anatomical.RightLowerArm.O = Vmean_app(FRAME.Technical_to_Anatomical.RightLowerArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Lowerarm Segment in Static Reference']}];
        end
        
        % Right hand
        try
            [FRAME.Technical.RightHand.O, FRAME.Technical.RightHand.R] = get_technical_frame_GUI_app(MARKERS.Filt.hand_med_right.data, MARKERS.Filt.hand_lat_right.data, MARKERS.Filt.hand_top_right.data);
            [FRAME.Anatomical.RightHand.O, FRAME.Anatomical.RightHand.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'RightHand_regular');
            for u = 1:size(FRAME.Technical.RightHand.R, 3)
                FRAME.Technical_to_Anatomical.RightHand.R(:,:,u) = FRAME.Technical.RightHand.R(:,:,u)'*FRAME.Anatomical.RightHand.R;
                FRAME.Technical_to_Anatomical.RightHand.O(:,u) = FRAME.Technical.RightHand.R(:,:,u)'*(FRAME.Anatomical.RightHand.O - FRAME.Technical.RightHand.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.RightHand.R = Rmean_app(FRAME.Technical_to_Anatomical.RightHand.R);
            REFFRAME.Technical_to_Anatomical.RightHand.O = Vmean_app(FRAME.Technical_to_Anatomical.RightHand.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Hand Segment in Static Reference']}];
        end
        
        % Left arm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Left upper arm
        try
            [FRAME.Technical.LeftUpperArm.O, FRAME.Technical.LeftUpperArm.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_upperarm_left_1.data, MARKERS.Filt.cluster_upperarm_left_2.data, MARKERS.Filt.cluster_upperarm_left_3.data);
            [FRAME.Anatomical.LeftUpperArm.O, FRAME.Anatomical.LeftUpperArm.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftUpperArm_regular');
            for u = 1:size(FRAME.Technical.LeftUpperArm.R, 3)
                FRAME.Technical_to_Anatomical.LeftUpperArm.R(:,:,u) = FRAME.Technical.LeftUpperArm.R(:,:,u)'*FRAME.Anatomical.LeftUpperArm.R;
                FRAME.Technical_to_Anatomical.LeftUpperArm.O(:,u) = FRAME.Technical.LeftUpperArm.R(:,:,u)'*(FRAME.Anatomical.LeftUpperArm.O - FRAME.Technical.LeftUpperArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftUpperArm.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftUpperArm.R);
            REFFRAME.Technical_to_Anatomical.LeftUpperArm.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftUpperArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Upperarm Segment in Static Reference']}];
        end
        % Left lower arm
        try
            [FRAME.Technical.LeftLowerArm.O, FRAME.Technical.LeftLowerArm.R] = get_technical_frame_GUI_app(MARKERS.Filt.cluster_lowerarm_left_1.data, MARKERS.Filt.cluster_lowerarm_left_2.data, MARKERS.Filt.cluster_lowerarm_left_3.data);
            [FRAME.Anatomical.LeftLowerArm.O, FRAME.Anatomical.LeftLowerArm.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftLowerArm_regular');
            for u = 1:size(FRAME.Technical.LeftLowerArm.R, 3)
                FRAME.Technical_to_Anatomical.LeftLowerArm.R(:,:,u) = FRAME.Technical.LeftLowerArm.R(:,:,u)'*FRAME.Anatomical.LeftLowerArm.R;
                FRAME.Technical_to_Anatomical.LeftLowerArm.O(:,u) = FRAME.Technical.LeftLowerArm.R(:,:,u)'*(FRAME.Anatomical.LeftLowerArm.O - FRAME.Technical.LeftLowerArm.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftLowerArm.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftLowerArm.R);
            REFFRAME.Technical_to_Anatomical.LeftLowerArm.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftLowerArm.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Lowerarm Segment in Static Reference']}];
        end
        
        % Left hand
        try
            [FRAME.Technical.LeftHand.O, FRAME.Technical.LeftHand.R] = get_technical_frame_GUI_app(MARKERS.Filt.hand_med_left.data, MARKERS.Filt.hand_lat_left.data, MARKERS.Filt.hand_top_left.data);
            [FRAME.Anatomical.LeftHand.O, FRAME.Anatomical.LeftHand.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'LeftHand_regular');
            for u = 1:size(FRAME.Technical.LeftHand.R, 3)
                FRAME.Technical_to_Anatomical.LeftHand.R(:,:,u) = FRAME.Technical.LeftHand.R(:,:,u)'*FRAME.Anatomical.LeftHand.R;
                FRAME.Technical_to_Anatomical.LeftHand.O(:,u) = FRAME.Technical.LeftHand.R(:,:,u)'*(FRAME.Anatomical.LeftHand.O - FRAME.Technical.LeftHand.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.LeftHand.R = Rmean_app(FRAME.Technical_to_Anatomical.LeftHand.R);
            REFFRAME.Technical_to_Anatomical.LeftHand.O = Vmean_app(FRAME.Technical_to_Anatomical.LeftHand.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Hand Segment in Static Reference']}];
        end
        
        % Trunk
        try
            [FRAME.Technical.Trunk.O, FRAME.Technical.Trunk.R] = get_technical_frame_GUI_app(MARKERS.Filt.clav.data, MARKERS.Filt.C_7.data, MARKERS.Filt.sternum.data);
            [FRAME.Anatomical.Trunk.O, FRAME.Anatomical.Trunk.R] = getanaframe_GUI_app(MARKERS.Filt, OPTIONS, 'Trunk_regular');
            for u = 1:size(FRAME.Technical.Trunk.R, 3)
                FRAME.Technical_to_Anatomical.Trunk.R(:,:,u) = FRAME.Technical.Trunk.R(:,:,u)'*FRAME.Anatomical.Trunk.R;
                FRAME.Technical_to_Anatomical.Trunk.O(:,u) = FRAME.Technical.Trunk.R(:,:,u)'*(FRAME.Anatomical.Trunk.O - FRAME.Technical.Trunk.O(:,u));
            end
            REFFRAME.Technical_to_Anatomical.Trunk.R = Rmean_app(FRAME.Technical_to_Anatomical.Trunk.R);
            REFFRAME.Technical_to_Anatomical.Trunk.O = Vmean_app(FRAME.Technical_to_Anatomical.Trunk.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk Segment in Static Reference']}];
        end
        
          REFFRAME.Anatomical = FRAME.Anatomical;

        %% Determining rotation matrices between adjacent coordinate systems
        try
            REFFRAME.Joint.Pelvis_to_Trunk = getR_app(FRAME.Anatomical.RightPelvis.R, FRAME.Anatomical.Trunk.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Pelvis to Trunk Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_Head = getR_app(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.Head.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Head Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_RightUpperArm = getR_app(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.RightUpperArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Right UpperArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_UpperArm_to_LowerArm = getR_app(FRAME.Anatomical.RightUpperArm.R, FRAME.Anatomical.RightLowerArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right UpperArm to LowerArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_LowerArm_to_Hand = getR_app(FRAME.Anatomical.RightLowerArm.R, FRAME.Anatomical.RightHand.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right LowerArm to Hand Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Trunk_to_LeftUpperArm = getR_app(FRAME.Anatomical.Trunk.R, FRAME.Anatomical.LeftUpperArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Trunk to Left UpperArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_UpperArm_to_LowerArm = getR_app(FRAME.Anatomical.LeftUpperArm.R, FRAME.Anatomical.LeftLowerArm.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left UpperArm to LowerArm Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_LowerArm_to_Hand = getR_app(FRAME.Anatomical.LeftLowerArm.R, FRAME.Anatomical.LeftHand.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left LowerArm to Hand Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Pelvis_to_Thigh = getR_app(FRAME.Anatomical.RightPelvis.R, FRAME.Anatomical.RightThigh.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Pelvis to Thigh Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Thigh_to_Shank = getR_app(FRAME.Anatomical.RightThigh.R, FRAME.Anatomical.RightShank.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Thigh to Shank Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Shank_to_Rearfoot = getR_app(FRAME.Anatomical.RightShank.R, FRAME.Anatomical.RightRearfoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Shank to Rearfoot Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Right_Rearfoot_to_Forefoot = getR_app(FRAME.Anatomical.RightRearfoot.R, FRAME.Anatomical.RightForefoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Rearfoot to Forefoot Rotation Matrix in Static Reference']}];
        end
        
        try
            REFFRAME.Joint.Left_Pelvis_to_Thigh = getR_app(FRAME.Anatomical.LeftPelvis.R, FRAME.Anatomical.LeftThigh.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Pelvis to Thigh Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Thigh_to_Shank = getR_app(FRAME.Anatomical.LeftThigh.R, FRAME.Anatomical.LeftShank.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Thigh to Shank Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Shank_to_Rearfoot = getR_app(FRAME.Anatomical.LeftShank.R, FRAME.Anatomical.LeftRearfoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Shank to Rearfoot Rotation Matrix in Static Reference']}];
        end
        try
            REFFRAME.Joint.Left_Rearfoot_to_Forefoot = getR_app(FRAME.Anatomical.LeftRearfoot.R, FRAME.Anatomical.LeftForefoot.R);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Rearfoot to Forefoot Rotation Matrix in Static Reference']}];
        end
        
        
        %% Describing joint centers in their respenctive segment coordinate systems
        try
            MARKERS.Derived.RightMPJCinForefoot = FRAME.Anatomical.RightFoot.R' * (FRAME.Anatomical.RightFoot.O - FRAME.Anatomical.RightFoot.O);
            MARKERS.Derived.RightAnkleJCinShank = FRAME.Anatomical.RightShank.R' * ((mean(MARKERS.Filt.mal_lat_right.data,2) + mean(MARKERS.Filt.mal_med_right.data,2))./2 - FRAME.Anatomical.RightShank.O);
            MARKERS.Derived.RightKneeJCinThigh = FRAME.Anatomical.RightThigh.R' * ((mean(MARKERS.Filt.epi_lat_right.data,2) + mean(MARKERS.Filt.epi_med_right.data,2))./2 - FRAME.Anatomical.RightThigh.O);
            MARKERS.Derived.RightHipJCinPelvis = FRAME.Anatomical.RightPelvis.R' * (mean(FRAME.Anatomical.RightPelvis.O,2) - FRAME.Anatomical.RightPelvis.O);
            MARKERS.Derived.RightHipJCinThigh = FRAME.Anatomical.RightThigh.R' * (mean(FRAME.Anatomical.RightPelvis.O,2) - FRAME.Anatomical.RightThigh.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Right Leg Joint Centers in Local Coordinate Systems']}];
        end
        try
            MARKERS.Derived.LeftMPJCinForefoot = FRAME.Anatomical.LeftFoot.R' * (FRAME.Anatomical.LeftFoot.O - FRAME.Anatomical.LeftFoot.O);
            MARKERS.Derived.LeftAnkleJCinShank = FRAME.Anatomical.LeftShank.R' * ((mean(MARKERS.Filt.mal_lat_left.data,2) + mean(MARKERS.Filt.mal_med_left.data,2))./2 - FRAME.Anatomical.LeftShank.O);
            MARKERS.Derived.LeftKneeJCinThigh = FRAME.Anatomical.LeftThigh.R' * ((mean(MARKERS.Filt.epi_lat_left.data,2) + mean(MARKERS.Filt.epi_med_left.data,2))./2 - FRAME.Anatomical.LeftThigh.O);
            MARKERS.Derived.LeftHipJCinPelvis = FRAME.Anatomical.LeftPelvis.R' * (mean(FRAME.Anatomical.LeftPelvis.O,2) - FRAME.Anatomical.LeftPelvis.O);
            MARKERS.Derived.LeftHipJCinThigh = FRAME.Anatomical.LeftThigh.R' * (mean(FRAME.Anatomical.LeftPelvis.O,2) - FRAME.Anatomical.LeftThigh.O);
        catch
            data.errorlog = [data.errorlog; {[ref_file, ' : Problems constructing Left Leg Joint Centers in Local Coordinate Systems']}];
        end
        
        
        
        
    end %get_refinfo_GUI