function dashboard(OPTIONS, PARAMETERS, KAM_curve, VELOCITY)
close all
trnames = fieldnames(OPTIONS.LEG);
for t = 1 : length(trnames)
    if strcmp(OPTIONS.LEG.(trnames{t})  , 'L') ==1
        leg = 0;
        subfix ='l';
        col = [1, 0, 1];
    else
        leg =1;
        subfix ='r';
        col = [1, 0, 0];
    end
    array{t,1} = leg;
    array{t,2} = col;

    if OPTIONS.FEEDBACK_GIVEN.(trnames{t})  ==0
        array{t,3} = 0;
    else
        array{t,3} = 1;
    end
    array{t,4} = OPTIONS.FEEDBACK_TYPE_NUMERIC.(trnames{t});
end


for f = 1: length(trnames)
   

    
    
    subplot(2,2,[1 3])

    subplot(2,2,2)
    barh(VELOCITY)
    xlabel ('CoM velocity [m/s]')
    
    
    subplot(2,2,4)
    plot(KAM_curve(:,f), 'color',  array{f,2})
    stan_plot_100ms
    hold on
    ylabel ('+KAM Nm/kg')
end

a=2;
end