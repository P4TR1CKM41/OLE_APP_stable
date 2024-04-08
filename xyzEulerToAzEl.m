function [azimuth, elevation] = xyzEulerToAzEl(alpha, beta, gamma)
    % Convert Euler angles from X-Y-Z sequence to azimuth and elevation
    % angles. Input angles alpha, beta, gamma should be in radians.

    % Rotation matrices for each axis
    Rx = [1, 0, 0; 0, cos(alpha), -sin(alpha); 0, sin(alpha), cos(alpha)];
    Ry = [cos(beta), 0, sin(beta); 0, 1, 0; -sin(beta), 0, cos(beta)];
    Rz = [cos(gamma), -sin(gamma), 0; sin(gamma), cos(gamma), 0; 0, 0, 1];

    % Combined rotation matrix
    R = Rx * Ry * Rz;

    % Assuming the "forward" vector in the original orientation is along the Z-axis
    forwardVector = R * [0; 0; 1];

    % Convert to spherical coordinates
    x = forwardVector(1);
    y = forwardVector(2);
    z = forwardVector(3);

    azimuth = atan2(y, x);
    elevation = atan2(z, sqrt(x^2 + y^2));

    % Convert radians to degrees if necessary
    % azimuth = rad2deg(azimuth);
    % elevation = rad2deg(elevation);
end