function [foot_progression_angle] = foot_progression_angle_fun(T,H,COM_velocity)

% Velocity vector of the center of mass (COM)

% Normalize the COM velocity vector and ensure it is always positive in the forward direction
COM_direction = [COM_velocity(1), COM_velocity(2), 0];
if COM_direction(1) < 0  % Assuming the x-axis represents forward motion
    COM_direction = -COM_direction;
end
COM_direction = COM_direction / norm(COM_direction);

% Calculate the foot's long axis projection on the ground plane
foot_vector = T - H;
foot_direction = [foot_vector(1), foot_vector(2), 0];  % Project onto ground plane
foot_direction = foot_direction / norm(foot_direction);

% Calculate the angle between the foot direction and COM direction vectors
dot_product = dot(foot_direction, COM_direction);
cos_theta = dot_product / (norm(foot_direction) * norm(COM_direction));
foot_progression_angle = acosd(cos_theta);  % Angle in degrees

% Determine the direction of the angle
cross_product = cross(foot_direction, COM_direction);
if cross_product(3) > 0
    foot_progression_angle = -foot_progression_angle;
end



end