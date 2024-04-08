function foot_on_active_fp(path_to_dyn,OPTIONS)
acq = btkReadAcquisition(path_to_dyn);


btkCloseAcquisition(acq);

[markers, markersInfo, markersResidual] = btkGetMarkers(acq)

end