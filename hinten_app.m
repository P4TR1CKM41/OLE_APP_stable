   function Y = hinten_app(P1, P2, P3, P4)
                % Function to rearrange Data Matrizes
                if nargin == 3
                    for i = 1:size(P1,2)
                        Y(:,1,i) = P1(:,i);
                        Y(:,2,i) = P2(:,i);
                        Y(:,3,i) = P3(:,i);
                    end
                end
                
                if nargin == 4
                    for i = 1:size(P1,2)
                        Y(:,1,i) = P1(:,i);
                        Y(:,2,i) = P2(:,i);
                        Y(:,3,i) = P3(:,i);
                        Y(:,4,i) = P4(:,i);
                    end
                end
                end %hinten