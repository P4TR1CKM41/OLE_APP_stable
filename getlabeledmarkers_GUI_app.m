   function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes] = getlabeledmarkers_GUI_app(Pfad)
        % Reads in labeled c3d trajectories from c3d file (using c3d server
        % functionality)
        
        %% Open C3D Files using C3D Server
        %AAA
        try
            M = c3dserver;
            openc3d(M,0,Pfad);
        catch
            try
                M = c3dserver;
                openc3d(M,0,Pfad);
            catch
                try
                    M = c3dserver;
                    openc3d(M,0,Pfad);
                catch
                    try
                        M = c3dserver;
                        openc3d(M,0,Pfad);
                    catch
                              M = c3dserver;
                        openc3d(M,0,Pfad);
                    end
                end
            end
        end
    
                    
                    freq = M.GetVideoFrameRate;
                    
                    ftkratio = M.GetAnalogVideoRatio;
                    

                    
                    start = M.GetVideoFrame(0);
                    ende = M.GetVideoFrame(1);
                    nframes = ende-start+1;
                    
                    index1 = M.GetParameterIndex('POINT', 'LABELS');
                    n_labels = M.GetParameterLength(index1);
                    run = 1;
                    for i = 0:n_labels-1
                        if ~isempty(M.GetParameterValue(index1,i))
                            label = deleteblank(M.GetParameterValue(index1,i));
                            sternlabel = strfind(label, '*');
                            
                            if isempty(sternlabel)
                                Labels(run,1) = cellstr(label); %#ok<AGROW>
                                run = run+1;
                                for j = 0:2
                                    Markers.(label).data(j+1,:) = cell2mat(M.GetPointDataEx(i,j,start,ende,'1'));
                                end
                            end
                        end
                        clear label sternlabel
                    end
                    
                    %% Checking for Gaps
                    for k = 1:length(Labels)
                        for l = 1:ende-start+1
                            if sum(Markers.(char(Labels(k,1))).data(1:3,l)) == 0
                                Gaps.(char(Labels(k,1))).frames(1,l) = 1;
                            else
                                Gaps.(char(Labels(k,1))).frames(1,l) = 0;
                            end
                        end
                        Gaps.exist = 0;
                        if sum(Gaps.(char(Labels(k,1))).frames(1,:)) > 0
                            Gaps.(char(Labels(k,1))).exist = 1;
                            Gaps.exist = 1;
                        else
                            Gaps.(char(Labels(k,1))).exist = 0;
                        end
                    end
                    closec3d(M);
                end %getlabeledmarkers_GUI