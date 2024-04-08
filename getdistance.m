function DIST = getdistance(V1, V2)


for t = 1:length(V1)
    DIST.vector(:,t) = V1(:,t) - V2(:,t);
    DIST.scalar(1,t) = v3dlaenge(DIST.vector(:,t));
end
DIST.mean = mean(DIST.scalar);
DIST.std = std(DIST.scalar);