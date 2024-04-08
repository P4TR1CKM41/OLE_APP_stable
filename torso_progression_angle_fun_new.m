function [theta_deg] = torso_progression_angle_fun_new(fersenmarker_at_TD,mid_point_mtp_at_TD, com_velocity_at_TD, grafic)
% % % mid_point_mtp_at_TD = [300,-500,0]
%% ploten der marker und des COM vectors von "oben"

%% rotate the COM to match with c3d CS
R_x = [1, 0, 0;
    0, cos(pi/2), -sin(pi/2);
    0, sin(pi/2), cos(pi/2)];
rotated_marker_position_com = R_x * com_velocity_at_TD';
rotated_marker_position_com = rotated_marker_position_com';



% Define vectors representing the two lines
v = [mid_point_mtp_at_TD(1)-fersenmarker_at_TD(1); mid_point_mtp_at_TD(2)-fersenmarker_at_TD(2)]; % Replace x1 and y1 with the coordinates of a point on the first line
w = [rotated_marker_position_com(1)*100; rotated_marker_position_com(2)*100]; % Replace x2 and y2 with the coordinates of a point on the second line

% Compute the angle between the vectors
cos_theta = dot(v, w) / (norm(v) * norm(w));
theta = acos(cos_theta);

% Determine the sign of the angle based on the direction of rotation
cross_product = v(1)*w(2) - v(2)*w(1);
if cross_product < 0
    theta = -theta; % clockwise rotation
end
theta_deg = rad2deg(theta);
if grafic ==1
    close all
    scatter(mid_point_mtp_at_TD(1), mid_point_mtp_at_TD(2), 'filled', 'MarkerFaceColor','k')
    hold on
    text (mid_point_mtp_at_TD(1), mid_point_mtp_at_TD(2), 'Mipoint MTP')
    scatter(fersenmarker_at_TD(1), fersenmarker_at_TD(2), 'filled', 'MarkerFaceColor','k')
    text (fersenmarker_at_TD(1), fersenmarker_at_TD(2), 'Heel')
    plot([mid_point_mtp_at_TD(1), fersenmarker_at_TD(1)], [mid_point_mtp_at_TD(2),fersenmarker_at_TD(2)], 'k')
    scatter (0,0, 'filled', 'MarkerFaceColor','r')

    scatter (rotated_marker_position_com(1), rotated_marker_position_com(2), 'filled', 'MarkerFaceColor','b')
    plot([0, rotated_marker_position_com(1)*100], [0, rotated_marker_position_com(2)*100], 'b')
    text (0,0, 'CoM')
    quiver(0, 0, v(1), v(2), 0, 'b', 'LineWidth', 2); hold on;
    quiver(0, 0, w(1), w(2), 0, 'r', 'LineWidth', 2);

    % Plot the angle between the vectors
    arc_radius = 1.5; % adjust for your visualization

    theta_range = linspace(0, theta, 100);
    arc_x = arc_radius * cos(theta_range);
    arc_y = arc_radius * sin(theta_range);
    fill([v(1), 0, w(1)], [v(2), 0, w(2)], 'g', 'FaceAlpha', 0.3);

    % Set axis limits and labels
    axis equal;
    % xlim([-1, max([v(1), w(1)]) + 1]);
    % ylim([-1, max([v(2), w(2)]) + 1]);
    xlabel('X');
    ylabel('Y');
    title(['Angle between vectors: ', num2str(theta_deg), ' degrees']);
    legend('Vector v', 'Vector w', 'Angle');
else
end

end