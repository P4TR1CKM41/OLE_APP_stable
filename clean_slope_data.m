
clc
clear all
close all
load('C:\Users\patrickmai\Downloads\MERGEDDATA_ADVANCED.mat')

%trials IDs to remove

toremove = [3782 4247   4248     4258  4259 4262  4263]';


MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y(toremove,:) = [];

MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_ANKLE.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_ANKLE.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_ANKLE.Z(toremove,:) = [];

MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_MPJ.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_MPJ.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_MPJ.Z(toremove,:) = [];

MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_ANKLE.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_ANKLE.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_ANKLE.Z(toremove,:) = [];

MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_MPJ.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_MPJ.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.MOMENTS.RIGHT_MPJ.Z(toremove,:) = [];


MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_MPJ.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_MPJ.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_MPJ.Z(toremove,:) = [];

MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_ANKLE.X(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_ANKLE.Y(toremove,:) = [];
MERGEDDATA.R.TIMEDOMAIN.POWER.RIGHT_ANKLE.Z(toremove,:) = [];

%% now clean SUBJECTS
MERGEDDATA.INFO.Subjects(toremove,:) = [];
%% now clean conidtions
MERGEDDATA.INFO.Conditions(toremove,:) = [];

%% now idenfity the minimum number of trials

no_probs= MERGEDDATA.INFO.Subjects(end);
no_con = MERGEDDATA.INFO.Conditions(end) ;

for c = 1 : no_con
    conditions{c,1}=find (MERGEDDATA.INFO.Conditions==c)
    for p = 1 : no_probs
        if c==1
            probanden{p,c}=find (MERGEDDATA.INFO.Subjects(conditions{c,1},:)==p)
            numberoftrialsperProbperCon(p,c) = length (find (MERGEDDATA.INFO.Subjects(conditions{c,1},:)==p));
        else
            probanden{p,c}=find (MERGEDDATA.INFO.Subjects(conditions{c,1},:)==p)+conditions{c-1,1}(end);
            numberoftrialsperProbperCon(p,c) = length (find (MERGEDDATA.INFO.Subjects(conditions{c,1},:)==p));

        end

    end

end

%% now identify the minimum number of valid trials
minimumnumberoftrails = min (numberoftrialsperProbperCon(:));

%% now remove trials from those who have to many :)
for c = 1 : no_con
    for p = 1 : no_probs
        numberoftrialsperProbperCon(p,c);
        currentnumberoftrails = length (probanden{p,c});
        numberstoremove(p,c) = currentnumberoftrails-minimumnumberoftrails;
        %         randowmtrails = randperm(currentnumberoftrails,currentnumberoftrails);
        %         trailstouse = randowmtrails(1:minimumnumberoftrails)';
        %         trailstoremove = randowmtrails(minimumnumberoftrails+1:currentnumberoftrails)';
    end
end

probandenbackup = probanden;

for c = 1 : no_con
    for p = 1 : no_probs
        numberstoremove(p,c);
        probanden{p, c} ;

        randowmtrails{p, c}  = randperm(length ( probanden{p, c}),numberstoremove(p,c))';
        probandenbackup{p, c}(randowmtrails{p, c} ,:) = [];

        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_TD(p,c)= mean((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],1)));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_TO(p,c)= mean((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],end)));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MAX(p,c)= mean( max((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],:))'));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MIN(p,c)= mean( min((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],:))'));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MAX_withinfirst25(p,c)= mean( max((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],[1:51]))'));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MIN_withinfirst25(p,c)= mean( min((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],[1:51]))'));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MAX_withinlast75(p,c)= mean( max((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],[151:201]))'));
        MERGEDDATA.R.DISCRETE.MPJ_VEL_at_MIN_withinlast75(p,c)= mean( min((MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y([ probandenbackup{p, c}],[151:201]))'));
MERGEDDATA.R.DISCRETE.MPJ_PEAK_DORSI_FLEX(p,c)= mean( min((MERGEDDATA.R.TIMEDOMAIN.ANGLES.RIGHT_MPJ.Y([ probandenbackup{p, c}],:))'));
        trialswithareremoved{p,c} =  probanden{p, c}(randowmtrails{p, c});
        %         randowmtrails = randperm(currentnumberoftrails,currentnumberoftrails);
        %         trailstouse = randowmtrails(1:minimumnumberoftrails)';
        %         trailstoremove = randowmtrails(minimumnumberoftrails+1:currentnumberoftrails)';
    end
end
nauf = 1;
for c = 1 : no_con
    for p = 1 : no_probs

        finalremovevector{nauf,1 } =  trialswithareremoved{p,c} ;
        probandenbackup{p, c}
        nauf = nauf+1;
        %         randowmtrails = randperm(currentnumberoftrails,currentnumberoftrails);
        %         trailstouse = randowmtrails(1:minimumnumberoftrails)';
        %         trailstoremove = randowmtrails(minimumnumberoftrails+1:currentnumberoftrails)';
    end
end

clearvars toremove
toremove = cell2mat (finalremovevector);
%final cleanup
MERGEDDATA.R.TIMEDOMAIN.ANGU_VEL.RIGHT_MPJ.Y(toremove,:) = [];

%% now clean SUBJECTS
MERGEDDATA.INFO.Subjects(toremove,:) = [];
%% now clean conidtions
MERGEDDATA.INFO.Conditions(toremove,:) = [];

