function  [markers_mean]= static_c3d_to_trc_Motrack(path_to_static, OPTIONS)
acq = btkReadAcquisition(path_to_static);
%% 1 fill all gaps
tic
[markers, markersInfo, markersResidual] = btkGetMarkers(acq);
markernames = fieldnames (markers);
for mm = 1 : length (markernames)
    markers_mean.(markernames{mm, 1}) = mean(markers.(markernames{mm, 1}));
end
%% delete all previous Virtual Markers
index_v = find(~cellfun(@isempty,strfind(markernames,'V_')));
index_pro = find(~cellfun(@isempty,strfind(markernames,'Pro_')));
remove_idx = sort([index_v; index_pro], 'descend');
for k = 1 : length (remove_idx)
    try
        [points, pointsInfo] = btkRemovePoint(acq, markernames{remove_idx(k), 1} );
    catch
    end
end
btkWriteAcquisition(acq,path_to_static)
%%
hoch =1;
for mn = 1: length(markernames)
    [rows, ~] = find(( markers.(markernames{mn, 1}))==0);
    if ~isempty(rows)
        rows= unique(rows);
        markers.(markernames{mn, 1})(  markers.(markernames{mn, 1})==0) = NaN;
        nanmeanvalue = nanmean( markers.(markernames{mn, 1}));
        for r = 1: length(rows)
            markers.(markernames{mn, 1})(rows(r),:) = nanmeanvalue;
        end
        res = ones(1,length( markers.(markernames{mn, 1})))';
        try
            btkSetPoint(acq,(markernames{mn, 1}),  markers.(markernames{mn, 1}), res)
        catch

        end
        ERROR{hoch,1} = (markernames{mn, 1});
        ERROR{hoch,2} = length(rows);
        hoch =hoch+1;
    else
    end
end
% expected = 49;%49 initial
% if length(markernames) < expected
% uiwait(msgbox(['Expected markers: ', num2str(expected), ' Markers in recording: ', num2str(length(markernames)) ],"Marker missing?","modal"));
% else
% end
%% 2 Step add the virtual markers
offset = +0.1;
%% Corrosponding markersetnames
row_num = find(contains((OPTIONS.MARKER_SETUP.HIP(:,1)),OPTIONS.SETTINGS)==1);
%% flatten all foot markers
markernames = (OPTIONS.MARKER_SETUP.FOOT(row_num,2:end));
markernames(cellfun(@(markernames) any(isnan(markernames)),markernames)) = [];
for ll = 1 : length (markernames)
    markers.(markernames{1, ll}) ;
    residuals = ones(1,length ( markers.(markernames{1, ll}) ))';
    %markers.(markernames{1, ll})(:,3) = zeros (1,length ( markers.(markernames{1, ll})))+offset;
    DUMMY = [   markers.(markernames{1, ll})(:,1),  markers.(markernames{1, ll})(:,2), (zeros (1,length ( markers.(markernames{1, ll})))+offset)'];
    try
        [points, pointsInfo] = btkAppendPoint(acq, 'marker' , ['V_',(markernames{1, ll})], DUMMY, residuals);
    catch
    end
end




try
    %right knee
    x1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,3})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,2})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,3})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,2})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,3})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,2})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    M_p_Knee_right = M_p;
    residuals = ones(1,length (M_p))'; % can be used for all and is required value between 0 and 1 actually it doens matter whats in there at least somethint is in there
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_Knee', M_p, residuals);
end
try
    %left knee
    x1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,5})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,4})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,5})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,4})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,5})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.KNEE{row_num,4})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_Knee', M_p, residuals);
end
try
    %right mal
    x1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,3})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,2})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,3})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,2})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,3})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,2})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_Mal', M_p, residuals);
    M_p_p = M_p;
    M_p_p(:,3) = zeros (1,length (M_p))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'Pro_MidPnt_R_Mal',  M_p_p, residuals);
    clearvars   M_p_p M_p
end


try
    %left mal
    x1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,5})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,4})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,5})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,4})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,5})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.ANKLE{row_num,4})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_Mal', M_p, residuals);
    M_p_p = M_p;
    M_p_p(:,3) = zeros (1,length ( M_p))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'Pro_MidPnt_L_Mal',  M_p_p, residuals);
    clearvars   M_p_p M_p
end


try
    %right MTP
    x1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,2})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,3})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,2})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,3})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,2})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.MTP{row_num,3})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_MTP', M_p, residuals);
    % M_p_p(:,3) = zeros (1,length ( M_p))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'Pro_MidPnt_R_MTP',  [M_p(:,1), M_p(:,2), (zeros (1,length ( M_p))+offset)'], residuals);
    clearvars    M_p
end

try
    %left MTP
    x1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,4})(:,1);
    x2=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,5})(:,1);
    y1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,4})(:,2);
    y2=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,5})(:,2);
    z1=markers.(OPTIONS.MARKER_SETUP.MTP{row_num,4})(:,3);
    z2 =markers.(OPTIONS.MARKER_SETUP.MTP{row_num,5})(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_MTP', M_p, residuals);

    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'Pro_MidPnt_L_MTP',  [M_p(:,1), M_p(:,2), (zeros (1,length ( M_p))+offset)'], residuals);
    clearvars    M_p
end



% SPIS
x1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})(:,1);
x2=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})(:,1);
y1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})(:,2);
y2=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})(:,2);
z1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})(:,3);
z2 =markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})(:,3);
M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
MidPnt_SIPS = M_p;
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_SIPS', M_p);
end
% SIAS
x1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(:,1);
x2=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(:,1);
y1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(:,2);
y2=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(:,2);
z1=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(:,3);
z2 =markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(:,3);
M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
MidPnt_SIAS = M_p;
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_SIAS', M_p);

end

%right Hip
% This time R is initially determined; O comes subsequently
[~, y] = size(markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})');


MPASI = zeros(3,1,y);
MPPSI = zeros(3,1,y);
Help1 = zeros(3,1,y);
X = zeros(3,1,y);
Y = zeros(3,1,y);
Z = zeros(3,1,y);

for i = 1:y
    i;
    MPASI(:,i) = (markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(i,:) + markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(i,:))/2;
    MPPSI(:,i) = (markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})(i,:) + markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})(i,:))/2;
    Y(:,i) = markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(i,:) - markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(i,:);
    Help1(:,i) = MPASI(:,i) - MPPSI(:,i);
    Z(:,i) = cross(Help1(:,i), Y(:,i));
    X(:,i) = cross(Y(:,i), Z(:,i));
    X(:,i) = X(:,i) / norm(X(:,i));
    Y(:,i) = Y(:,i) / norm(Y(:,i));
    Z(:,i) = Z(:,i) / norm(Z(:,i));
end

R = Rmean([X,Y,Z]);
SLength = 0;

% Bestimmung des mittleren Abstandes zwischen LASI und RASI Marker
% bzw. zwischen RASI und RPSI Marker
DIST.ASIS = getdistance(markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})', markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})');
DIST.RASI_RPSI = getdistance(markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})', markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})');
DIST.LASI_LPSI = getdistance(markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})', markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})');

% Ermittlung des Hüftgelenkmittelpunkts im loaklen
% Hüftkoordinatensystem (Ursprung RASI) nach Seidel (1995) (X und Y
% Koordinate)  bzw. Bell (1989) (Z - Koordinate)
POS.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
POS.hip.pelvis.lokal(2,1) = DIST.ASIS.mean*0.14;
POS.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;
POSL.hip.pelvis.lokal(1,1) = -DIST.RASI_RPSI.mean*0.34;
POSL.hip.pelvis.lokal(2,1) = -DIST.ASIS.mean*0.14;
POSL.hip.pelvis.lokal(3,1) = -DIST.ASIS.mean*0.31;

% Transformieren in globales Koordinatensystem
O_allframes = zeros(3,y);
for u = 1:y

    O_allframes(:,u) = R*POS.hip.pelvis.lokal + markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})(u,:)';
    O_allframesL(:,u) = R*POSL.hip.pelvis.lokal + markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})(u,:)';
end


%    midpoint of the hipjointcenters
HJR= O_allframes';
HJL= O_allframesL';

%% Harington

%Renamd for convenience
SIAS_left=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,5})';   %after transposition: [3xtime]
SIAS_right=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,4})';
SIPS_left=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,3})';
SIPS_right=markers.(OPTIONS.MARKER_SETUP.HIP{row_num,2})';


for t=1:size(SIAS_right,2)

    %Right-handed Pelvis reference system definition
    SACRUM(:,t)=(SIPS_right(:,t)+SIPS_left(:,t))/2;
    %Global Pelvis Center position
    OP(:,t)=(SIAS_left(:,t)+SIAS_right(:,t))/2;

    PROVV(:,t)=(SIAS_right(:,t)-SACRUM(:,t))/norm(SIAS_right(:,t)-SACRUM(:,t));
    IB(:,t)=(SIAS_right(:,t)-SIAS_left(:,t))/norm(SIAS_right(:,t)-SIAS_left(:,t));

    KB(:,t)=cross(IB(:,t),PROVV(:,t));
    KB(:,t)=KB(:,t)/norm(KB(:,t));

    JB(:,t)=cross(KB(:,t),IB(:,t));
    JB(:,t)=JB(:,t)/norm(JB(:,t));

    OB(:,t)=OP(:,t);

    %rotation+ traslation in homogeneous coordinates (4x4)
    pelvis(:,:,t)=[IB(:,t) JB(:,t) KB(:,t) OB(:,t);
        0 0 0 1];

    %Trasformation into pelvis coordinate system (CS)
    OPB(:,t)=inv(pelvis(:,:,t))*[OB(:,t);1];

    PW(t)=norm(SIAS_right(:,t)-SIAS_left(:,t));
    PD(t)=norm(SACRUM(:,t)-OP(:,t));

    %Harrington formulae (starting from pelvis center)
    diff_ap(t)=-0.24*PD(t)-9.9;
    diff_v(t)=-0.30*PW(t)-10.9;
    diff_ml(t)=0.33*PW(t)+7.3;


    vett_diff_pelvis_sx(:,t)=[-diff_ml(t);diff_ap(t);diff_v(t);1];
    vett_diff_pelvis_dx(:,t)=[diff_ml(t);diff_ap(t);diff_v(t);1];

    %hjc in pelvis CS (4x4)
    rhjc_pelvis(:,t)=OPB(:,t)+vett_diff_pelvis_dx(:,t);
    lhjc_pelvis(:,t)=OPB(:,t)+vett_diff_pelvis_sx(:,t);


    %Transformation Local to Global
    RHJC(:,t)=pelvis(1:3,1:3,t)*[rhjc_pelvis(1:3,t)]+OB(:,t);
    LHJC(:,t)=pelvis(1:3,1:3,t)*[lhjc_pelvis(1:3,t)]+OB(:,t);


end

try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_Right_Hip', RHJC');
end
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_Left_Hip', LHJC');
end


%%
x1=RHJC(1,:);
x2=LHJC(1,:);
y1=RHJC(2,:);
y2=LHJC(2,:);
z1=RHJC(3,:);
z2 =LHJC(3,:);
M_p = [(x1+x2)/2; (y1+y2)/2; (z1+z2)/2];
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_Hip', M_p');
end
%mitten im becken midpoint SIAS und Midpoint SIPS
MidPnt_SIAS ;
MidPnt_SIPS;
x1=MidPnt_SIAS(:,1);
x2=MidPnt_SIPS(:,1);
y1=MidPnt_SIAS(:,2);
y2=MidPnt_SIPS(:,2);
z1=MidPnt_SIAS(:,3);
z2 =MidPnt_SIPS(:,3);
M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
M_p_Pelvis = M_p;
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_Pelvis', M_p);
end

try
    BH = OPTIONS.ANTRO.height*10;
    BH = repmat (BH,length (M_p_Pelvis), 1);
    M_p_Head = M_p_Pelvis;
    M_p_Head(:,end)= BH;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_TopHead', M_p_Head, residuals);
catch

end
try
    %hand_right
    x1=markers.hand_med_right(:,1);
    x2=markers.hand_lat_right(:,1);
    y1=markers.hand_med_right(:,2);
    y2=markers.hand_lat_right(:,2);
    z1=markers.hand_med_right(:,3);
    z2 =markers.hand_lat_right(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_Hand', M_p, residuals);
    M_p_p = M_p;
    clearvars   M_p_p M_p
end

try
    %hand_left
    x1=markers.hand_med_left(:,1);
    x2=markers.hand_lat_left(:,1);
    y1=markers.hand_med_left(:,2);
    y2=markers.hand_lat_left(:,2);
    z1=markers.hand_med_left(:,3);
    z2 =markers.hand_lat_left(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_Hand', M_p, residuals);
    M_p_p = M_p;
    clearvars   M_p_p M_p
end

try
    %elbow_right
    x1=markers.elbow_med_right(:,1);
    x2=markers.elbow_lat_right(:,1);
    y1=markers.elbow_med_right(:,2);
    y2=markers.elbow_lat_right(:,2);
    z1=markers.elbow_med_right(:,3);
    z2 =markers.elbow_lat_right(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_elbow', M_p, residuals);
    M_p_p = M_p;
    clearvars   M_p_p M_p
end

try
    %elbow_left
    x1=markers.elbow_med_left(:,1);
    x2=markers.elbow_lat_left(:,1);
    y1=markers.elbow_med_left(:,2);
    y2=markers.elbow_lat_left(:,2);
    z1=markers.elbow_med_left(:,3);
    z2 =markers.elbow_lat_left(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_elbow', M_p, residuals);
    M_p_p = M_p;
    clearvars   M_p_p M_p
end


btkWriteAcquisition(acq,path_to_static)
btkCloseAcquisition(acq);

%% now create a trc file
c3d = osimC3D(path_to_static,1);
%% Rotate the data
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
decom = split(path_to_static, '/');
name = replace(decom{end,1}, '.c3d', '.trc');
c3d.writeTRC(name);

toc
end