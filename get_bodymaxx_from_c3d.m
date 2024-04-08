function [mass] = get_bodymaxx_from_c3d(static_c3d_path)


acq = btkReadAcquisition(static_c3d_path);
fpw = btkGetForcePlatformWrenches(acq);
[nofps, ~] = size (fpw);
for p  = 1 : nofps
    bodyweight(p,1) = nanmean(fpw(p).F(:,end));
end

btkCloseAcquisition(acq)
mass  = sum(bodyweight)/9.81;
end