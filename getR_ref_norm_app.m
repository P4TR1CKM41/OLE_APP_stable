                function R = getR_ref_norm_app(R1, R2, R_REF, reftostatic)
                % Determines the rotation matrix between two segments, either with
                % reference to a static trial or not
                [x, y, z] = size(R1);
                R = zeros(x,y,z);
                if reftostatic
                    for i = 1:z
                        R(:,:,i) = (R1(:,:,i)'*R2(:,:,i)) * R_REF(:,:,1)';
                    end
                else
                    for i = 1:z
                        R(:,:,i) = R1(:,:,i)'*R2(:,:,i);
                    end
                end
                end %getR_ref_norm
                