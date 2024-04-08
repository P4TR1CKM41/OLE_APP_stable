              function [V, ACC, LinV, LinACC, Theta] = getsegmentderivatives_app(R,O,freq)
                % Determines linear velocity and acceleration and the skew
                % symmetric matrix Theta from a coordinate system (defined by
                % origin O and rotation matrix R)
                Rpunkt = getderivateM3point_app(R)./(1/freq);
                Theta = getTheta_app(Rpunkt, R);
                V(1,:) =  Theta(3,2,:);
                V(2,:) =  Theta(1,3,:);
                V(3,:) =  Theta(2,1,:);
                ACC = zeros(3,length(O));
                for o = 1:3
                    ACC(o,:) = getderivativesvel_app(V(o,:))./(1/freq);
                end
                LinV = getderivateCOMVEL3point_app(O)./(1/freq) / 1000;
                LinACC = getderivateCOMACC3point_app(LinV)./(1/freq);
                end %getsegmentderivatives