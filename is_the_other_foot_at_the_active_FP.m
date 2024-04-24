function [answer] = is_the_other_foot_at_the_active_FP(markers_opposite_leg, corner_points_of_fp_used)


namen = fieldnames (markers_opposite_leg);
for n = 1 : length (namen)

    % scatter(MARKERS.(namen{n, 1})(TD_marker,1), MARKERS.(namen{n, 1})(TD_marker,2))
    M(:,n) = [markers_opposite_leg.(namen{n, 1})(1,1), markers_opposite_leg.(namen{n, 1})(1,2)]';
    M_height(:,n) = [markers_opposite_leg.(namen{n, 1})(1,3)]';
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


[in , out]= inpolygon(M(1,:),M(2,:),FP(1,:),FP(2,:));

X_pairtocheck=M(1,:)';
Y_pairtocheck=M(2,:)';



%% how check the z height of each marker
if length(find (in>=1)) >0
    % figure()
    % plot(FP(1,:),FP(2,:), linewidth =3) % polygon
    % axis equal
    % hold on
    % plot(X_pairtocheck(in),Y_pairtocheck(in),'r+') % points inside
    % plot(X_pairtocheck(~in),Y_pairtocheck(~in),'bo') % points outside
    % box off
    if length(find (M_height <= mean(corner_points_of_fp_used(3,:)))) ==0
        answer = 0;
    else
        answer = 1;
    end
else
    answer = 0;
end

end