function [theta] = kevin_foot_strike_pattern(H,T)
% Coordinates of heel (H) and toe (T) markers

% Calculate the foot vector
foot_vector = T - H;

% Project the foot vector onto the ground plane (assuming ground plane is XY)
forward_vector = [foot_vector(1), foot_vector(2), 0];

% Normalize the forward vector to ensure it always points in the same direction
% (forward in the context of the foot)
normalized_forward_vector = forward_vector / norm(forward_vector);

% Calculate the angle between the foot vector and the normalized forward vector
% Use the dot product for angle calculation
dot_product = dot(foot_vector, normalized_forward_vector);
norm_foot_vector = norm(foot_vector);
cos_theta = dot_product / (norm_foot_vector * norm(normalized_forward_vector));
theta = acosd(cos_theta);  % Angle in degrees

% Determine the sign of the angle based on the z-component of the foot vector
if foot_vector(3) < 0
    theta = -theta;
end


end