function Vel = getderivativesvel_ap(V)
                %         % Determines the derivative of a vetor using quintic spline
                %         % interpolation
                %
                %         for i = 1:length(V)-5
                %             POL(:,i) = polyfit([1:6],V(1,i:i+5), 5);
                %             KO(:,i+2) = POL(:,i);
                %         end
                %         KO(:,1) = KO(:,3);
                %         KO(:,2) = KO(:,3);
                %         KO(:,length(V)-3:length(V)) = V(length(V)-4);
                %
                %
                %         for t = 1:length(KO)
                %             KO_V(1,t) = KO(1,t)*5;
                %             KO_V(2,t) = KO(2,t)*4;
                %             KO_V(3,t) = KO(3,t)*3;
                %             KO_V(4,t) = KO(4,t)*2;
                %             KO_V(5,t) = KO(5,t)*1;
                %         end
                %
                %
                %
                %         for j = 1:length(KO)
                %             Vel(1,j) = polyval(KO_V(1:5,j),3);
                %
                %         end
                Vel = gradient(V);
                end % getderivativesvel