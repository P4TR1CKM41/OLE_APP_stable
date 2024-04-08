function [angle_deg] = get_angle_between_two_planes(plane1,plane2)
% Extract normal vectors and constants from plane equations
normal_vector1 = plane1(1:3);
d1 = plane1(4);

normal_vector2 = plane2(1:3);
d2 = plane2(4);

% Calculate the dot product of the normal vectors
dot_product = dot(normal_vector1, normal_vector2);

% Calculate the magnitude of the normal vectors
magnitude1 = norm(normal_vector1);
magnitude2 = norm(normal_vector2);

% Calculate the angle between the planes using the dot product formula
angle_rad = acos(dot_product / (magnitude1 * magnitude2));

% Convert angle from radians to degrees
angle_deg = rad2deg(angle_rad);

end