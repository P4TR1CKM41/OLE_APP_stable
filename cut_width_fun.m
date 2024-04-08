function [cut_width] = cut_width_fun(CP,CMPOS, CMVEL)
% Define the coordinates of the center of pressure (CP) and the center of mass (CM)
% CP = [CP_x, CP_y, CP_z]; % Replace CP_x, CP_y, CP_z with actual values
% CM = [CM_x, CM_y, CM_z]; % Replace CM_x, CM_y, CM_z with actual values
close all
R_x = [1, 0, 0;
    0, cos(pi/2), -sin(pi/2);
    0, sin(pi/2), cos(pi/2)];
CP = R_x * CP';
CMPOS = R_x * CMPOS';
CMVEL = R_x * CMVEL';
CP =CP';
CMPOS_pro =[CMPOS(1), CMPOS(2), 0];
CMPOS =CMPOS';
CMVEL =CMVEL';
%% define plane
% Calculate the normal vector of the plane
normal = cross(CMPOS_pro - CMPOS, CMVEL);

% Normalize the normal vector
normal = normal / norm(normal);

% Calculate the vector from the center of pressure to the center of mass
vector_CP_to_CM = CMPOS - CP;

% Calculate the vertical vector in the plane perpendicular to the direction of movement
% This is a cross product of CMVEL and vector_CP_to_CM, then cross product of the result with CMVEL to ensure perpendicularity
vertical_vector = cross(CMVEL, vector_CP_to_CM);
vertical_vector = cross(vertical_vector, CMVEL);
vertical_vector = vertical_vector / norm(vertical_vector); % Normalize to unit length

% Calculate the dot product and the angle
dot_product = dot(vector_CP_to_CM, vertical_vector);
magnitude_CP_to_CM = norm(vector_CP_to_CM);
cos_angle = dot_product / magnitude_CP_to_CM;  % vertical_vector is unit length
angle_radians = acos(cos_angle);

% Convert the angle to degrees
cut_width = rad2deg(angle_radians);

% Visualization
figure;
hold on;

% Plot the centers as points
plot3(CP(1), CP(2), CP(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Center of Pressure');
plot3(CMPOS(1), CMPOS(2), CMPOS(3), 'bo', 'MarkerSize', 10, 'DisplayName', 'Center of Mass');
plot3(CMPOS(1), CMPOS(2), CMPOS(3), 'bo', 'MarkerSize', 10, 'DisplayName', 'Center of Mass');
plot3(CMPOS_pro(1), CMPOS_pro(2), CMPOS_pro(3), 'ko', 'MarkerSize', 10, 'DisplayName', 'Center of Mass');

% Plot the vectors
quiver3(CP(1), CP(2), CP(3), vector_CP_to_CM(1), vector_CP_to_CM(2), vector_CP_to_CM(3), 'k', 'DisplayName', 'CP to CM Vector');
quiver3(CP(1), CP(2), CP(3), vertical_vector(1), vertical_vector(2), vertical_vector(3), 'g', 'DisplayName', 'Vertical Vector');

% Draw arc for angle visualization
arc_radius = 0.5 * magnitude_CP_to_CM;
arc_angle = linspace(0, angle_radians, 100);
arc_x = CP(1) + arc_radius * cos(arc_angle);
arc_y = CP(2) + arc_radius * sin(arc_angle);
arc_z = CP(3) + zeros(size(arc_x));  % Adjust this line if in 3D
plot3(arc_x, arc_y, arc_z, 'r-', 'LineWidth', 2, 'DisplayName', 'Cut Width Angle');

legend;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Visualization of the Cut Width Angle');
grid on;
axis equal;

% Visualize the plane
[x, y] = meshgrid(linspace(min([CMPOS(1), CMPOS_pro(1)]), max([CMPOS(1), CMPOS_pro(1)]), 10), ...
                  linspace(min([CMPOS(2), CMPOS_pro(2)]), max([CMPOS(2), CMPOS_pro(2)]), 10));
z = (-normal(1)*(x - CMPOS(1)) - normal(2)*(y - CMPOS(2))) / normal(3) + CMPOS(3);


surf(x*100, y*100, zeros(10,10), 'FaceAlpha', 0.5);  % Plot the surface representing the plane
view(3);




end