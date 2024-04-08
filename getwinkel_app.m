                function Winkel = getwinkel_app(R)
                % Determines three Cardan Angles from a rotation matrix R using a
                % yxz order of rotation.
                Y_yxz = zeros(1,size(R,3));
                X_yxz = zeros(1,size(R,3));
                Z_yxz = zeros(1,size(R,3));
                for i=1:size(R,3)
                    %YXZ
                    Y_yxz(:,i)=atan2( R(1,3,i),R(3,3,i));
                    X_yxz(:,i)=atan2(-R(2,3,i),sqrt((R(1,3,i)^2)+(R(3,3,i)^2)));
                    Z_yxz(:,i)=atan2(R(2,1,i), R(2,2,i));
                end
                
                Winkel.X = X_yxz;
                Winkel.Y = Y_yxz;
                Winkel.Z = Z_yxz;
                end % getwinkel