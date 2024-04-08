function angle = calculate_angle(foot_markers, floor_markers)
% Define the equations of the two planes
plane1 = [a1, b1, c1, d1]; % Coefficients of plane 1: ax + by + cz + d = 0
plane2 = [a2, b2, c2, d2]; % Coefficients of plane 2: ax + by + cz + d = 0

% Extract normal vectors and constants from plane equations
normal_vector1 = plane1(1:3);
d1 = plane1(4);

normal_vector2 = plane2(1:3);
d2 = plane2(4);

% Calculate the dot product of the normal vectors
dot_product = dot(normal_vector1, normal_vector2);

% If the dot product is negative, it means the planes are facing in opposite directions
% In this case, we invert the direction of one of the normal vectors
if dot_product < 0
    normal_vector2 = -normal_vector2;
    d2 = -d2;
end

% Calculate the angle between the planes using the dot product formula
angle_rad = acos(dot(normal_vector1, normal_vector2) / (norm(normal_vector1) * norm(normal_vector2)));

% Determine the foot strike orientation based on the sign of the angle
if angle_rad < pi/2  % Foot pointing downward, indicating a rearfoot strike
    angle_deg = -rad2deg(angle_rad);
else  % Foot pointing upward, indicating a forefoot strike
    angle_deg = rad2deg(angle_rad);
end



end