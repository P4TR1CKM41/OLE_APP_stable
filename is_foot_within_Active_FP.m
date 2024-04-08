function [use] = is_foot_within_Active_FP(MARKERS,naefilename_global,filename, Active_FP, legside)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = load(filename);
structname = fieldnames(data); 
data.(structname{1, 1}); 
Active_FP = str2num(Active_FP);

F = data.(structname{1, 1}).Force(Active_FP).Force(3,:)*-1; 

FP_loc_x = data.(structname{1, 1}).Force(Active_FP).ForcePlateLocation(:,1); 
FP_loc_y= data.(structname{1, 1}).Force(Active_FP).ForcePlateLocation(:,2);

pat = F > 30;
vd = diff([0 pat 0]);
starts = find(vd == 1);
ends = find(vd == -1); 
[longest_streak, idx] = max(ends-starts);
TD_analog= starts(idx);
TD_Kinematic = fix(TD_analog/(data.(structname{1, 1}).Force(Active_FP).Frequency /data.(structname{1, 1}).FrameRate));


if strcmp (legside, 'Right')

  markernames={'forfoot_med_right', 'forfoot_lat_right', 'toe_right','calc_back_right', 'calc_lat_right', 'calc_med_right'};
else 
  markernames={'forefoot_med_left', 'forefoot_lat_left', 'toe_left','calc_back_left', 'calc_lat_left', 'calc_med_left'};
end

for i = 1: length(markernames)
X_pairtocheck(i,1) = MARKERS.(naefilename_global).Filt.(markernames{1, i}).data(1, TD_Kinematic);

Y_pairtocheck(i,1) = MARKERS.(naefilename_global).Filt.(markernames{1, i}).data(2, TD_Kinematic);
end


[in , out]= inpolygon(X_pairtocheck,Y_pairtocheck,FP_loc_x,FP_loc_y);


if length(find (in ==0) )>=1

figure

plot(FP_loc_x,FP_loc_y, linewidth =3) % polygon
axis equal

hold on
plot(X_pairtocheck(in),Y_pairtocheck(in),'r+') % points inside
plot(X_pairtocheck(~in),Y_pairtocheck(~in),'bo') % points outside
box off
title ([naefilename_global], 'interpreter', 'none')
use=0;
else
use=1;
end
