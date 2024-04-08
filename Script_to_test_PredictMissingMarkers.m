%
% This code was developed to test the PredictMissingMarker function which
% is described in a paper submitted to PlosOne. 
% The script reads in samples data, creates a gap in this data for a 
% specified marker with a specified length, calls the function 
% PredictMissingMarkers and compares the reconstruction result with the 
% original marker trajectory.

% (c) Peter Federolf, 2013. All rights reserved. 

% Please cite the corresponding paper if you use this script or the gap 
% filling algorithm in your research: 
% Federolf P.: A novel approach to solve the “missing marker problem” 
% in marker-based motion analysis that exploits the segment coordination 
% patterns in multi-limb motion data. Plos One. (submitted 2013)


clear;
close all;

%% Read in Data

if 1  %select either Walking or Balancing
load Walking_20Steps_noGaps;
% Read in walking data
% creataes a variable "Data" of 4300x111 containing the gait kinematics 
else
load OneLegBalancing_18seconds_noGaps;
% read in balancing data
% creataes a variable "Data" of 4300x111 containing the balance kinematics 
end

% This is the marker setup:
Marker_name{1} = 'LTOE';
Marker_name{2} = 'LANK';
Marker_name{3} = 'LHEE';
Marker_name{4} = 'LTIB';
Marker_name{5} = 'LKNE';
Marker_name{6} = 'LTHI';
Marker_name{7} = 'RTOE';
Marker_name{8} = 'RANK';
Marker_name{9} = 'RHEE';
Marker_name{10} = 'RTIB';
Marker_name{11} = 'RKNE';
Marker_name{12} = 'RTHI';
Marker_name{13} = 'RASIS';
Marker_name{14} = 'LASIS';
Marker_name{15} = 'RPSI';
Marker_name{16} = 'LPSI';
Marker_name{17} = 'STRN';
Marker_name{18} = 'CLAV';
Marker_name{19} = 'C7';
Marker_name{20} = 'T10';
Marker_name{21} = 'RBAK';
Marker_name{22} = 'RSHO';
Marker_name{23} = 'RUPA';
Marker_name{24} = 'RELB';
Marker_name{25} = 'RFRA';
Marker_name{26} = 'RWRA';
Marker_name{27} = 'RWRB';
Marker_name{28} = 'LSHO';
Marker_name{29} = 'LUPA';
Marker_name{30} = 'LELB';
Marker_name{31} = 'LFRA';
Marker_name{32} = 'LWRA';
Marker_name{33} = 'LWRB';
Marker_name{34} = 'LFHD';
Marker_name{35} = 'RFHD';
Marker_name{36} = 'LBHD';
Marker_name{37} = 'RBHD';


%
%% Create a test matrix by deleting a selected marker:

% select which marker should be deleted:
deleteMarker = [5];        % e.g. [34]; %= LFHEAD

%define the Neighbours of the deleted marker:
% Attention! mistakes here (e.g. acidentally selecting a marker on the 
% contra-lateral limb) lead to very bad results! 
nearNeighbours = [4,6];        % e.g. [35,36,37];
secondaryNeighbours = [2,14];   % can be empty

% define weights for the neighbouring markers
weights_nearNeighbours = 10;      % 10 usually gives good results
weights_secondaryNeighbours = 5;  %  5 usually gives good results


%choose for how many frames the marker should be available: 
N_frames_without_gaps = 2150;     %  430 -->  2 steps of 20 available
                                  % 2150 --> 10 steps of 20 available 
                                  % 3870 --> 18 steps of 20 available

            
% create Matric with gaps: 
% Note: in this version the gaps are always created at the end of the 
%       column. However, PredictMissingMarkers can handle gaps anywhere
%       in the file.

Data_gaps = Data;

Deleted = NaN(size(Data_gaps,1)-N_frames_without_gaps,3);
% Note: Some 

for i=deleteMarker
    Data_gaps(size(Data_gaps,1)-size(Deleted,1)+1:size(Data_gaps,1),...
              i*3-2:i*3) = Deleted;
end


%% Call PredictMissingMarkers
%tic

ReconstructedFullDataSet = ...
    PredictMissingMarkers(Data_gaps,nearNeighbours,secondaryNeighbours,...
                          weights_nearNeighbours,...
                          weights_secondaryNeighbours);

%toc                     
%% Analyse the accuracy of the reconstruction
% 
for i=deleteMarker

Difference_X{i} = ...
    Data(size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3-2)-...
    ReconstructedFullDataSet(...
         size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3-2);
Difference_Y{i} = ...
    Data(size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3-1)-...
    ReconstructedFullDataSet(...
         size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3-1);
Difference_Z{i} = ...
    Data(size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3)-...
    ReconstructedFullDataSet(...
         size(Data,1)-size(Deleted,1)+1:size(Data,1),i*3);    
    
ROM_X = max(Data(:,i*3-2))-min(Data(:,i*3-2));
ROM_Y = max(Data(:,i*3-1))-min(Data(:,i*3-1));
ROM_Z = max(Data(:,i*3))  -min(Data(:,i*3));

maxDifference_X{i} = round( max( abs( Difference_X{i} )));
maxDifference_Y{i} = round( max( abs( Difference_Y{i} )));
maxDifference_Z{i} = round( max( abs( Difference_Z{i} )));

meanDifference_X{i} = round( mean( abs( Difference_X{i} )));
meanDifference_Y{i} = round( mean( abs( Difference_Y{i} ))); 
meanDifference_Z{i} = round( mean( abs( Difference_Z{i} ))); 

disp(['Marker ',num2str(i),'  ',Marker_name{i}])
disp(['Mean absolute difference X = ',num2str(meanDifference_X{i}),...
           ' mm  ',num2str(round(meanDifference_X{i}/ROM_X*100)),...
           '% of ROM'])
disp(['Mean absolute difference Y = ',num2str(meanDifference_Y{i}),...
           ' mm  ',num2str(round(meanDifference_Y{i}/ROM_Y*100)),...
           '% of ROM'])
disp(['Mean absolute difference Z = ',num2str(meanDifference_Z{i}),...
           ' mm  ',num2str(round(meanDifference_Z{i}/ROM_Z*100)),...
           '% of ROM'])
disp(['Maximum absolute difference X = ',num2str(maxDifference_X{i}),...
           ' mm  ',num2str(round(maxDifference_X{i}/ROM_X*100)),...
           '% of ROM'])
disp(['Maximum absolute difference Y = ',num2str(maxDifference_Y{i}),...
           ' mm  ',num2str(round(maxDifference_Y{i}/ROM_Y*100)),...
           '% of ROM'])
disp(['Maximum absolute difference Z = ',num2str(maxDifference_Z{i}),...
           ' mm  ',num2str(round(maxDifference_Z{i}/ROM_Z*100)),...
           '% of ROM'])
disp(' ')

end


if 1  % create graph
h03 = figure;
subplot(3,1,1)
plot(Data(:,(deleteMarker)*3-2),'b','LineWidth',2)
hold on
plot(Data_gaps(:,(deleteMarker)*3-2),'k','LineWidth',2)
plot(ReconstructedFullDataSet(:,(deleteMarker)*3-2),'r','LineWidth',2)
box off
ylabel('X [mm]','FontSize',14,'FontWeight','bold')
title('Reconstructed: red;   Input trajectory: black;   Reference: blue'...
    ,'FontSize',14,'FontWeight','bold')

subplot(3,1,2)
plot(Data(:,(deleteMarker)*3-1),'b','LineWidth',2)
hold on
box off
plot(Data_gaps(:,(deleteMarker)*3-1),'k','LineWidth',2)
plot(ReconstructedFullDataSet(:,(deleteMarker)*3-1),'r','LineWidth',2)
ylabel('Y [mm]','FontSize',14,'FontWeight','bold')

subplot(3,1,3)
plot(Data(:,(deleteMarker)*3),'b','LineWidth',2)
hold on
box off
plot(Data_gaps(:,(deleteMarker)*3),'k','LineWidth',2)
plot(ReconstructedFullDataSet(:,(deleteMarker)*3),'r','LineWidth',2)
ylabel('Z [mm]','FontSize',14,'FontWeight','bold')
xlabel('frame number','FontSize',14,'FontWeight','bold')
end

