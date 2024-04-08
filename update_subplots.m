function update_subplots(app,axisnumber, dropdownnumber)
%% get only right and left wo feedback valid TODO
%add vertical mean lines for left and right
trialnames = fieldnames(app.datacontainer.GRF_TABLE);
for tr = 1 : length (trialnames)
    matrix(tr,1) = app.datacontainer.OPTIONS.ANALYZEDLEG_BIN.(trialnames{tr, 1}) ;
    matrix(tr,2) = app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1});
    matrix(tr,3) =app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1});
end
% was right was valid and no instruduction
idxr = find(matrix(:,1) ==1 & (matrix(:,2) ==1) & (matrix(:,3) ==0));
idxl = find(matrix(:,1) ==0 & (matrix(:,2) ==1) & (matrix(:,3) ==0));

%% get the mean KAM for L and R wo feedback
R_mean_KAM_woF= mean(app.datacontainer.PARAMETERS.PEAK_KNEE_X(idxr));
L_mean_KAM_woF = mean(app.datacontainer.PARAMETERS.PEAK_KNEE_X(idxl));

hold(app.(axisnumber), 'off');
for tr = 1 : length (trialnames)
    %app.datacontainer.ANALYZEDLEG app.datacontainer.OPTIONS.WAS_VALID app.datacontainer.OPTIONS.Instruction
    if strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'R') && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1 && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==0
        col = [0, 0,0];
    elseif strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'L') && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1 && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==0
        col = [192,192,192]/255;
    elseif   app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)  < R_mean_KAM_woF-(5*R_mean_KAM_woF)/100 && strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'R') && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==1 && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1
        col = [0,128,0]/255;
    elseif   app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)  > R_mean_KAM_woF-(5*R_mean_KAM_woF)/100 && strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'R') && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==1 && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1
        col = [139,0,0]/255;
    elseif   app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)  < L_mean_KAM_woF-(5*L_mean_KAM_woF)/100 && strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'L') && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==1 && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1
        col = [44,238,144]/255;
    elseif   app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)  > L_mean_KAM_woF-(5*L_mean_KAM_woF)/100 && strcmp (app.datacontainer.OPTIONS.ANALYZEDLEG.(trialnames{tr, 1})   , 'L') && app.datacontainer.OPTIONS.Instruction.(trialnames{tr, 1})  ==1 && app.datacontainer.OPTIONS.WAS_VALID.(trialnames{tr, 1}) ==1
        col = [233,150,122]/255;
    else
        col = [255,255,0]/255;
    end
    bar(app.(axisnumber),tr,app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)(:,tr), 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', col);
    hold(app.(axisnumber), 'on'); % Hold on to plot additional data on the same axes
    xline(app.(axisnumber),mean(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)(idxl)), 'Color',[192,192,192]/255)
    xline(app.(axisnumber),mean(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)(idxr)))
    ylabel(app.(axisnumber), (app.(dropdownnumber).Value), 'Interpreter','none');
    ylim(app.(axisnumber), [0, length(trialnames)+1])

    if mean(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)) >0 && min(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value))>0
        xlim(app.(axisnumber), [0, max(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value))])
    elseif mean(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)) <0  && max(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value))<0
        xlim(app.(axisnumber), [min(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)),0])
    else
        xlim(app.(axisnumber), [min(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value)),max(app.datacontainer.PARAMETERS.(app.(dropdownnumber).Value))])
    end
end
end