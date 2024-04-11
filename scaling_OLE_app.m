function  [opensimmodelpathscaled, IK_results_static_path, IK_res_ANGLES, scaliing_time]=scaling_OLE_app(path_to_trc,  ID, pathtopfolder,  static_name, modelname, markersetname, scalesetupname, OPTIONS)
tic
static_name = [static_name];
import org.opensim.modeling.*
%% Path to the OSIM generic model
osim_model= modelname;
osim_path = [cd, '\'];

copyfile ([osim_path, osim_model], [pathtopfolder,'/', osim_model]);
copyfile ([osim_path, markersetname], [pathtopfolder,'/', markersetname]);
visualizer_path = ('C:\OpenSim 4.3\Geometry'); % set the geometry path depending on the OS version
ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path)


%% Scaling
scaleTool = ScaleTool([scalesetupname]); % ////////////////////
scaleTool.setName(ID);% 
scaleTool.setSubjectMass(OPTIONS.ANTRO.mass); % 
scaleTool.setSubjectHeight(OPTIONS.ANTRO.height);% 
scaleTool.setPathToSubject(pathtopfolder);% 
scaleTool.getGenericModelMaker().setModelFileName(osim_model); % 
scaleTool.getGenericModelMaker().setMarkerSetFileName(markersetname); % /////////////
scaleTool.getModelScaler().setApply(true); % 
% scaleTool.getPathToSubject();
scaleTool.getModelScaler().setMarkerFileName(['\',static_name]); % 
% scaleTool.getModelScaler().getMarkerFileName()
scaleTool.getModelScaler().setOutputModelFileName([pathtopfolder,'\scaled_matlab.osim']); % 
scaleTool.getModelScaler().setOutputScaleFileName([pathtopfolder,'\scaleSet_applied.xml']); % 
scaleTool.getMarkerPlacer().setApply(true); % 
scaleTool.getMarkerPlacer().setStaticPoseFileName(['\',static_name]); % 
scaleTool.getMarkerPlacer().setOutputModelFileName(['\scaled_weighted_matlab.osim']); %

opensimmodelpathscaled =[pathtopfolder, '/', 'scaled_weighted_matlab.osim'];
scaleTool.getMarkerPlacer().setOutputMotionFileName(['\static_output.mot']);%
scaleTool.getMarkerPlacer().setOutputMarkerFileName(['\MarkerSet_after_scale.xml']);%
scaleTool.getMarkerPlacer().setMaxMarkerMovement(-1.00000000); %
% scaleTool.print(['Participant_Scale_Setup','.xml']);
scaleTool.print([pathtopfolder,'/','Setup_Scaling','.xml']);
scaleTool.setPrintResultFiles(true)
scaleTool.run();
clearvars scaleTool
% 
% ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
% myModel = Model(opensimmodelpathscaled) ;
% myModel.initSystem();
% % table = TimeSeriesTable([pathtopfolder,'\static_output.mot']);
% % ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
% VisualizerUtilities.showModel(myModel);

IK_results_static_path = [pathtopfolder, '/static_output.mot'];
name = split(IK_results_static_path, '/');
[~, ~,IK_res_ANGLES] = readMOTSTOTRCfiles([pathtopfolder,'/'], (name{end, 1}));
scaliing_time = toc; 
end