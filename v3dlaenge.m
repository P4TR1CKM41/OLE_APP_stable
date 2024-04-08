function y = v3dlaenge(V)
if size(V,1) == 3
    y = sqrt(V(1,1)^2 + V(2,1)^2 + V(3,1)^2);
end

if size(V,1) == 2
    y = sqrt(V(1,1)^2 + V(2,1)^2)
end