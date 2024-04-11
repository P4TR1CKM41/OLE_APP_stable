function  gap_fill_markers_OLE(path, info, OPTIONS)
%% read marker data
% tic
pause(0.01)
errorlog{1,1} = '';

acq = btkReadAcquisition(path);
index_in_marker_setup_array = find(~cellfun(@isempty,(strfind((OPTIONS.MARKER_SETUP.HIP(:,1)),OPTIONS.SETTINGS ))));
[markers,  ~, ~] = btkGetMarkers(acq);
%% loop to check for gaps
markernames = fieldnames(markers);
h = 1;
for m = 1: length (markernames)
    [nframes, ~] =size( markers.(markernames{m, 1}));
    if find (markers.(markernames{m, 1})(:,1) ==0) >0
        a = 2;
        gaps{1,h} = (markernames{m, 1});
        frames_with_gap{1,h} = num2str(length(find (markers.(markernames{m, 1})(:,1) ==0)));
        h = h+1;
    else
    end

end

%% bring the marker in the same format to allow use of the subfunctions
structname = 'Test';
for m = 1: length (markernames)
    MARKERS.(structname).Raw.(markernames{m, 1}).data  = markers.(markernames{m, 1})';
end

if exist ('gaps' ,'var') ==1
    %% the hip
    try
        [MARKERS, Gap_lengt(1,1), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.HIP{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.HIP{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.HIP{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.HIP{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,1} = marker_recon_name;
    end
    %% right calc
    try
        [MARKERS, Gap_lengt(1,2), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,2} = marker_recon_name;
    end
    %% left calc
    try
        [MARKERS, Gap_lengt(1,3), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 8}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 9}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 10}  ,OPTIONS.MARKER_SETUP.FOOT{index_in_marker_setup_array, 11}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,3} = marker_recon_name;
    end
    %% torso
    try
        [MARKERS, Gap_lengt(1,4), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.TORSO{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.TORSO{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.TORSO{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.TORSO{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));

        %% Head
        [MARKERS, Gap_lengt(1,5), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.HEAD{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.HEAD{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.HEAD{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.HEAD{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,4} = marker_recon_name;
    end
    %% right femur and left
   
        try
            [MARKERS, Gap_lengt(1,6), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.R_FEMUR{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.R_FEMUR{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.R_FEMUR{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.R_FEMUR{index_in_marker_setup_array, 5}  });
            markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
            btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
            btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
        catch
            errorlog{1,6} = marker_recon_name;
        end
        try
            [MARKERS, Gap_lengt(1,7), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.L_FEMUR{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.L_FEMUR{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.L_FEMUR{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.L_FEMUR{index_in_marker_setup_array, 5}  });
            markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
            btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
            btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
        catch
            errorlog{1,7} = marker_recon_name;
        end
    


    %% right tibia
    try
        [MARKERS, Gap_lengt(1,8), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.R_TIBIA{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.R_TIBIA{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.R_TIBIA{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.R_TIBIA{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,7} = marker_recon_name;
    end
    %% left tibia
    try
        [MARKERS, Gap_lengt(1,9), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{OPTIONS.MARKER_SETUP.L_TIBIA{index_in_marker_setup_array, 2}  ,OPTIONS.MARKER_SETUP.L_TIBIA{index_in_marker_setup_array, 3}  ,OPTIONS.MARKER_SETUP.L_TIBIA{index_in_marker_setup_array, 4}  ,OPTIONS.MARKER_SETUP.L_TIBIA{index_in_marker_setup_array, 5}  });
        markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
        btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
        btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    catch
        errorlog{1,8} = marker_recon_name;
    end
    errorlog(~cellfun('isempty',errorlog));
    % % try
    % %     %% right arm
    % %     [MARKERS, Gap_lengt(1,10), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{'RGH', 'RELBOW', 'RWRIST'  });
    % %     markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
    % %     btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
    % %     btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    % %
    % %     %% left arm
    % %     [MARKERS, Gap_lengt(1,10), marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS, structname ,{'LGH', 'LELBOW', 'LWRIST'  });
    % %     markers.(marker_recon_name)  = MARKERS.Test.Raw.(marker_recon_name).data';
    % %     btkSetPointValues(acq, marker_recon_name, MARKERS.Test.Raw.(marker_recon_name).data');
    % %     btkSetPointResiduals(acq, marker_recon_name, ones(length(MARKERS.Test.Raw.(marker_recon_name).data'),1));
    % %
    % % end
    btkWriteAcquisition(acq, path);
    %% simple gap file use a spline
    for e = 1: length (gaps)
        % markers.(gaps{1, e})
        %% skip if epi or mal markers
        if ~isempty(find(ismember({OPTIONS.MARKER_SETUP.KNEE{index_in_marker_setup_array,[2:end]}}, (gaps{1, e})))) ==0
            try
                markers.(gaps{1, e})  (markers.(gaps{1, e})  ==0) = NaN;
                markers.(gaps{1, e})(:,1)  = splineFillNaNs(markers.(gaps{1, e})(:,1) ); %splineFillNaNs % replaceNaNsWithClosest
                markers.(gaps{1, e})(:,2)  = splineFillNaNs(markers.(gaps{1, e})(:,2) );
                markers.(gaps{1, e})(:,3)  = splineFillNaNs(markers.(gaps{1, e})(:,3) );
                btkSetPointValues(acq, (gaps{1, e}), markers.(gaps{1, e}));
                btkSetPointResiduals(acq, (gaps{1, e}), ones(length(markers.(gaps{1, e})),1));
            catch

            end
        else

        end
    end
    % btkWriteAcquisition(acq, path);
    btkCloseAcquisition(acq);
    if info ==1
        createInfoBox(gaps) % Info about filled gaps
    else
    end
else
    %% NO GAPS AT ALL
end
% toc
pause(0.0001)
end