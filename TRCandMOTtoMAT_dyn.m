function [path_to_mat]=TRCandMOTtoMAT_dyn(path, file)

%% for the rotation from OpenSim to Global different axis defintion
globalReferenceSystem = 'XZY';
globalToOpenSimRotations=globalToOpenSimRotParametersCreator(globalReferenceSystem);
globalToOpenSimRotations.RotX =1;
globalToOpenSimRotations.RotY =0;
globalToOpenSimRotations.RotZ =0;
globalToOpenSimRotations.Rot1deg =-90;
globalToOpenSimRotations.Rot2deg =0;
parameters.globalReferenceSystem=globalReferenceSystem;
parameters.globalToOpenSimRotations=globalToOpenSimRotations;





[dataM,CM,tableDataM] =  readMOTSTOTRCfiles(path,  file);
%Force mot data
[dataF,CF,tableDataF] =  readMOTfiles(path , replace(file, '.trc', '.mot'));
name = erase(file, '.trc');

tmpStruct = struct;
tmpStruct.(name).File = [path,  file]; %mainStruct.(name).File;
tmpStruct.(name).Timestamp =  datetime('now'); %mainStruct.(name).Timestamp;
tmpStruct.(name).StartFrame = dataM(1,1);%sf_video;
tmpStruct.(name).Frames = dataM(end,1); %ef_video-sf_video+1;
tmpStruct.(name).FrameRate = round(1/(dataM(end,2)-dataM(end-1,2))); %mainStruct.(name).FrameRate;
up =1;

for mna = 3:3 :length ({CM{3:end}})
templabel =CM{mna};
templabel(end)= [];
LABELS{1,up} = templabel;
up = up+1;
end
tmpStruct.(name).Trajectories.Labeled.Labels = LABELS; %mainStruct.(name).Trajectories.Labeled.Labels;
tmpStruct.(name).Trajectories.Labeled.Count = length (CM); %mainStruct.(name).Trajectories.Labeled.Count;
%%
% Loop through the fps to get all of them.
for n = 1:fix((length(CF)-1)/9)
    if n ==1 % a very simple methode
        index = [2:10];
    elseif n==2
        index = [11:19];
    elseif n==3
        index = [20:28];
    end
    tmpStruct.(name).Force(n).ForcePlateName = ['Force-plate ', num2str(n)]; %mainStruct.(name).Force(n).ForcePlateName;
    tmpStruct.(name).Force(n).SamplingFactor = 1/(dataF(end,1)-dataF(end-1,1)) / round(1/(dataM(end,2)-dataM(end-1,2))); %mainStruct.(name).Force(n).SamplingFactor;
    tmpStruct.(name).Force(n).Frequency = fix(1/(dataF(end,1)-dataF(end-1,1))); %mainStruct.(name).Force(n).Frequency;
    tmpStruct.(name).Force(n).ForcePlateLocation = [0 0 0;0 0 0;0 0  0;0 0 0];%mainStruct.(name).Force(n).ForcePlateLocation;
    tmpStruct.(name).Force(n).ForcePlateOrientation = 100000;% mainStruct.(name).Force(n).ForcePlateOrientation;
    tmpStruct.(name).Force(n).ForceNOTROT = dataF(:,index(1:3))';
    tmpStruct.(name).Force(n).MomentNOTROT =dataF(:,index(7:9))' ;
    tmpStruct.(name).Force(n).COPNOTROT = (dataF(:,index(4:6))')*1000;
    %Rotate back from opensim to global
    tmpStruct.(name).Force(n).Force= RotateCS( tmpStruct.(name).Force(n).ForceNOTROT',globalToOpenSimRotations)';
    tmpStruct.(name).Force(n).Moment= RotateCS( tmpStruct.(name).Force(n).MomentNOTROT',globalToOpenSimRotations)';
    tmpStruct.(name).Force(n).COP = RotateCS( tmpStruct.(name).Force(n).COPNOTROT',globalToOpenSimRotations)';

end
%%
% contact = find (tmpStruct.(name).Force(2).Force(3,:)>30);
%   plot(tmpStruct.(name).Force(2).COP(1,contact))
% Now cut the timeseries parameters to the given length of the trial.
Markerarray = (dataM(:,3:end-1));
[rows, columns] = size(Markerarray);
axis = 3;
MarkerQTMformat = pagetranspose(reshape(Markerarray', axis, columns/axis, rows));
for mn = 1:length(LABELS)
    %Markers.(LABELS{mn}) = squeeze(MarkerQTMformat(mn, 1:3, :))';
    %MarkersArrayCell{mn+1} = squeeze(MarkerQTMformat(mn, 1:3, :))';
    % rotate the marker in opensim format
    rotatedMarkers{mn}=RotateCS(squeeze(MarkerQTMformat(mn, 1:3, :))',globalToOpenSimRotations);
end

MarkerROT = cell2mat (rotatedMarkers);

MarkerQTMformatROT = pagetranspose(reshape(MarkerROT', axis, columns/axis, rows));


tmpStruct.(name).Trajectories.Labeled.Data = MarkerQTMformatROT;
path_to_mat =  replace([path,  file], '.trc', '.mat');
save(path_to_mat, '-struct', 'tmpStruct')
end