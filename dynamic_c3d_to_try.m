function [ftkratio, TRC_FILE, MOT_FILE, Y, Y_kinematic, markerStruct, forcesStruct, pf, af, FP_Corner_Points_of_FP_used, markers_from_c3d, markers_from_c3d_filt, run_time]=dynamic_c3d_to_try(path, cut, FP_used, threshold, setup_Identifier)
%% Cut
tic
acq = btkReadAcquisition(path);
pf = btkGetPointFrequency(acq);
af = btkGetAnalogFrequency(acq);
[forceplates, forceplatesInfo] = btkGetForcePlatforms(acq);
FP_Corner_Points_of_FP_used = forceplates((FP_used)).corners;
ftkratio = af/pf;
fpw = btkGetForcePlatformWrenches(acq, 1);
verticalgrf = fpw(FP_used).F(:,3);
Y = getContact_FP_app(verticalgrf', threshold);
Y_kinematic = unique(fix(Y/ftkratio));
td_analog = Y(1);
to_analog = Y(end);
ff = btkGetFirstFrame(acq);
td_kinematic =fix( Y(1)/ftkratio);
to_kinematic =fix(Y(end)/ftkratio);
if cut ==1
    btkCropAcquisition(acq, ff+(td_kinematic-20), (to_kinematic-(td_kinematic-20))+20)

end
[markers, markersInfo, markersResidual] = btkGetMarkers(acq);
markernames = fieldnames (markers);

try %% add force plate corners as markers
    [forceplates, forceplatesInfo] = btkGetForcePlatforms(acq);
    for cp = 1 : length({forceplates.corners})
        for sp = 1 : length(forceplates(cp).corners)
            residuals = ones(1,length(markers.(markernames{1, 1})))';
            [points, pointsInfo] = btkAppendPoint(acq, 'marker' , ['V_FP_',num2str(cp), '_Corner', num2str(sp)], repmat([forceplates(cp).corners(:,sp)]',length(markers.(markernames{1, 1} )),1), residuals);
        end
    end
catch
end

if strcmp(setup_Identifier, 'CALGARY') ==1
    try %% remove vicon random makers
        [markers, markersInfo, markersResidual] = btkGetMarkers(acq);
        markernames = fieldnames (markers);
        idxrm = sort(find(contains(markernames, 'C_')), 'descend');
        for i = 1 : length(idxrm)
            [points, pointsInfo] = btkRemovePoint(acq, idxrm(i));
        end
        % btkWriteAcquisition(acq, path)
    catch
    end
else
end


btkWriteAcquisition(acq, path)
clearvars fpw Y Y_kinematic
fpw = btkGetForcePlatformWrenches(acq, 1);
verticalgrf = fpw(FP_used).F(:,3);
Y = getContact_FP_app(verticalgrf', threshold);
Y_kinematic = unique(fix(Y/ftkratio));
[markers_from_c3d,  ~, ~] = btkGetMarkers(acq);

markernames_c3d = fieldnames(markers_from_c3d);
[b_filt,a_filt] = butter(2,  20/(pf), 'low');
for kev = 1 : length (markernames_c3d)
    markers_from_c3d_filt.(markernames_c3d{kev, 1})(:,1) =  filtfilt(b_filt,a_filt,markers_from_c3d.(markernames_c3d{kev, 1})(:,1));
    markers_from_c3d_filt.(markernames_c3d{kev, 1})(:,2)  =  filtfilt(b_filt,a_filt,markers_from_c3d.(markernames_c3d{kev, 1})(:,2));
    markers_from_c3d_filt.(markernames_c3d{kev, 1})(:,3) =  filtfilt(b_filt,a_filt,markers_from_c3d.(markernames_c3d{kev, 1})(:,3));
end
btkCloseAcquisition(acq)

% fill gaps (todo)


%% Convert to trc file
c3d = osimC3D_PM(path,1);
c3d.rotateData('x',-90)
c3d.convertMillimeters2Meters();
[markerStruct, forcesStruct] = c3d.getAsStructs();

c3d.writeTRC([erase(path, '.c3d'), '.trc']);
c3d.writeMOT([erase(path, '.c3d'), '.mot']);
TRC_FILE = [erase(path, '.c3d'), '.trc'];
MOT_FILE = [erase(path, '.c3d'), '.mot'];
run_time = toc; 
end