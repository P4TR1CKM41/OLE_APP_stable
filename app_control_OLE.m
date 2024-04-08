function  app_control_OLE(app)
%core functionality
clc
close all
app.Label.Text = '';
app.Label_2.Text = '';
%% some global variables drwan from the app and predefined
[DATA.OPTIONS] = get_set_up_files(app.SetupDropDown.Value ,cd);
DATA.OPTIONS.GEOMETRYPATH = 'C:\OpenSim 4.4\Geometry';
DATA.OPTIONS.FilterOrder = 4;
DATA.OPTIONS.CutOffMarkers = 20;
DATA.OPTIONS.Age = app.AgeyearsEditField.Value;
DATA.OPTIONS.CutOffGRF = 20;
DATA.OPTIONS.ForceTreshold= app.NEditField.Value;
DATA.OPTIONS.FILEFORMAT = app.File2scanDropDown.Value;
DATA.OPTIONS.mass = app.MassKgEditField.Value;
DATA.OPTIONS.Height= app.HeightcmEditField.Value/100;
DATA.OPTIONS.ANTRO.mass = DATA.OPTIONS.mass ;
DATA.OPTIONS.ANTRO.height = DATA.OPTIONS.Height;
DATA.OPTIONS.INFO.PreviousACL = app.ACLInjuryYearEditField.Value;
DATA.OPTIONS.INFO.InterventionGroup =app.InterventionEditField.Value;
DATA.OPTIONS.INFO.Division =app.DivisionEditField.Value;
DATA.OPTIONS.INFO.Position =app.PositionEditField.Value;
DATA.OPTIONS.INFO.DominantLeg =app.DominantLegEditField.Value;
DATA.OPTIONS.INFO.Throwingarm = app.ThrowingarmKickingLegEditField.Value;
DATA.OPTIONS.INFO.StrengthTMin = app.StrengthminEditField.Value;
DATA.OPTIONS.INFO.HandballTMin = app.HandballminEditField.Value;
DATA.OPTIONS.INFO.GamesMin =app.ActiveGameminEditField.Value;
DATA.OPTIONS.INFO.Sport = app.SportDropDown.Value;
DATA.OPTIONS.REF_ID =  app.RefidentifierEditField.Value;
DATA.OPTIONS.Ref_Identifier = DATA.OPTIONS.REF_ID;

%% load a excel sheet with marker set definitions allows to compute and add virtual markers to the c3d and thereby enhancing scaling
DATA.OPTIONS.SETTINGS = app.SetupDropDown.Value;
[~, ~, DATA.OPTIONS.MARKER_SETUP.HIP] = xlsread('Marker_for_segments_v3.xlsx','HIP');
[~, ~, DATA.OPTIONS.MARKER_SETUP.KNEE] = xlsread('Marker_for_segments_v3.xlsx','KNEE');
[~, ~, DATA.OPTIONS.MARKER_SETUP.ANKLE] = xlsread('Marker_for_segments_v3.xlsx','ANKLE');
[~, ~, DATA.OPTIONS.MARKER_SETUP.FOOT] = xlsread('Marker_for_segments_v3.xlsx','FOOT');
[~, ~, DATA.OPTIONS.MARKER_SETUP.MTP] = xlsread('Marker_for_segments_v3.xlsx','MTP');
[~, ~, DATA.OPTIONS.MARKER_SETUP.DISTAL] = xlsread('Marker_for_segments_v3.xlsx','DISTAL_Marker');
go_out=0;
%% search all the time for a static until it was found
while strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==1)
    fileList = dir(fullfile(app.storageglobal_path, ['*', app.File2scanDropDown.Value]));
    fileList_cells = {fileList.name};
    for st = 1 : length (fileList_cells)
        staticfound =  strfind((fileList_cells{1, st}), app.RefidentifierEditField.Value);
        if staticfound >= 1 % if static found
            app.Label.Text = 'Found static';
            app.Label.FontColor = [0 0.5 0];
            pause(0.0001) % pause needed to update the GUI
            path_to_static = [app.storageglobal_path, '/', (fileList_cells{1, st})];
            if strcmp(app.File2scanDropDown.Value, '.c3d') ==1 % found a file that mached the ref identifier
                %% c3d file to trc static
                index_in_marker_set_file_excel = find(contains((DATA.OPTIONS.MARKER_SETUP.HIP(:,1)),DATA.OPTIONS.SETTINGS)==1);
                DATA.REF_MARKERS=static_c3d_to_trc_Motrack(path_to_static, DATA.OPTIONS);
                [DATA.OPTIONS.ANTRO.mass] = get_bodymaxx_from_c3d(path_to_static);
                app.MassKgEditField.Value = round(DATA.OPTIONS.ANTRO.mass,1);
                app.MassKgEditField.FontColor = [0,1,0];
                %% Start the scaling in opensim
                trc_file = split (path_to_static, '/'); % improve
                trc_file = replace (trc_file{end, 1}, '.c3d', '.trc'); % improve
                [DATA.OPTIONS.PATH.SCALED_MODEL, DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static]=scaling_OLE_app(replace (path_to_static, '.c3d', '.trc'),  app.IDEditField.Value, app.FoldertomonitorEditField.Value, trc_file,DATA.OPTIONS.PATH.GENERIC_MODEL, DATA.OPTIONS.GENERIC.markersetname, DATA.OPTIONS.GENERIC.scalesetupname, DATA.OPTIONS);
                %% this function will call the scaled opensim model and ajust the joint angles according to the IK of the static file
                ajust_scaled_model_joint_angles(DATA.OPTIONS.PATH.SCALED_MODEL, DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static)
                %opensimvisualizer(DATA.OPTIONS.PATH.SCALED_MODEL,[app.storageglobal_path, '/','static_output.mot'], DATA.OPTIONS.GEOMETRYPATH )
                go_out =1; % exit searching for static improve when multiple statics?
            else
            end
            pause(2)
            % % % % if length(ExistentMarkers)~=80;
            % % % %     app.Label.Text = 'Static found BUT';
            % % % %     app.Label.FontColor = [1 0.5 0];
            % % % %     pause(0.000001)
            % % % %     go_out = 1;
            % % % %     fstatic = msgbox(["Static processed but ", num2str(length(ExistentMarkers)) ,"from 80 Markers where found. Static is still used but problems in dynamic files may come up!"],"Error","error");
            % % % % else
            % % % %     go_out = 1;
            % % % % end
        else
        end
    end
    app.Label.Text = 'Looking for static file';
    app.Label.FontColor = [1 0 0];
    pause(0.00001)
    if go_out ==1 || strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==0)
        app.Label.Text = 'Found static';
        app.Label.FontColor = [0 0.5 0];
        pause(0.000001)
        break;
    end
end

%% now start amother loop for the dynamic calculation
%processed= {}; % will contain all the processed files, appended after each loop to avoid detecting already existed files
up = 1; % counts incrementel when a file has processed
while strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==1)
    fileList = dir(fullfile(app.storageglobal_path, ['*', app.File2scanDropDown.Value]));
    Index_Static = find(contains({fileList.name}, app.RefidentifierEditField.Value));
    fileList(Index_Static) = []; % remove the static c3d file from the list, will not be recognized
    fileList_cells = {fileList.name};
    % processed_pos = find (contains( {fileList.name}, processed));
    % fileList(processed_pos) = [];
    fileList_cells = {fileList.name};
    dy = 1;
    if ~isempty(fileList_cells)
        close all
        pause(2)
        tic
        trialname = matlab.lang.makeValidName(erase((fileList_cells{1, dy}),  app.File2scanDropDown.Value));
        choice = questdlg(['Do you want to process ',(fileList_cells{1, dy}),'?'], ...
            'Confirmation', ...
            'Yes', 'No', 'modal');
        if strcmp(choice, 'Yes')
            DATA.OPTIONS.ForcePlateNumber.(trialname) = str2double(app.FPuseDropDown.Value);
            DATA.OPTIONS.LEG_ANALYZED.(trialname) =app.Leg2AnalyzeDropDown.Value;
            path_to_dyn = [app.storageglobal_path, '/', (fileList_cells{1, dy})];
            app.Label_2.Text = [fileList_cells{1, dy}];
            app.Label_2.FontColor = [0 0.5 0];
            pause(0.0000000000001)
            %% Cut, fill, create trc and mot
            try
                [DATA.OPTIONS.ftkratio, DATA.OPTIONS.PATHS.TRC.(trialname), DATA.OPTIONS.PATHS.MOT.(trialname), DATA.CONTACT_ANALOG.(trialname), DATA.CONTACT_KINEMATIC.(trialname), DATA.MARKERS.(trialname), DATA.GRF.(trialname), DATA.OPTIONS.FREQ_KINEMATIC, DATA.OPTIONS.FREQ_ANALOG, DATA.OPTIONS.FP_CORNERS.(trialname), markers_from_c3d, DATA.markers_from_c3d_filt.(trialname)] = dynamic_c3d_to_try(path_to_dyn, app.CutfilesCheckBox.Value, DATA.OPTIONS.ForcePlateNumber.(trialname), app.NEditField.Value);
            catch
                DATA.OPTIONS.FOOT_IN_FP.(trialname) =0;
                DATA.OPTIONS.ERROR_REASON.(trialname) = 'convert';
                %% remove previously written field from struct because of the error
                DATA.OPTIONS.LEG_ANALYZED = rmfield( DATA.OPTIONS.LEG_ANALYZED, (trialname));
                DATA.OPTIONS.ForcePlateNumber = rmfield( DATA.OPTIONS.ForcePlateNumber, (trialname));
                errordlg (['Error when converting ', fileList_cells{1, dy} ,'Check Markers and Forces. Enure that the correct force plate was selected!'])
            end
            %% Check if foot is on FP
            try
                [DATA.OPTIONS.FOOT_IN_FP.(trialname)] = is_foot_on_force_plate_fun(DATA.OPTIONS.MARKER_SETUP, DATA.OPTIONS.SETTINGS, DATA.OPTIONS.FP_CORNERS.(trialname), DATA.CONTACT_KINEMATIC.(trialname)(1),DATA.CONTACT_ANALOG.(trialname)(1), markers_from_c3d,DATA.OPTIONS.LEG_ANALYZED.(trialname) );
            catch ME
                %% remove previously written field from struct because of the error
                DATA.OPTIONS.LEG_ANALYZED = rmfield( DATA.OPTIONS.LEG_ANALYZED, (trialname));
                DATA.OPTIONS.ForcePlateNumber = rmfield( DATA.OPTIONS.ForcePlateNumber, (trialname));
                DATA.OPTIONS.FOOT_IN_FP.(trialname) =0;
                DATA.OPTIONS.ERROR_REASON.(trialname) = 'foot_on_force_plate';
                errordlg (ME.message);
            end
            if DATA.OPTIONS.FOOT_IN_FP.(trialname)==1
                %% IK
                [DATA.OPTIONS.PATHS.IK.(trialname)]=IK_app(DATA.OPTIONS.PATHS.TRC.(trialname),app.FoldertomonitorEditField.Value);
                %% ID
                [DATA.OPTIONS.PATHS.ID.(trialname)] = ID_app(DATA.OPTIONS.PATHS.MOT.(trialname),DATA.OPTIONS.PATHS.TRC.(trialname),app.FoldertomonitorEditField.Value, DATA.OPTIONS.PATHS.IK.(trialname), DATA.OPTIONS.LEG_ANALYZED.(trialname), DATA.OPTIONS.ForcePlateNumber.(trialname) );
                %% Body kinematics
                [DATA.OPTIONS.PATHS.BK_ACC.(trialname), DATA.OPTIONS.PATHS.BK_VEL.(trialname),DATA.OPTIONS.PATHS.BK_POS.(trialname)] = on_Bodykinematics(DATA.OPTIONS.PATHS.IK.(trialname),DATA.OPTIONS.PATH.SCALED_MODEL, app.FoldertomonitorEditField.Value, app.IDEditField.Value, trialname);
                %% TODO make automatic choose the correct marker index_in_marker_set_file_excel
                if  strcmp(lower(app.Leg2AnalyzeDropDown.Value(1)), 'l') ==1
                    multi = -1;
                    DATA.OPTIONS.LEG.(trialname) ='L';
                    % toe= DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,13};
                    % ferse = DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,8};
                    marker1=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,11};
                    marker2=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,12};
                    marker3=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,8};
                    %marker4=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,9};
                    % toe= 'toe_left';
                    % ferse = 'LMC';
                    % marker1='L1MTP';
                    % marker2='L5MTP';
                    % marker3='LMC';
                    % marker4='LMEDC';
                    subtraction = 180;
                    multi2= 1;
                else
                    multi =1;
                    DATA.OPTIONS.LEG.(trialname) ='R';
                    % toe= DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,7};
                    % ferse =  DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,2};
                    marker1=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,5};
                    marker2=DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,6};
                    marker3= DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,2};
                    %marker4= DATA.OPTIONS.MARKER_SETUP.FOOT{index_in_marker_set_file_excel,3};
                    % DATA.MIDPOINT_MTP.(trialname) = [((DATA.markers_from_c3d_filt.(trialname).R5MTP(:,1) +DATA.markers_from_c3d_filt.(trialname).R1MTP(:,1)))/2,((DATA.markers_from_c3d_filt.(trialname).R5MTP(:,2) +DATA.markers_from_c3d_filt.(trialname).R1MTP(:,2)))/2,((DATA.markers_from_c3d_filt.(trialname).R5MTP(:,3) +DATA.markers_from_c3d_filt.(trialname).R1MTP(:,3)))/2 ];
                    % DATA.MIDPOINT_MTP_REF_MARKERS = [((DATA.REF_MARKERS.R5MTP(:,1) +DATA.REF_MARKERS.R1MTP(:,1)))/2,((DATA.REF_MARKERS.R5MTP(:,2) +DATA.REF_MARKERS.R1MTP(:,2)))/2,((DATA.REF_MARKERS.R5MTP(:,3) +DATA.REF_MARKERS.R1MTP(:,3)))/2 ];
                    subtraction = 0;
                    multi2= -1;
                end
                DATA.OPTIONS.TASK_NAME.(trialname) =  app.TaskselectionButtonGroup.SelectedObject.Text;
                DATA.OPTIONS.TASK_ID_NUMERIC.(trialname)  = find(cellfun(@(x) strcmp(x, app.TaskselectionButtonGroup.SelectedObject.Text), {app.TaskselectionButtonGroup.Buttons(:).Text}));

                DATA.MIDPOINT_MTP.(trialname) = [((DATA.markers_from_c3d_filt.(trialname).(marker2)(:,1) +DATA.markers_from_c3d_filt.(trialname).(marker1)(:,1)))/2,((DATA.markers_from_c3d_filt.(trialname).(marker2)(:,2) +DATA.markers_from_c3d_filt.(trialname).(marker1)(:,2)))/2,((DATA.markers_from_c3d_filt.(trialname).(marker2)(:,3) +DATA.markers_from_c3d_filt.(trialname).(marker1)(:,3)))/2 ];
                DATA.MIDPOINT_MTP_REF_MARKERS = [((DATA.REF_MARKERS.(marker2)(:,1) +DATA.REF_MARKERS.(marker1)(:,1)))/2,((DATA.REF_MARKERS.(marker2)(:,2) +DATA.REF_MARKERS.(marker1)(:,2)))/2,((DATA.REF_MARKERS.(marker2)(:,3) +DATA.REF_MARKERS.(marker1)(:,3)))/2 ];
                %% get the results in matlab structures
                [~,~,DATA.ANGLES_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.IK.(trialname)(1:find((DATA.OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.IK.(trialname)(find((DATA.OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.MOMENT_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.ID.(trialname)(1:find((DATA.OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.ID.(trialname)(find((DATA.OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.GRF_TABLE.(trialname)] =     readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.MOT.(trialname)(1:find((DATA.OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.MOT.(trialname)(find((DATA.OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.BK_ACC_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_ACC.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_ACC.(trialname)(find((DATA.OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.BK_VEL_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_VEL.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_VEL.(trialname)(find((DATA.OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.BK_POS_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_POS.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_POS.(trialname)(find((DATA.OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last')+1:end)));
                %% refilter the IK results to match with the ID
                [DATA.ANGLES_TABLE_FILT.(trialname)] = filter_IK(DATA.ANGLES_TABLE.(trialname), 20);

                ARRAY = DATA.BK_VEL_TABLE.(trialname);
                for op = 1 : length(ARRAY.Properties.VariableNames)
                    DATA.PARAMETERS.(['IC_BKVEL_',ARRAY.Properties.VariableNames{op} ])(1,up)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
                end
                ARRAY = DATA.BK_POS_TABLE.(trialname);
                for op = 1 : length(ARRAY.Properties.VariableNames)
                    DATA.PARAMETERS.(['IC_BKPOS_',ARRAY.Properties.VariableNames{op} ])(1,up)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
                end
                ARRAY = DATA.GRF_TABLE.(trialname);
                for op = 1 : length(ARRAY.Properties.VariableNames)
                    DATA.PARAMETERS.(['IC_GRF_',ARRAY.Properties.VariableNames{op} ])(1,up)  = table2array(ARRAY(DATA.CONTACT_ANALOG.(trialname)(1),ARRAY.Properties.VariableNames{op}));
                end
                clearvars ARRAY

                %% save some additional trial based information
                DATA.OPTIONS.FEEDBACK_GIVEN.(trialname) = app.InstructionsgivenCheckBox.Value;
                DATA.OPTIONS.FEEDBACK_TYPE.(trialname) = app.ButtonGroup_2.SelectedObject.Text;
                DATA.OPTIONS.FEEDBACK_TYPE_NUMERIC.(trialname) = app.ButtonGroup_2.SelectedObject.Value;

                %% improve timeseries data and visualization
                DATA.OPTIONS.Instruction.(trialname)=app.InstructionsgivenCheckBox.Value;
                DATA.OPTIONS.ANALYZEDLEG.(trialname) =   DATA.OPTIONS.LEG_ANALYZED.(trialname)(1);
                DATA.OPTIONS.ANALYZEDLEG_BIN.(trialname)=strcmp( DATA.OPTIONS.ANALYZEDLEG.(trialname), 'R');
                DATA.NORMAL.HEADER{1,up} = trialname;
                DATA.NORMAL.KAM(:,up) = normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_adduction_',lower(DATA.OPTIONS.LEG.(trialname)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5);
                DATA.NORMAL.KNEE_FLEX_MOMENT(:,up) = normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_angle_',lower(DATA.OPTIONS.LEG.(trialname)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5);
                DATA.NORMAL.KNEE_ROT_MOMENT(:,up) = normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_rotation_',lower(DATA.OPTIONS.LEG.(trialname)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5);
                DATA.PARAMETERS.VELOCITY(:,up) = [norm([DATA.PARAMETERS.IC_BKVEL_center_of_mass_X(:,up), DATA.PARAMETERS.IC_BKVEL_center_of_mass_Z(:,up)])];
                DATA.NORMAL.VELOCITY(:,up) = normalize_vector(vecnorm([DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))],2,2),0.5)';
                [DATA.PARAMETERS.PEAK_KNEE_X(1,up),DATA.PARAMETERS.PEAK_KNEE_X_FRAME_NORMAL(1,up)] = max( DATA.NORMAL.KAM(:,up));
                %% Valgus Angle at IC
                DATA.PARAMETERS.KNEE_VALGUS_AT_IC(1,up) = DATA.ANGLES_TABLE_FILT.(trialname).(['knee_adduction_',lower( DATA.OPTIONS.LEG.(trialname))])(DATA.CONTACT_KINEMATIC.(trialname)(1));
                %% Contact Time
                DATA.PARAMETERS.CONTACT_TIME(1,up) = length(DATA.CONTACT_KINEMATIC.(trialname))*(1/DATA.OPTIONS.FREQ_KINEMATIC);
                %% Cutting Angle
                DATA.PARAMETERS.CuttingAngle(1,up)  = acosd (dot([DATA.BK_VEL_TABLE.(trialname).center_of_mass_X( DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))], [DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(end)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(end))]) / ((norm([DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))])*norm([DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(end)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(end))]))));
                %% Trunk lean
                [a1,b1,c1,d1] = get_plane_equation_from_four_markers(DATA.markers_from_c3d_filt.(trialname).C7(DATA.CONTACT_KINEMATIC.(trialname)(1),:), DATA.markers_from_c3d_filt.(trialname).STERNUM(DATA.CONTACT_KINEMATIC.(trialname)(1),:), DATA.markers_from_c3d_filt.(trialname).T6(DATA.CONTACT_KINEMATIC.(trialname)(1),:),DATA.markers_from_c3d_filt.(trialname).XYPHOID(DATA.CONTACT_KINEMATIC.(trialname)(1),:));
                [a2,b2,c2,d2] = get_plane_equation_from_four_markers(DATA.OPTIONS.FP_CORNERS.(trialname)(:,1)',DATA.OPTIONS.FP_CORNERS.(trialname)(:,2)',DATA.OPTIONS.FP_CORNERS.(trialname)(:,3)',DATA.OPTIONS.FP_CORNERS.(trialname)(:,4)');
                [DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up)] = get_angle_between_two_planes([a1,b1,c1,d1],[a2,b2,c2,d2]);
                DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up) = 90-DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up)*multi;
                DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up) = DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up)-subtraction;
                %DATA.PARAMETERS.TRUNK_LEAN_AT_IC(1,up) =90-DATA.BK_POS_TABLE.(trialname).torso_Oz(DATA.CONTACT_KINEMATIC.(trialname)(1))*multi
                %% Leverarm and res GRF
                YY = vecnorm([DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_vx']), DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_vy']), DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_vz'])],2,2);
                DATA.NORMAL.RESGRF(:,up) =normalize_vector( YY(DATA.CONTACT_ANALOG.(trialname)(1):DATA.CONTACT_ANALOG.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_ANALOG)), 0.5);
                clearvars YY
                DATA.PARAMETERS.MOMENTARMatPeakKAM(1,up) = ((DATA.PARAMETERS.PEAK_KNEE_X(1,up)*DATA.OPTIONS.ANTRO.mass)/ DATA.NORMAL.RESGRF(DATA.PARAMETERS.PEAK_KNEE_X_FRAME_NORMAL(1,up),up))*100;
                DATA.NORMAL.LEVERARM(:,up) =((DATA.NORMAL.KAM(:,up)*DATA.OPTIONS.ANTRO.mass)./DATA.NORMAL.RESGRF(:,up))*100;
                DATA.PARAMETERS.RESGRFatPeakKAM(1,up) =DATA.NORMAL.RESGRF(DATA.PARAMETERS.PEAK_KNEE_X_FRAME_NORMAL(1,up),up)/DATA.OPTIONS.ANTRO.mass;
                DATA.NORMAL.RESGRF(:,up) = DATA.NORMAL.RESGRF(:,up)/DATA.OPTIONS.ANTRO.mass;
                DATA.NORMAL.KNEE_FLEXION_ANGLE(:,up) =normalize_vector((DATA.ANGLES_TABLE_FILT.(trialname).(DATA.ANGLES_TABLE_FILT.(trialname).Properties.VariableNames{string(DATA.ANGLES_TABLE_FILT.(trialname).Properties.VariableNames) == ['knee_angle_',lower(DATA.OPTIONS.LEG.(trialname))]})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))), 0.5);
                DATA.NORMAL.KNEE_ROTATION_ANGLE(:,up) =normalize_vector((DATA.ANGLES_TABLE_FILT.(trialname).(DATA.ANGLES_TABLE_FILT.(trialname).Properties.VariableNames{string(DATA.ANGLES_TABLE_FILT.(trialname).Properties.VariableNames) == ['knee_rotation_',lower(DATA.OPTIONS.LEG.(trialname))]})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))), 0.5);
                DATA.PARAMETERS.KNEE_FLEX_AT_IC(1,up) = DATA.NORMAL.KNEE_FLEXION_ANGLE(1,up);
                DATA.PARAMETERS.KNEE_ROTATION_AT_IC(1,up) = DATA.NORMAL.KNEE_ROTATION_ANGLE(1,up);

                %% Foot strike Angle
                [DATA.PARAMETERS.FOOT_STRIKE_PATTERN(1,up)] = kevin_foot_strike_pattern( DATA.MIDPOINT_MTP.(trialname)(DATA.CONTACT_KINEMATIC.(trialname)(1),:), DATA.markers_from_c3d_filt.(trialname).(marker3)(DATA.CONTACT_KINEMATIC.(trialname)(1),:));
                [foot_angle_neutral] = kevin_foot_strike_pattern( DATA.MIDPOINT_MTP_REF_MARKERS, DATA.REF_MARKERS.(marker3));
                DATA.PARAMETERS.FOOT_STRIKE_PATTERN(1,up) = DATA.PARAMETERS.FOOT_STRIKE_PATTERN(1,up)-foot_angle_neutral;
                %% FOOT PROGRESSION ANGLE
                %com_vel_at_TD =  [DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)), DATA.BK_VEL_TABLE.(trialname).center_of_mass_Y(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))];
                [ DATA.PARAMETERS.FOOT_PROGRESSION_ANGLE(1,up)] = foot_progression_angle_fun_new(DATA.markers_from_c3d_filt.(trialname).(marker3)(DATA.CONTACT_KINEMATIC.(trialname)(1),:),DATA.MIDPOINT_MTP.(trialname)(DATA.CONTACT_KINEMATIC.(trialname)(1),:), [DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)), DATA.BK_VEL_TABLE.(trialname).center_of_mass_Y(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))],0);
                DATA.PARAMETERS.FOOT_PROGRESSION_ANGLE(1,up) =  DATA.PARAMETERS.FOOT_PROGRESSION_ANGLE(1,up)*multi2;
                %% Trunk Rotation
                [ DATA.PARAMETERS.TRUNK_ROTATION_AT_IC(1,up)] = torso_progression_angle_fun_new(DATA.markers_from_c3d_filt.(trialname).T6(DATA.CONTACT_KINEMATIC.(trialname)(1),:),DATA.markers_from_c3d_filt.(trialname).XYPHOID(DATA.CONTACT_KINEMATIC.(trialname)(1),:), [DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)), DATA.BK_VEL_TABLE.(trialname).center_of_mass_Y(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))],0);
                DATA.PARAMETERS.TRUNK_ROTATION_AT_IC(1,up) = DATA.PARAMETERS.TRUNK_ROTATION_AT_IC(1,up)*multi2;
                %% Cut Width TODO
                %[DATA.PARAMETERS.CUT_WIDTH(1,up)] = cut_width_fun( [DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_px'])(DATA.CONTACT_ANALOG.(trialname)(1)),DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_py'])(DATA.CONTACT_ANALOG.(trialname)(1)),DATA.GRF_TABLE.(trialname).(['ground_force_',num2str(DATA.OPTIONS.ForcePlateNumber.(trialname)),'_pz'])(DATA.CONTACT_ANALOG.(trialname)(1))],[DATA.BK_POS_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)), DATA.BK_POS_TABLE.(trialname).center_of_mass_Y(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_POS_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))],[DATA.BK_VEL_TABLE.(trialname).center_of_mass_X(DATA.CONTACT_KINEMATIC.(trialname)(1)), DATA.BK_VEL_TABLE.(trialname).center_of_mass_Y(DATA.CONTACT_KINEMATIC.(trialname)(1)),DATA.BK_VEL_TABLE.(trialname).center_of_mass_Z(DATA.CONTACT_KINEMATIC.(trialname)(1))]);
                %% check for speed
                if strcmp(app.SpeedCheckerDropDown.Value , 'Yes' ) ==1 & app.InstructionsgivenCheckBox.Value==1
                    DATA.OPTIONS.WAS_VALID.(trialname)  =1; % assume it will be valid before overwriting the variable
                    [is_valid] = speed_cheker_fun(DATA.PARAMETERS.VELOCITY, DATA.OPTIONS,find(cellfun(@(x) strcmp(x, app.TaskselectionButtonGroup.SelectedObject.Text), {app.TaskselectionButtonGroup.Buttons(:).Text})),DATA.NORMAL.HEADER,DATA.OPTIONS.ANALYZEDLEG_BIN.(trialname),up );
                    if is_valid==1
                        DATA.OPTIONS.WAS_VALID.(trialname)  =1;
                        DATA.OPTIONS.ERROR_REASON.(trialname) = 'none';
                    else
                        DATA.OPTIONS.WAS_VALID.(trialname)  =0;
                        DATA.OPTIONS.ERROR_REASON.(trialname) = 'Speed';
                        msgbox("The approach velocity was slower than without feedback! Try run-in faster!","Speed Checker","error");
                    end
                else
                    DATA.OPTIONS.ERROR_REASON.(trialname) = 'none';
                    DATA.OPTIONS.WAS_VALID.(trialname)  =1;
                end
                
                %% save the results in mat structure
                save([app.FoldertomonitorEditField.Value,'/' ,app.IDEditField.Value,'.mat'], '-struct', 'DATA');
                up = up+1;
                %% push files to a folder "Processed"
                mkdir ([app.storageglobal_path, '/', 'Processed'])
                copyfile([app.storageglobal_path, '/',(fileList_cells{1, dy})], [app.storageglobal_path, '/', 'Processed']);
                pause(0.01)
                delete ([app.storageglobal_path, '/',(fileList_cells{1, dy})]);
                if isAppRunning('Dashboard')
                    delete(findall(0, 'Type', 'figure', 'Name', 'Dashboard'));
                    app.Menu_2.Text ='Dashboard app closed successfully.';
                else
                    app.Menu_2.Text ='Dashboard app is not running.';
                end
                Dashboard([app.FoldertomonitorEditField.Value,'/' ,app.IDEditField.Value,'.mat'])
                pause(0.001)
            else
                mkdir ([app.storageglobal_path, '/', 'Invalid'])
                msgbox(['File moved to: ',app.storageglobal_path, '/', 'Invalid', '/',(fileList_cells{1, dy})], 'Invalid file moved', 'modal');
                copyfile([app.storageglobal_path, '/',(fileList_cells{1, dy})], [app.storageglobal_path, '/', 'Invalid']);
                delete ([app.storageglobal_path, '/',(fileList_cells{1, dy})]);
            end
        else % user has decided to not process the file
            mkdir ([app.storageglobal_path, '/', 'Invalid'])
            msgbox(['File moved to: ',app.storageglobal_path, '/', 'Invalid', '/',(fileList_cells{1, dy})], 'Invalid file moved', 'modal');
            copyfile([app.storageglobal_path, '/',(fileList_cells{1, dy})], [app.storageglobal_path, '/', 'Invalid']);
            delete ([app.storageglobal_path, '/',(fileList_cells{1, dy})]);
        end
        %opensimvisualizer_dynamic(DATA.OPTIONS.PATH.SCALED_MODEL,DATA.OPTIONS.PATHS.IK.(trialname),DATA.OPTIONS.GEOMETRYPATH)
        % try
            %processed(end+1) = fileList_cells(1, dy);
            app.Label_2.Text = [fileList_cells{1, dy}];
            app.Label_2.FontColor = [0 0.5 0];
            pause(0.0000000000001)
            endtime =  toc;
            app.Label_3.Text = [num2str(round(endtime,1)), 's'];
        % catch ME
        %     %delete(path_to_dyn)
        %     myicon = imread("error_alf.jpg");
        %     zelle{1,1} = 'Could not process:';
        %     zelle{2,1} = path_to_dyn;
        %     zelle{3,1} = 'Check in QTM the file for:';
        %     zelle{4,1} = '1. Missing Markers';
        %     zelle{5,1} = '2. Missing forces';
        %     zelle{6,1} = '3. ...';
        %     f = msgbox(zelle,"Error","custom", myicon);
        %     set(f,'color','w');
        %     %processed(end)=[];
        % end
    else
        pause(0.0000000000001)
        if app.InstructionsgivenCheckBox.Value==0
            app.ToeLandingButton.Enable ='off';
            app.LateralPressButton.Enable = 'off';
            app.CoMVelocityButton.Enable = 'off';
            app.FeedbackTextYes.Enable = 'off';
            app.ToeLandingButton.Value = false;
        elseif app.InstructionsgivenCheckBox.Value==1
            app.ToeLandingButton.Enable ='on';
            app.LateralPressButton.Enable = 'on';
            app.CoMVelocityButton.Enable = 'on';
            app.FeedbackTextYes.Enable = 'on';
            pause(0.0000000000001)
            if  app.FeedbackTextYes.Value == true
                app.FeedbackTextInput.Enable = 'on';
            else
                app.FeedbackTextInput.Enable = 'off';
            end
        end
        app.Label_2.Text = 'Searching for dynamic';
        pause(0.000001)
    end
    %end
    stop_dyn_loop = strcmp (app.ButtonGroup.SelectedObject.Text, 'Start') && (app.ButtonGroup.SelectedObject.Value ==0);
    pause(0.000001)
    if stop_dyn_loop ==1
        break;
    end
end