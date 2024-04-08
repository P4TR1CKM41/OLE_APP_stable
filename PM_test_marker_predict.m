
clc
clear all
close all

load('C:\Users\pmai\Desktop\Handballfinter2021\P00X\P00X.mat')



MARKERARRY  = [MARKERS.Cutting11.Raw.cluster_tibia_right_1.data', MARKERS.Cutting11.Raw.cluster_tibia_right_2.data', MARKERS.Cutting11.Raw.cluster_tibia_right_3.data', MARKERS.Cutting11.Raw.cluster_tibia_right_4.data']
MARKERARRYORI = MARKERARRY;
MARKERARRY(30:end,1:3) =NaN;
% MARKERARRY(50:51,4:6) =NaN;
[ReconstructedFullDataSet] = PredictMissingMarkers(MARKERARRY, [3 ,4])


figure(1)

plot(MARKERARRY(:,1:3),'r',lineWidth=10)

hold on
plot(MARKERARRYORI(:,1:3),'g', LineWidth=3)

plot(ReconstructedFullDataSet(:,1:3),'b')
