function  static_c3d_to_try(path_to_static, app)
acq = btkReadAcquisition(path_to_static);
%% 1 fill all gaps
tic
[markers, markersInfo, markersResidual] = btkGetMarkers(acq);
markernames = fieldnames (markers);
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
expected = 49;%49 initial 
if length(markernames) < expected
uiwait(msgbox(['Expected markers: ', num2str(expected), ' Markers in recording: ', num2str(length(markernames)) ],"Marker missing?","modal"));
else
end
%% 2 Step add the virtual markers
BH = app.HeightcmEditField.Value;
offset = +0.1; 
%flaten the footmarker
try
    residuals = ones(1,length ( markers.toe_right))';
    markers.toe_right(:,3) = zeros (1,length ( markers.toe_right))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_toe_right',  markers.toe_right, residuals);
end
try
    residuals = ones(1,length ( markers.toe_left))';
    markers.toe_left(:,3) = zeros (1,length ( markers.toe_left))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_toe_left',  markers.toe_left, residuals);
end
try
    markername = 'R5MT';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end
try
    markername = 'L5MT';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end
try
    markername = 'R1MT';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'L1MT';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'RMEDC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'LMEDC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'LMEDC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'RMEDC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'RMC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'LMC';
    residuals = ones(1,length ( markers.(markername)))';
    markers.(markername)(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  markers.(markername), residuals);
end

try
    markername = 'LMM';
    residuals = ones(1,length ( markers.(markername)))';
    dummy =markers.(markername) ;
    dummy(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  dummy, residuals);
end

try
    markername = 'RMM';
    residuals = ones(1,length ( markers.(markername)))';
    dummy =markers.(markername) ;
    dummy(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))), dummy, residuals);
end


try
    markername = 'LMM';
    residuals = ones(1,length ( markers.(markername)))';
    dummy =markers.(markername) ;
    dummy(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))),  dummy, residuals);
end

try
    markername = 'LLM';
    residuals = ones(1,length ( markers.(markername)))';
    dummy =markers.(markername) ;
    dummy(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))), dummy, residuals);
end

try
    markername = 'RLM';
    residuals = ones(1,length ( markers.(markername)))';
    dummy =markers.(markername) ;
    dummy(:,3) = zeros (1,length ( markers.(markername)))+offset;
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , (strcat('V_',(markername))), dummy, residuals);
end

try
    %right knee
    x1=markers.RME(:,1);
    x2=markers.RLE(:,1);
    y1=markers.RME(:,2);
    y2=markers.RLE(:,2);
    z1=markers.RME(:,3);
    z2 =markers.RLE(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    M_p_Knee_right = M_p;
    residuals = ones(1,length (M_p))'; % can be used for all and is required value between 0 and 1 actually it doens matter whats in there at least somethint is in there
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_Knee', M_p, residuals);
end
try
    %left knee
    x1=markers.LME(:,1);
    x2=markers.LLE(:,1);
    y1=markers.LME(:,2);
    y2=markers.LLE(:,2);
    z1=markers.LME(:,3);
    z2 =markers.LLE(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_Knee', M_p, residuals);
end
try
    %right mal


    x1=markers.RMM(:,1);
    x2=markers.RLM(:,1);
    y1=markers.RMM(:,2);
    y2=markers.RLM(:,2);
    z1=markers.RMM(:,3);
    z2 =markers.RLM(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];% - because


    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_Mal', M_p, residuals);

    M_p_p = M_p;
    M_p_p(:,3) = zeros (1,length (M_p));
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_Pro_MidPnt_R_Mal',  M_p_p, residuals);

    clearvars   M_p_p M_p

end


try
    %left mal
    x1=markers.LMM(:,1);
    x2=markers.LLM(:,1);
    y1=markers.LMM(:,2);
    y2=markers.LLM(:,2);
    z1=markers.LMM(:,3);
    z2 =markers.LLM(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_Mal', M_p, residuals);



    M_p_p = M_p;
    M_p_p(:,3) = zeros (1,length ( M_p));
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_Pro_MidPnt_L_Mal',  M_p_p, residuals);

    clearvars   M_p_p M_p

end


try
    %left MTP
    x1=markers.R1MT(:,1);
    x2=markers.R5MT(:,1);
    y1=markers.R1MT(:,2);
    y2=markers.R5MT(:,2);
    z1=markers.R1MT(:,3);
    z2 =markers.R5MT(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_R_MTP', M_p, residuals);
end

try
    %left MTP
    x1=markers.L1MT(:,1);
    x2=markers.L5MT(:,1);
    y1=markers.L1MT(:,2);
    y2=markers.L5MT(:,2);
    z1=markers.L1MT(:,3);
    z2 =markers.L5MT(:,3);
    M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_L_MTP', M_p, residuals);
end


% SPIS
x1=markers.RPSIS(:,1);
x2=markers.LPSIS(:,1);
y1=markers.RPSIS(:,2);
y2=markers.LPSIS(:,2);
z1=markers.RPSIS(:,3);
z2 =markers.LPSIS(:,3);
M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
MidPnt_SIPS = M_p;
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_SIPS', M_p);
end
% SIAS
x1=markers.RASIS(:,1);
x2=markers.LASIS(:,1);
y1=markers.RASIS(:,2);
y2=markers.LASIS(:,2);
z1=markers.RASIS(:,3);
z2 =markers.LASIS(:,3);
M_p = [(x1+x2)/2, (y1+y2)/2, (z1+z2)/2];
MidPnt_SIAS = M_p;
try
    [points, pointsInfo] = btkAppendPoint(acq, 'marker' , 'V_MidPnt_SIAS', M_p);

end

%right Hip
% This time R is initially determined; O comes subsequently
[~, y] = size(markers.RASIS');


MPASI = zeros(3,1,y);
MPPSI = zeros(3,1,y);
Help1 = zeros(3,1,y);
X = zeros(3,1,y);
Y = zeros(3,1,y);
Z = zeros(3,1,y);

for i = 1:y
    i;
    MPASI(:,i) = (markers.LASIS(i,:) + markers.RASIS(i,:))/2;
    MPPSI(:,i) = (markers.LPSIS(i,:) + markers.RPSIS(i,:))/2;
    Y(:,i) = markers.LASIS(i,:) - markers.RASIS(i,:);
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
DIST.ASIS = getdistance(markers.LASIS', markers.RASIS');
DIST.RASI_RPSI = getdistance(markers.RASIS', markers.RPSIS');
DIST.LASI_LPSI = getdistance(markers.LASIS', markers.LPSIS');

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

    O_allframes(:,u) = R*POS.hip.pelvis.lokal + markers.RASIS(u,:)';
    O_allframesL(:,u) = R*POSL.hip.pelvis.lokal + markers.LASIS(u,:)';
end


%    midpoint of the hipjointcenters
HJR= O_allframes';
HJL= O_allframesL';

%% Harington

%Renamd for convenience
LASIS=markers.LASIS';   %after transposition: [3xtime]
RASIS=markers.RASIS';
LPSIS=markers.LPSIS';
RPSIS=markers.RPSIS';


for t=1:size(RASIS,2)

    %Right-handed Pelvis reference system definition
    SACRUM(:,t)=(RPSIS(:,t)+LPSIS(:,t))/2;
    %Global Pelvis Center position
    OP(:,t)=(LASIS(:,t)+RASIS(:,t))/2;

    PROVV(:,t)=(RASIS(:,t)-SACRUM(:,t))/norm(RASIS(:,t)-SACRUM(:,t));
    IB(:,t)=(RASIS(:,t)-LASIS(:,t))/norm(RASIS(:,t)-LASIS(:,t));

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

    PW(t)=norm(RASIS(:,t)-LASIS(:,t));
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
BH = repmat (BH,length (M_p_Pelvis), 1);
M_p_Head = M_p_Pelvis;
M_p_Head(:,end)= BH;


btkWriteAcquisition(acq,path_to_static)
btkCloseAcquisition(acq);

%% now create a trc file
c3d = osimC3D(path_to_static,1);
%% Rotate the data
c3d.rotateData('x',-90);
c3d.convertMillimeters2Meters();
decom = split(path_to_static, '/');
name = replace(decom{end,1}, '.c3d', '.trc');
c3d.writeTRC(name);
toc
end