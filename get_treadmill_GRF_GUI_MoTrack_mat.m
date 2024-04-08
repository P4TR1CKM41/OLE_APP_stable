function [COP, COP_vid, GRFfilt,GRFfilt_vid, FM, ind_baseline, O] = get_treadmill_GRF_GUI_MoTrack_mat(file, OPTIONS, baseline_correct)

 close all
% clc
% [filename, pathname] = uigetfile('*.c3d', 'Daten her', 'C:\TextBL\Cond1\S001_test\');
% file = [pathname, filename];
% order = [2;1;3;5;4;6;8;7;9;11;10;12];
exp_flight = 40;
% origins = [354 ,	535 ,	43]./1000;

%% Filter coefficients
[b,a] = butter(2, OPTIONS.CutOffGRF/(OPTIONS.freqGRF/2), 'low');
[bp,ap] = butter(2, 10/(OPTIONS.freqGRF/2), 'low');
%% Read in Analog Channels for BAseline Correction
%% Express data into Newtons
% Step 1: convert to Volts
% % acq = btkReadAcquisition(file);
% % [analogs, analogsInfo] = btkGetAnalogs(acq);
% % force = [analogs.F1X,analogs.F1Y,analogs.F1Z,analogs.M1X,analogs.M1Y,analogs.M1Z,analogs.F2X,analogs.F2Y,analogs.F2Z,analogs.M2X,analogs.M2Y,analogs.M2Z];
% % range = 10; % +/- 5V
% % resolution = 16; % resolution [bits]
% force = force*range/(2^resolution);
 
% Step 2: convert to Newtons
% force(:,[1:2 7:8]) = force(:,[1:2 7:8])*500; % Fx and Fy of forceplates 1 and 2
% force(:,[3 9]) = force(:,[3 9])*1000; % Fz of forceplates 1 and 2
% force(:,[4 10]) = force(:,[4 10])*800; % these are moments x from forceplates 1 and 2
% force(:,[5 6 11 12]) = force(:,[5 6 11 12])*400; % these are moments y,z from forceplates 1 and 2
 
data = load (file);
structname = fieldnames (data);
data.(structname{1, 1});


force(:,[1:2]) = data.(structname{1, 1}).Force(1).Force([1,2], :)'*-1; 
force(:,[7:8]) = data.(structname{1, 1}).Force(2).Force([1,2], :)'*-1;
force(:,[3]) = data.(structname{1, 1}).Force(1).Force([3], :)'*-1;
force(:,[9]) = data.(structname{1, 1}).Force(2).Force([3], :)'*-1;
force(:,[4]) = data.(structname{1, 1}).Force(1).Moment([1], :)';
force(:,[10]) = data.(structname{1, 1}).Force(2).Moment([1], :)';
force(:,[5]) = data.(structname{1, 1}).Force(1).Moment([2], :)';
force(:,[6]) = data.(structname{1, 1}).Force(1).Moment([3], :)';
force(:,[11]) = data.(structname{1, 1}).Force(2).Moment([2], :)';
force(:,[12]) = data.(structname{1, 1}).Force(2).Moment([3], :)';


%% NANs in file replace with zeros
force(isnan(force))=0;


% % % % %  Labels = data.(structname{1, 1}).Trajectories.Labeled.Labels';
% % % % %         
% % % % %         for n = 1:length(Labels)
% % % % %             Markers.(Labels{n}).data = squeeze(data.(structname{1, 1}).Trajectories.Labeled.Data(n, 1:3, :));
% % % % %         end
% % % % % 
% % % % %         figure(19)
% % % % %         for p = 79 : 79
% % % % %             scatter3(Markers.toe_right.data(1,p), Markers.toe_right.data(2,p), Markers.toe_right.data(3,p), 'filled', 'r')
% % % % %             hold on
% % % % %             scatter3(Markers.forefoot_med_right.data(1,p), Markers.forefoot_med_right.data(2,p), Markers.forefoot_med_right.data(3,p), 'filled', 'r')
% % % % %             scatter3(Markers.forefoot_lat_right.data(1,p), Markers.forefoot_lat_right.data(2,p), Markers.forefoot_lat_right.data(3,p), 'filled', 'r')
% % % % % 
% % % % % 
% % % % %             scatter3(Markers.calc_med_right.data(1,p), Markers.calc_med_right.data(2,p), Markers.calc_med_right.data(3,p), 'filled', 'k')
% % % % %             scatter3(Markers.calc_lat_right.data(1,p), Markers.calc_lat_right.data(2,p), Markers.calc_lat_right.data(3,p), 'filled', 'g')
% % % % %             scatter3(Markers.calc_back_right.data(1,p), Markers.calc_back_right.data(2,p), Markers.calc_back_right.data(3,p), 'filled', 'g')
% % % % % 
% % % % %             scatter3(Markers.epi_med_right.data(1,p), Markers.epi_med_right.data(2,p), Markers.epi_med_right.data(3,p), 'filled', 'k')
% % % % %             scatter3(Markers.epi_lat_right.data(1,p), Markers.epi_lat_right.data(2,p), Markers.epi_lat_right.data(3,p), 'filled', 'g')
% % % % % 
% % % % % 
% % % % %             quiver3(data.(structname{1, 1}).Force(2).COP(1,p*OPTIONS.ftkratio), data.(structname{1, 1}).Force(2).COP(2,p*OPTIONS.ftkratio), data.(structname{1, 1}).Force(2).COP(3,p*OPTIONS.ftkratio), -1*data.(structname{1, 1}).Force(2).Force(1,p*OPTIONS.ftkratio), -1*data.(structname{1, 1}).Force(2).Force(2,p*OPTIONS.ftkratio), -1*data.(structname{1, 1}).Force(2).Force(3,p*OPTIONS.ftkratio))
% % % % % view(160,20)
% % % % %             axis equal
% % % % %         end

run = 1;
for i = 6*OPTIONS.ForcePlateNumber-3
    A  =force(:,i);
    Afilt(:,run) = filtfilt(bp,ap,double(force(:,i)));
    run = run+1;
end
% Fzbl = sum(A,2);
Fzbl = -sum(A,2);
Fzbl_filt = -sum(Afilt,2);
% figure
% plot(Fzbl)
% hold on
% plot(Fzbl_filt, 'r');
upperlimit = min(Fzbl_filt) + 100;
ind_low = find(Fzbl_filt < upperlimit);
if ~isempty(find(diff(ind_low) > 100))
    steps(1,:) = find(diff(ind_low) > 100);
    for i = 1:length(steps)
        stepsreal(1,i) = ind_low(steps(i));
        stepsreal(2,i) = 1;
        for j = stepsreal(1,i):-1:1
            if Fzbl(j) > upperlimit
                stepsreal(2,i) = j;
                break
            end
        end
    end
    for i = 1:length(stepsreal)
        barriers(1,i) = stepsreal(2,i) + round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
        barriers(2,i) = stepsreal(1,i) - round(((stepsreal(1,i)-stepsreal(2,i)) -  exp_flight) / 2);
    end
%     for i = 1:length(steps)
%        plot([stepsreal(1,i) stepsreal(1,i)], get(gca, 'YLim'), 'k');
%        plot([stepsreal(2,i) stepsreal(2,i)], get(gca, 'YLim'), 'k');
%        plot([barriers(1,i) barriers(1,i)], get(gca, 'YLim'), 'g');
%        plot([barriers(2,i) barriers(2,i)], get(gca, 'YLim'), 'g');
%     end
%     plot(get(gca, 'Xlim'), [upperlimit upperlimit], 'k');
%     assignin('base', 'ind_low', ind_low);
%     assignin('base', 'steps', steps);
%     assignin('base', 'stepsreal', stepsreal);
%     assignin('base', 'barriers', barriers);
%     pause
    
    barriervalues = [];
    for i = 1:length(barriers)-1
        barriervalues = [barriervalues, [barriers(1,i+1):barriers(2,i+1)]];
    end
else
    barriervalues = 1:length(Fzbl);
end
assignin('base', 'barriervalues', barriervalues);



%% Baseline correction
baseline_correct = 0;
O = mean(force(barriervalues,:),1);
for i = 1:12
    if baseline_correct
        force(:,i) = force(:,i) - O(i);
    end
end


%% Filter Analog Channels


for i = 1:12
    FF(i,:) = filtfilt(b,a,double(force(:,i)))';
end

%% Rotate forces to MoTrack Global Coordinate System
% % % Rforce = [0 1 0;1 0 0;0 0 -1];
% % % for i = 1:3:12
% % %    for j = 1:size(force,1)
% % %        Frot(i:i+2,j) = Rforce'*FF(i:i+2,j);
% % %    end
% % % end
Frot=FF; 
% % % % 
% % % % %% CoP berechnen
% % % % for j = 1:size(Frot,2)
% % % %     CoP1(1,j) = ((-0.015*Frot(7,j)+Frot(11,j)) / -Frot(9,j)).*1000 ;
% % % %     CoP1(2,j) = ((0.015*Frot(8,j)+Frot(10,j)) / Frot(9,j)).*1000;
% % % %     CoP1(3,j) = 0;
% % % % end

%% CoP from mat file in Global
CoP1 =data.(structname{1, 1}).Force(1).COP(:, :);
% NANs in file replace with zeros
CoP1(isnan(CoP1))=0;
CoP2 =data.(structname{1, 1}).Force(2).COP(:, :);
% NANs in file replace with zeros
CoP2(isnan(CoP2))=0;

% OPTIONS.CutOffGRF
[bp,ap] = butter(2, 10/(OPTIONS.freqGRF/2), 'low'); 

CoP2(1,:) = filtfilt(bp,ap,double(CoP2(1,:)));
CoP2(2,:) = filtfilt(bp,ap,double(CoP2(2,:)));
CoP2(3,:) = filtfilt(bp,ap,double(CoP2(3,:)));

%% filter COPs

%% Free Moment berechnen
FMtemp = Frot(12,:) - Frot(8,:).*(CoP1(1,:)./1000) + Frot(7,:).*(CoP1(2,:)./1000);

FMtemp = Frot(12,:) - Frot(8,:).*(CoP2(1,:)./1000) + Frot(7,:).*(CoP2(2,:)./1000);


%% Parameter zusammenfassen zu Output
for p  =1:size(CoP1, 2)
    COP.Both(:,p) = CoP1(:,p) + [-1627; -1180; 0];
end
GRFfilt.Both = Frot(7:9,:);
FM.Both = [zeros(1,length(FMtemp)); zeros(1,length(FMtemp)); FMtemp];
COP.Both = CoP2; 
try
    ind_baseline = barriers;
catch
   ind_baseline = 1:length(FM.Both); 
end

GRFfilt_vid.Both = GRFfilt.Both(:,1:OPTIONS.ftkratio:end);
COP_vid.Both = COP.Both(:,1:OPTIONS.ftkratio:end);



