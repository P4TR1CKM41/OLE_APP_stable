function Rout = Rmean(R)
%% erzeugt eine einzelne Rotationsmatrix (3x3) aus einer dreidimensionalen
%% Rotationsmatrix aus n Frames (3x3x n )



for i = 1:3
    for j = 1:3
        Rout(i,j) = mean(R(i,j,:));
    end
end