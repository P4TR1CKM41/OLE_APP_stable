function TIMING = getContactTreadmill_MoTrack(FP, MARKERS, OPTIONS)

AllContact = zeros(1, length(FP.GRFfilt.Both));
for i = 50:length(FP.GRFfilt.Both)-50
    if FP.GRFfilt.Both(3,i) > OPTIONS.ForceTreshold  && (sum(FP.GRFfilt.Both(3,i-49:i-1) > OPTIONS.ForceTreshold) == 49  ||  sum(FP.GRFfilt.Both(3,i+1:i+49) > OPTIONS.ForceTreshold) == 49)
        AllContact(i) = 1;
    end
end
runTD = 1;
for i = 1:length(FP.GRFfilt.Both)-1
    if AllContact(i) == 0  && (AllContact(i+1) == 1 && AllContact(i+5) == 1 && AllContact(i+10) == 1 && AllContact(i+20) == 1 && AllContact(i+25) == 1 && AllContact(i+30) == 1)
        EVENTS(1,runTD) = i+1;
        runTD = runTD+1;
    end
end

runTO = 1;
for i = EVENTS(1,1):length(FP.GRFfilt.Both)-1
    if AllContact(i) == 0  && (AllContact(i-1) == 1 && AllContact(i-5) == 1 && AllContact(i-10) == 1 && AllContact(i-20) == 1 && AllContact(i-25) == 1 && AllContact(i-30) == 1)
        EVENTS(2,runTO) = i-1;
        runTO = runTO+1;
    end
end

EVENTS = EVENTS (:,2:end-1);
EVENTSvid = floor(EVENTS ./ (ones(size(EVENTS)).*OPTIONS.ftkratio)) + ones(size(EVENTS));
ContactTimes = (EVENTS(2,:) - EVENTS(1,:)) / OPTIONS.freqGRF;
FlightTimes = (EVENTS(1,2:end) - EVENTS(2,1:end-1)) / OPTIONS.freqGRF;

 
for i = 1:length(EVENTS)-1
    StepFrequency(i) = 1/((EVENTS(1,i+1) - EVENTS(1,i))/OPTIONS.freqGRF);
    
end

TIMING.ContactTimes = ContactTimes;
TIMING.FlightTimes = FlightTimes;
TIMING.StepFrequency = StepFrequency;
TIMING.EVENTSgrf = EVENTS;
TIMING.EVENTSvid = EVENTSvid;

if ~isempty(MARKERS)
    TOERIGHT = fit(MARKERS.Raw.toe_right.data, FP.GRFfilt.Both);
    HEELRIGHT = fit(MARKERS.Raw.calc_back_right.data, FP.GRFfilt.Both);
%     TOERIGHT = fit(MARKERS.Raw.RTIP.data, FP.GRFfilt.Both);
%     HEELRIGHT = fit(MARKERS.Raw.RHCAL.data, FP.GRFfilt.Both);
    assignin('base', 'HEELRIGHT', HEELRIGHT);
%     TOELEFT = fit(MARKERS.Raw.toe_left.data, FP.GRFfilt.Both);
%     if TOERIGHT(1,EVENTS(1,1)) > TOELEFT(1,EVENTS(1,1))
    if HEELRIGHT(3,EVENTS(1,1)) < HEELRIGHT(3,EVENTS(1,2))
        TIMING.EVENTS_R = EVENTS(:,1:2:size(EVENTS,2));
        TIMING.EVENTS_L = EVENTS(:,2:2:size(EVENTS,2));
        TIMING.EVENTS_R_vid = TIMING.EVENTSvid(:,1:2:size(EVENTSvid,2));
        TIMING.EVENTS_L_vid = TIMING.EVENTSvid(:,2:2:size(EVENTSvid,2));
        TIMING.ContactTimes_R = TIMING.ContactTimes(1:2:size(EVENTSvid,2));
        TIMING.FlightTimes_R = TIMING.FlightTimes(1:2:size(EVENTS,2)-1);
        TIMING.StepFrequency_R = TIMING.StepFrequency(1:2:size(EVENTS,2)-1);
    else
        TIMING.EVENTS_R = EVENTS(:,2:2:size(EVENTS,2));
        TIMING.EVENTS_L = EVENTS(:,3:2:size(EVENTS,2));
        TIMING.EVENTS_R_vid = TIMING.EVENTSvid(:,2:2:size(EVENTSvid,2));
        TIMING.EVENTS_L_vid = TIMING.EVENTSvid(:,3:2:size(EVENTSvid,2));
        TIMING.ContactTimes_R = TIMING.ContactTimes(2:2:size(EVENTS,2));
        TIMING.FlightTimes_R = TIMING.FlightTimes(2:2:size(EVENTS,2)-1);
        TIMING.StepFrequency_R = TIMING.StepFrequency(2:2:size(EVENTS,2)-1);
    end
    try
        for i = 1:length(TIMING.EVENTS_R_vid)-1
            TIMING.StrideLength_Right(i) = OPTIONS.RunningSpeed*TIMING.FlightTimes_R(i) + (MARKERS.Opti.calc_back_left.data(1,TIMING.EVENTS_L_vid(1,i)) - MARKERS.Opti.toe_right.data(1,TIMING.EVENTS_R_vid(2,i)))/1000; %+ (MARKERS.Calc.CoM_MALE(1,TIMING.EVENTS_L_vid(1,i)) - MARKERS.Calc.CoM_MALE(1,TIMING.EVENTS_R_vid(2,i)))/1000;
        end
    catch
        for i = 1:length(TIMING.EVENTS_R_vid)-1
            TIMING.StrideLength_Right(i) = NaN;
        end
    end
end