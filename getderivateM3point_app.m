                function Matrix = getderivateM3point_app(M)
                % Performs numerical differentiation of a vector or matrix using
                % the 3 point method
                Matrix = zeros(size(M,1), size(M,2), size(M,3));
                if ndims(M) == 2 %#ok<ISMAT>
                    for j = 1:size(M,1)
                        for k = 2:size(M,2)-1
                            Matrix(j,k) = (M(j,k+1) - M(j,k-1)) / 2;
                        end
                    end
                    Matrix(:,size(M,2)) = Matrix(:,size(M,2)-1);
                    
                elseif ndims(M) == 3
                    for i = 2:size(M,3)-1
                        for j = 1:size(M,1)
                            for k = 1:size(M,2)
                                Matrix(j,k,i) = ((M(j,k,i+1) - M(j,k,i-1)) / 2);
                            end
                        end
                    end
                    Matrix(:,:,size(M,3)) = Matrix(:,:,size(M,3)-1);
                end
                end %getderivateM3point