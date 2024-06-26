function  bar_sub_plot(parametername,axisnumber_90, axisnumber_180,matrix, idxr_180, idxl_180,idxr_90, idxl_90,no_trials, col ,ytext, xtext,idxr_180_w_f,idxl_180_w_f,idxr_90_w_f,idxl_90_w_f,app)

hunderteight_count =1;
ninety_count =1;


R_mean_woF_180= mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_180,5)));
L_mean_woF_180 = mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_180,5)));

R_mean_woF_90= mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_90,5)));
L_mean_woF_90 = mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_90,5)));

R_mean_wF_180= mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_180_w_f,5)));
L_mean_wF_180 = mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_180_w_f,5)));
R_mean_wF_90 = mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_90_w_f,5)));
L_mean_wF_90 = mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_90_w_f,5)));
if strcmp(parametername, 'PEAK_KNEE_X')
    if R_mean_wF_180 <=R_mean_woF_180*0.9
        col_f_r_180 = [0,128,0]/255;% green rechts
    elseif R_mean_wF_180 >=R_mean_woF_180*1.1
        col_f_r_180 = [220,20,60]/255; % rot rechts
    else
        col_f_r_180 = [0,0,0]; %schwaz
    end

    if L_mean_wF_180 <=L_mean_woF_180*0.9
        col_f_l_180 = [0,255,0]/255;% green rechts
    elseif L_mean_wF_180 >=L_mean_woF_180*1.1
        col_f_l_180 = [255,99,71]/255; % rot rechts
    else
        col_f_l_180 = [192,192,192]/255;
    end

    if R_mean_wF_90 <=R_mean_woF_90*0.9
        col_f_r_90 = [0,128,0]/255;% green rechts
    elseif R_mean_wF_90 >=R_mean_woF_90*1.1
        col_f_r_90 = [220,20,60]/255; % rot rechts
    else
        col_f_r_90 = [0,0,0]; %schwaz
    end

    if L_mean_wF_90 <=L_mean_woF_90*0.9
        col_f_l_90 = [0,255,0]/255;% green rechts
    elseif L_mean_wF_90 >=L_mean_woF_90*1.1
        col_f_l_90 = [255,99,71]/255; % rot rechts
    else
        col_f_l_90 = [192,192,192]/255;
    end

else
    col_f_r_180 = [0,0,0];
    col_f_l_180 = [192,192,192]/255;
    col_f_r_90 = [0,0,0];
    col_f_l_90 = [192,192,192]/255;
end
%[192,192,192]/255; grau

% elseif matrix(tr,1)==0 & matrix(tr,2) ==1 & matrix(tr,3) ==1 & (app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)<=L_mean_KAM_woF_180*0.9)
%     col{tr,1} = [0,255,0]/255;
% elseif matrix(tr,1)==0 & matrix(tr,2) ==1 & matrix(tr,3) ==1 & (app.datacontainer.PARAMETERS.PEAK_KNEE_X(tr)>=L_mean_KAM_woF_180*1.1)
for tr = 1:no_trials
    if matrix(tr,4) ==1 % is 180
        bar(app.(axisnumber_180),hunderteight_count,app.datacontainer.PARAMETERS.(parametername)(:,tr), 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', col{tr}, 'EdgeColor', 'none')
        hold(app.(axisnumber_180), 'on'); % Hold on to plot additional data on the same axes
        xline(app.(axisnumber_180),mean(app.datacontainer.PARAMETERS.(parametername)((matrix(idxl_180,5)))), 'Color',col{tr, 1})

        xline(app.(axisnumber_180), R_mean_woF_180, Linewidth=3, Color=[0, 0,0])
        xline(app.(axisnumber_180), L_mean_woF_180, Linewidth=3, Color=[192,192,192]/255)

        ylim(app.(axisnumber_180), [0, length(find(matrix(:,4)==1))+1])
        yticks(app.(axisnumber_180),[1: length(find(matrix(:,4)==1))]);
        ylabel(app.(axisnumber_180), (ytext), 'Interpreter','none', 'FontWeight', 'bold');
        xlabel(app.(axisnumber_180), (xtext), 'Interpreter','none');

        xline(app.(axisnumber_180),mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_180_w_f,5))), 'Linestyle', '--' , Linewidth=3, Color=col_f_r_180)
        xline(app.(axisnumber_180),mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_180_w_f,5))), 'Linestyle', '--' , Linewidth=3, Color=col_f_l_180)

        hunderteight_count = hunderteight_count+1;
    elseif matrix(tr,4) ==2 % is 90
        bar(app.(axisnumber_90),ninety_count,app.datacontainer.PARAMETERS.(parametername)(:,tr), 'Horizontal', 'on', 'FaceColor', 'flat', 'CData', col{tr}, 'EdgeColor', 'none')
        hold(app.(axisnumber_90), 'on'); % Hold on to plot additional data on the same axes
        xline(app.(axisnumber_90),mean(app.datacontainer.PARAMETERS.(parametername)((matrix(idxl_90,5)))), 'Color',col{tr, 1})

        xline(app.(axisnumber_90), R_mean_woF_90, Linewidth=3, Color=[0, 0,0])
        xline(app.(axisnumber_90), L_mean_woF_90, Linewidth=3, Color=[192,192,192]/255)


        xline(app.(axisnumber_90),mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxr_90_w_f,5))), 'Linestyle', '--' , Linewidth=3, Color=col_f_r_90)
        xline(app.(axisnumber_90),mean(app.datacontainer.PARAMETERS.(parametername)(matrix(idxl_90_w_f,5))), 'Linestyle', '--' , Linewidth=3, Color=col_f_l_90)


        ylabel(app.(axisnumber_90), (ytext), 'Interpreter','none', 'FontWeight', 'bold');
        xlabel(app.(axisnumber_90), (xtext), 'Interpreter','none');
        ylim(app.(axisnumber_90), [0, length(find(matrix(:,4)==2))+1])
        yticks(app.(axisnumber_90),[1: length(find(matrix(:,4)==2))]);
        ninety_count = ninety_count+1;
    end
end

end