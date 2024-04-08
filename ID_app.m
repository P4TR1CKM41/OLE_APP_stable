function [ID_RESULTS_PATH]=ID_app(MOT_FILE,TRC_FILE, path, IK_results_path, leg, FP_used)
tic
import org.opensim.modeling.*

%  Load the model and initialize
model = Model([path,'\scaled_matlab.osim']);
model.initSystem();

%TRC work around
% Create name of trial from .trc file name
trialname = erase(erase(MOT_FILE, [path,'/']), '.mot');
markerPath =TRC_FILE;
% Get trc data to determine time range
markerData = MarkerData(markerPath);
% Get initial and final time to compute
initial_time = markerData.getStartFrameTime();    % simply get from the loaded trc file the start frame/ time
final_time = markerData.getLastFrameTime();       %simply get from the loaded trc file the end frame/ time

% Create path and Name for Coordinate File (IK File)
fullpathIKFile =IK_results_path;


idTool = InverseDynamicsTool([cd, '/', 'ID_Setup.xml']);


idTool.setName(['ID_' trialname]); % set name for the ID tool

% Tell Tool to use the loaded model
idTool.setModel(model); % set the model to the ID object
% Get the name of the file for this trial
grfFile = MOT_FILE;

% create and prepare external forces xml file

if strcmp(leg, 'Right') && FP_used==1
    external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup_FP1_Right.xml'],1); %this is the stupid fore file
elseif strcmp(leg, 'Right') && FP_used==2
    external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup_FP2_Right.xml'],1); %this is the stupid fore file
elseif strcmp(leg, 'Left') && FP_used==1
    external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup_FP1_Left.xml'],1); %this is the stupid fore file
elseif strcmp(leg, 'Left') && FP_used==2
    external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup_FP2_Left.xml'],1); %this is the stupid fore file
end

%external_loads = ExternalLoads([cd, '/', 'ExternalForce_Setup.xml'],1); %this is the stupid fore file


external_loads.setDataFileName(MOT_FILE);
%     externalforce =ExternalForce ()
%     externalforce.set_data_source_name(fullpathGRFFile)
%     external_loads.adoptAndAppend(externalforce)

extLoadsName = ['Setup_force_',trialname,'.xml'];
lowpassfilter= 6;
external_loads.print([path,'/', extLoadsName]);
idTool.setName(trialname);
idTool.setModelFileName([path,'/' ,'scaled_weighted_matlab.osim']);
%Set file containing IK data
idTool.setCoordinatesFileName(fullpathIKFile);

%Set start and end time
idTool.setStartTime(initial_time);
idTool.setEndTime(final_time);

%Set output file and folder
idTool.setOutputGenForceFileName([ path,'\ID_RESULTS_' trialname '.sto' ]);
ID_RESULTS_PATH = [ path,'\ID_RESULTS_' trialname '.sto' ]; 
idTool.setResultsDir([path, '/']);

% Set file containing External Loads information
idTool.setExternalLoadsFileName([path,  '\' ,extLoadsName]);

%%
idTool.setLowpassCutoffFrequency(lowpassfilter);
% Save the settings in a setup file
outfileID = [path, '/Setup_ID_' trialname '.xml' ];
idTool.print(outfileID);
idTool.run();

toc
end