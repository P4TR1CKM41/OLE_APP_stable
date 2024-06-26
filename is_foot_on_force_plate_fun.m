function [use] = is_foot_on_force_plate_fun(markerset,marker_set_up_identifier, corner_points_of_fp_used, TD_marker, TD_force, MARKERS, leg, plot)

%% Get the marker names of the the current marker set up for
row_num = find(contains((markerset.FOOT(:,1)),marker_set_up_identifier)==1);

if strcmp(leg, 'Right') ==1
    USED_MARKER_NAMES.(markerset.FOOT{row_num,2}) = markerset.FOOT{row_num,2};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,3})  = markerset.FOOT{row_num,3};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,4})  = markerset.FOOT{row_num,4};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,5})  = markerset.FOOT{row_num,5};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,6})  = markerset.FOOT{row_num,6};
    try
        USED_MARKER_NAMES.(markerset.FOOT{row_num,7})  = markerset.FOOT{row_num,7};
    end
    try
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,8}) = MARKERS.(markerset.FOOT{row_num,8})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,9}) = MARKERS.(markerset.FOOT{row_num,9})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,10}) = MARKERS.(markerset.FOOT{row_num,10})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,11}) = MARKERS.(markerset.FOOT{row_num,11})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,12}) = MARKERS.(markerset.FOOT{row_num,12})(TD_marker,:);
        try
            OPPOSITE_MARKERS.(markerset.FOOT{row_num,13}) = MARKERS.(markerset.FOOT{row_num,13})(TD_marker,:);
        end
    end
else
    USED_MARKER_NAMES.(markerset.FOOT{row_num,8}) = markerset.FOOT{row_num,8};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,9})  = markerset.FOOT{row_num,9};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,10})  = markerset.FOOT{row_num,10};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,11})  = markerset.FOOT{row_num,11};
    USED_MARKER_NAMES.(markerset.FOOT{row_num,12})  = markerset.FOOT{row_num,12};
    try
        USED_MARKER_NAMES.(markerset.FOOT{row_num,13})  = markerset.FOOT{row_num,13};
    end
    try
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,2}) = MARKERS.(markerset.FOOT{row_num,2})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,3}) = MARKERS.(markerset.FOOT{row_num,3})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,4}) = MARKERS.(markerset.FOOT{row_num,4})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,5}) = MARKERS.(markerset.FOOT{row_num,5})(TD_marker,:);
        OPPOSITE_MARKERS.(markerset.FOOT{row_num,6}) = MARKERS.(markerset.FOOT{row_num,6})(TD_marker,:);
        try
            OPPOSITE_MARKERS.(markerset.FOOT{row_num,7}) = MARKERS.(markerset.FOOT{row_num,7})(TD_marker,:);
        end
    end
end

%% now get the X and Z components of the markers at TD (OpenSim CS)
namen = fieldnames (USED_MARKER_NAMES);
for n = 1 : length (namen)
    MARKERS.(namen{n, 1})(TD_marker,[1,3]);
    % scatter(MARKERS.(namen{n, 1})(TD_marker,1), MARKERS.(namen{n, 1})(TD_marker,2))
    M(:,n) = [MARKERS.(namen{n, 1})(TD_marker,1), MARKERS.(namen{n, 1})(TD_marker,2)]';
    % hold on
    if n == length(namen)
        % scatter(corner_points_of_fp_used(1,1), corner_points_of_fp_used(2,1), 'filled')
        % scatter(corner_points_of_fp_used(1,2), corner_points_of_fp_used(2,2), 'filled')
        % scatter(corner_points_of_fp_used(1,3), corner_points_of_fp_used(2,3), 'filled')
        % scatter(corner_points_of_fp_used(1,4), corner_points_of_fp_used(2,4), 'filled')
        FP(:,1) = [[corner_points_of_fp_used(1,1), corner_points_of_fp_used(2,1)]'];
        FP(:,2) = [[corner_points_of_fp_used(1,2), corner_points_of_fp_used(2,2)]'];
        FP(:,3) = [[corner_points_of_fp_used(1,3), corner_points_of_fp_used(2,3)]'];
        FP(:,4) = [[corner_points_of_fp_used(1,4), corner_points_of_fp_used(2,4)]'];
    end
end
a = 2;

[in , out]= inpolygon(M(1,:),M(2,:),FP(1,:),FP(2,:));

X_pairtocheck=M(1,:)';
Y_pairtocheck=M(2,:)';
if length(find (in ==0) )>=1
    if plot ==1
        figure()

        plot(FP(1,:),FP(2,:), linewidth =3) % polygon
        axis equal

        hold on
        plot(X_pairtocheck(in),Y_pairtocheck(in),'r+') % points inside
        plot(X_pairtocheck(~in),Y_pairtocheck(~in),'bo') % points outside
        box off
    else
    end
    use=0;
else
    use=1;
end
try
    [answer] = is_the_other_foot_at_the_active_FP(OPPOSITE_MARKERS, corner_points_of_fp_used)
catch
end
end