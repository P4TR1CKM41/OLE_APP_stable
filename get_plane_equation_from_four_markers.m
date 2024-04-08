function [a,b,c,d] = get_plane_equation_from_four_markers(marker1, marker2,marker3,marker4)
% Define marker positions


% Create vectors lying in the plane
vector1 = marker2 - marker1;
vector2 = marker3 - marker1;

% Calculate the normal vector of the plane
normal_vector = cross(vector1, vector2);

% Normalize the normal vector
normal_vector = normal_vector / norm(normal_vector);

% Define the plane equation using one of the markers and the normal vector
% The equation of a plane is ax + by + cz + d = 0, where [a, b, c] is the normal vector and (x0, y0, z0) is a point on the plane
a = normal_vector(1);
b = normal_vector(2);
c = normal_vector(3);
x0 = marker1(1);
y0 = marker1(2);
z0 = marker1(3);

% Calculate d
d = - (a*x0 + b*y0 + c*z0);

% The plane equation is ax + by + cz + d = 0


end