function  opensimvisualizer(modelpath,ik_path, geometrypath)
import org.opensim.modeling.*
visualizer_path = (geometrypath); % set the geometry path depending on the OS version
ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
myModel = Model(modelpath) ;
myModel.initSystem();
table = TimeSeriesTable(ik_path);
ModelVisualizer.addDirToGeometrySearchPaths(visualizer_path);
try
    VisualizerUtilities.showMotion(myModel, table);
catch
    VisualizerUtilities.showModel(myModel)
end
end