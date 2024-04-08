function [OPTIONS] = get_set_up_files(Setupfolder, pathtopfolder)
setup_files = dir(fullfile([pathtopfolder, '\OpenSim Master_Folder\', Setupfolder], '*.xml'));
generic_osim_model = dir(fullfile([pathtopfolder, '\OpenSim Master_Folder\', Setupfolder], '*.osim'));



OPTIONS.PATH.GENERIC_MODEL = 'generic_model.osim';
OPTIONS.GENERIC.markersetname='markerset.xml' ;
OPTIONS.GENERIC.scalesetupname = 'Scaling_Setup.xml';
OPTIONS.GENERIC.setupIKname = 'IK_Setup.xml';
OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
OPTIONS.GENERIC.setupBKname = 'BODYKIN_Setup.xml';

copyfile([setup_files(1).folder, '/', OPTIONS.PATH.GENERIC_MODEL], [pathtopfolder, '/', OPTIONS.PATH.GENERIC_MODEL])
copyfile([setup_files(1).folder, '/', OPTIONS.GENERIC.markersetname], [pathtopfolder, '/', OPTIONS.GENERIC.markersetname])
copyfile([setup_files(1).folder, '/',OPTIONS.GENERIC.scalesetupname], [pathtopfolder, '/', OPTIONS.GENERIC.scalesetupname])
copyfile([setup_files(1).folder, '/', OPTIONS.GENERIC.setupIKname], [pathtopfolder, '/', OPTIONS.GENERIC.setupIKname])
copyfile([setup_files(1).folder, '/', OPTIONS.GENERIC.setupIDname], [pathtopfolder, '/', OPTIONS.GENERIC.setupIDname])
copyfile([setup_files(1).folder, '/', OPTIONS.GENERIC.setupBKname ], [pathtopfolder, '/', OPTIONS.GENERIC.setupBKname])

try
copyfile([setup_files(1).folder, '/ExternalForce_Setup_FP1_Left.xml'], [pathtopfolder, '/ExternalForce_Setup_FP1_Left.xml'])
copyfile([setup_files(1).folder, '/ExternalForce_Setup_FP2_Left.xml'], [pathtopfolder, '/ExternalForce_Setup_FP2_Left.xml'])
copyfile([setup_files(1).folder, '/ExternalForce_Setup_FP1_Right.xml'], [pathtopfolder, '/ExternalForce_Setup_FP1_Right.xml'])
copyfile([setup_files(1).folder, '/ExternalForce_Setup_FP2_Right.xml'], [pathtopfolder, '/ExternalForce_Setup_FP2_Right.xml'])
catch

end

end