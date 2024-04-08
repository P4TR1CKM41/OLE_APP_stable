   
                function Matrix = getderivateCOMACC3point_app(M)
                % Determines the first derivative of along the second or third
                % dimension of a matrix.
                if ndims(M) == 3
                    for i = 3:size(M,3)-2
                        for j = 1:size(M,1)
                            for k = 1:size(M,2)
                                Matrix2(j,k,i) = ((M(j,k,i+1) - M(j,k,i-1)) / 2);
                            end
                        end
                    end
                    for i = 1:length(Matrix2)
                        Matrix(:,i) = Matrix2(:,1,i);
                    end
                    Matrix(:,size(M,3)-1:size(M,3)) = 0;
                end
                
                if ndims(M) == 2
                    for j = 1:size(M,1)
                        for k = 3:size(M,2)-2
                            Matrix(j,k) = (M(j,k+1) - M(j,k-1)) / 2;
                        end
                    end
                    Matrix(:,size(M,2)-1:size(M,2)) = 0;
                end
                end % getderivateCOMACC3point