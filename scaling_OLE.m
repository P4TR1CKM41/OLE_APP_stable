function  [opensimmodelpathscaled]=scaling_OLE(path_to_trc,  ID, pathtopfolder, mass, height, static_name)
path_to_trc = replace(path_to_trc, '.c3d', '.trc');

static_name= replace(static_name, '.c3d', '.trc');
import org.opensim.modeling.*
%% Path to the OSIM generic model
osim_model= 'generic_Model_with_Markers.osim';
osim_path = [cd, '\'];

copyfile ([osim_path, osim_model], [pathtopfolder,'/', osim_model]);
copyfile ([osim_path, 'Markerset.xml'], [pathtopfolder,'/', 'Markerset.xml']);
visualizer_path = ('C:\OpenSim 4.4\Geometry'); % set the geometry path depending on the OS version
ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path)


%% Scaling
scaleTool = ScaleTool(['Scaling_Setup.xml']);
scaleTool.setName(ID);
scaleTool.setSubjectMass(mass); % (kg) % load from CSV file
scaleTool.setSubjectHeight(height*1000);
scaleTool.setPathToSubject(pathtopfolder);
scaleTool.getGenericModelMaker().setModelFileName(osim_model);
scaleTool.getGenericModelMaker().setMarkerSetFileName(['Markerset.xml']);
scaleTool.getModelScaler().setApply(true);
% scaleTool.getPathToSubject();
scaleTool.getModelScaler().setMarkerFileName(['\',static_name]);
% scaleTool.getModelScaler().getMarkerFileName()
scaleTool.getModelScaler().setOutputModelFileName([pathtopfolder,'\scaled_matlab.osim']);
scaleTool.getModelScaler().setOutputScaleFileName([pathtopfolder,'\scaleSet_applied.xml']);
scaleTool.getMarkerPlacer().setApply(true);
scaleTool.getMarkerPlacer().setStaticPoseFileName(['\',static_name]);
scaleTool.getMarkerPlacer().setOutputModelFileName(['\scaled_weighted_matlab.osim']);

opensimmodelpathscaled =[pathtopfolder, '/', 'scaled_weighted_matlab.osim'];
scaleTool.getMarkerPlacer().setOutputMotionFileName(['\static_output.mot']);
scaleTool.getMarkerPlacer().setOutputMarkerFileName(['\MarkerSet_after_scale.xml']);
scaleTool.getMarkerPlacer().setMaxMarkerMovement(-1.00000000);
% scaleTool.print(['Participant_Scale_Setup','.xml']);
scaleTool.print([pathtopfolder,'/','Setup_Scaling','.xml']);
scaleTool.setPrintResultFiles(true)
scaleTool.run();
clearvars scaleTool

ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
myModel = Model(opensimmodelpathscaled) ;
myModel.initSystem();
% table = TimeSeriesTable([pathtopfolder,'\static_output.mot']);
% ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
VisualizerUtilities.showModel(myModel);


end