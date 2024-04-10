function [ACC, VEL, POS, run_time] = on_Bodykinematics(fullpathIKFile,modelpath, scanfolderrpath, ID, trialName)
tic
import org.opensim.modeling.*
model = Model(modelpath); % location of the scaled model
model.initSystem();

dummy =[cd, '/','BODYKIN_Setup.xml' ];
%store the ik_results mot data here for getting initial and final time
motCoordsData = Storage(fullpathIKFile);
%get initial and final time from .mot data
initial_time = motCoordsData.getFirstTime();
final_time = motCoordsData.getLastTime();

%Input here the analyze setup file from the topfolder
analyzeTool=AnalyzeTool(dummy);
%set initial and final time for the analyze tool
analyzeTool.setInitialTime(initial_time);
analyzeTool.setFinalTime(final_time);
analyzeTool.setModel(model);
analyzeTool.setModelFilename(modelpath);
%Set the modelname as participant
analyzeTool.setName(['BODYKIN_RESULTS_',trialName]);
analyzeTool.setCoordinatesFileName(fullpathIKFile);
analyzeTool.setResultsDir([scanfolderrpath, '/']);
analyzeTool.setLowpassCutoffFrequency(6);
%print the xml setupfile into the Analyze setip folder
% Save the settings in a setup file
outfileID = [ scanfolderrpath,'/Setup_BODYKIN', trialName '.xml' ];
analyzeTool.print(outfileID);
%run the analyze tool
analyzeTool.run();
ACC = [scanfolderrpath,'/BODYKIN_RESULTS_',trialName, '_BodyKinematics_acc_global.sto'];
VEL = [scanfolderrpath,'/BODYKIN_RESULTS_',trialName, '_BodyKinematics_vel_global.sto'];
POS = [scanfolderrpath,'/BODYKIN_RESULTS_',trialName, '_BodyKinematics_pos_global.sto'];
run_time = toc; 
end