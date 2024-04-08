clc
clear all
close all


%%

topfolder = 'C:\Users\patrickmai\Downloads\sorted\sorted';
% get the folder contents
d = dir(topfolder);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]) ;
% remove '.' and '..'
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
clearvars d

% loop conditions
for c = 1 : length (dfolders)

    tempcon = [dfolders(c).folder, '/', dfolders(c).name];

    %% list subject folders
    dd = dir(tempcon);
    % remove all files (isdir property is 0)
    ddfolders = dd([dd(:).isdir]) ;
    % remove '.' and '..'
    ddfolders = ddfolders(~ismember({ddfolders(:).name},{'.','..'}));
    % loop subjects
    for p = 1 : length (ddfolders)
        tempsubject = [ddfolders(p).folder, '/', ddfolders(p).name];
        %% list the mat files
        tempfiles = dir(fullfile(tempsubject, '*.mat'));
        tempVisual3D=  load (  [tempsubject, '/', tempfiles(1).name]);

        tempQualysis=  load (  [tempsubject, '/', tempfiles(2).name]);

        qualysisname = fieldnames (tempQualysis);

        tempQualysis.(qualysisname{1,1});
        tempQualysis.(qualysisname{1,1}).Force;
        FORCE_FROM_QTMFILES =  tempQualysis.(qualysisname{1,1}).Force;
        MARKERS_FROM_QTMFILES = tempQualysis.(qualysisname{1,1}).Trajectories;
        MARKER_FRAMERATE =   tempQualysis.(qualysisname{1,1}).FrameRate  ;
        %% Downsample the force data
        FORCE_DOWNSAMPLE(:,1) = fit (FORCE_FROM_QTMFILES.Force(1,:), tempVisual3D.CenterOfMass{1, 1}(:,1)');
        FORCE_DOWNSAMPLE(:,2) = fit (FORCE_FROM_QTMFILES.Force(2,:), tempVisual3D.CenterOfMass{1, 1}(:,1)');
        FORCE_DOWNSAMPLE(:,3) = fit (FORCE_FROM_QTMFILES.Force(3,:), tempVisual3D.CenterOfMass{1, 1}(:,1)');
        try
            tempVisual3D = rmfield(tempVisual3D,'tempVisual3D');
        catch
        end
        [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI_mat([tempsubject, '/', tempfiles(2).name]);

        markernames = fieldnames (Markers);

        for m = 1 : length (markernames)
            Markers.(markernames{m, 1}).data;
            MARKER_DOWNSAMPLE.(markernames{m, 1}) = fit (Markers.(markernames{m, 1}).data, tempVisual3D.CenterOfMass{1, 1}(:,1)');
        end
        figure(p)
plot(FORCE_DOWNSAMPLE([1:200],3)*-1)
hold on
plot(MARKER_DOWNSAMPLE.calc_back_left(3,[1:200]))
plot(MARKER_DOWNSAMPLE.calc_back_right(3,[1:200]))
        save( [tempsubject, '/', tempfiles(1).name], 'FORCE_DOWNSAMPLE', "MARKER_DOWNSAMPLE",'-append')
 
        

        clearvars tempVisual3D tempQualysis
    end


end







function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI_mat(Pfad)
%         tmpName = split(Pfad, '\');
mainStruct = [];
mainStruct = load(Pfad);
name = string(fieldnames(mainStruct));

freq = mainStruct.(name).FrameRate;

ftkratio = mainStruct.(name).Force.Frequency/mainStruct.(name).FrameRate;

start = mainStruct.(name).StartFrame;

%end umschreiben in frames die genommen werden von dem File
%(berechnen)
ende = start + mainStruct.(name).Frames - 1;
nframes = mainStruct.(name).Frames;

n_labels = mainStruct.(name).Trajectories.Labeled.Count;

Labels = mainStruct.(name).Trajectories.Labeled.Labels';

for n = 1:length(Labels)
    Markers.(Labels{n}).data = squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
end
alf = 2;
Gaps = 0;
end