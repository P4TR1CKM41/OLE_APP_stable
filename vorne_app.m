                function [Y1, Y2, Y3, Y4] = vorne_app(V)
                % Function to rearrange Data Matrizes
                Y1 = zeros(3,size(V,3));
                Y2 = zeros(3,size(V,3));
                Y3 = zeros(3,size(V,3));
                Y4 = zeros(3,size(V,3));
                if size(V,2) == 1
                    for i = 1:size(V,3)
                        Y1(:,i) = V(:,1,i);
                        
                    end
                end
                
                
                if size(V,2) == 3
                    for i = 1:size(V,3)
                        Y1(:,i) = V(:,1,i);
                        Y2(:,i) = V(:,2,i);
                        Y3(:,i) = V(:,3,i);
                    end
                end
                
                if size(V,2) == 4
                    for i = 1:size(V,3)
                        Y1(:,i) = V(:,1,i);
                        Y2(:,i) = V(:,2,i);
                        Y3(:,i) = V(:,3,i);
                        Y4(:,i) = V(:,4,i);
                    end
                end
                end %vorne