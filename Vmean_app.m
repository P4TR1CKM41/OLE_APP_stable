          function Rout = Vmean_app(R)
                % Determines mean of a matrix along the second dimension
                for j = 1:3
                    Rout(j,1) = mean(R(j,:));
                end
                end %Vmean
                