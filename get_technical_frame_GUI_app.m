function [O,R] = get_technical_frame_GUI_app(P1, P2, P3, P4)
% Function to determine a technical coordinate system (with origin
% O and rotation matrix R) from clusters of three or four markers
if nargin == 3
    [~, y] = size(P1);
    O = zeros(3,y);


    for i = 1:y
        O(:,i) = (P1(:,i) + P2(:,i) + P3(:,i)) / 3;
    end




    Help1 = zeros(3,1,y);
    X = zeros(3,1,y);
    Y = zeros(3,1,y);
    Z = zeros(3,1,y);
    for i = 1:y


        X(:,i) = P2(:,i) - P1(:,i);
        Help1(:,i) = P3(:,i) - P1(:,i);
        Z(:,i) = cross(X(:,i), Help1(:,i));
        Y(:,i) = cross(Z(:,i), X(:,i));
        X(:,i) = X(:,i) / norm(X(:,i));
        Y(:,i) = Y(:,i) / norm(Y(:,i));
        Z(:,i) = Z(:,i) / norm(Z(:,i));
    end

    R = [X,Y,Z];

else
    [~, y] = size(P1);
    O = zeros(3,y);


    for i = 1:y
        O(:,i) = (P1(:,i) + P2(:,i) + P3(:,i) + P4(:,i)) / 4;
    end




    Help1 = zeros(3,1,y);
    X = zeros(3,1,y);
    Y = zeros(3,1,y);
    Z = zeros(3,1,y);
    for i = 1:y


        Z(:,i) = ((P1(:,i) + P2(:,i)) / 2) - O(:,i);
        Help1(:,i) = ((P2(:,i) + P4(:,i)) / 2) - O(:,i);
        X(:,i) = cross(Help1(:,i), Z(:,i));
        Y(:,i) = cross(Z(:,i), X(:,i));
        X(:,i) = X(:,i) / norm(X(:,i));
        Y(:,i) = Y(:,i) / norm(Y(:,i));
        Z(:,i) = Z(:,i) / norm(Z(:,i));
    end

    R = [X,Y,Z];
end
end %get_technical_frame_GUI