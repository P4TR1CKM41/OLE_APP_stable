                function Theta = getTheta_app(Rpunkt, R)
                % Determines the skew symmetric matrix theta from which te angular
                % velocity of a coordinate system can be determined
                Theta = zeros(3,3,size(Rpunkt,3));
                for i = 1:size(Rpunkt,3)
                    Theta(:,:,i) = Rpunkt(:,:,i)*R(:,:,i)';
                end
                end %getTheta