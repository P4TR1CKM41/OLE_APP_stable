function [MARKERS_FILT , number_of_gaps]= markersfilt_app(RAW, b, a, range)
% Filters raw 3D trajectory data
if nargin == 3
    for j = 1:3
        if j ==1
            number_of_gaps =  length(find (isnan(RAW.data(j,:))));
        else
        end
        RAW.data(j,:) = fillmissing(RAW.data(j,:), 'nearest');
        MARKERS_FILT.data(j,:) = filtfilt(b,a,double(RAW.data(j,:)));
    end
else
    for j = 1:3
        if j ==1
            number_of_gaps =  length(find (isnan(RAW.data(j,:))));
        else
        end
        RAW.data(j,:) = fillmissing(RAW.data(j,:), 'nearest');
        MARKERS_FILT.data(j,:) = filtfilt(b,a,double(RAW.data(j,range)));
    end
end
end %markersfilt