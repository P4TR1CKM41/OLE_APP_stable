                function R = getR_app(R1, R2)
                %Determines the rotation matrix between to coordinate systems
                [x, y, z] = size(R1);
                for i = 1:z
                    R(:,:,i) = R1(:,:,i)'*R2(:,:,i);
                end
                end %getR
                
                function OUT = loadevents(File)
                
                M = c3dserver;
                openc3d(M,0,File);
                start = M.GetVideoFrame(0);
                ende = M.GetVideoFrame(1);
                fRate = M.GetVideoFrameRate;
                IND_ADDED_MARKER = M.AddMarker;
                index2 = M.GetParameterIndex('EVENT', 'LABELS');
                index3 = M.GetParameterIndex('EVENT', 'CONTEXTS');
                index4 = M.GetParameterIndex('EVENT', 'TIMES');
                nLength = M.GetParameterLength(index2);
                nLength2 = M.GetParameterLength(index4);
                for i = 1:nLength
                    OUT.Labels{i} = M.GetParameterValue(index2, i-1);
                    OUT.Contexts{i} = M.GetParameterValue(index3, i-1);
                end
                run = 1;
                for i = 2:2:nLength2
                    OUT.Frame(run) = M.GetParameterValue(index4, i-1);
                    OUT.Frame(run) = (round(OUT.Frame(run).*fRate)+1) - start + 1;;
                    run = run+1;
                end
                
                closec3d(M);
                end %loadevents