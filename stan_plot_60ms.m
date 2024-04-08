            box off
            xlim([1,201]);
            xlabel('[ms of stance]');
            set(gca, 'LineWidth', 1.5)
            set(gca, 'Xtick', [1:50:201]);
            set(gca, 'XTickLabel', {'0', '15', '30', '45', '60'});
            set(gca, 'LineWidth', 1.5);
            set(gcf,'color','w');
            set(gca, 'FontSize', 10);
            set(gca, 'Fontname', 'Arial');
           legend boxoff
            set(legend, 'Interpreter', 'none')
                        legend off