% load('C:\Users\pmai\OneDrive\Handballfinter2022\Norge_Report\Session 1\P041.mat')
% OPTIONS.ANTHRO.Mass
% OPTIONS.ANTHRO.Height



%%
clc
clear all
close all
% cd('/Users/leon/Documents/Studium_DSHS/Master/Thesis/Data/Right_Steps_Biggest_N/Slope_down_15_speed_3_5/P004/')
load('C:\Users\pmai\OneDrive\Handballfinter2022\OpenCap\505_Marker\P005\Static_5o5 1.mat')
v = Static_5o5_1.Trajectories.Labeled.Data  ;

i=1;
j=2;
k=3;
% [markers, markersInfo, markersResidual] = btkGetMarkers(h)
for x2=1:size(v,1)
    for x1=1:size(v,3)
        markerStatic(x1,i)=v(x2,1,x1);
        markerStatic(x1,j)=v(x2,2,x1);
        markerStatic(x1,k)=v(x2,3,x1);
        
    end
    i=i+3;
    j=j+3;
    k=k+3;
end

%v1 = btkGetMarkersValues(h);

globalReferenceSystem = 'XZY';
globalToOpenSimRotations=globalToOpenSimRotParametersCreator(globalReferenceSystem);
globalToOpenSimRotations.RotX =0;
globalToOpenSimRotations.RotY =0;
globalToOpenSimRotations.RotZ =1;
globalToOpenSimRotations.Rot1deg =90; %270
globalToOpenSimRotations.Rot2deg =0;
parameters.globalReferenceSystem=globalReferenceSystem;
parameters.globalToOpenSimRotations=globalToOpenSimRotations;
% [FProtations(1).Degrees]= 180;
% [FProtations(2).Degrees]= 90;
% [FProtations(1).Axis]= 'X';
% [FProtations(2).Axis]= 'Z';
% FPtoGlobalRotationsParameters = FPtoGlobalRotParameterStructCreator(FProtations);
% parameters.FPtoGlobalRotations=FPtoGlobalRotationsParameters;
% FPtoGlobalRotations=parameters.FPtoGlobalRotations;

FPStruct= 0;

v2=RotateCS (markerStatic,globalToOpenSimRotations, FPStruct);




for x1=1:size(v,3)
    i=1;
    for x2=1:size(v,1)
        v(x2,1,x1) = v2(x1,i);
        v(x2,2,x1) = v2(x1,i+1);
        v(x2,3,x1) = v2(x1,i+2);
        i=i+3;
    end
    
end

Static_5o5_1.Trajectories.Labeled.Data = v;
disp("Done")
