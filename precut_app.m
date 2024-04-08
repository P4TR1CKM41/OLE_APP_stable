function precut_app(path_to_dyn_file, fp)
%  PRECUT_APP This function takes the path of the given .mat-file which is the uncut version 
% of the QTM output.
% 
% Touchdown and toe off will be taken and 200 frames before and afterwards added 
% to ensure enough buffer for Motrack. 
% path_to_dyn_file = "C:\Users\markur\Desktop\TestFolder\Cutting 19_long.mat";
% path_to_dyn_file = "C:\Users\Markus\Desktop\TestFolder\Cutting 19_long.mat";
%% 
% Load the respective *.mat-file to get all the necessary data to cut it.
mainStruct = load(path_to_dyn_file);
name = string(fieldnames(mainStruct));
%% 
% Preallocate certain variables for later usage.
ftkratio = mainStruct.(name).Force(fp).SamplingFactor;
% use the above for the final function (dynamic choice of fp)
% ftkratio = mainStruct.(name).Force(2).SamplingFactor;
% start = mainStruct. (name).StartFrame;
ende = mainStruct.(name).Frames;
ende_analog = ende*ftkratio;
%% 
% Export the raw force data and fill missing NaN values at the end with the 
% 
% previous values to have force data without NaNs.
force_raw = mainStruct.(name).Force(fp).Force(3, :)*-1;
% % % % % % % % % % use the above for the final function (dynamic choice of fp)
% % % % % % % % % % force_raw = mainStruct.(name).Force(2).Force(3, :)*-1;
force_raw = fillmissing(force_raw, 'previous');
% % % % % % % % % [~, force_peak] = max(force_raw);
% % % % % % % % % %% 
% % % % % % % % % % Find the start of the manouver and add 200 frames as a security.
% % % % % % % % % for n = force_peak:-1:1
% % % % % % % % %     % Add another condition to return to the main function if trial is
% % % % % % % % %     % already cutted.
% % % % % % % % %     if force_raw(n) <= 20
% % % % % % % % %         %         sf_analog = n;
% % % % % % % % %         secure_n = n - 200;
% % % % % % % % %         sf_video = fix((secure_n + ftkratio - 1)/ftkratio);
% % % % % % % % %         %         if sf_video < start
% % % % % % % % %         %             return
% % % % % % % % %         %         end
% % % % % % % % %         break
% % % % % % % % %     end
% % % % % % % % % end
% % % % % % % % % %% 
% % % % % % % % % % Find the end of the manouver and add 200 frames as a security.
% % % % % % % % % for n = force_peak:1:ende_analog
% % % % % % % % %     % Add another condition to return to the main function if trial is
% % % % % % % % %     % already cutted.
% % % % % % % % %     if force_raw(n) <= 20
% % % % % % % % %         %         ef_analog = n;
% % % % % % % % %         secure_n = n + 200;
% % % % % % % % %         ef_video = fix((secure_n + ftkratio - 1)/ftkratio);
% % % % % % % % %         %         if ef_video > ende_analog
% % % % % % % % %         %             return
% % % % % % % % %         %         end
% % % % % % % % %         break
% % % % % % % % %     end
% % % % % % % % % end
% % % % % % % % % %% 
% Create data struct for the new file and copy all non-timeseries data to
%% PM methode 
F = force_raw;
pat = F > 30;
vd = diff([0 pat 0]);
starts = find(vd == 1);
ends = find(vd == -1); 
[longest_streak, idx] = max(ends-starts);
location = starts(idx)-50;
locationend = ends(idx)+50;
sf_video = fix(location/ftkratio);
ef_video =fix(locationend/ftkratio);
% % % plot(F(location:locationend))
% the new struct for the cutted file
tmpStruct = struct;
tmpStruct.(name).File = mainStruct.(name).File;
tmpStruct.(name).Timestamp = mainStruct.(name).Timestamp;
tmpStruct.(name).StartFrame = sf_video;
tmpStruct.(name).Frames = ef_video-sf_video+1;
tmpStruct.(name).FrameRate = mainStruct.(name).FrameRate;
tmpStruct.(name).Trajectories.Labeled.Labels = mainStruct.(name).Trajectories.Labeled.Labels;
tmpStruct.(name).Trajectories.Labeled.Count = mainStruct.(name).Trajectories.Labeled.Count;
%% 
% Loop through the fps to get all of them.
for n = 1:length(mainStruct.(name).Force)
    tmpStruct.(name).Force(n).ForcePlateName = mainStruct.(name).Force(n).ForcePlateName;
    tmpStruct.(name).Force(n).SamplingFactor = mainStruct.(name).Force(n).SamplingFactor;
    tmpStruct.(name).Force(n).Frequency = mainStruct.(name).Force(n).Frequency;
    tmpStruct.(name).Force(n).ForcePlateLocation = mainStruct.(name).Force(n).ForcePlateLocation;
    tmpStruct.(name).Force(n).ForcePlateOrientation = mainStruct.(name).Force(n).ForcePlateOrientation;
end
%% 
% Now cut the timeseries parameters to the given length of the trial.
tmpStruct.(name).Trajectories.Labeled.Data = mainStruct.(name).Trajectories.Labeled.Data(:, :,...
    sf_video:ef_video);
%% 
% Loop again through the fps to cut the parameters to the final length.
for n = 1:length(mainStruct.(name).Force)
    tmpStruct.(name).Force(n).Force = mainStruct.(name).Force(n).Force(:, ...
        sf_video*(ftkratio)-(ftkratio - 1):ef_video*(ftkratio));
    tmpStruct.(name).Force(n).Moment = mainStruct.(name).Force(n).Moment(:, ...
        sf_video*(ftkratio)-(ftkratio - 1):ef_video*(ftkratio));
    tmpStruct.(name).Force(n).COP = mainStruct.(name).Force(n).COP(:, ...
        sf_video*(ftkratio)-(ftkratio - 1):ef_video*(ftkratio));
end
%% 
% Use the commented line for testing the code.
% save('C:\Users\Markus\Desktop\testfile_cutted.mat', '-struct', 'tmpStruct')
save(path_to_dyn_file, '-struct', 'tmpStruct')
end