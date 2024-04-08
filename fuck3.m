clc
clear all
close all

import org.opensim.modeling.*
app.FoldertomonitorEditField.Value = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Calgary\Test2'
%  Load the model and initialize
model = Model([app.FoldertomonitorEditField.Value,'\scaled_matlab.osim']);
model.initSystem();
TRC_FILE = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Calgary\Test2\Participant_105_90degreecut06.trc'
MOT_FILE = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Calgary\Test2\Participant_105_90degreecut06.mot';

%% clean up force file removes nan
% A = load_mot(MOT_FILE);
% A(isnan(A))=0;
% % desitination = [ app.FoldertomonitorEditField.Value,'/_force' ,'.mot'];
% writeMot(A(:,[2:end]),A(:,1),MOT_FILE)
a = 2;
%TRC work around
% Create name of trial from .trc file name
trialname = erase(erase(MOT_FILE, [app.FoldertomonitorEditField.Value,'/']), '.mot');
markerPath =TRC_FILE;
% Get trc data to determine time range
markerData = MarkerData(markerPath);
% Get initial and final time to compute
initial_time = markerData.getStartFrameTime();    % simply get from the loaded trc file the start frame/ time
final_time = markerData.getLastFrameTime();       %simply get from the loaded trc file the end frame/ time

% Create path and Name for Coordinate File (IK File)
fullpathIKFile ='C:\Users\adpatrick\OneDrive - nih.no\Desktop\Calgary\Test2\IK_RESULTS_Participant_105_90degreecut06.mot';




idTool = InverseDynamicsTool([cd, '/', 'ID_Setup.xml']); %xxxx
idTool.setName(['ID_' trialname]); %xxxx
idTool.setModel(model); %xxxx
grfFile = MOT_FILE; %xxxx


external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup_Calgary.xml'],1); %xxxx
external_loads.setDataFileName(grfFile); %xxxx

external_loads.setName(['Name']); %xxxx

% external_loads.setExternalLoadsModelKinematicsFileName(fullpathIKFile) %xxxx
% fullpathGRFFile = MOT_FILE;

% Set the grf filename
% external_loads.setDataFileName(fullpathGRFFile);
%     externalforce =ExternalForce ()
%     externalforce.set_data_source_name(fullpathGRFFile)
%     external_loads.adoptAndAppend(externalforce)

extLoadsName = ['TEST_Setup_force.xml'];


%

lowpassfilter= 6; %xxxx
% Set Filter for Kinematics
idTool.setLowpassCutoffFrequency(lowpassfilter) %xxxx



%     externalforce =ExternalForce ();
%external_force.getDataSourceName()
%     externalforce.set_data_source_name(fullpathGRFFile);
% Print GRF setup file
external_loads.print([app.FoldertomonitorEditField.Value '\' extLoadsName]);

%Set name of ID Trial
idTool.setName('A');

idTool.setModelFileName([app.FoldertomonitorEditField.Value,'\scaled_matlab.osim']);
%Set file containing IK data
idTool.setCoordinatesFileName(fullpathIKFile);

%Set start and end time
idTool.setStartTime(initial_time);
idTool.setEndTime(final_time);

%Set output file and folder
idTool.setOutputGenForceFileName([ app.FoldertomonitorEditField.Value, '/ID_RESULTS_', '.sto' ]);
idTool.setResultsDir([ app.FoldertomonitorEditField.Value, '/']);

% Set file containing External Loads information
idTool.setExternalLoadsFileName([app.FoldertomonitorEditField.Value,  '\' ,extLoadsName]);

%%
idTool.setLowpassCutoffFrequency(lowpassfilter);
% Save the settings in a setup file
outfileID = [ 'setup_ID_'  '.xml' ];
idTool.print([app.FoldertomonitorEditField.Value, '\' outfileID]);
idTool.run();